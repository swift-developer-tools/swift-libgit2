# Index

Index management.

## Topics

### Structs

- ``GitIndexTime``
- ``GitIndexEntry``

### Macros

- ``gitIndexEntryNameMask``
- ``gitIndexEntryStageMask``
- ``gitIndexEntryStageShift``
- ``gitIndexEntryStageSet(entry:stage:)``

### Enums

- ``GitIndexEntryFlagT``
- ``GitIndexEntryExtendedFlagT``
- ``GitIndexCapabilityT``
- ``GitIndexAddOptionT``
- ``GitIndexStageT``

### Callbacks

- ``GitIndexMatchedPathCB``

### Functions

- ``gitIndexOpen(indexOut:indexPath:)``
- ``gitIndexNew(indexOut:)``
- ``gitIndexFree(index:)``
- ``gitIndexOwner(index:)``
- ``gitIndexCaps(index:)``
- ``gitIndexSetCaps(index:caps:)``
- ``gitIndexVersion(index:)``
- ``gitIndexSetVersion(index:version:)``
- ``gitIndexRead(index:force:)``
- ``gitIndexWrite(index:)``
- ``gitIndexPath(index:)``
- ``gitIndexChecksum(index:)``
- ``gitIndexReadTree(index:tree:)``
- ``gitIndexWriteTree(out:index:)``
- ``gitIndexWriteTreeTo(out:index:repo:)``
- ``gitIndexEntryCount(index:)``
- ``gitIndexClear(index:)``
- ``gitIndexGetByIndex(index:n:)``
- ``gitIndexGetByPath(index:path:stage:)``
- ``gitIndexRemove(index:path:stage:)``
- ``gitIndexRemoveDirectory(index:dir:stage:)``
- ``gitIndexAdd(index:sourceEntry:)``
- ``gitIndexEntryStage(entry:)``
- ``gitIndexEntryIsConflict(entry:)``
- ``gitIndexIteratorNew(iteratorOut:index:)``
- ``gitIndexIteratorNext(out:iterator:)``
- ``gitIndexIteratorFree(iterator:)``
- ``gitIndexAddByPath(index:path:)``
- ``gitIndexAddFromBuffer(index:entry:buffer:len:)``
- ``gitIndexRemoveByPath(index:path:)``
- ``gitIndexAddAll(index:pathspec:flags:callback:payload:)``
- ``gitIndexRemoveAll(index:pathspec:callback:payload:)``
- ``gitIndexUpdateAll(index:pathspec:callback:payload:)``
- ``gitIndexFind(atPos:index:path:)``
- ``gitIndexFindPrefix(atPos:index:prefix:)``
- ``gitIndexConflictAdd(index:ancestoryEntry:ourEntry:theirEntry:)``
- ``gitIndexConflictGet(ancestorOut:ourOut:theirOut:index:path:)``
- ``gitIndexConflictRemove(index:path:)``
- ``gitIndexConflictCleanup(index:)``
- ``gitIndexHasConflicts(index:)``
- ``gitIndexConflictIteratorNew(iteratorOut:index:)``
- ``gitIndexConflictNext(ancestorOut:ourOut:theirOut:iterator:)``
- ``gitIndexConflictIteratorFree(iterator:)``
