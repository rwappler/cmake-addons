# 20160221
# CMake script to delete build output and cmake files

SET(cmake_generated ${CMAKE_BINARY_DIR}/CMakeCache.txt
    ${CMAKE_BINARY_DIR}/cmake_install.cmake
    ${CMAKE_BINARY_DIR}/Makefile
    ${CMAKE_BINARY_DIR}/CMakeFiles
    ${CMAKE_BINARY_DIR}/build)

foreach(file ${cmake_generated})
    if(EXISTS ${file})
        message(STATUS "Deleting ${file}")
        file(REMOVE_RECURSE ${file})
    endif()
endforeach()
