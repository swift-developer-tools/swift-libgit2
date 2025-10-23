# Revwalk

Traverse the commit graph of a repository.

## Topics

### Enums

- ``GitSortT``

### Callbacks

- ``GitRevwalkHideCB``

### Functions

- ``gitRevwalkNew(out:repo:)``
- ``gitRevwalkReset(walker:)``
- ``gitRevwalkPush(walk:id:)``
- ``gitRevwalkPushGlob(walk:glob:)``
- ``gitRevwalkPushHEAD(walk:)``
- ``gitRevwalkHide(walk:commitID:)``
- ``gitRevwalkHideGlob(walk:glob:)``
- ``gitRevwalkHideHEAD(walk:)``
- ``gitRevwalkPushRef(walk:refName:)``
- ``gitRevwalkHideRef(walk:refName:)``
- ``gitRevwalkNext(out:walk:)``
- ``gitRevwalkSorting(walk:sortMode:)``
- ``gitRevwalkPushRange(walk:range:)``
- ``gitRevwalkSimplifyFirstParent(walk:)``
- ``gitRevwalkFree(walk:)``
- ``gitRevwalkRepository(walk:)``
- ``gitRevwalkAddHideCB(walk:hideCB:payload:)``
