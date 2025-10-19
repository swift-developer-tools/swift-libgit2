# Refs

References that point to a commit.

## Topics

### Enums

- ``GitReferenceFormatT``
- ``GitReferenceT``

### Callbacks

- ``GitReferenceForEachCB``
- ``GitReferenceForEachNameCB``

### Functions

- ``gitReferenceLookup(out:repo:name:)``
- ``gitReferenceNameToID(out:repo:name:)``
- ``gitReferenceDWIM(out:repo:shorthand:)``
- ``gitReferenceSymbolicCreateMatching(out:repo:name:target:force:currentValue:logMessage:)``
- ``gitReferenceSymbolicCreate(out:repo:name:target:force:logMessage:)``
- ``gitReferenceCreate(out:repo:name:id:force:logMessage:)``
- ``gitReferenceCreateMatching(out:repo:name:id:force:currentID:logMessage:)``
- ``gitReferenceTarget(ref:)``
- ``gitReferenceTargetPeel(ref:)``
- ``gitReferenceSymbolicTarget(ref:)``
- ``gitReferenceType(ref:)``
- ``gitReferenceName(ref:)``
- ``gitReferenceResolve(out:ref:)``
- ``gitReferenceOwner(ref:)``
- ``gitReferenceSymbolicSetTarget(out:ref:target:logMessage:)``
- ``gitReferenceSetTarget(out:ref:id:logMessage:)``
- ``gitReferenceRename(newRef:ref:newName:force:logMessage:)``
- ``gitReferenceDelete(ref:)``
- ``gitReferenceRemove(repo:name:)``
- ``gitReferenceList(array:repo:)``
- ``gitReferenceForEach(repo:callback:payload:)``
- ``gitReferenceForEachName(repo:callback:payload:)``
- ``gitReferenceDup(dest:source:)``
- ``gitReferenceFree(ref:)``
- ``gitReferenceCmp(ref1:ref2:)``
- ``gitReferenceIteratorNew(out:repo:)``
- ``gitReferenceIteratorGlobNew(out:repo:glob:)``
- ``gitReferenceNext(out:iter:)``
- ``gitReferenceNextName(out:iter:)``
- ``gitReferenceIteratorFree(iter:)``
- ``gitReferenceForEachGlob(repo:glob:callback:payload:)``
- ``gitReferenceHasLog(repo:refName:)``
- ``gitReferenceEnsureLog(repo:refName:)``
- ``gitReferenceIsBranch(ref:)``
- ``gitReferenceIsRemote(ref:)``
- ``gitReferenceIsTag(ref:)``
- ``gitReferenceIsNote(ref:)``
- ``gitReferenceNormalizeName(bufferOut:bufferSize:name:flags:)``
- ``gitReferencePeel(out:ref:type:)``
- ``gitReferenceNameIsValid(valid:refName:)``
- ``gitReferenceShorthand(ref:)``
