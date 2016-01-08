# mary, 2015/05/27

# Creating Coverage Reports without Debug information is nonsense.
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(TEST_COVERAGE "true" CACHE BOOL "Set to true, to gather coverage information")
elseif(${TEST_COVERAGE})
    message(WARNING "Test Coverage is true, but CMAKE_BUILD_TYPE is not Debug."
        " Coverage information will not be generated")
endif()

if (${TEST_COVERAGE})
    MESSAGE("Generating coverage information for debug builds")
    set(COVERAGE_DIR ${OUTPUT_DIR}/coverage)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} --coverage")

    set(LCOV_INFO ${COVERAGE_DIR}/coverage.info)
    set(LCOV_EXTRA_ARGS --base-directory "${CPP_SOURCE_DIR}" 
            --directory "${OUTPUT_DIR}"
            --no-external
            --gcov-tool "${COVERAGE_COMMAND}"
            --rc lcov_branch_coverage=1
            --rc geninfo_all_blocks=true)
    set(GENHTML_EXTRA_ARGS --show-details --frames --legend
            --branch-coverage --function-coverage --sort
            --demangle-cpp
            --title "${PROJECT_NAME}")

    add_custom_target(CreateCoverageDir ${CMAKE_COMMAND} -E make_directory
        "${COVERAGE_DIR}")
    add_custom_command(OUTPUT "${LCOV_INFO}.base"
        COMMAND lcov --capture --initial ${LCOV_EXTRA_ARGS}
            --output-file "${LCOV_INFO}.base"
        DEPENDS CreateCoverageDir
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

    add_custom_target(ZeroCoverage DEPENDS "${LCOV_INFO}.base")
    add_custom_target(CoverageReport
        DEPENDS "${LCOV_INFO}.base"
        COMMAND lcov --capture  ${LCOV_EXTRA_ARGS} 
            --output-file "${LCOV_INFO}.test"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        
        COMMAND lcov ${LCOV_EXTRA_ARGS}
            --add-tracefile "${LCOV_INFO}.base"
            --add-tracefile "${LCOV_INFO}.test"
            --output-file "${LCOV_INFO}.total"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        
        COMMAND lcov ${LCOV_EXTRA_ARGS}
            --remove "${LCOV_INFO}.total" "ui_*.h" "moc_*.cpp" "*.moc"
            --output-file "${LCOV_INFO}.clean"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        
        COMMAND genhtml ${GENHTML_EXTRA_ARGS}
            --output-directory "${OUTPUT_DIR}/coverage"
            "${LCOV_INFO}.clean"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        
        COMMENT Generate coverage report using lcov)        
endif(${TEST_COVERAGE})
