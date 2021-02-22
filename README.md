# open62541-interface

The project is used to add bug fixes and features to the open62541 stack, that are not yet available in the stack. 
This package is used by ChimeraTK packages that make use of OPC UA. Currently those are:

* ControlSystemAdapter-OPC-UA-Adapter
* DeviceAccess-OPC-UA-Backend

The idea is to provide a cmake interface that is identical to the offcial cmake interface. That allows to build the ChimeraTK packages that require OPC UA also against the offcial open6251 stack. 
