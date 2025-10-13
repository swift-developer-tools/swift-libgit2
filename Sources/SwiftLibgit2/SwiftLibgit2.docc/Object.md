# Object

Blobs, trees, commits, and annotated tags.

## Topics

### Macros

- ``gitObjectSizeMax``

### Enums

- ``GitObjectT``

### Aliases

- ``GitObjectSizeT``

### Functions

- ``gitObjectLookup(object:repo:id:type:)``
- ``gitObjectLookupPrefix(objectOut:repo:id:len:type:)``
- ``gitObjectLookupByPath(out:treeish:path:type:)``
- ``gitObjectID(obj:)``
- ``gitObjectShortID(out:obj:)``
- ``gitObjectType(obj:)``
- ``gitObjectOwner(obj:)``
- ``gitObjectFree(object:)``
- ``gitObjectType2String(type:)``
- ``gitObjectString2Type(str:)``
- ``gitObjectPeel(peeled:object:targetType:)``
- ``gitObjectDup(dest:source:)``
- ``gitObjectRawContentIsValid(valid:buf:len:objectType:)``
