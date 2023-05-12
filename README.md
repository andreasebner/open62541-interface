# open62541-interface

The project is used to add bug fixes and features to the open62541 stack, that are not yet available in the stack. 
This package is used by ChimeraTK packages that make use of OPC UA. Currently those are:

* ControlSystemAdapter-OPC-UA-Adapter
* DeviceAccess-OPC-UA-Backend

The idea is to provide a cmake interface that is identical to the official cmake interface. 
That allows to build the ChimeraTK packages that require OPC UA also against the official open6251 stack. 
In general the aim is to integrate the patches and features to the `open62541` project.
But as long as this project includes patches or additional features building ChimeraTK packages against the official open62541 stack will result in a different behavior. 

## Cmake details

In this project the open62541 project is build as an external project. It is installed to a temporary directory in cmake's build directory.
In the install step files from the temporary directory are copied to the install directory set for the open62541-interface project.
In principle, the external project could be installed directly to the install directory of the open62541-interface project.
However, if the open62541-interface project is used with the DebianBuildScripts to build a debian package the taregt install directory is `/usr`.
When the external project would be installed directly to `/usr` in `pbuilder` environment an permission denied error is raised.
So this is not possible. 

With the solution of using a temporary install directory for the external project another problem arises.
If an install prefix of `/usr` is used cmake creates different config files (e.g. `open62541Config.cmake`) as if another prefix is used. 
Also the library install directory is different resulting from using `GNUInstallDirs` to determine the library install directory.
So to build a proper debian package using the  DebianBuildScripts the install prefix has to be `/usr` but `open62541` is build with a different install prefix.
Finally, the checks that are used to determine the integrity of the build debian package fail or projects using the open62541-interface will not find the library.

To solve the problem, install step of the external project is modified to use set the environment variable `DESTDIR`, which points to the build directory. 
Like that the external project can use the same install prefix as the open62541-interface project, i.e. `/usr` in case of building a debian package. 
In the install step of the open62541-interface project a subset of the external project installation is copied from the binary directory to the install destination of the open62541-interface project.
