# Rebase

Manipulate commit history.

## Topics

### Structs

- ``GitRebaseOptions``
- ``GitRebaseOperation``

### Macros

- ``gitRebaseOptionsVersion``
- ``gitRebaseNoOperation``

### Enums

- ``GitRebaseOperationT``

### Functions

- ``gitRebaseOptionsInit(opts:version:)``
- ``gitRebaseInit(out:repo:branch:upstream:onto:opts:)``
- ``gitRebaseOpen(out:repo:opts:)``
- ``gitRebaseOrigHEADName(rebase:)``
- ``gitRebaseOrigHEADID(rebase:)``
- ``gitRebaseOntoName(rebase:)``
- ``gitRebaseOntoID(rebase:)``
- ``gitRebaseOperationEntryCount(rebase:)``
- ``gitRebaseOperationCurrent(rebase:)``
- ``gitRebaseOperationByIndex(rebase:idx:)``
- ``gitRebaseNext(operation:rebase:)``
- ``gitRebaseInMemoryIndex(index:rebase:)``
- ``gitRebaseCommit(id:rebase:author:committer:messageEncoding:message:)``
- ``gitRebaseAbort(rebase:)``
- ``gitRebaseFinish(rebase:signature:)``
- ``gitRebaseFree(rebase:)``
