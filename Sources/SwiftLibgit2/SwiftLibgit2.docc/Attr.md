# Attr

Additional information about how to handle certain paths.

## Topics

### Structs

- ``GitAttrOptions``

### Macros

- ``gitAttrIsTrue(attr:)``
- ``gitAttrIsFalse(attr:)``
- ``gitAttrIsUnspecified(attr:)``
- ``gitAttrHasValue(attr:)``
- ``gitAttrOptionsVersion``

### Enums

- ``GitAttrCheckFlagsT``
- ``GitAttrValueT``

### Callbacks

- ``GitAttrForEachCB``

### Functions

- ``gitAttrValue(attr:)``
- ``gitAttrGet(valueOut:repo:flags:path:name:)``
- ``gitAttrGetExt(valueOut:repo:opts:path:name:)``
- ``gitAttrGetMany(valueOut:repo:flags:path:numAttr:names:)``
- ``gitAttrGetManyExt(valueOut:repo:opts:path:numAttr:names:)``
- ``gitAttrForEach(repo:flags:path:callback:payload:)``
- ``gitAttrForEachExt(repo:opts:path:callback:payload:)``
- ``gitAttrCacheFlush(repo:)``
- ``gitAttrAddMacro(repo:name:values:)``
