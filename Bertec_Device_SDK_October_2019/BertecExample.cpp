// BertecExample.cpp : this example code shows how to use the data gathering process
// with the Bertec Device DLL. The command line program allows you to use either callbacks
// or data polling, logging output to a file or to the screen for a given number of seconds.
//

#include <iostream>
#include <time.h>
#include <windows.h>
#include <string.h>
#include "bertecif.h"
#ifdef _WIN32
#include <tchar.h>
#endif


bool dropHeader = true;
bool includesyncaux = false;
int limitChannels = 0;

// The data callback will be passed the already existing FILE pointer in the userData.
// This example shows how this is used by typecasting it to the proper data type.
// The same concept can also be applied to a C++ object.
void CALLBACK DataCallback( bertec_Handle bHand, bertec_DataFrame * dataFrame, void * userData )
{
   FILE* pFile = (FILE*)userData;
   if (dataFrame->deviceCount > 0)
   {
      if (dropHeader)
      {
         const bool hasMults = (dataFrame->deviceCount > 1);
         // For multiple devices the general convention is to append the device index as the suffix to each channel name.
         for (int devNum = 0; devNum < dataFrame->deviceCount; ++devNum)
         {
            const int suffix = devNum + 1;
            if (hasMults)
            {
               if (devNum > 0)
                  fprintf( pFile, "," );
               fprintf( pFile, "Timestamp-%d", suffix );
            }
            else
               fprintf( pFile, "Timestamp" );

            if (includesyncaux)
            {
               if (hasMults)
                  fprintf( pFile, ",Sync-%d,Aux-%d", suffix, suffix );
               else
                  fprintf( pFile, ",Sync,Aux" );
            }

            char channelNames[BERTEC_MAX_CHANNELS][BERTEC_MAX_CHANNELNAME_LENGTH + 1];  /* the channel names from the device's eprom, null terminated */
            int channelCount = bertec_GetDeviceChannels( bHand, devNum, &channelNames[0][0], sizeof( channelNames ) );
            if (limitChannels > 0 && limitChannels < channelCount)
               channelCount = limitChannels;
            for (int col = 0; col < channelCount; ++col)
            {
               if (hasMults)
                  fprintf( pFile, ",%s-%d", channelNames[col], suffix );
               else
                  fprintf( pFile, ",%s", channelNames[col] );
            }
         }
         fprintf( pFile, "\n" );
         dropHeader = false;
      }

      bool needLF = false;
      for (int devNum = 0; devNum < dataFrame->deviceCount; ++devNum)
      {
         const bertec_DeviceData& devData = dataFrame->device[devNum]; // for multiple devices you would iterate through the device array.
         int channelCount = devData.channelData.count;

         if (limitChannels > 0 && limitChannels < channelCount)
            channelCount = limitChannels;

         if (channelCount > 0)
         {
            needLF = true;
            if (devNum > 0)
               fprintf( pFile, "," );

            // The timestamps that come in are expressed in 8ths of a millisecond even if there is no external clock signal.
            fprintf( pFile, "%.3f", (double)devData.additionalData.timestamp / 8.0 );

            if (includesyncaux)
               fprintf( pFile, ",%d,%d", devData.additionalData.syncData, devData.additionalData.auxData );

            for (int col = 0; col < channelCount; ++col)
               fprintf( pFile, ",%f", devData.channelData.data[col] );
         }
      }
      if (needLF)
         fprintf( pFile, "\n" );
   }
}

// we ignore the deviceNum; we could maintain seperate counters for multiple devices for example.
// the userData was set as the stepping value for the timestamp, so we cast from a void* to an int for that.
int64_t CALLBACK DeviceTimestampCallback( int deviceNum, void * userData )
{
   static int64_t timestampValue = 0;
   timestampValue += (int64_t)(userData);
   return timestampValue;
}

// Portable version of Windows Sleep function
void WaitForXmilliseconds(int milliseconds )
{
#ifdef _WIN32
   Sleep( milliseconds );
#else
   struct timespec ts;
   ts.tv_sec = milliseconds / 1000;
   ts.tv_nsec = (milliseconds % 1000) * 1000000;
   nanosleep( &ts, nullptr );
#endif
}

