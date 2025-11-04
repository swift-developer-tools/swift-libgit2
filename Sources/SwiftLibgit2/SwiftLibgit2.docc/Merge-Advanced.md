# Merge (Advanced)

Custom merge drivers.

## Topics

### Structs

- ``GitMergeDriver``

### Macros

- ``gitMergeDriverText``
- ``gitMergeDriverBinary``
- ``gitMergeDriverUnion``
- ``gitMergeDriverVersion``

### Callbacks

- ``GitMergeDriverInitFN``
- ``GitMergeDriverShutdownFN``
- ``GitMergeDriverApplyFN``

### Functions

- ``gitMergeDriverLookup(name:)``
- ``gitMergeDriverSourceRepo(src:)``
- ``gitMergeDriverSourceAncestor(src:)``
- ``gitMergeDriverSourceOurs(src:)``
- ``gitMergeDriverSourceTheirs(src:)``
- ``gitMergeDriverSourceFileOptions(src:)``
- ``gitMergeDriverRegister(name:driver:)``
- ``gitMergeDriverUnregister(name:)``
