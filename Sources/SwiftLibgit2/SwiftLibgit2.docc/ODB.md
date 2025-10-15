# ODB

Object databases.

## Topics

### Structs

- ``GitODBOptions``
- ``GitODBExpandID``

### Macros

- ``gitODBOptionsVersion``

### Enums

- ``GitODBLookupFlagsT``

### Callbacks

- ``GitODBForEachCB``

### Functions

- ``gitODBNew(odb:)``
- ``gitODBOpen(odbOut:objectsDir:)``
- ``gitODBAddDiskAlternate(odb:path:)``
- ``gitODBFree(db:)``
- ``gitODBRead(obj:db:id:)``
- ``gitODBReadPrefix(obj:db:shortID:len:)``
- ``gitODBReadHeader(lenOut:typeOut:db:id:)``
- ``gitODBExists(db:id:)``
- ``gitODBExistsExt(db:id:flags:)``
- ``gitODBExistsPrefix(out:db:shortID:len:)``
- ``gitODBExpandIDs(db:ids:count:)``
- ``gitODBRefresh(db:)``
- ``gitODBForEach(db:cb:payload:)``
- ``gitODBWrite(out:odb:data:len:type:)``
- ``gitODBOpenWStream(out:db:size:type:)``
- ``gitODBStreamWrite(stream:buffer:len:)``
- ``gitODBStreamFinalizeWrite(out:stream:)``
- ``gitODBStreamRead(stream:buffer:len:)``
- ``gitODBStreamFree(stream:)``
- ``gitODBOpenRStream(out:len:type:db:oid:)``
- ``gitODBWritePack(out:db:progressCB:progressPayload:)``
- ``gitODBWriteMultiPackIndex(db:)``
- ``gitODBHash(oid:data:len:objectType:)``
- ``gitODBHashFile(oid:path:objectType:)``
- ``gitODBObjectDup(dest:source:)``
- ``gitODBObjectFree(object:)``
- ``gitODBObjectID(object:)``
- ``gitODBObjectData(object:)``
- ``gitODBObjectSize(object:)``
- ``gitODBObjectType(object:)``
- ``gitODBAddBackend(odb:backend:priority:)``
- ``gitODBAddAlternate(odb:backend:priority:)``
- ``gitODBNumBackends(odb:)``
- ``gitODBGetBackend(out:odb:pos:)``
- ``gitODBSetCommitGraph(odb:cGraph:)``
