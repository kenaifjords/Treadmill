cmake_minimum_required(VERSION 3.18)
project(ClosedLoopFeedback)

set(BERTEC_FOLDER_NAME "BertecSDKOctober2022")
set(BERTEC_ZIP_NAME "${BERTEC_FOLDER_NAME}.zip")
if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_FOLDER_NAME})
    message(STATUS "Bertec is pre-downloaded, skipping download. Delete build directory if you want to re-download.")
else()
    message(STATUS "Downloading Bertec SDK...")
    file(DOWNLOAD https://downloads.bertec.com/Bertec_Device_SDK_August_2022.zip ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_ZIP_NAME} SHOW_PROGRESS)
    file(ARCHIVE_EXTRACT INPUT ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_ZIP_NAME}
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_FOLDER_NAME}
        VERBOSE
    )
endif()

if(WIN32)
    # Prefix all shared libraries with 'lib'.
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
    # Prefix all static libraries with 'lib'.
    set(CMAKE_STATIC_LIBRARY_PREFIX "")
endif()

# Allow selecting static or dynamic
# https://cmake.org/cmake/help/latest/guide/tutorial/Selecting%20Static%20or%20Shared%20Libraries.html#step-9-selecting-static-or-shared-libraries
option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)



# Load the library into CMake
# We may be able to call "regsvr32 BertecDevice.lib", but that fails on all of them so far
# TODO determine when to use the x64 directory
add_library(BertecDevice ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_FOLDER_NAME}/x64/BertecDevice.lib)

# Create an alias (modern cmake style) so we can be sure it is found for linking
add_library(Bertec::BertecDevice ALIAS BertecDevice)
# Because CMake cannot determine the linker language on it's own, set it to C++ here
set_target_properties(BertecDevice PROPERTIES LINKER_LANGUAGE C)

# Now we include directories, again, using brittle absolute paths
target_include_directories(BertecDevice PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_FOLDER_NAME})

# Try building the bertec example
add_executable(BertecExample ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_FOLDER_NAME}/BertecExample.cpp)
target_link_libraries(BertecExample PUBLIC Bertec::BertecDevice)
set_target_properties(BertecExample PROPERTIES LINKER_LANGUAGE C)

# Finally, link the Bertec Library to the add_executable
# add_executable(DemoLinkageExe main.cpp)
# target_link_libraries(DemoLinkageExe PUBLIC Bertec::BertecDevice)
