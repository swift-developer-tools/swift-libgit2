# Stash

Store uncommitted changes.

## Topics

### Structs

- ``GitStashSaveOptions``
- ``GitStashApplyOptions``

### Macros

- ``gitStashSaveOptionsVersion``
- ``gitStashApplyOptionsVersion``

### Enums

- ``GitStashFlags``
- ``GitStashApplyFlags``
- ``GitStashApplyProgressT``

### Callbacks

- ``GitStashApplyProgressCB``
- ``GitStashCB``

### Functions

- ``gitStashSave(out:repo:stasher:message:flags:)``
- ``gitStashSaveOptionsInit(opts:version:)``
- ``gitStashSaveWithOpts(out:repo:opts:)``
- ``gitStashApplyOptionsInit(opts:version:)``
- ``gitStashApply(repo:index:options:)``
- ``gitStashForEach(repo:callback:payload:)``
- ``gitStashDrop(repo:index:)``
- ``gitStashPop(repo:index:options:)``
