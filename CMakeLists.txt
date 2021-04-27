project(open62541)
cmake_minimum_required(VERSION 3.5)

SET(${PROJECT_NAME}_MAJOR_VERSION 1)
SET(${PROJECT_NAME}_MINOR_VERSION 2)
SET(${PROJECT_NAME}_PATCH_VERSION 1)
include(${CMAKE_SOURCE_DIR}/cmake/set_version_numbers.cmake)

include(ExternalProject)
 ExternalProject_Add(external-open62541
   GIT_REPOSITORY "https://github.com/open62541/open62541.git"
   GIT_TAG "v1.2.1"
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
   "-D${PROJECT_NAME}_MAJOR_VERSION=${${PROJECT_NAME}_MAJOR_VERSION}"
   "-D${PROJECT_NAME}_MINOR_VERSION=${${PROJECT_NAME}_MINOR_VERSION}"
   "-D${PROJECT_NAME}_PATCH_VERSION=${${PROJECT_NAME}_PATCH_VERSION}"
   "-D${PROJECT_NAME}_BUILDVERSION=${${PROJECT_NAME}_BUILDVERSION}"
  #"-DUA_ENABLE_GENERATE_NAMESPACE0=On"
  #"-DUA_ENABLE_ENABLE_MULTITHREADING=ON"
  )

install(DIRECTORY ${CMAKE_BINARY_DIR}/open62541_install/include/ DESTINATION include)
install(DIRECTORY ${CMAKE_BINARY_DIR}/open62541_install/lib/ DESTINATION lib )
install(DIRECTORY ${CMAKE_BINARY_DIR}/open62541_install/share/ DESTINATION share )

##########################
# Packaging              #
##########################
# invoke via `make package`
set(open62541_extern ${CMAKE_BINARY_DIR}/open62541_src/src/external-open62541-build "open62541" "ALL" "/")
set(CPACK_INSTALL_CMAKE_PROJECTS ${open62541_extern})

# Copied from open62541/tools/packaging/CMakeLists.txt
set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_VENDOR "open62541 team")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "OPC UA implementation")
set(CPACK_PACKAGE_DESCRIPTION "open62541 is a C-based library (linking with C++ projects is possible) with all necessary tools to implement dedicated OPC UA clients and servers, or to integrate OPC UA-based communication into existing applications.")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${PROJECT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_VERSION_MAJOR "${${PROJECT_NAME}_MAJOR_VERSION}")
set(CPACK_PACKAGE_VERSION_MINOR "${${PROJECT_NAME}_MINOR_VERSION}")
set(CPACK_PACKAGE_VERSION_PATCH "${${PROJECT_NAME}_PATCH_VERSION}")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "open62541 team") #required

include(CPack)