#ifdef _WIN32
int _tmain( int argc, _TCHAR* argv[] )
#else
int  main( int argc, char* argv[] )
#endif
{
   char filename[MAX_PATH] = "";
   bool useCallbacks = false;
   bool usePolling = false;
   int runTimeSeconds = 0;
   bool useAutozeroing = false;
   bool startWithZeroLoad = false;
   int64_t timestampStepping = 0;

   bertec_ClockSourceFlags extClock = bertec_ClockSourceFlags::CLOCK_SOURCE_INTERNAL;

   limitChannels = 0;
   includesyncaux = false;
   dropHeader = true;

   if (argc < 2)
   {
   showhelp:
      printf( "Bertec Device Example:\n" );
      printf( "-f <filename>   output to the given filename\n" );
      printf( "-t <seconds>    run for the given # of seconds\n" );
      printf( "-l <num>        limit to first num channels per row\n" );
      printf( "-y              include the sync/aux values\n" );
      printf( "-c              do callbacks\n" );
      printf( "-p              do polling\n" );
      printf( "-a              turn on autozeroing\n" );
      printf( "-z              zero load before data gather\n" );
      printf( "-e <mode>       use the external sync clock. Mode is either NONE, RISE, FALL, or BOTH\n" );
      printf( "-x <step>       used callback timestamp method instead of hardware timestamps, stepping by <step>\n" );
      return 0;
   }

   int i = 1;
   while (i < argc)
   {
      char *item = argv[i];
      char *parm = argv[i + 1];
      ++i;
      if (item[0] == '-')
      {
         switch (item[1])
         {
         case 'f':
            if (parm != nullptr)
            {
               strncpy( filename, parm, sizeof( filename ) );
               ++i;
            }
            break;
         case 't':
            if (parm != nullptr)
            {
               runTimeSeconds = atoi( parm );
               ++i;
            }
            break;
         case 'l':
            if (parm != nullptr)
            {
               limitChannels = atoi( parm );
               ++i;
            }
            break;
         case 'c':
            useCallbacks = true;
            usePolling = false;
            break;
         case 'p':
            useCallbacks = false;
            usePolling = true;
            break;
         case 'a':
            useAutozeroing = true;
            break;
         case 'z':
            startWithZeroLoad = true;
            break;
         case 'y':
            includesyncaux = true;
            break;
         case 'x':
            if (parm != nullptr)
            {
               timestampStepping = atoi( parm );
               ++i;
            }
            break;
         case 'e':
            if (parm != nullptr)
            {
               if (strcmp( parm, "RISE" ) == 0)
                  extClock = CLOCK_SOURCE_EXT_RISE;
               else if (strcmp( parm, "FALL" ) == 0)
                  extClock = CLOCK_SOURCE_EXT_FALL;
               else if (strcmp( parm, "BOTH" ) == 0)
                  extClock = CLOCK_SOURCE_EXT_BOTH;
               else
                  extClock = CLOCK_SOURCE_INTERNAL;
               ++i;
            }
            break;
         }
      }
   }

   if (runTimeSeconds < 1)
      goto showhelp;
   if (usePolling == useCallbacks)
      goto showhelp;
   if (filename[0] == 0)
      goto showhelp;

   FILE* pFile = fopen( filename, "wt" );
   if (pFile == nullptr)
   {
      printf( "Unable to open filename %s for writing.\n", filename );
      return -1;
   }
    
   printf( "Initializing the library...\n" );
    
   bertec_Handle hand = bertec_Init();

   if (hand == nullptr)
   {
      fclose( pFile );
      printf( "Unable to initialize the Bertec Device Library (possible missing FTD2XX install).\n" );
      return -1;
   }
    
   if (timestampStepping > 0)
   {
      printf( "Using timestamp callbacks with a step value of %d.\n", (int)timestampStepping );
      bertec_RegisterDeviceTimestampCallback( hand, DeviceTimestampCallback, (void*)timestampStepping );
   }
    
     printf( "Calling set autozero with a flag of %d...\n", useAutozeroing ? 1 : 0  );

   bertec_SetEnableAutozero( hand, useAutozeroing ? 1 : 0 );

    printf("Calling Start...\n");
   bertec_Start( hand );
   // At this point the SDK will attempt to find any connected USB force devices and start reading data from them.
   // Data will buffer as soon as it becomes available, will can be read by data polling or callback functionality.

   printf( "Waiting for devices..\n" );

   // This simply waits until the stats returns a state of READY. This block through bertec_SetExternalClockMode call
   // could also be made into a callback handler tied to bertec_RegisterStatusCallback .
   while (bertec_GetStatus( hand ) != BERTEC_DEVICES_READY)
   {
      // Waiting for devices....
      //printf( ".\n" );
      WaitForXmilliseconds( 100 );
      if (bertec_GetDeviceCount( hand ) > 0)
         break;   // also can check like this (but we prefer status callbacks since we can get instant results)
   }
   printf( " done\n" );

   for (int i = 0; i < bertec_GetDeviceCount( hand ); ++i)
   {
      char buffer[256] = "";
      bertec_GetDeviceSerialNumber( hand, i, buffer, sizeof( buffer ) );
      printf("Plate serial %s\n", buffer );
   }

   if (startWithZeroLoad)
   {
      printf( "Zeroing load.." );
      bertec_ZeroNow( hand );
      while (bertec_GetAutozeroState( hand ) != AUTOZEROSTATE_ZEROFOUND)
      {
         // Waiting for zero to happen.
         printf( "." );
         WaitForXmilliseconds( 100 );
      }
      printf( " done\n" );
   }

   // Set the external clock mode, if any. If the device does not support external clocking modes, then this
   // function call will return BERTEC_UNSUPPORED_COMMAND.
   bertec_SetExternalClockMode( hand, 0, extClock );

   // Since all of the above can result in data actually being captured before any real reading of the data
   // is done (either by polling or setting up callbacks), clearing the buffer is suggested. Clearing the 
   // buffer is even more important when using external clocking modes since data could have been captured
   // before the external clock mode was set.

   bertec_ClearBufferedData( hand );

   // When using callbacks, we can simply use the Windows sleep function call to suspend our main thread
   // while the callback thread does all the work for us. Note the use of pFile being passed as the user
   // data value.
   // Also note that callbacks SHOULD be set up before calling bertec_Start() so that they are available
   // for use as soon as data is present. In your own code you can use a program-specific flag to determine
   // if data should be retained or discarded. Callbacks are also the method of choice when using a GUI
   // system or any other main-thread blocking functionality (ex: heavy database usage or network functionality).
   if (useCallbacks)
   {
      printf( "Using callbacks to gather data.\n" );
      bertec_RegisterDataCallback( hand, DataCallback, pFile );

      WaitForXmilliseconds( 1000 * runTimeSeconds ); // in your code, you could do real work here.
   }

   // When polling, this is slightly more work since we need to go and check the timer ourselves.
   if (usePolling)
   {
      printf( "Using polling to gather data.\n" );

      size_t datasize = 0;
      bertec_DataFrame* pData = bertec_AllocateReadBufferedData( hand, &datasize );

      time_t targetTime = time( nullptr ) + runTimeSeconds;

      while (time( nullptr ) < targetTime)
      {
         while (bertec_GetBufferedDataAvailable( hand ) > 0)
         {
            bertec_ReadBufferedData( hand, pData, datasize );
            DataCallback( hand, pData, (void*)pFile );  // call the same code as the callback would do
         };
         WaitForXmilliseconds( 100 );  // if your main process is in a tight loop like this one, you can overrun the device by continually polling when there is no data there
      }

      bertec_FreeAllocatedReadBufferedData( hand, pData );
      pData = nullptr;
   }

   bertec_Stop( hand );

   printf( "Data gather complete, shutting down.\n" );

   bertec_Close( hand );

   fclose( pFile );

   return 0;
}

