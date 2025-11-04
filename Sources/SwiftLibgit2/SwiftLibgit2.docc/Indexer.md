# Indexer

Produce an index from a packfile.

## Topics

### Structs

- ``GitIndexerProgress``
- ``GitIndexerOptions``

### Macros

- ``gitIndexerOptionsVersion``

### Callbacks

- ``GitIndexerProgressCB``

### Functions

- ``gitIndexerOptionsInit(opts:version:)``
- ``gitIndexerNew(out:path:mode:odb:opts:)``
- ``gitIndexerAppend(idx:data:size:stats:)``
- ``gitIndexerCommit(idx:stats:)``
- ``gitIndexerHash(idx:)``
- ``gitIndexerName(idx:)``
- ``gitIndexerFree(idx:)``
