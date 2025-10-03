# Diff

Indicate the difference between two versions of the repository.

## Topics

### Structs

- ``GitDiffFile``
- ``GitDiffDelta``
- ``GitDiffOptions``
- ``GitDiffBinaryFile``
- ``GitDiffBinary``
- ``GitDiffHunk``
- ``GitDiffLine``
- ``GitDiffSimilarityMetric``
- ``GitDiffFindOptions``
- ``GitDiffParseOptions``
- ``GitDiffPatchIDOptions``

### Macros

- ``gitDiffOptionsVersion``
- ``gitDiffHunkHeaderSize``
- ``gitDiffFindOptionsVersion``
- ``gitDiffParseOptionsVersion``
- ``gitDiffPatchIDOptionsVersion``

### Enums

- ``GitDiffOptionT``
- ``GitDiffFlagT``
- ``GitDeltaT``
- ``GitDiffBinaryT``
- ``GitDiffLineT``
- ``GitDiffFindT``
- ``GitDiffFormatT``
- ``GitDiffStatsFormatT``

### Callbacks

- ``GitDiffNotifyCB``
- ``GitDiffProgressCB``
- ``GitDiffFileCB``
- ``GitDiffBinaryCB``
- ``GitDiffHunkCB``
- ``GitDiffLineCB``

### Functions

- ``gitDiffOptionsInit(opts:version:)``
- ``gitDiffFindOptionsInit(opts:version:)``
- ``gitDiffFree(diff:)``
- ``gitDiffTreeToTree(diff:repo:oldTree:newTree:opts:)``
- ``gitDiffTreeToIndex(diff:repo:oldTree:index:opts:)``
- ``gitDiffIndexToWorkdir(diff:repo:index:opts:)``
- ``gitDiffTreeToWorkdir(diff:repo:oldTree:opts:)``
- ``gitDiffTreeToWorkdirWithIndex(diff:repo:oldTree:opts:)``
- ``gitDiffIndexToIndex(diff:repo:oldIndex:newIndex:opts:)``
- ``gitDiffMerge(onto:from:)``
- ``gitDiffFindSimilar(diff:options:)``
- ``gitDiffNumDeltas(diff:)``
- ``gitDiffNumDeltasOfType(diff:type:)``
- ``gitDiffGetDelta(diff:idx:)``
- ``gitDiffIsSortedICase(diff:)``
- ``gitDiffForEach(diff:fileCB:binaryCB:hunkCB:lineCB:payload:)``
- ``gitDiffStatusChar(status:)``
- ``gitDiffPrint(diff:format:printCB:payload:)``
- ``gitDiffToBuf(out:diff:format:)``
- ``gitDiffBlobs(oldBlob:oldAsPath:newBlob:newAsPath:options:fileCB:binaryCB:hunkCB:lineCB:payload:)``
- ``gitDiffBlobToBuffer(oldBlob:oldAsPath:buffer:bufferLen:bufferAsPath:options:fileCB:binaryCB:hunkCB:lineCB:payload:)``
- ``gitDiffBuffers(oldBuffer:oldBufferLen:oldBufferAsPath:newBuffer:newBufferLen:newBufferAsPath:options:fileCB:binaryCB:hunkCB:lineCB:payload:)``
- ``gitDiffFromBuffer(out:content:contentLen:)``
- ``gitDiffGetStats(out:diff:)``
- ``gitDiffStatsFilesChanged(stats:)``
- ``gitDiffStatsInsertions(stats:)``
- ``gitDiffStatsDeletions(stats:)``
- ``gitDiffStatsToBuf(out:stats:format:width:)``
- ``gitDiffStatsFree(stats:)``
- ``gitDiffPatchID(out:diff:opts:)``
