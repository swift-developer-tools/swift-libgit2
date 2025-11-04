# Repository

The history of source tree revisions.

## Topics

### Structs

- ``GitRepositoryInitOptions``

### Macros

- ``gitRepositoryInitOptionsVersion``

### Enums

- ``GitRepositoryOpenFlagT``
- ``GitRepositoryInitFlagT``
- ``GitRepositoryInitModeT``
- ``GitRepositoryItemT``
- ``GitRepositoryStateT``

### Callbacks

- ``GitRepositoryFETCHHEADForEachCB``
- ``GitRepositoryMERGEHEADForEachCB``

### Functions

- ``gitRepositoryOpen(out:path:)``
- ``gitRepositoryOpenFromWorktree(out:wt:)``
- ``gitRepositoryWrapODB(out:odb:)``
- ``gitRepositoryDiscover(out:startPath:acrossFS:ceilingDirs:)``
- ``gitRepositoryOpenExt(out:path:flags:ceilingDirs:)``
- ``gitRepositoryOpenBare(out:barePath:)``
- ``gitRepositoryFree(repo:)``
- ``gitRepositoryInit(out:path:isBare:)``
- ``gitRepositoryInitOptionsInit(opts:version:)``
- ``gitRepositoryInitExt(out:repoPath:opts:)``
- ``gitRepositoryHEAD(out:repo:)``
- ``gitRepositoryHEADForWorktree(out:repo:name:)``
- ``gitRepositoryHEADDetached(repo:)``
- ``gitRepositoryHEADDetachedForWorktree(repo:name:)``
- ``gitRepositoryHEADUnborn(repo:)``
- ``gitRepositoryIsEmpty(repo:)``
- ``gitRepositoryItemPath(out:repo:item:)``
- ``gitRepositoryPath(repo:)``
- ``gitRepositoryWorkdir(repo:)``
- ``gitRepositoryCommonDir(repo:)``
- ``gitRepositorySetWorkdir(repo:workdir:updateGitlink:)``
- ``gitRepositoryIsBare(repo:)``
- ``gitRepositoryIsWorktree(repo:)``
- ``gitRepositoryConfig(out:repo:)``
- ``gitRepositoryConfigSnapshot(out:repo:)``
- ``gitRepositoryODB(out:repo:)``
- ``gitRepositoryRefDB(out:repo:)``
- ``gitRepositoryIndex(out:repo:)``
- ``gitRepositoryMessage(out:repo:)``
- ``gitRepositoryMessageRemove(repo:)``
- ``gitRepositoryStateCleanup(repo:)``
- ``gitRepositoryFETCHHEADForEach(repo:callback:payload:)``
- ``gitRepositoryMERGEHEADForEach(repo:callback:payload:)``
- ``gitRepositoryHashFile(out:repo:path:type:asPath:)``
- ``gitRepositorySetHEAD(repo:refName:)``
- ``gitRepositorySetHEADDetached(repo:committish:)``
- ``gitRepositorySetHEADDetachedFromAnnotated(repo:committish:)``
- ``gitRepositoryDetachHEAD(repo:)``
- ``gitRepositoryState(repo:)``
- ``gitRepositorySetNamespace(repo:nmspace:)``
- ``gitRepositoryGetNamespace(repo:)``
- ``gitRepositoryIsShallow(repo:)``
- ``gitRepositoryIdent(name:email:repo:)``
- ``gitRepositorySetIdent(repo:name:email:)``
- ``gitRepositoryOIDType(repo:)``
- ``gitRepositoryCommitParents(commits:repo:)``
