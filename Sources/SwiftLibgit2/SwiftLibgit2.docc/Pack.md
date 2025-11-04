# Pack

Creation and management of packfiles.

## Topics

### Enums

- ``GitPackbuilderStageT``

### Callbacks

- ``GitPackbuilderForEachCB``
- ``GitPackbuilderProgressCB``

### Functions

- ``gitPackbuilderNew(out:repo:)``
- ``gitPackbuilderSetThreads(pb:n:)``
- ``gitPackbuilderInsert(pb:id:name:)``
- ``gitPackbuilderInsertTree(pb:id:)``
- ``gitPackbuilderInsertCommit(pb:id:)``
- ``gitPackbuilderInsertWalk(pb:walk:)``
- ``gitPackbuilderInsertRecur(pb:id:name:)``
- ``gitPackbuilderWriteBuf(buf:pb:)``
- ``gitPackbuilderWrite(pb:path:mode:progressCB:progressCBPayload:)``
- ``gitPackbuilderHash(pb:)``
- ``gitPackbuilderName(pb:)``
- ``gitPackbuilderForEach(pb:cb:payload:)``
- ``gitPackbuilderObjectCount(pb:)``
- ``gitPackbuilderWritten(pb:)``
- ``gitPackbuilderSetCallbacks(pb:progressCB:progressCBPayload:)``
- ``gitPackbuilderFree(pb:)``
