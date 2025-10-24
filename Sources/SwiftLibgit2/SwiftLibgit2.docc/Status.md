# Status

Changes in the index and working directory.

## Topics

### Structs

- ``GitStatusOptions``
- ``GitStatusEntry``

### Macros

- ``gitStatusOptDefaults``
- ``gitStatusOptionsVersion``

### Enums

- ``GitStatusT``
- ``GitStatusShowT``
- ``GitStatusOptT``

### Callbacks

- ``GitStatusCB``

### Functions

- ``gitStatusOptionsInit(opts:version:)``
- ``gitStatusForEach(repo:callback:payload:)``
- ``gitStatusForEachExt(repo:opts:callback:payload:)``
- ``gitStatusFile(statusFlags:repo:path:)``
- ``gitStatusListNew(out:repo:opts:)``
- ``gitStatusListEntryCount(statusList:)``
- ``gitStatusByIndex(statusList:idx:)``
- ``gitStatusListFree(statusList:)``
- ``gitStatusShouldIgnore(ignored:repo:path:)``
