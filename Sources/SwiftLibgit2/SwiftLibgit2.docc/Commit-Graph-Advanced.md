# Commit Graph (Advanced)

Information about commit relationships.

## Topics

### Structs

- ``GitCommitGraphWriterOptions``

### Macros

- ``gitCommitGraphWriterOptionsVersion``

### Enums

- ``GitCommitGraphSplitStrategyT``

### Functions

- ``gitCommitGraphOpen(cGraphOut:objectsDir:)``
- ``gitCommitGraphFree(cGraph:)``
- ``gitCommitGraphWriterOptionsInit(opts:version:)``
- ``gitCommitGraphWriterNew(out:objectsInfoDir:options:)``
- ``gitCommitGraphWriterFree(w:)``
- ``gitCommitGraphWriterAddIndexFile(w:repo:idxPath:)``
- ``gitCommitGraphWriterAddRevwalk(w:walk:)``
- ``gitCommitGraphWriterCommit(w:)``
- ``gitCommitGraphWriterDump(buffer:w:)``
