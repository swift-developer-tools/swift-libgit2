# Filter (Advanced)

Custom filter backends and plugins.

## Topics

### Structs

- ``GitFilter``

### Macros

- ``gitFilterCRLF``
- ``gitFilterIdent``
- ``gitFilterCRLFPriority``
- ``gitFilterIdentPriority``
- ``gitFilterDriverPriority``
- ``gitFilterVersion``

### Callbacks

- ``GitFilterInitFN``
- ``GitFilterShutdownFN``
- ``GitFilterCheckFN``
- ``GitFilterApplyFN``
- ``GitFilterStreamFN``
- ``GitFilterCleanupFN``

### Functions

- ``gitFilterLookup(name:)``
- ``gitFilterListNew(out:repo:mode:options:)``
- ``gitFilterListPush(fl:filter:payload:)``
- ``gitFilterListLength(fl:)``
- ``gitFilterSourceRepo(src:)``
- ``gitFilterSourcePath(src:)``
- ``gitFilterSourceFileMode(src:)``
- ``gitFilterSourceID(src:)``
- ``gitFilterSourceMode(src:)``
- ``gitFilterSourceFlags(src:)``
- ``gitFilterInit(filter:version:)``
- ``gitFilterRegister(name:filter:priority:)``
- ``gitFilterUnregister(name:)``
