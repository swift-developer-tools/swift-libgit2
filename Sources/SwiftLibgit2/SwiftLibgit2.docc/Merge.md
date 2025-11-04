# Merge

Join two branches of a repository.

## Topics

### Structs

- ``GitMergeFileInput``
- ``GitMergeFileOptions``
- ``GitMergeFileResult``
- ``GitMergeOptions``

### Macros

- ``gitMergeFileInputVersion``
- ``gitMergeConflictMarkerSize``
- ``gitMergeFileOptionsVersion``
- ``gitMergeOptionsVersion``

### Enums

- ``GitMergeFlagT``
- ``GitMergeFileFavorT``
- ``GitMergeFileFlagT``
- ``GitMergeAnalysisT``
- ``GitMergePreferenceT``

### Functions

- ``gitMergeFileInputInit(opts:version:)``
- ``gitMergeFileOptionsInit(opts:version:)``
- ``gitMergeOptionsInit(opts:version:)``
- ``gitMergeAnalysis(analysisOut:preferenceOut:repo:theirHeads:theirHeadsLen:)``
- ``gitMergeAnalysisForRef(analysisOut:preferenceOut:repo:ourRef:theirHeads:theirHeadsLen:)``
- ``gitMergeBase(out:repo:one:two:)``
- ``gitMergeBases(out:repo:one:two:)``
- ``gitMergeBaseMany(out:repo:length:inputArray:)``
- ``gitMergeBasesMany(out:repo:length:inputArray:)``
- ``gitMergeBaseOctopus(out:repo:length:inputArray:)``
- ``gitMergeFile(out:ancestor:ours:theirs:opts:)``
- ``gitMergeFileFromIndex(out:repo:ancestor:ours:theirs:opts:)``
- ``gitMergeFileResultFree(result:)``
- ``gitMergeTrees(out:repo:ancestorTree:ourTree:theirTree:opts:)``
- ``gitMergeCommits(out:repo:ourCommit:theirCommit:opts:)``
- ``gitMerge(repo:theirHeads:theirHeadsLen:mergeOpts:checkoutOpts:)``
