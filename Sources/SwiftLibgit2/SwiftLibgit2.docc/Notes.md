# Notes

Metadata attached to an object.

## Topics

### Callbacks

- ``GitNoteForEachCB``

### Functions

- ``gitNoteIteratorNew(out:repo:notesRef:)``
- ``gitNoteCommitIteratorNew(out:notesCommit:)``
- ``gitNoteIteratorFree(it:)``
- ``gitNoteNext(noteID:annotatedID:it:)``
- ``gitNoteRead(out:repo:notesRef:oid:)``
- ``gitNoteCommitRead(out:repo:notesCommit:oid:)``
- ``gitNoteAuthor(note:)``
- ``gitNoteCommitter(note:)``
- ``gitNoteMessage(note:)``
- ``gitNoteID(note:)``
- ``gitNoteCreate(out:repo:notesRef:author:committer:oid:note:force:)``
- ``gitNoteCommitCreate(notesCommitOut:notesBlobOut:repo:parent:author:committer:oid:note:allowNoteOverwrite:)``
- ``gitNoteRemove(repo:notesRef:author:committer:oid:)``
- ``gitNoteCommitRemove(notesCommitOut:repo:notesCommit:author:committer:oid:)``
- ``gitNoteFree(note:)``
- ``gitNoteDefaultRef(out:repo:)``
- ``gitNoteForEach(repo:notesRef:noteCB:payload:)``
