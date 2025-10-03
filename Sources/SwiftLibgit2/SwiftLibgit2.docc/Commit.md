# Commit

A representation of a set of changes in the repository.

## Topics

### Structs

- ``GitCommitCreateOptions``
- ``GitCommitArray``

### Macros

- ``gitCommitCreateOptionsVersion``

### Callbacks

- ``GitCommitCreateCB``

### Functions

- ``gitCommitLookup(commit:repo:id:)``
- ``gitCommitLookupPrefix(commit:repo:id:len:)``
- ``gitCommitFree(commit:)``
- ``gitCommitID(commit:)``
- ``gitCommitOwner(commit:)``
- ``gitCommitMessageEncoding(commit:)``
- ``gitCommitMessage(commit:)``
- ``gitCommitMessageRaw(commit:)``
- ``gitCommitSummary(commit:)``
- ``gitCommitBody(commit:)``
- ``gitCommitTime(commit:)``
- ``gitCommitTimeOffset(commit:)``
- ``gitCommitCommitter(commit:)``
- ``gitCommitAuthor(commit:)``
- ``gitCommitCommitterWithMailmap(out:commit:mailmap:)``
- ``gitCommitAuthorWithMailmap(out:commit:mailmap:)``
- ``gitCommitRawHeader(commit:)``
- ``gitCommitTree(out:commit:)``
- ``gitCommitTreeID(commit:)``
- ``gitCommitParentCount(commit:)``
- ``gitCommitParent(out:commit:n:)``
- ``gitCommitParentID(commit:n:)``
- ``gitCommitNthGenAncestor(ancestor:commit:n:)``
- ``gitCommitHeaderField(out:commit:field:)``
- ``gitCommitExtractSignature(signature:signedData:repo:commitID:field:)``
- ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``
- ``gitCommitCreateFromStage(id:repo:message:opts:)``
- ``gitCommitAmend(id:commitToAmend:updateRef:author:committer:messageEncoding:message:tree:)``
- ``gitCommitCreateBuffer(out:repo:author:committer:messageEncoding:message:tree:parentCount:parents:)``
- ``gitCommitCreateWithSignature(out:repo:commitContent:signature:signatureField:)``
- ``gitCommitDup(out:source:)``
- ``gitCommitArrayDispose(array:)``
