project(open62541)
cmake_minimum_required(VERSION 3.5)



SET(${PROJECT_NAME}_MAJOR_VERSION 1)
SET(${PROJECT_NAME}_MINOR_VERSION 3)
SET(${PROJECT_NAME}_PATCH_VERSION 3)
include(${CMAKE_SOURCE_DIR}/cmake/set_version_numbers.cmake)
set(${PROJECT_NAME}_REVISION 4)
message(STATUS "Version number: ${${PROJECT_NAME}_FULL_LIBRARY_VERSION}")

if(${CMAKE_VERSION} VERSION_LESS "3.18.0") 
    message(STATUS "No update step will be applied.")
    set(UPDATESTRING "echo 'Nothing to do'")
else()
    set(UPDATESTRING "git checkout *")
endif()

include(ExternalProject)
 ExternalProject_Add(external-open62541
   GIT_REPOSITORY "https://github.com/open62541/open62541.git"
   GIT_TAG "v1.3.3"
   PREFIX "${CMAKE_BINARY_DIR}/open62541_src"
   CMAKE_ARGS
   "-DCMAKE_PROJECT_NAME=${PROJECT_NAME}"
   "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/open62541_install"
   "-DUA_ENABLE_AMALGAMATION=Off"
   "-DBUILD_SHARED_LIBS=ON"
   "-DUA_ENABLE_METHODCALLS=ON"
   "-DUA_ENABLE_NODEMANAGEMENT=ON"
   "-DUA_ENABLE_SUBSCRIPTIONS=ON"
   "-DUA_LOGLEVEL=300"
   "-DCMAKE_BUILD_TYPE=DEBUG"
   "-DPROJECT_BUILD_VERSION=$ENV{PROJECT_BUILDVERSION}"
   "-DPROJECT_REVISION=${${PROJECT_NAME}_REVISION}"
   "-DUA_ENABLE_ENCRYPTION=ON"
   "-DUA_ENABLE_HISTORIZING=ON"
  #"-DUA_ENABLE_GENERATE_NAMESPACE0=On"
  #"-DUA_ENABLE_ENABLE_MULTITHREADING=ON"
   PATCH_COMMAND git apply ${PROJECT_SOURCE_DIR}/cmakefile.patch
                           ${PROJECT_SOURCE_DIR}/FixForZeroSamplingInterval.patch
   UPDATE_COMMAND bash -c ${UPDATESTRING}
  )

install(DIRECTORY ${CMAKE_BINARY_DIR}/open62541_install/include/ DESTINATION include)
install(DIRECTORY ${CMAKE_BINARY_DIR}/open62541_install/lib/ DESTINATION lib )
install(DIRECTORY ${CMAKE_BINARY_DIR}/open62541_install/share/ DESTINATION share )
configure_file(${PROJECT_SOURCE_DIR}/open62541-config.in "${PROJECT_BINARY_DIR}/open62541-config" @ONLY)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/open62541-config DESTINATION bin COMPONENT dev)

##########################
# Packaging              #
##########################
# invoke via `make package`
set(open62541_extern ${CMAKE_BINARY_DIR}/open62541_src/src/external-open62541-build "open62541" "ALL" "/")
set(CPACK_INSTALL_CMAKE_PROJECTS ${open62541_extern})

execute_process(COMMAND lsb_release -cs
    OUTPUT_VARIABLE RELEASE_CODENAME
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
  set(CPACK_SYSTEM_NAME "amd64")
else()
  set(CPACK_SYSTEM_NAME "i386")
endif()  

# Copied from open62541/tools/packaging/CMakeLists.txt
set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_VENDOR "open62541 team")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "OPC UA implementation")
set(CPACK_PACKAGE_DESCRIPTION "open62541 is a C-based library (linking with C++ projects is possible) with all necessary tools to implement dedicated OPC UA clients and servers, or to integrate OPC UA-based communication into existing applications.")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${PROJECT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_VERSION_MAJOR "${${PROJECT_NAME}_MAJOR_VERSION}")
set(CPACK_PACKAGE_VERSION_MINOR "${${PROJECT_NAME}_MINOR_VERSION}")
set(CPACK_PACKAGE_VERSION_PATCH "${${PROJECT_NAME}_PATCH_VERSION}-${RELEASE_CODENAME}")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "open62541 team") #required
set(CPACK_DEBIAN_PACKAGE_RELEASE "${${PROJECT_NAME}_REVISION}")
include(CPack)
