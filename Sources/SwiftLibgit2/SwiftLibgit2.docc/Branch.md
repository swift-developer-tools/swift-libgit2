# Branch

Branch creation and management.

## Topics

### Enums

- ``GitBranchT``

### Functions

- ``gitBranchCreate(out:repo:branchName:target:force:)``
- ``gitBranchCreateFromAnnotated(refOut:repo:branchName:target:force:)``
- ``gitBranchDelete(branch:)``
- ``gitBranchIteratorNew(out:repo:listFlags:)``
- ``gitBranchNext(out:outType:iter:)``
- ``gitBranchIteratorFree(iter:)``
- ``gitBranchMove(out:branch:newBranchName:force:)``
- ``gitBranchLookup(out:repo:branchName:branchType:)``
- ``gitBranchName(out:ref:)``
- ``gitBranchUpstream(out:ref:)``
- ``gitBranchSetUpstream(branch:branchName:)``
- ``gitBranchUpstreamName(out:repo:refName:)``
- ``gitBranchIsHEAD(branch:)``
- ``gitBranchIsCheckedOut(branch:)``
- ``gitBranchRemoteName(out:repo:refName:)``
- ``gitBranchUpstreamRemote(buf:repo:refName:)``
- ``gitBranchUpstreamMerge(buf:repo:refName:)``
- ``gitBranchNameIsValid(valid:name:)``
