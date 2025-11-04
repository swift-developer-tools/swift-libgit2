# Submodule

The contents of a repository within another repository.

## Topics

### Structs

- ``GitSubmoduleUpdateOptions``

### Macros

- ``gitSubmoduleStatusInFlags``
- ``gitSubmoduleStatusIndexFlags``
- ``gitSubmoduleStatusWDFlags``
- ``gitSubmoduleStatusIsUnmodified(status:)``
- ``gitSubmoduleStatusIsIndexUnmodified(status:)``
- ``gitSubmoduleStatusIsWDUnmodified(status:)``
- ``gitSubmoduleStatusIsWDDirty(status:)``
- ``gitSubmoduleUpdateOptionsVersion``

### Enums

- ``GitSubmoduleStatusT``
- ``GitSubmoduleUpdateT``
- ``GitSubmoduleIgnoreT``
- ``GitSubmoduleRecurseT``

### Callbacks

- ``GitSubmoduleCB``

### Functions

- ``gitSubmoduleUpdateOptionsInit(opts:version:)``
- ``gitSubmoduleUpdate(submodule:init:options:)``
- ``gitSubmoduleLookup(out:repo:name:)``
- ``gitSubmoduleDup(out:source:)``
- ``gitSubmoduleFree(submodule:)``
- ``gitSubmoduleForEach(repo:callback:payload:)``
- ``gitSubmoduleAddSetup(out:repo:url:path:useGitlink:)``
- ``gitSubmoduleClone(out:submodule:opts:)``
- ``gitSubmoduleAddFinalize(submodule:)``
- ``gitSubmoduleAddToIndex(submodule:writeIndex:)``
- ``gitSubmoduleOwner(submodule:)``
- ``gitSubmoduleName(submodule:)``
- ``gitSubmodulePath(submodule:)``
- ``gitSubmoduleURL(submodule:)``
- ``gitSubmoduleResolveURL(out:repo:url:)``
- ``gitSubmoduleBranch(submodule:)``
- ``gitSubmoduleSetBranch(repo:name:branch:)``
- ``gitSubmoduleSetURL(repo:name:url:)``
- ``gitSubmoduleIndexID(submodule:)``
- ``gitSubmoduleHEADID(submodule:)``
- ``gitSubmoduleWDID(submodule:)``
- ``gitSubmoduleIgnore(submodule:)``
- ``gitSubmoduleSetIgnore(repo:name:ignore:)``
- ``gitSubmoduleUpdateStrategy(submodule:)``
- ``gitSubmoduleSetUpdate(repo:name:ignore:)``
- ``gitSubmoduleFetchRecurseSubmodules(submodule:)``
- ``gitSubmoduleSetFetchRecurseSubmodules(repo:name:fetchRecurseSubmodules:)``
- ``gitSubmoduleInit(submodule:overwrite:)``
- ``gitSubmoduleRepoInit(out:sm:useGitlink:)``
- ``gitSubmoduleSync(submodule:)``
- ``gitSubmoduleOpen(repo:submodule:)``
- ``gitSubmoduleReload(submodule:force:)``
- ``gitSubmoduleStatus(status:repo:name:ignore:)``
- ``gitSubmoduleLocation(locationStatus:submodule:)``
