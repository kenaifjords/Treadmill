#include "bertecif.h"
#include <iostream>

int main() {
    std::cout << "Starting Bertec Demo App;)" << std::endl;
    std::cout << "Bertec version is: " << BERTEC_LIBRARY_VERSION << "and" << bertec_LibraryVersion() << std::endl;
    return 0;
}