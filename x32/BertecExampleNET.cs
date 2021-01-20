/// <summary>
/// This sample program for the .NET interface for the Bertec DLL shows how to use the data gathering process
/// with the Bertec Device .NET DLL. The command line program allows you to use either callbacks
/// or data polling, logging output to a file or to the screen for a given number of seconds.
/// </summary>
using System;
using System.IO;
using System.Collections.Generic;
using System.Text;

namespace BertecExampleNET
{
   /// <summary>
   /// The CallbackDataHandlerClass is where the data from the device is handled. In this example, the
   /// output is just simply written as a trivial CSV file.
   /// In order to make it a little simpler, the member pFile is exposed as public, so that it can be
   /// directly used outside of the class. This means that this class is created even if data polling
   /// (not callbacks) are used.
   /// </summary>
   class CallbackDataHandlerClass
   {
      /// <summary>
      /// The output file. This is also used when doing data polling.
      /// </summary>
      public StreamWriter pFile;

      public int iLimitNChannels=0;
      public bool dropHeader = true;
      public bool includesyncaux = false;


      public BertecDeviceNET.BertecDevice hand = null;

      /// <summary>
      /// The data callback event is called each time there is data. This is enabled by using the
      /// BertecDeviceNET.DataEventHandler event notification mechanism.
      /// </summary>
      public void OnDataCallback(BertecDeviceNET.DataFrame[] dataFrames)
      {
         if (dataFrames.Length > 0)
         {
            if (dropHeader)
            {
               pFile.Write("Timestamp");
               if (includesyncaux)
                  pFile.Write(",Sync,Aux");

               string[] names = hand.DeviceChannelNames(0);
               int cc = names.Length;

               if (iLimitNChannels > 0 && iLimitNChannels < cc)
                  cc = iLimitNChannels;
               for (int col = 0; col < cc; ++col)
                  pFile.Write(",{0}", names[col]);

               pFile.Write("\r\n");

               dropHeader = false;
            }
            BertecDeviceNET.DataFrame devData = dataFrames[0]; // for multiple devices you would iterate through the device array.
            int channelCount = devData.forceData.Length;

            if (iLimitNChannels > 0 && iLimitNChannels < channelCount)
               channelCount = iLimitNChannels;

            if (channelCount > 0)
            {
               // The timestamps that come in are expressed in 8ths of a millisecond even if there is no external clock signal.
               pFile.Write("{0:f3}", (double)devData.timestamp / 8.0);

               if (includesyncaux)
                  pFile.Write(",{0},{1}", devData.syncData, devData.auxData);

               for (int col = 0; col < channelCount; ++col)
                  pFile.Write(",{0}", devData.forceData[col]);

               pFile.Write("\r\n");
            }
         }
      }

      public void StatusEvent(BertecDeviceNET.StatusErrors status)
      {
         Console.WriteLine("Status event {0}", status);
      }

      public int timestampStepping = 0;
      private Int64 timestampValue = 0;
      public Int64 DeviceTimestamp(int deviceNum)
      {
         timestampValue += timestampStepping;
         return timestampValue;
      }
   }


   class BertecExampleNET
   {
      static void ShowHelp()
      {
         Console.WriteLine("Bertec Device Example (.NET):");
         Console.WriteLine("-f <filename>   output to the given filename");
         Console.WriteLine("-t <seconds>    run for the given # of seconds");
         Console.WriteLine("-l <num>        limit to first num channels per row");
         Console.WriteLine("-y              include the sync/aux values\n");
         Console.WriteLine("-c              do callbacks");
         Console.WriteLine("-p              do polling");
         Console.WriteLine("-a              turn on autozeroing");
         Console.WriteLine("-z              zero load before data gather");
         Console.WriteLine("-e <mode>       use the external sync clock. Mode is either NONE, RISE, FALL, or BOTH");
         Console.WriteLine("-x <step>       used callback timestamp method instead of hardware timestamps, stepping by <step>");
      }



