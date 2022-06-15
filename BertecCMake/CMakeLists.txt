cmake_minimum_required(VERSION 3.14.3)
project(ClosedLoopFeedback)

set(BERTEC_FOLDER_NAME "BertecSDKOctober2019")
set(BERTEC_ZIP_NAME "${BERTEC_FOLDER_NAME}.zip")
if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/_deps/BertecSDKOctober2019)
    message(STATUS "Bertec is pre-downloaded, skipping download. Delete build directory if you want to re-download.")
else()
    message(STATUS "Downloading Bertec SDK...")
    file(DOWNLOAD https://downloads.bertec.com/Bertec_Device_SDK_October_2019.zip ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_ZIP_NAME} SHOW_PROGRESS)
    file(ARCHIVE_EXTRACT INPUT ${CMAKE_CURRENT_BINARY_DIR}/_deps/${BERTEC_ZIP_NAME}
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/_deps/BertecSDKOctober2019
        VERBOSE
    )
endif()

# set(CMAKE_CXX_STANDARD 11)
add_executable(DemoLinkageExe main.cpp)

# Load the library into CMake
# We may be able to call "regsvr32 BertecDevice.lib", but that fails on all of them so far
# TODO determine when to use the x64 directory
add_library(Bertec ${CMAKE_CURRENT_BINARY_DIR}/_deps/BertecSDKOctober2019/BertecDevice.lib)

# Create an alias (modern cmake style) so we can be sure it is found for linking
add_library(Bertec::bertec ALIAS Bertec)
# Because CMake cannot determine the linker language on it's own, set it to C++ here
set_target_properties(Bertec PROPERTIES LINKER_LANGUAGE CXX)

# Now we include directories, again, using brittle absolute paths
target_include_directories(Bertec PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/_deps/BertecSDKOctober2019)

# Finally, link the Bertec Library to the add_executable
target_link_libraries(DemoLinkageExe PUBLIC Bertec::bertec)