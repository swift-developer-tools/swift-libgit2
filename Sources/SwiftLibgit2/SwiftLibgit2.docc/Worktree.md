# Worktree

Additional working directories for a repository.

## Topics

### Structs

- ``GitWorktreeAddOptions``
- ``GitWorktreePruneOptions``

### Macros

- ``gitWorktreeAddOptionsVersion``
- ``gitWorktreePruneOptionsVersion``

### Enums

- ``GitWorktreePruneT``

### Functions

- ``gitWorktreeList(out:repo:)-5tysn``
- ``gitWorktreeLookup(out:repo:name:)``
- ``gitWorktreeOpenFromRepository(out:repo:)``
- ``gitWorktreeFree(wt:)``
- ``gitWorktreeValidate(wt:)``
- ``gitWorktreeAddOptionsInit(opts:version:)``
- ``gitWorktreeAdd(out:repo:name:path:opts:)``
- ``gitWorktreeLock(wt:reason:)``
- ``gitWorktreeUnlock(wt:)``
- ``gitWorktreeIsLocked(reason:wt:)``
- ``gitWorktreeName(wt:)``
- ``gitWorktreePath(wt:)``
- ``gitWorktreePruneOptionsInit(opts:version:)``
- ``gitWorktreeIsPrunable(wt:opts:)``
- ``gitWorktreePrune(wt:opts:)``
