# Cherrypick

Reapply the changes of an individual commit to the current index and working 
directory.

## Topics

### Structs

- ``GitCherrypickOptions``

### Macros

- ``gitCherrypickOptionsVersion``

### Functions

- ``gitCherrypickOptionsInit(opts:version:)``
- ``gitCherrypickCommit(out:repo:cherrypickCommit:ourCommit:mainline:mergeOptions:)``
- ``gitCherrypick(repo:commit:cherrypickOptions:)``
