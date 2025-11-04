# Pathspec

Path matching.

## Topics

### Enums

- ``GitPathspecFlagT``

### Functions

- ``gitPathspecNew(out:pathspec:)``
- ``gitPathspecFree(ps:)``
- ``gitPathspecMatchesPath(ps:flags:path:)``
- ``gitPathspecMatchWorkdir(out:repo:flags:ps:)``
- ``gitPathspecMatchIndex(out:index:flags:ps:)``
- ``gitPathspecMatchTree(out:tree:flags:ps:)``
- ``gitPathspecMatchDiff(out:diff:flags:ps:)``
- ``gitPathspecMatchListFree(m:)``
- ``gitPathspecMatchListEntryCount(m:)``
- ``gitPathspecMatchListEntry(m:pos:)``
- ``gitPathspecMatchListDiffEntry(m:pos:)``
- ``gitPathspecMatchListFailedEntryCount(m:)``
- ``gitPathspecMatchListFailedEntry(m:pos:)``
