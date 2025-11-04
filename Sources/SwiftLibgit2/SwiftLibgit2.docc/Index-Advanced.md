# Index (Advanced)

Low-level index management.

## Topics

### Structs

- ``GitIndexNameEntry``
- ``GitIndexREUCEntry``

### Functions

- ``gitIndexNameEntryCount(index:)``
- ``gitIndexNameGetByIndex(index:n:)``
- ``gitIndexNameAdd(index:ancestor:ours:theirs:)``
- ``gitIndexNameClear(index:)``
- ``gitIndexREUCEntryCount(index:)``
- ``gitIndexREUCFind(atPos:index:path:)``
- ``gitIndexREUCGetByPath(index:path:)``
- ``gitIndexREUCGetByIndex(index:n:)``
- ``gitIndexREUCAdd(index:path:ancestorMode:ancestorID:ourMode:ourID:theirMode:theirID:)``
- ``gitIndexREUCRemove(index:n:)``
- ``gitIndexREUCClear(index:)``
