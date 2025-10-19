# Reflog

The log of how references have changed.

## Topics

### Functions

- ``gitReflogRead(out:repo:name:)``
- ``gitReflogWrite(reflog:)``
- ``gitReflogAppend(reflog:id:committer:msg:)``
- ``gitReflogRename(repo:oldName:name:)``
- ``gitReflogDelete(repo:name:)``
- ``gitReflogEntryCount(reflog:)``
- ``gitReflogEntryByIndex(reflog:idx:)``
- ``gitReflogDrop(reflog:idx:rewritePreviousEntry:)``
- ``gitReflogEntryIDOld(entry:)``
- ``gitReflogEntryIDNew(entry:)``
- ``gitReflogEntryCommitter(entry:)``
- ``gitReflogEntryMessage(entry:)``
- ``gitReflogFree(reflog:)``
