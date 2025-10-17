# Patch

Textual diffs in a delta.

## Topics

### Functions

- ``gitPatchOwner(patch:)``
- ``gitPatchFromDiff(out:diff:idx:)``
- ``gitPatchFromBlobs(out:oldBlob:oldAsPath:newBlob:newAsPath:opts:)``
- ``gitPatchFromBlobAndBuffer(out:oldBlob:oldAsPath:buffer:bufferLen:bufferAsPath:opts:)``
- ``gitPatchFromBuffers(out:oldBuffer:oldBufferLen:oldAsPath:newBuffer:newBufferLen:newAsPath:opts:)``
- ``gitPatchFree(patch:)``
- ``gitPatchGetDelta(patch:)``
- ``gitPatchNumHunks(patch:)``
- ``gitPatchLineStats(totalContext:totalAdditions:totalDeletions:patch:)``
- ``gitPatchGetHunk(out:linesInHunk:patch:hunkIdx:)``
- ``gitPatchNumLinesInHunk(patch:hunkIdx:)``
- ``gitPatchGetLineInHunk(out:patch:hunkIdx:lineOfHunk:)``
- ``gitPatchSize(patch:includeContext:includeHunkHeaders:includeFileHeaders:)``
- ``gitPatchPrint(patch:printCB:payload:)``
- ``gitPatchToBuf(out:patch:)``
