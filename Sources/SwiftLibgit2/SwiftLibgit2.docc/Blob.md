# Blob

The raw data of a file in a repository.

## Topics

### Structs

- ``GitBlobFilterOptions``

### Macros

- ``gitBlobFilterOptionsVersion``

### Enums

- ``GitBlobFilterFlagT``

### Functions

- ``gitBlobLookup(blob:repo:id:)``
- ``gitBlobLookupPrefix(blob:repo:id:len:)``
- ``gitBlobFree(blob:)``
- ``gitBlobID(blob:)``
- ``gitBlobOwner(blob:)``
- ``gitBlobRawContent(blob:)``
- ``gitBlobRawSize(blob:)``
- ``gitBlobFilterOptionsInit(opts:version:)``
- ``gitBlobFilter(out:blob:asPath:opts:)``
- ``gitBlobCreateFromWorkdir(id:repo:relativePath:)``
- ``gitBlobCreateFromDisk(id:repo:path:)``
- ``gitBlobCreateFromStream(out:repo:hintPath:)``
- ``gitBlobCreateFromStreamCommit(out:stream:)``
- ``gitBlobCreateFromBuffer(id:repo:buffer:len:)``
- ``gitBlobIsBinary(blob:)``
- ``gitBlobDataIsBinary(data:len:)``
- ``gitBlobDup(out:source:)``
