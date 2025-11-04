# Revert

Cherry-pick the inverse of a commit to undo its changes.

## Topics

### Structs

- ``GitRevertOptions``

### Macros

- ``gitRevertOptionsVersion``

### Functions

- ``gitRevertOptionsInit(opts:version:)``
- ``gitRevertCommit(out:repo:revertCommit:ourCommit:mainline:mergeOptions:)``
- ``gitRevert(repo:commit:givenOpts:)``