      static void Main(string[] args)
      {
         string filename="";
         bool useCallbacks = false;
         bool usePolling = false;
         int runTimeMSeconds = 0;
         int limitChannels = 0;
         bool useAutozeroing = false;
         bool startWithZeroLoad = false;
         bool includesyncaux = false;
         int timestampStepping = 0;

         BertecDeviceNET.ClockSourceFlags extClock = BertecDeviceNET.ClockSourceFlags.CLOCK_SOURCE_INTERNAL;

         if (args.Length < 1)
         {
            ShowHelp();
            return;
         }

         bool nextIsParm=false;
         string parm="", command="";
         foreach (string item in args)
         {
            if (nextIsParm)
            {
               parm = item;
               nextIsParm = false;
            }
            else if (item.StartsWith("-"))
            {
               command = item.Substring(1);
               if (command == "f" || command == "t" || command == "l" || command == "s" || command == "x")
               {
                  nextIsParm = true;
                  continue;
               }
            }

            switch (command)
            {
               case "f":
                  if (parm.Length > 0)
                     filename = parm;
                  break;
               case "t":
                  if (parm.Length > 0)
                     runTimeMSeconds = 1000 * System.Convert.ToInt32(parm);
                  break;
               case "l":
                  if (parm.Length > 0)
                     limitChannels = System.Convert.ToInt32(parm);
                  break;
               case "c":
                  useCallbacks = true;
                  usePolling = false;
                  break;
               case "p":
                  useCallbacks = false;
                  usePolling = true;
                  break;
               case "a":
                  useAutozeroing = true;
                  break;
               case "z":
                  startWithZeroLoad = true;
                  break;
               case "y":
                  includesyncaux = true;
                  break;
               case "x":
                  if (parm.Length > 0)
                     timestampStepping = System.Convert.ToInt32(parm);
                  break;
               case "e":
                  if (parm.Length > 0)
                  {
                     if (parm == "RISE")
                        extClock = BertecDeviceNET.ClockSourceFlags.CLOCK_SOURCE_EXT_RISE;
                     else if (parm == "FALL")
                        extClock = BertecDeviceNET.ClockSourceFlags.CLOCK_SOURCE_EXT_FALL;
                     else if (parm == "BOTH")
                        extClock = BertecDeviceNET.ClockSourceFlags.CLOCK_SOURCE_EXT_BOTH;
                     else
                        extClock = BertecDeviceNET.ClockSourceFlags.CLOCK_SOURCE_INTERNAL;
                  }
                  break;
            }

            parm = "";
         }

         if ((runTimeMSeconds < 1) || (usePolling == useCallbacks) || (filename.Length < 1))
         {
            ShowHelp();
            return;
         }

         // We create the handler class here, even if not doing callbacks, in order to use the pFile member.
         CallbackDataHandlerClass callbackClass = new CallbackDataHandlerClass();
         callbackClass.iLimitNChannels = limitChannels;
         callbackClass.includesyncaux = includesyncaux;

         callbackClass.pFile = File.CreateText(filename);

         // This will actually connect to the devices and work with them. The BertecDeviceNET.BertecDevice
         // object gives you all the functionality you need.
         BertecDeviceNET.BertecDevice hand;
         try
         {
            hand = new BertecDeviceNET.BertecDevice();
         }
         catch (System.Exception ex)
         {
            Console.Write("Unable to initialize the Bertec Device Library (possible missing FTD2XX install).");
            return;
         }
         callbackClass.hand = hand;

         if (timestampStepping>0)
         {
            Console.Write("Using timestamp callbacks with a step value of {0}.\n", timestampStepping);
            callbackClass.timestampStepping = timestampStepping;
            hand.OnDeviceTimestamp += callbackClass.DeviceTimestamp;
         }

         hand.AutoZeroing = useAutozeroing;

         hand.Start();
         // At this point the SDK will attempt to find any connected USB force devices and start reading data from them.
         // Data will buffer as soon as it becomes available, will can be read by data polling or callback functionality.

         Console.Write("Waiting for devices..");

         // This simply waits until the stats returns a state of READY. This block through bertec_SetExternalClockMode call
         // could also be made into a callback handler tied to bertec_RegisterStatusCallback .
         while (hand.Status != BertecDeviceNET.StatusErrors.DEVICES_READY)
         {
            // Waiting for devices...
            Console.Write(".");
            System.Threading.Thread.Sleep(100);
            if (hand.DeviceCount > 0)
               break;   // also can check like this (but we prefer status callbacks since we can get instant results)
         }
         Console.WriteLine(" done");

         for (int i = 0; i < hand.DeviceCount; ++i)
         {
            Console.WriteLine("Plate serial {0}", hand.DeviceSerialNumber(i));
         }

         // When starting with a zero load, we need to zero after we start; if you call stop after zeroing, it will reset
         // the zero load values.
         if (startWithZeroLoad)
         {
            Console.Write("Zeroing Load...");
            hand.ZeroNow();
            while (hand.AutoZeroState != BertecDeviceNET.AutoZeroStates.ZEROFOUND)
            {
               Console.Write(".");
               System.Threading.Thread.Sleep(100);
            }
            Console.WriteLine(" done");
         }

         // Set the external clock mode, if any. If the device does not support external clocking modes, then this
         // function call will return UNSUPPORED_COMMAND.
         hand.SetExternalClockMode(0, extClock);

         // Since all of the above can result in data actually being captured before any real reading of the data
         // is done (either by polling or setting up callbacks), clearing the buffer is suggested. Clearing the 
         // buffer is even more important when using external clocking modes since data could have been captured
         // before the external clock mode was set.

         hand.ClearBufferedData();

         // When using callbacks (.NET events), we can simply use the Sleep function call to suspend our main thread
         // while the callback thread does all the work for us. 
         // Also note that callbacks SHOULD be set up before calling Start() so that they are available
         // for use as soon as data is present. In your own code you can use a program-specific flag to determine
         // if data should be retained or discarded. Callbacks are also the method of choice when using a GUI
         // system or any other main-thread blocking functionality (ex: heavy database usage or network functionality).
         if (useCallbacks)
         {
            Console.WriteLine("Using callbacks to gather data.");
            hand.OnData += callbackClass.OnDataCallback;
            hand.OnStatus += callbackClass.StatusEvent;

            System.Threading.Thread.Sleep(runTimeMSeconds); // in your code, you could do real work here.
         }
         
         // When polling, this is slightly more work since we need to go and check the timer ourselves.
         if (usePolling)
         {
            Console.WriteLine("Using polling to gather data.");
            BertecDeviceNET.DataFrame[] dataFrames = new BertecDeviceNET.DataFrame[0];

            int startTime = Environment.TickCount;

            while ((Environment.TickCount - startTime) < runTimeMSeconds)
            {
               while (hand.BufferedDataAvailable > 0)
               {
                  hand.ReadBufferedData(ref dataFrames);
                  callbackClass.OnDataCallback(dataFrames);  // call the same code as the callback would do
               };

               System.Threading.Thread.Sleep(100);  // if your main process is in a tight loop like this one, you can overrun the device by continually polling when there is no data there
            }
         }

         hand.Stop();
         Console.WriteLine("Data gather complete, shutting down.");

         // And we close the file.
         callbackClass.pFile.Close();
         callbackClass.pFile = null;

         // Always a good idea to call Dispose on any item that has it. Otherwise, wrapper the block with using().
         hand.Dispose();
         hand = null;
      
      }

   }
}
