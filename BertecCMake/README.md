# Closed Loop Control

Rachel Marbaker

## Setup

* See References
* For bertec, I tried installing the Bertec DLL... it failed to install, and also failed to uninstall.

    `regsvr32 BertecDevice.dll`

## Build

In a MSYS2 terminal, navigate to this directory, then run the following.
```
cd /f/Users/Rachel/ClosedLoopControl
# Generate
cmake -G "MSYS Makefiles" -S . -B build
# OR 
cmake -G "MinGW Makefiles" -S . -B build
# Run the build tool (you could call make directly)
cmake --build build
# Run
./build/DemoLinkageExe
```

To be convenient, you can combine them all.

## Troubleshooting

```
$ cmake -G "MSYS Makefiles" -S . -B build && cmake --build build && ./build/DemoLinkageExe.exe
-- Configuring done
-- Generating done
-- Build files have been written to: F:/Users/Rachel/ClosedLoopControl/build
[ 33%] Built target Bertec
Consolidate compiler generated dependencies of target DemoLinkageExe
[ 66%] Linking CXX executable DemoLinkageExe.exe
C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/11.3.0/../../../../x86_64-w64-mingw32/bin/ld.exe: CMakeFiles/DemoLinkageExe.dir/objects.a(main.cpp.obj):main.cpp:(.text+0x79): undefined reference to `__imp_bertec_LibraryVersion'
collect2.exe: error: ld returned 1 exit status
make[2]: *** [CMakeFiles/DemoLinkageExe.dir/build.make:102: DemoLinkageExe.exe] Error 1
make[1]: *** [CMakeFiles/Makefile2:85: CMakeFiles/DemoLinkageExe.dir/all] Error 2
make: *** [Makefile:91: all] Error 2
```


## References

* [Setup Instructions](https://docs.google.com/document/d/1qPVCVi-5vuUVGVsCsM8hnhSn-FHlYV2f4-WbrWuzfWM/edit?usp=sharing)