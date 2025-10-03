# Blame

Decorate individual lines in a file with the commit that introduced the changes.

## Topics

### Structs

- ``GitBlameOptions``
- ``GitBlameHunk``
- ``GitBlameLine``

### Macros

- ``gitBlameOptionsVersion``

### Enums

- ``GitBlameFlagT``

### Functions

- ``gitBlameLineCount(blame:)``
- ``gitBlameHunkCount(blame:)``
- ``gitBlameHunkByIndex(blame:index:)``
- ``gitBlameHunkByLine(blame:lineNo:)``
- ``gitBlameLineByIndex(blame:idx:)``
- ``gitBlameGetHunkCount(blame:)``
- ``gitBlameGetHunkByIndex(blame:index:)``
- ``gitBlameGetHunkByLine(blame:lineNo:)``
- ``gitBlameFile(out:repo:path:options:)``
- ``gitBlameBuffer(out:base:buffer:bufferLen:)``
- ``gitBlameFree(blame:)``
