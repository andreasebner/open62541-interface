# open62541-interface

The project add some bug fixes and features to the open62541 stack, that are not yet available in the stack. 
This package is used by ChimeraTK packages that make use of OPC UA. Currently those are:

* ControlSystemAdapter-OPC-UA-Adapter
* DeviceAccess-OPC-UA-Backend

The idea is to provide a cmake interface that is identical to the offcial cmake interface. That allows to build the ChimeraTK packages that require OPC UA also against the offcial open6251 stack. 
Currently that is not possible, because both ChimeraTK packages mentioned above use an almagamed open62541 header, but the debian dev packagage of the open62541 stack provided all the single header files

Furthermore, currently the package name of the open62541 stack is named libopen62541-1. Following this scheme the package provided here would be libopen62541-0. 
But, since we use DebianPackagingScripts it is not possible to provide a library (libopen62541.so) that does not match the package name.
Therefore, the pacakge associated with this project is named libopen62541.

Maybe one could use the open62541 internal CPack to build the debian package. Currently that is not possible because the CPack build settings and project configuration is only useful starting with v1.0. So once this version is used in ChimeraTK this would be an option.
 