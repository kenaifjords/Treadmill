This is the October 2019 Beta Release of the Bertec Device SDK. You will need your current Bertec Device's USB driver installed in order to use this. Digital Acquire is probably the easist way to download and install it. Contact Bertec Development if you would like instructions on how to package the USB driver for your own deployment.

This release of the SDK includes updated PDF documentation, example code for both C/C++ and C#.

If you were previously using the 2014 release of the SDK the major difference is that the new SDK changes how each "frame" of data is presented (being more structually defined) and that the new SYNC and AUX modes are supported, including the ability to sync aganst an external clock.

Also note that the header file and SDK interface has change in signifigant ways, which may require changes to your existing code base.

Any comments, questions, or suggestions should be directed to Todd Wilson at todd@bertec.com