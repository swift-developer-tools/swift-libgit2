# Config (Advanced)

Custom Git configuration backends.

## Topics

### Structs

- ``GitConfigBackendEntry``
- ``GitConfigIterator``
- ``GitConfigBackend``
- ``GitConfigBackendMemoryOptions``

### Macros

- ``gitConfigBackendVersion``
- ``gitConfigBackendMemoryOptionsVersion``

### Functions

- ``gitConfigInitBackend(backend:version:)``
- ``gitConfigAddBackend(cfg:file:level:repo:force:)``
- ``gitConfigBackendFromString(out:cfg:len:opts:)``
- ``gitConfigBackendFromValues(out:values:len:opts:)``
