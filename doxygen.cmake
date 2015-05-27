# mary, 2015/05/27

find_package(Doxygen)
if (DOXYGEN_FOUND)
    SET (DOC_OUTPUT_DIRECTORY "${OUTPUT_DIR}/doc")
    configure_file(${PROJECT_SOURCE_DIR}/doxyfile.in
        ${OUTPUT_DIR}/doxyfile @ONLY)
    add_custom_target(doc ${DOXYGEN_EXECUTABLE}
        ${OUTPUT_DIR}/doxyfile
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating API documentation"
        SOURCES ${PROJECT_SOURCE_DIR}/doxyfile.in)
endif(DOXYGEN_FOUND)