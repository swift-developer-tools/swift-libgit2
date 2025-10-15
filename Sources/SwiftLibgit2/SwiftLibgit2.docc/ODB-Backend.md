# ODB Backend

Object database backends.

## Topics

### Structs

- ``GitODBBackendPackOptions``
- ``GitODBBackendLooseOptions``
- ``GitODBStream``
- ``GitODBWritePack``

### Macros

- ``gitODBBackendPackOptionsVersion``
- ``gitODBBackendLooseOptionsVersion``

### Enums

- ``GitODBBackendLooseFlagT``
- ``GitODBStreamT``

### Functions

- ``gitODBBackendPack(out:objectsDir:)``
- ``gitODBBackendOnePack(out:indexFile:)``
- ``gitODBBackendLoose(out:objectsDir:compressionLevel:doFSync:dirMode:fileMode:)``
