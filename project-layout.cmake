# mary 2015/05/27

# Defines a default project tree layout as follows
# + src
# |  + main           # production sources
# |  |   + cpp        # production source C++
# |  + test           # test sources
# |      + cpp        # test sources
# + build             # output directory
#    + main           # main outputs
#    |   + cpp        # C++ binaries
#    + test           # test binaries
#        + cpp        # C++ test binaries
 
set(SOURCE_DIR "${PROJECT_SOURCE_DIR}/src")
set(OUTPUT_DIR "${PROJECT_BINARY_DIR}/build")

SET(CPP_SOURCE_DIR "${SOURCE_DIR}/main/cpp")
SET(CPP_BINARY_DIR "${OUTPUT_DIR}/main/cpp")
SET(CPP_TESTSRC_DIR "${SOURCE_DIR}/test/cpp")
SET(CPP_TESTBIN_DIR "${OUTPUT_DIR}/test/cpp")
