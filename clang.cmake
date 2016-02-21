# This file contains some specifics for for clang


if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

    # required for ccache
    # Note, that you still have to set CMAKE_*_COMPILER to a ccache binary
    if (CCACHE_FOUND)
        add_definitions("-Wno-error=unused-command-line-argument")
    endif()
    
    # just for the case, you want to generate coverage information
	MESSAGE("Searching for llvm-cov")
	find_program(COV_COMMAND llvm-cov)
	if(COV_COMMAND)
	    set(COVERAGE_COMMAND "${COV_COMMAND}"
		    CACHE FILEPATH "Coverage Tool" FORCE)
	endif()    
endif()
