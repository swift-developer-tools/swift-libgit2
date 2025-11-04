# Tree

Collections of files and folders in a repository's hierarchy.

## Topics

### Structs

- ``GitTreeUpdate``

### Enums

- ``GitTreewalkMode``
- ``GitTreeUpdateT``
- ``GitFileModeT``

### Callbacks

- ``GitTreebuilderFilterCB``
- ``GitTreewalkCB``

### Functions

- ``gitTreeLookup(out:repo:id:)``
- ``gitTreeLookupPrefix(out:repo:id:len:)``
- ``gitTreeFree(tree:)``
- ``gitTreeID(tree:)``
- ``gitTreeOwner(tree:)``
- ``gitTreeEntryCount(tree:)``
- ``gitTreeEntryByName(tree:fileName:)``
- ``gitTreeEntryByIndex(tree:idx:)``
- ``gitTreeEntryByID(tree:id:)``
- ``gitTreeEntryByPath(out:root:path:)``
- ``gitTreeEntryDup(out:source:)``
- ``gitTreeEntryFree(entry:)``
- ``gitTreeEntryName(entry:)``
- ``gitTreeEntryID(entry:)``
- ``gitTreeEntryType(entry:)``
- ``gitTreeEntryFileMode(entry:)``
- ``gitTreeEntryFileModeRaw(entry:)``
- ``gitTreeEntryCmp(e1:e2:)``
- ``gitTreeEntryToObject(objectOut:repo:entry:)``
- ``gitTreebuilderNew(out:repo:source:)``
- ``gitTreebuilderClear(bld:)``
- ``gitTreebuilderEntryCount(bld:)``
- ``gitTreebuilderFree(bld:)``
- ``gitTreebuilderGet(bld:fileName:)``
- ``gitTreebuilderInsert(out:bld:fileName:id:fileMode:)``
- ``gitTreebuilderRemove(bld:fileName:)``
- ``gitTreebuilderFilter(bld:filter:payload:)``
- ``gitTreebuilderWrite(id:bld:)``
- ``gitTreeWalk(tree:mode:callback:payload:)``
- ``gitTreeDup(out:source:)``
- ``gitTreeCreateUpdated(out:repo:baseline:nUpdates:updates:)``
