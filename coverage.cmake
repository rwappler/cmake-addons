# mary, 2015/05/27

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(TEST_COVERAGE "true" CACHE BOOL "Set to true, to gather coverage information")
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    # required for ccache
    set(ENV{CCACHE_CPP2} "true")
    add_definitions("-Wno-error=unused-command-line-argument")
    
    find_program(LLVM_COV llvm-cov)
    if (DEFINED LLVM_COV)
        set(COVERAGE_COMMAND "${LLVM_COV}" CACHE FILEPATH
            "The coverage tool to use" FORCE)
    endif()
endif()

if (${TEST_COVERAGE})
    MESSAGE("Generating coverage information for debug builds")
    set(COVERAGE_DIR ${OUTPUT_DIR}/coverage)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} --coverage")
	# set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} --coverage")

	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
			MESSAGE("Searching for llvm-cov")
			find_program(COV_COMMAND llvm-cov)
			set(COVERAGE_COMMAND "${COV_COMMAND}"
				CACHE FILEPATH "Coverage Tool" FORCE)
	endif()

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
