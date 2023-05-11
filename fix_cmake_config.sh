#!/bin/bash

# Fix library path in cmake configuraiton.
# Parameter 1: Directory that includes the cmake files
# Parameter 2: Library install directory

#Backgroud: We install the external package open62541 to a temporary location in the Project binary directory.
#           This is done by setting the CMAKE_INSTALL_PREFIX of the external package to the temporary location.
#           In this case the CMAKE_INSTALL_LIBDIR will return lib. This path is used in the cmake configuration
#           of the open62541 pacakge. When we install the open62541-interface using the prefix /usr GNUInstallDirs
#           will set CMAKE_INSTALL_LIBDIR to lib/x86_64-linux-gnu - in that case the cmake configuration created
#           in the external project step will be wrong and still use lib as the CMAKE_INSTALL_PREFIX used in 
#           the external project step is a non system directory and GNUInstallDirs simply returns lib.
#           
#           With this script we simply replace the lib directory in the cmake configuration of the external project
#           to use the library directory resulting from the open62541-interface project.


if [ -z $2 ] ; then
  exit 1
fi

for file in `ls $1/open62541Targets-*.cmake`; do
  if grep -q "IMPORT_PREFIX}/lib" $file; then
    echo "Fixing file: $file Lib Path is: $2"
    if grep -q "IMPORT_PREFIX}/$2" $file; then
      echo "File is already fixed."
    else
      sed -i "s|\${_IMPORT_PREFIX}/lib/|\${_IMPORT_PREFIX}/$2/|g" $file
    fi
  fi
done