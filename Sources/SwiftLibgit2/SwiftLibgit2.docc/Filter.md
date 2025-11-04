# Filter

Modify files during checkout or commit operations.

## Topics

### Structs

- ``GitFilterOptions``

### Macros

- ``gitFilterOptionsVersion``

### Enums

- ``GitFilterModeT``
- ``GitFilterFlagT``

### Functions

- ``gitFilterListLoad(filters:repo:blob:path:mode:flags:)``
- ``gitFilterListLoadExt(filters:repo:blob:path:mode:opts:)``
- ``gitFilterListContains(filters:name:)``
- ``gitFilterListApplyToBuffer(out:filters:in:inLen:)``
- ``gitFilterListApplyToFile(out:filters:repo:path:)``
- ``gitFilterListApplyToBlob(out:filters:blob:)``
- ``gitFilterListStreamBuffer(filters:buffer:len:target:)``
- ``gitFilterListStreamFile(filters:repo:path:target:)``
- ``gitFilterListStreamBlob(filters:blob:target:)``
- ``gitFilterListFree(filters:)``
