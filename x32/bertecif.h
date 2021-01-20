/***************************************************************************
 * Bertec device interface library header                                  *
 *  v. 2.33                                                                *
 *  Copyright (C) 2008-2019 Bertec Corporation                             *
 ***************************************************************************/

#ifndef BERTECIF_H
#define BERTECIF_H

#include <stdint.h>
#include <stddef.h>

// The compiler will typically warn about a zero-sized array, so to avoid noise pollution we disable this warning in MSVC
#pragma warning(disable:4200)

#ifndef BIFH_EXPORT
   #ifdef WIN32
      #ifdef BERTECDEVICEDLL_BUILD
         #define BIFH_EXPORT __declspec(dllexport)
      #else
         #define BIFH_EXPORT __declspec(dllimport)
      #endif
   #else
      #ifdef BERTECDEVICEDLL_BUILD
         #define BIFH_EXPORT __declspec(dllexport)
      #else
         #define BIFH_EXPORT
      #endif
   #endif
#endif

#ifndef CALLBACK
   #ifdef WIN32
      #define CALLBACK __stdcall
   #else
      #define CALLBACK 
   #endif
#endif


#ifdef  __cplusplus
   extern "C" {
#endif

/** The version define is the version # of this Device DLL. You can check it via bertec_LibraryVersion
    If it doesn't match what this one is, then structures and/or functions may have changed,
    and you should proceed with caution. */
#define BERTEC_LIBRARY_VERSION   (0x233)

/** This defines how many channels and devices that the DLL can support. Currently up to 32 devices with 32 channels each. */
#define BERTEC_MAX_CHANNELS            (32)
#define BERTEC_MAX_DEVICES             (32)
#define BERTEC_MAX_SERIAL_LENGTH       (31)
#define BERTEC_MAX_MODELNAME_LENGTH    (31)
#define BERTEC_MAX_CHANNELNAME_LENGTH  (15)

/** library handle */
typedef void * bertec_Handle;

#pragma pack(push)
#pragma pack(8)
/** information about a device */
struct bertec_DeviceInfo
{
   unsigned short version; /* mmMM. Minor and Major are broken out from this. Ex: 0x0211 is minor version 17, major version 2  */
   unsigned char  minorVer;         /* these are version of the DEVICES, not the dll */
   unsigned char  majorVer;
   int   status;            /* status of the device, separate from the overall state. Zero is good, negative bad. */
   int   samplingFreq;      /* native sampling frequency in Hertz */
   char  serial[BERTEC_MAX_SERIAL_LENGTH+1];       /* the serial # of the device */
   char  model[BERTEC_MAX_MODELNAME_LENGTH+1];     /* the model # of the device */
   int   channelCount;      /* how many output channels there are */
   bool  hasInternalClock;  /* if set, then the device has an internal 64-bit timestamp value which can be reset (1ms accuracy) */
   bool  hasAuxSyncPins;    /* if set, then the device has full control over the aux and sync pins and the data block will reflect this. */
   float dimensionWidth;  /* width of the plate in meters, if known */
   float dimensionHeight; /* height of the plate in meters, if known */
   float offsetX;         /* X offset from the center origin in meters, if known. 0 == dead center */
   float offsetY;         /* Y offset from the center origin in meters, if known. 0 == dead center */
   float offsetZ;         /* vetical Z offset from the center origin in meters, if known. 0 == phyiscal top of plate */
   char  channelNames[BERTEC_MAX_CHANNELS][BERTEC_MAX_CHANNELNAME_LENGTH+1];  /* the channel names from the device's eprom, null terminated */
};


/** Channel data that is part of the frame of data. */
struct bertec_ChannelData
{
   int   count;  // how much channel data is in this structure. Copied from bertec_DeviceInfo.channelCount
   float data[BERTEC_MAX_CHANNELS];
};

/** Additional data that is part of the frame of data. Note that this is only value on devices with firmware that support these
    (that is, hasInternalClock and hasAuxSyncPins are set). All other devices will return zero. */
struct bertec_AdditionalData
{
   int64_t        timestamp;  // the plate's clock or "sequence number" for this frame of data. Devices without bertec_DeviceInfo.hasInternalClock will have this backfilled by computed sequence numbers.
   unsigned char  auxData;    // rolling 8-bit value of the AUX pin status. MSB is the current value. Valid in all AUX pin modes.
   unsigned char  syncData;   // rolling 8-bit value of the SYNC pin status. MSB is the current value. Valid in all SYNC pin modes.
};

/** A single device's block of data, both the channel data and the additional timestamp/sync data. This is part of the bertec_DataFrame */
struct bertec_DeviceData
{
   bertec_ChannelData      channelData;
   bertec_AdditionalData   additionalData;
};

/** A single block of data as sent via bertec_DataCallback or retrieved via bertec_ReadBufferedData. The frame contains a single sample of data from all of the devices. */
struct bertec_DataFrame
{
   int                deviceCount;   // same as bertec_DeviceCount
   bertec_DeviceData  device[0];     // the device data is allocated per device and contains up to deviceCount data blocks
};
#pragma pack(pop)

/** Sync pin mode flags */
enum bertec_SyncModeFlags
{
   SYNC_NONE           = 0x00, // The SYNC pin is an input, but its value is not interpreted in any way. This mode is also known as SYNC_IN_SAMPLED. This is the default power-up mode.
   SYNC_OUT_MASTER     = 0x01, // The SYNC pin is outputting a 1kHz square wave clock with a reference mark embedded every 2000ms.
   SYNC_IN_SLAVE       = 0x02, // The SYNC pin is inputting a 1kHz square wave clock with optional reference marks.
   SYNC_OUT_PATGEN     = 0x04, // The SYNC pin is outputting a random pattern. This is useful for debugging.
   SYNC_IN_CONTINUOUS  = 0x05, // The SYNC pin is inputting a continuous 1kHz square wave clock without reference marks.
   SYNC_IN_STROBED     = 0x06, // The SYNC pin is inputting a transient 1kHz square wave clock without reference mark.
   SYNC_OUT_CONTINUOUS = 0x07, // The SYNC pin is outputting a continuous 1kHz square wave clock without reference marks.
   SYNC_OUT_INSTANT    = 0x08  // The SYNC pin is outputting the value most recently set via the OUTPUT command.
};

/** Aux pin mode flags */
enum bertec_AuxModeFlags
{
   AUX_NONE_AUX_IN_ZERO = 0x00, // AM6500: The AUX pin is an input, but its value is not interpreted in any way.
                                // AM6800/AM6817: the input is taken from the ZERO pin, and a logic low level keeps the analog output signals zeroed.
                                // This is the default power-up mode.
   AUX_IN_SAMPLED       = 0x01, // The AUX/ZERO pin is an input, and its value is not interpreted in any way.
   AUX_OUT_INSTANT      = 0x02, // The AUX is outputting the value most recently set via the OUTPUT command.
   AUX_OUT_PATGEN       = 0x04  // The AUX pin is outputting a random pattern. This is useful for debugging.
};

/** Internal/External Clock Source flags */
enum bertec_ClockSourceFlags
{
   CLOCK_SOURCE_INTERNAL = 0x00, // This is the default state and the SDK will present data at the native device rate (1000hz).
                                 // Averaging will affect this. All Sync and Aux modes are available, including multiple device sync.
   CLOCK_SOURCE_EXT_RISE = 0x01, // This will cause data to be presented whenever the SYNC pin changes from low (0) to high (1),
                                 // which can be higher (up to 4000hz) or lower (down to 1hz).
                                 // Averaging is disabled, and the SYNC mode is forced to SYNC_NONE. All other Aux modes are available,
                                 // but multiple device sync is disabled.
   CLOCK_SOURCE_EXT_FALL = 0x02, // This will cause data to be presented whenever the SYNC pin changes from high (1) to low (0),
                                 // which can be higher (up to 4000hz) or lower (down to 1hz).
                                 // Averaging is disabled, and the SYNC mode is forced to SYNC_NONE. All other Aux modes are available,
                                 // but multiple device sync is disabled.
   CLOCK_SOURCE_EXT_BOTH = 0x03, // This will cause data to be presented whenever the SYNC pin changes from either a low-to-high or high-to-low state.
                                 // Averaging is disabled, and the SYNC mode is forced to SYNC_NONE. All other Aux modes are available,
                                 // but multiple device sync is disabled.

   CLOCK_SOURCE_NO_INTERPOLATE = 0x80, // By default the ClockSource logic will attempt to perform a fractional delay on the input data.
                                       // This can cause the data signal to appear to be delayed by up to 4.875ms. If such a delay would
                                       // cause problems with your code path you will need to pass this bit flag along with the clock source
                                       // to change from a fractional delay to a simpler skip-and-fill. Skip-and-fill will either omit or
                                       // duplicate channel data depending on when the edge signal occurs in the data flow.
};

/** Autozero states as returned by bertec_GetAutozeroState */
enum bertec_AutozeroStates
{
   AUTOZEROSTATE_NOTENABLED= 0,  // Not enabled yet
   AUTOZEROSTATE_WORKING   = 1,  // Autozero is enabled, but has not yet been achieved
   AUTOZEROSTATE_ZEROFOUND = 2   // Autozero has been achieved and will continue to automatically rezero as needed.
};

/** Computed channels options. This is a bit field array. Note that the Sway Angle requires a set subject height to be correct */
enum bertec_ComputedChannelFlags
{
   NO_COMPUTED_CHANNELS = 0,
   COMPUTE_COP_VALUES = 0x01,
   COMPUTE_COG_VALUES = 0x02,
   COMPUTE_SWAY_ANGLE = 0x04,
   COMPUTE_ALL_VALUES = 0X07
};

/** Common plate dimensions for the standard Bertec plates (Essential, Functional, and Sport). Other plate sizes exist; see the bertec_DeviceInfo structure.
    These are all expressed in millimeters.
    The placement of the Medial Malleolus line on the Functional plate aligns with an Essential when both plates are aligned on the front; to map the Y position
    of the line between a Functional and Essential (normalize the position between the two), you will need to add in a constant value of
    155mm (ESSENTIAL_MALLEOLUS_OFFSET_Y-FUNCTIONAL_MALLEOLUS_OFFSET_Y) to the computed Functional COPY value.
    Note that you DO NOT NEED TO DO THIS unless you care about the stance position and the markings on the plate; if your applicaiton just cares about
    the raw COP position, then you should NOT add any constant offsets and instead use the as-computed COP values.
    The Lateral Calcaneus X offset values are provided as informational use only and will be negative for the left side of the plate and positive for the right.
    */
enum bertec_CommonDimensions
{
   ESSENTIAL_WIDTH_MM = 508,
   ESSENTIAL_HEIGHT_MM = 457,
   ESSENTIAL_MALLEOLUS_OFFSET_Y = 65, // this is where the foot placement center line is located on the plate, offset from the center. 
   ESSENTIAL_CALCANEUS_OFFSET_X_MINOR = 11, // this is the first hash mark, offset from the center. 
   ESSENTIAL_CALCANEUS_OFFSET_X_MIDDLE = 13, // this is the second hash mark, offset from the center. 
   ESSENTIAL_CALCANEUS_OFFSET_X_MAJOR = 15, // this is the third and largest hash mark, offset from the center. 

   FUNCTIONAL_WIDTH_MM = 508,
   FUNCTIONAL_HEIGHT_MM = 762,  // note that when Aggregate Device Mode is enabled, you should consider the virtual plate size 2x of this (1524mm)
   FUNCTIONAL_MALLEOLUS_OFFSET_Y = -90, // this is where the foot placement center line is located on the plate, offset from the center. Not valid for Aggregate Device Mode 
   FUNCTIONAL_CALCANEUS_OFFSET_X_MINOR = 11, // this is the first hash mark, offset from the center. 
   FUNCTIONAL_CALCANEUS_OFFSET_X_MIDDLE = 13, // this is the second hash mark, offset from the center. 
   FUNCTIONAL_CALCANEUS_OFFSET_X_MAJOR = 15, // this is the third and largest hash mark, offset from the center. 

   SPORT_WIDTH_MM = 762,
   SPORT_HEIGHT_MM = 457,
   SPORT_MALLEOLUS_OFFSET_Y = 65, // this is where the foot placement center line is located on the plate, offset from the center. 
   SPORT_CALCANEUS_OFFSET_X_MINOR = 11, // this is the first hash mark, offset from the center. 
   SPORT_CALCANEUS_OFFSET_X_MIDDLE = 13, // this is the second hash mark, offset from the center. 
   SPORT_CALCANEUS_OFFSET_X_MAJOR = 15, // this is the third and largest hash mark, offset from the center. 
};

/**
   The hardware id (HWID) is used to determine the type of hardware that is being communicating with. This the type of the hardware that the PC
   is directly communicating with, NOT the type of any further downstream device (ex: plate, plylon).
   If the PC is connected to a transducer, either via USB or directly, the hardware ID will be that of the transducer.
   If the PC is connected to a signal converter, the hardware ID will be that of the signal converter.
   Note that the id values are grouped in blocks of 10, and that the lower digit should be masked off. For example, any hardware id with a value
   in the 90-99 range should be considered an AM6817
*/
enum bertec_HardwareIDs
{
   HWID_UNKNOWN= 0, /** the device firmware did not provide a hardware id value */

   HWID_AM6500 = 20, /** serial-to-USB signal converter */

   HWID_AM6143 = 40, /** 1st generation USB preamplifier */

   HWID_AM6817 = 90, /** serial-to-USB/analog signal converters. Different hardware ids refer to different generations of the 6817 series */
   HWID_AM6817A = 90,
   HWID_AM6817B = 91,
   HWID_AM6817C = 92,
   HWID_AM6817D = 93,
   HWID_AM6817E = 94,

   HWID_AM6145 = 110, /** force plate preamplifier via a direct connection without a signal converter */

   HWID_AM6146 = 120, /** custom USB preamplifier project, not publicly released. */

   HWID_AM6800 = 150, /** serial-to-USB/analog signal converter */

   HWID_AM6147 = 160, /** 2nd generation USB preamplifier */
   HWID_AM6147A = 160,
   HWID_AM6147B = 161,
   HWID_AM6147C = 162,
   HWID_AM6147D = 163,
   HWID_AM6147E = 164,
};

/** Defined errors and status values */
enum bertec_StatusErrors
{
   BERTEC_NOERROR                = 0,/** Generic no error */
   BERTEC_NO_BUFFERS_SET         = -2,/** no data buffers were allocated */
   BERTEC_DATA_BUFFER_OVERFLOW   = -4,/** the internal buffer has become saturated; either data polling isn't occuring often/fast enough,
                                   or else your callback is blocking for too long. Old data is now lost. */


   BERTEC_NO_DEVICES_FOUND       = -5,/** there are apparently no devices attached */

   BERTEC_DATA_READ_NOT_STARTED  = -6,/** didn't start the data process - call Start */

   BERTEC_DATA_SYNCHRONIZING     = -7,/** synchronizing, data not available yet */

   BERTEC_DATA_SYNCHRONIZE_LOST  = -8,/** the plates have lost sync with each other - check sync cable */


   BERTEC_DATA_SEQUENCE_MISSED   = -9,/** one or more plates have missing data sequence - data may be invalid */

   BERTEC_DATA_SEQUENCE_REGAINED = -10,/** the plates have regained their data sequence */


   BERTEC_NO_DATA_RECEIVED       = -11,/** no data is being received from the devices, check the cables */


   BERTEC_DEVICE_HAS_FAULTED     = -12,/** the device has failed in some manner - power off the device, check all connections, power back on */

   BERTEC_UNABLE_TO_START_STARTED   = -30, /** bertec_Start() was called twice; the second call was ignored */
   BERTEC_UNABLE_TO_START_STOPPING  = -31, /** bertec_Start() was called while the last bertec_Stop() call was still being processed; the bertec_Start() call was ignored. */
   BERTEC_UNABLE_TO_STOP_NOTRUNNING = -32, /** bertec_Stop() was called but bertec_Start() was not called first; the library is already stopped. */
   BERTEC_UNABLE_TO_STOP_STOPPING   = -33, /** bertec_Stop() was called twice; the second call was ignored */
   BERTEC_UNABLE_TO_STOP_STARTING   = -34, /** bertec_Stop() was called while the last bertec_Start() call was still being processed; the bertec_Stop() call may not take effect. */

   BERTEC_UNABLE_TO_START_FAILED = -35,   /** Internal error - device threads have failed to spin up */
   BERTEC_UNABLE_TO_STOP_FAILED = -36, /** Internal error - device threads have failed to shut down */

   BERTEC_LOOKING_FOR_DEVICES    = -45,/** the sdk is scanning for devices; the next status will be either BERTEC_NO_DEVICES_FOUND or BERTEC_DEVICES_READY */

   BERTEC_DEVICES_READY          = -50,/** there are devices connected */

   BERTEC_AUTOZEROSTATE_WORKING  = -51,/** currently finding the zero values */

   BERTEC_AUTOZEROSTATE_ZEROFOUND =-52,/** the zero leveling value was found */

   BERTEC_ERROR_INVALIDHANDLE    = -100,/** handle is invalid */

   BERTEC_UNABLE_TO_LOCK_MUTEX   = -101,/** internal logic error */

   BERTEC_UNSUPPORED_COMMAND     = -200,/** the firmware doesn't support the command that was attempted to be used */

   BERTEC_INVALID_PARAMETER      = -201,
   BERTEC_INDEX_OUT_OF_RANGE     = -202,

   BERTEC_GENERIC_ERROR          = -32767
};


/** returns the version of the library. This should match BERTEC_LIBRARY_VERSION */
BIFH_EXPORT unsigned int bertec_LibraryVersion();

/** initialize the library, returns a handle */
BIFH_EXPORT bertec_Handle bertec_Init(void);

/** close the library when it's no longer needed */
BIFH_EXPORT void bertec_Close(bertec_Handle bHand);

/** verifies that the handle passed is a legitimate bertec_Handle item. Returns FALSE if not. */
BIFH_EXPORT bool bertec_CheckHandle( bertec_Handle bHand );

/** start the device detection and data collection */
BIFH_EXPORT int bertec_Start(bertec_Handle bHand);

/** stops all data collection and disconnects from all devices */
BIFH_EXPORT int bertec_Stop(bertec_Handle bHand);

/** returns the current status */
BIFH_EXPORT int bertec_GetStatus(bertec_Handle bHand);

/** returns the number of devices connected to the system. Only valid once start has been called and devices have been found. */
BIFH_EXPORT int bertec_GetDeviceCount(bertec_Handle bHand);

/** copies the current device info at the given index to the passed buffer. If there is no device at that index returns OUT OF RANGE */
BIFH_EXPORT int bertec_GetDeviceInfo(bertec_Handle bHand, int deviceIndex, bertec_DeviceInfo * info, size_t infoSize);

/** convenience function to access the device's serial number */
BIFH_EXPORT int bertec_GetDeviceSerialNumber(bertec_Handle bHand,int deviceIndex,char *buffer,size_t bufferSize);

/** convenience function to access the device's model number */
BIFH_EXPORT int bertec_GetDeviceModelNumber( bertec_Handle bHand, int deviceIndex, char *buffer, size_t bufferSize );

/** convenience function to access the device's channels. Returns # of channels and fills the buffer with a copy of bertec_DeviceInfo::channelNames */
BIFH_EXPORT int bertec_GetDeviceChannels(bertec_Handle bHand,int deviceIndex,char *buffer,size_t bufferSize);

BIFH_EXPORT int bertec_GetDeviceChannelCount( bertec_Handle bHand, int deviceIndex );

BIFH_EXPORT int bertec_GetDeviceChannelName(bertec_Handle bHand,int deviceIndex,int channelIndex,char *buffer,size_t bufferSize);

/** zero the input against what the plate has loaded on it right now */
BIFH_EXPORT int bertec_ZeroNow(bertec_Handle bHand);

/** enable/disable the autozeroing of the plate, which occurs if the plate is loaded at less than 40 Newtons for
    about 3.5 seconds. */
BIFH_EXPORT int bertec_SetEnableAutozero(bertec_Handle bHand,int enableFlag);
BIFH_EXPORT int bertec_GetEnableAutozero( bertec_Handle bHand );

/** returns the current autozering status. */
BIFH_EXPORT bertec_AutozeroStates bertec_GetAutozeroState(bertec_Handle bHand);

/** returns the zero level noise value for a device. ZeroNow/EnableAutozero must have been called.
    This is a computed value that can be used for advanced filtering. 
    This is always a positive value; negative values indicate no zeroing or some other error. */
BIFH_EXPORT float bertec_GetZeroLevelNoiseValue(bertec_Handle bHand,int deviceIndex,int channelIndex);

/** Average the samples. SamplesToAverage should be >= 2. Setting to 1 or less turns it off */
BIFH_EXPORT int bertec_SetAveraging(bertec_Handle bHand,int samplesToAverage);
BIFH_EXPORT int bertec_GetAveraging( bertec_Handle bHand );

/** Perform low-pass filtering on the samples. SamplesToFilter should be >=1. Setting to 0 or less turns it off. */
BIFH_EXPORT int bertec_SetLowpassFiltering(bertec_Handle bHand,int samplesToFilter);
BIFH_EXPORT int bertec_GetLowpassFiltering( bertec_Handle bHand);


/** callback registration functions
    * callbacks are called from a separate thread.
    * the callback is called with the user_data pointer passed to the register function
    * a callback is identified by the (function pointer, user data pointer) pair -
      the pair has to be unique.
    * the registration functions safely ignore any requests to register existing
      callbacks (i.e. same pair), or to unregister callbacks that are not
      registered at the moment.
    * if the userData value is not needed, it should be NULL.
    */

#ifndef bertec_DataCallback
typedef void (CALLBACK *bertec_DataCallback)(bertec_Handle bHand, bertec_DataFrame * dataFrame, void * userData);
#endif

BIFH_EXPORT int bertec_RegisterDataCallback(bertec_Handle bHand,bertec_DataCallback, void * userData);
BIFH_EXPORT int bertec_UnregisterDataCallback(bertec_Handle bHand,bertec_DataCallback, void * userData);


#ifndef bertec_StatusCallback
typedef void (CALLBACK *bertec_StatusCallback)(bertec_Handle bHand, int status, void * userData);
#endif

BIFH_EXPORT int bertec_RegisterStatusCallback(bertec_Handle bHand,bertec_StatusCallback, void * userData);
BIFH_EXPORT int bertec_UnregisterStatusCallback(bertec_Handle bHand,bertec_StatusCallback, void * userData);

/** This will set a callback that is used to sort the device order. By default they are sorted by usb hardware id/connection */
#ifndef bertec_DeviceSortCallback
typedef void (CALLBACK *bertec_DeviceSortCallback)(bertec_DeviceInfo* pInfos,int deviceCount,int* orderArray, void * userData);
#endif
BIFH_EXPORT int bertec_RegisterDeviceSortCallback(bertec_Handle bHand,bertec_DeviceSortCallback, void * userData);
BIFH_EXPORT int bertec_UnregisterDeviceSortCallback(bertec_Handle bHand,bertec_DeviceSortCallback, void * userData);

/** This will set a callback that is used whenever data is received from the USB connection, and is used to fill in the timestamp value.
    This value will override the hardware timestamp from the device when the clock source is set to CLOCK_SOURCE_INTERNAL. If the clock source
    is set to one of the three external signals, then this callback will be ignored.
    The callback implementation must return a non-repeating timestamp value expressed in 8ths of a millisecond (1 ms = step of 8). This is done so that
    the value passed here matches the output value in the bertec_AdditionalData.timestamp item.
    The device number requesting the timestamp will be passed, along with the user data pointer if set. */
#ifndef bertec_DeviceTimestampCallback
typedef int64_t (CALLBACK *bertec_DeviceTimestampCallback)(int deviceNum, void * userData);
#endif
BIFH_EXPORT int bertec_RegisterDeviceTimestampCallback( bertec_Handle bHand, bertec_DeviceTimestampCallback, void * userData );
BIFH_EXPORT int bertec_UnregisterDeviceTimestampCallback( bertec_Handle bHand, bertec_DeviceTimestampCallback, void * userData );


/** This will set a callback that is used whenever a new line of text is written to the device log file. The callback is called in the context of a worker
    thread and as such your own code should handle things appropriately. Use this to monitor and display text diagnostic data. The leading digits are the 
    millisecond timestamp when the message was generated (which will differ from when it is actually logged). */
#ifndef bertec_DeviceLogCallback
typedef void (CALLBACK *bertec_DeviceLogCallback)(const char* pszText, void * userData);
#endif
BIFH_EXPORT void bertec_RegisterDeviceLogCallback(bertec_DeviceLogCallback, void * userData);
BIFH_EXPORT void bertec_UnregisterDeviceLogCallback(bertec_DeviceLogCallback, void * userData);

/** If not using callbacks, calling this will read one sample from the buffered data and return ether 1 (data read but more left) or 0 (did not read, no more left)
    The dataFrame pointer MUST point to a valid bertec_DataFrame block, which will be filled in with the appropriate values. Passing NULL
    will result in an error. If there are no more data blocks waiting to be read in the buffer this will return zero.
    The dataFrameSize MUST be equal to the size of the bertec_DeviceData structure times the # of devices + the size of an int. */
BIFH_EXPORT int bertec_ReadBufferedData(bertec_Handle bHand, bertec_DataFrame * dataFrame, size_t dataFrameSize );

/** To facilitate create and using the buffer data reader, these two convenience functions have been provided.  */

/** This is a convenience for use with bertec_ReadBufferedData; it simply allocates a buffer large enough to handle
    the current number of connected devices. You must call free before exiting the sdk or re-allocating another buffer. */
BIFH_EXPORT bertec_DataFrame * bertec_AllocateReadBufferedData( bertec_Handle bHand, size_t* dataFrameSizeOut );
BIFH_EXPORT int bertec_FreeAllocatedReadBufferedData( bertec_Handle bHand, bertec_DataFrame* dataFrame );


/** This will return how many blocks of data are in the internal buffer and can be read via bertec_ReadBufferedData.
    This is a shortcut to calling bertec_ReadBufferedData(bHand,NULL)
    Only use this if your code is using bertec_ReadBufferedData (polling) instead of data callbacks. 
    */
BIFH_EXPORT int bertec_GetBufferedDataAvailable(bertec_Handle bHand);

/** discards all current data in the buffer. */
BIFH_EXPORT int bertec_ClearBufferedData(bertec_Handle bHand);

/** by default the SDK will buffer up to 100 samples before discarding old data. If you believe your system cannot keep up or are using slow polling, then
    increase this value. Be aware that larger values (ex: 5000) will dramatically increase memory usage which can impact your application.
     Note that changing the size will force a discard of all currently buffered data, so do this before calling Start. */
BIFH_EXPORT int bertec_ChangeMaxBufferedDataSize(bertec_Handle bHand,int newMaxSamples);

/** returns the currently set max buffer size, in samples. The default is 100 */
BIFH_EXPORT int bertec_GetMaxBufferedDataSize(bertec_Handle bHand);

/** Enables or disables the ability to compute certain channels from the force device's FZ, MX, and MY values. If the device does not have the
    appropriate channels, then setting this will have no effect. Note that turning on the COG and Sway Angle channels may incur a small CPU usage
    penalty and require setting the subject height via bertec_SetSubjectHeight. The COP calculation is a simple moments over force function and
    has little to no additional CPU overhead. The COP also does not need the subject height set in order to be used.
    This function must be called after bertec_Init but before bertec_Start; calling this while devices are actively delivering data will result in an error. */
BIFH_EXPORT int bertec_SetComputedChannelsFlags( bertec_Handle bHand, bertec_ComputedChannelFlags newMode );

BIFH_EXPORT bertec_ComputedChannelFlags bertec_GetComputedChannelsFlags( bertec_Handle bHand );

/** For the SwayAngle computation, the height of the person standing on the plate must be known. If this value is not set the program will
    default to 1.5 meters (1500mm). This value CAN be changed while data is being collected. */
BIFH_EXPORT int bertec_SetSubjectHeight( bertec_Handle bHand, float heightMM );

/** Enables or disables the ability to combine the output of two plates as one long virtual plate. This can be enabled or disabled at any point,
    and the output from the callback or data block will change accordingly. If this mode is turned on then the bertec_DataFrame::deviceCount value
    will be set to 1 even if there are more than one device connected, but Bertec_GetDeviceCount will always return the true number of devices
    connected to the system.
    In order for this to work properly both devices must be of the same type, same size, and have the same data channels. You should not try to
    combine a balance plate with a force plate, or a sport plate with a functional model for example. */
BIFH_EXPORT int bertec_SetAggregateDeviceMode( bertec_Handle bHand, int enable );

BIFH_EXPORT int bertec_GetAggregateDeviceMode( bertec_Handle bHand );

/** Enables or disables the slave/master setting when more than one device connected. If the ENABLE flag is FALSE or if there is only one device connected,
    the sync mode is set to SYNC_NONE (sampled) and internal hardware clock timers are reset (if present).
    If the ENABLE flag is TRUE and there is two or more devices, then the first device is set as SYNC_OUT_MASTER and all other devices are set as SYNC_IN_SLAVE,
    and internal hardware clock timers are reset (if present).
    By default the Master/Slave mode is enabled and will automatically be set up if two or more devices are present. Calling this with FALSE after Init but before
    calling Start will prevent this and cause all devices to run as SYNC_NONE. You can change this at any point during runtime by calling this with either TRUE
    or FALSE. 
    Calling this with TRUE is exactly the same as calling bertec_SetSyncPinMode with SYNC_OUT_MASTER for the first device and SYNC_IN_SLAVE for all others and
    resetting all clock timers to 0.
    */
BIFH_EXPORT int bertec_SetEnableMasterSlaveMode(bertec_Handle bHand,int enableMasterClock); // if false then all devices default/reset into SYNC_NONE.

BIFH_EXPORT int bertec_GetEnableMasterSlaveMode(bertec_Handle bHand);

/** Enables the ability for the SDK to clock the data stream against an external sync or clock source tied into the physical SYNC connection.
    Setting this to any non-zero value overrides the internal 1000hz hardware clock, allowing the data to be either under or over sampled as needed.
    Special note: using an external clock disables Averaging, low-pass Filtering, and multiple plate sync abilities; the SyncPinMode will be set to SYNC_NONE.
    Your hardware needs will dictate if this mode is suitable for your configuration, and your hardware must be capable of delivering the proper
    SYNC signal. Failure to do so will cause either random samples or no samples at all.
    */
BIFH_EXPORT int bertec_SetExternalClockMode( bertec_Handle bHand, int deviceIndex, bertec_ClockSourceFlags newMode );

/** Sets the SYNC pin operating mode. This is only valid for devices that support the extended SYNC and AUX feature set. Overrides the current master/slave relationship. */
BIFH_EXPORT int bertec_SetSyncPinMode(bertec_Handle bHand,int deviceIndex,bertec_SyncModeFlags newMode);

/** Sets the AUX pin operating mode. This is only valid for devices that support the extended SYNC and AUX feature set. */
BIFH_EXPORT int bertec_SetAuxPinMode(bertec_Handle bHand,int deviceIndex,bertec_AuxModeFlags newMode);

/** Sets both the SYNC and AUX output pins to the passed values; these values only take effect if the given pin has been set to _INSTANT.
    If the pin has not been set to _INSTANT, then the passed value is ignored. Note that you must pass both values even if you intend to only set one pin.
    Only valid for devices that support the extended SYNC and AUX feature set. */
BIFH_EXPORT int bertec_SetSyncAuxPinValues(bertec_Handle bHand,int deviceIndex, int syncValue, int auxValue);

/** Sets the device's internal clock timer (bertec_AdditionalData.timestamp) to the given value.
    This is only valid for devices that support the extended TIMESTAMP feature set; it will be ignored otherwise.
   */
BIFH_EXPORT int bertec_ResetDeviceClock(bertec_Handle bHand,int deviceIndex, int64_t newTimestampValue);

/** Sets all of the devices' internal clock timers (bertec_AdditionalData.timestamp) to the same given value.
    This is only valid for devices that support the extended TIMESTAMP feature set; it will be ignored otherwise.
   */
BIFH_EXPORT int bertec_ResetAllDeviceClocks(bertec_Handle bHand, int64_t newTimestampValue);

/** Sets the device's internal clock timer (bertec_AdditionalData.timestamp) to the given value when the timestamp reaches the condition value.
    This is only valid for devices that support the extended TIMESTAMP feature set; it will be ignored otherwise.
   */
BIFH_EXPORT int bertec_ResetDeviceClockAtTime(bertec_Handle bHand,int deviceIndex, int64_t newTimestampValue, int64_t futureConditionTime);

/** Sets all of the devices' internal clock timers (bertec_AdditionalData.timestamp) to the same given value when the timestamp reaches the condition value.
    This is only valid for devices that support the extended TIMESTAMP feature set; it will be ignored otherwise.
   */
BIFH_EXPORT int bertec_ResetAllDeviceClocksAtTime(bertec_Handle bHand, int64_t newTimestampValue, int64_t futureConditionTime);

/** By default, the library will only present data via the callback or data polling when *all* devices have data, allowing for software sync,
    device aggregation, and data averaging. This is typically the desired mode, but some applications may benefit from turning this functionality off.
    If the enabled parameter is set to 0 (false), then the library will present data whenever *any* device has data, even if the others do not.
    Software sync, device aggregation, and data averaging will *not* be performed in this mode. The data frame received by the callback or data polling
    will be incomplete; your implimentation must be ready to check for and handle cases where device #1 presents data but #2 will not, and then some
    frames later that will change to #2 has data but #1 does not; the data will appear to be unaligned with zero values for the no-data-present device structures.
    The simplest method to handle this situtation is to check the channelData.count value for the device; if this is zero, there is no data for that device
    in the current frame.
    Turning off unified data implies that your application will do it's own post-processing of the data, using either the sequence number or timestamp
    values to perform some kind of specialized alignment.
    Call this function prior to calling Start in order to ensure that the data being received is in the format expected.
    Using non-unified data mode with a single plate has no net effect.
    Computed channels, device clocks and sync pin settings (bertec_SetComputedChannelsFlags, bertec_ResetDeviceClock, bertec_SetExternalClockMode, etc)
    will still function if unified data is turned off; however, data averaging and aggregation (bertec_SetAveraging, bertec_SetAggregateDeviceMode) will not.
*/
BIFH_EXPORT int bertec_SetUnifiedDataMode( bertec_Handle bHand, int enabled );
BIFH_EXPORT int bertec_GetUnifiedDataMode( bertec_Handle bHand );


/** set the usb thread reader priority. Advanced functionality, usually not needed. */
BIFH_EXPORT void bertec_SetUsbThreadPriority(bertec_Handle bHand,int priority);

/** signals the sdk that it should perform a device rescan and reinit all the devices. This is the same as physically unplugging and
    then replugging all devices from the usb connection at the same time. The status BERTEC_LOOKING_FOR_DEVICES will be emitted. Does not block. */
BIFH_EXPORT int bertec_RedetectConnectedDevices( bertec_Handle bHand );

/** returns a dynamically computed value of the sample rate from the device, in hertz. This value is updated approximately every 100 ms */
BIFH_EXPORT float bertec_DeviceDataRate( bertec_Handle bHand );

/** This will reset the internal sync counters to zero; this is used with dual synced plates */
BIFH_EXPORT int bertec_ResetSyncCounters(bertec_Handle bHand);

/** Set or changes the output folder for the device logs and how long the logs should be kept. You should call this before anything else.
    Defaults to the %temp%/bertec-device-logs folder and 7 days. Pass NULL for the outputFolder to use the default directory, and 0 to turn off age cleaning.*/
BIFH_EXPORT void bertec_SetDeviceLogDirectory(const char *outputFolder,int maxAge);

/** Puts a copy of the current device log filename into the buffer array, and returns the length. If either buffer or maxBufferSize is NULL or 0,
    returns the needed minimum buffer size. */
BIFH_EXPORT int bertec_GetCurrentDeviceLogFilename(char* buffer,int maxBufferSize);

/** Change certain internal functionality as defined by the settings keys. Depending on the setting the value parm may be a number or a 0/1 bool value */
BIFH_EXPORT void bertec_SetInternalOption(const char *keyName,int value);


#ifdef  __cplusplus
   }
#endif

#endif
