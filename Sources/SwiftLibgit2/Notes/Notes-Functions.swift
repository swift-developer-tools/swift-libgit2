//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new note iterator.
/// - Parameters:
///   - out: The pointer in which to store the note iterator. The underlying
///   type must be `git_note_iterator`.
///   - repo: The repository containing the notes to iterate. The underlying
///   type must be `git_repository`.
///   - notesRef: The canonical name of the reference to use. Pass `nil` to
///   use `refs/notes/commits`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_iterator_new()`](https://libgit2.org/docs/reference/main/notes/git_note_iterator_new.html)
public func gitNoteIteratorNew(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    notesRef    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_note_iterator_new(
            out,
            repo,
            notesRef
        )
    }
}



/// Creates a new commit note iterator.
/// - Parameters:
///   - out: The pointer in which to store the commit note iterator. The
///   underlying type must be `git_note_iterator`.
///   - notesCommit: The notes commit object to iterate. The underlying type
///   must be `git_commit`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_commit_iterator_new()`](https://libgit2.org/docs/reference/main/notes/git_note_commit_iterator_new.html)
public func gitNoteCommitIteratorNew(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    notesCommit : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_note_commit_iterator_new(
            out,
            notesCommit
        )
    }
}



/// Frees the memory allocated for the given `git_note_iterator` instance.
/// - Parameter it: The note iterator to free. The underlying type must be
/// `git_note_iterator`.
///
/// ## C Equivalent
///
/// [`git_note_iterator_free()`](https://libgit2.org/docs/reference/main/notes/git_note_iterator_free.html)
public func gitNoteIteratorFree(
    it: OpaquePointer?
)
{
    guard let it: OpaquePointer = it
    else
    {
        return
    }
    
    git_note_iterator_free(it)
}



/// Gets the next note from the given note iterator.
/// - Parameters:
///   - noteID: The ``GitOID`` instance in which to store the ID of the blob
///   containing the message.
///   - annotatedID: The ``GitOID`` instance in which to store the ID of the
///   object being annotated.
///   - it: The note iterator to use. The underlying type must be
///   `git_note_iterator`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_next()`](https://libgit2.org/docs/reference/main/notes/git_note_next.html)
public func gitNoteNext(
    noteID      : inout GitOID,
    annotatedID : inout GitOID,
    it          : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try noteID.withMutatingCValue
        {
            cNoteID in
            
            return try annotatedID.withMutatingCValue
            {
                cAnnotatedID in
                
                return git_note_next(
                    cNoteID,
                    cAnnotatedID,
                    it
                )
            }
        }
    }
}



/// Reads the note for the given object.
/// - Parameters:
///   - out: The pointer in which to store the note. The underlying type
///   must be `git_note`.
///   - repo: The repository containing the note. The underlying type must be
///   `git_repository`.
///   - notesRef: The canonical name of the reference to use. Pass `nil` to
///   use `refs/notes/commits`.
///   - oid: The ID of the object for which to read the note.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_read()`](https://libgit2.org/docs/reference/main/notes/git_note_read.html)
public func gitNoteRead(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    notesRef    : String?,
    oid         : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return oid.withCValue
        {
            cOID in
            
            return git_note_read(
                out,
                repo,
                notesRef,
                cOID
            )
        }
    }
}



/// Reads the note for the given object.
/// - Parameters:
///   - out: The pointer in which to store the note. The underlying type
///   must be `git_note`.
///   - repo: The repository containing the note. The underlying type must be
///   `git_repository`.
///   - notesCommit: The notes commit object to read. The underlying type must
///   be `git_commit`.
///   - oid: The ID of the object for which to read the note.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_commit_read()`](https://libgit2.org/docs/reference/main/notes/git_note_commit_read.html)
public func gitNoteCommitRead(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    notesCommit : OpaquePointer?,
    oid         : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return oid.withCValue
        {
            cOID in
            
            return git_note_commit_read(
                out,
                repo,
                notesCommit,
                cOID
            )
        }
    }
}



/// Gets the author of the given note.
/// - Parameter note: The note for which to get the author. The underlying
/// type must be `git_note`.
/// - Returns: The author of the given note.
///
/// ## C Equivalent
///
/// [`git_note_author()`](https://libgit2.org/docs/reference/main/notes/git_note_author.html)
public func gitNoteAuthor(
    note: OpaquePointer
) -> GitSignature?
{
    guard let signature: UnsafePointer<git_signature> = git_note_author(note)
    else
    {
        return nil
    }
    
    return GitSignature(cValue: signature.pointee)
}



/// Gets the committer of the given note.
/// - Parameter note: The note for which to get the committer. The underlying
/// type must be `git_note`.
/// - Returns: The committer of the given note.
///
/// ## C Equivalent
///
/// [`git_note_committer()`](https://libgit2.org/docs/reference/main/notes/git_note_committer.html)
public func gitNoteCommitter(
    note: OpaquePointer
) -> GitSignature?
{
    guard let signature: UnsafePointer<git_signature>
            = git_note_committer(note)
    else
    {
        return nil
    }
    
    return GitSignature(cValue: signature.pointee)
}



/// Gets the message of the given note.
/// - Parameter note: The note for which to get the message. The underlying
/// type must be `git_note`.
/// - Returns: The message of the given note.
///
/// ## C Equivalent
///
/// [`git_note_message()`](https://libgit2.org/docs/reference/main/notes/git_note_message.html)
public func gitNoteMessage(
    note: OpaquePointer
) -> String?
{
    let message: UnsafePointer<CChar>? = git_note_message(note)
    
    return String(optionalCString: message)
}



/// Gets the ID of the given note.
/// - Parameter note: The note for which to get the ID. The underlying type
/// must be `git_note`.
/// - Returns: The ID of the given note.
///
/// ## C Equivalent
///
/// [`git_note_id()`](https://libgit2.org/docs/reference/main/notes/git_note_id.html)
public func gitNoteID(
    note: OpaquePointer
) -> GitOID?
{
    guard let noteOID: UnsafePointer<git_oid> = git_note_id(note)
    else
    {
        return nil
    }
    
    return GitOID(cValue: noteOID.pointee)
}



/// Adds a note for the given object.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID.
///   - repo: The repository in which to create the note. The underlying type
///   must be `git_repository`.
///   - notesRef: The canonical name of the reference to use. Pass `nil` to
///   use `refs/notes/commits`.
///   - author: The signature of the notes commit author.
///   - committer: The signature of the notes commit committer.
///   - oid: The ID of the object to decorate.
///   - note: The note to add for the given object.
///   - force: Whether to overwrite an existing note.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_create()`](https://libgit2.org/docs/reference/main/notes/git_note_create.html)
public func gitNoteCreate(
    out         : inout GitOID,
    repo        : OpaquePointer,
    notesRef    : String?,
    author      : GitSignature,
    committer   : GitSignature,
    oid         : GitOID,
    note        : String,
    force       : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try author.withCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return oid.withCValue
                    {
                        cOID in
                        
                        return git_note_create(
                            cOut,
                            repo,
                            notesRef,
                            cAuthor,
                            cCommitter,
                            cOID,
                            note,
                            force.int32Value
                        )
                    }
                }
            }
        }
    }
}



/// Adds a note for an object from the given commit.
/// - Parameters:
///   - notesCommitOut: The ``GitOID`` instance in which to store the note
///   commit ID.
///   - notesBlobOut: The ``GitOID`` instance in which to store the note
///   blob ID.
///   - repo: The repository in which to create the note. The underlying type
///   must be `git_repository`.
///   - parent: The parent note. Pass `nil` to start a new notes tree.
///   - author: The signature of the notes commit author.
///   - committer: The signature of the notes commit committer.
///   - oid: The ID of the object to decorate.
///   - note: The note to add for the given object.
///   - allowNoteOverwrite: Whether to overwrite an existing note.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting notes commit will be dangling. No reference will be created
/// pointing at it.
///
/// ## C Equivalent
///
/// [`git_note_commit_create()`](https://libgit2.org/docs/reference/main/notes/git_note_commit_create.html)
public func gitNoteCommitCreate(
    notesCommitOut      : inout GitOID,
    notesBlobOut        : inout GitOID,
    repo                : OpaquePointer,
    parent              : OpaquePointer?,
    author              : GitSignature,
    committer           : GitSignature,
    oid                 : GitOID,
    note                : String,
    allowNoteOverwrite  : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return try notesCommitOut.withMutatingCValue
        {
            cNotesCommitOut in
            
            return try notesBlobOut.withMutatingCValue
            {
                cNotesBlobOut in
                
                return try author.withCValue
                {
                    cAuthor in
                    
                    return try committer.withCValue
                    {
                        cCommitter in
                        
                        return oid.withCValue
                        {
                            cOID in
                            
                            return git_note_commit_create(
                                cNotesCommitOut,
                                cNotesBlobOut,
                                repo,
                                parent,
                                cAuthor,
                                cCommitter,
                                cOID,
                                note,
                                allowNoteOverwrite.int32Value
                            )
                        }
                    }
                }
            }
        }
    }
}



/// Removes the note for the given object.
/// - Parameters:
///   - repo: The repository containing the note. The underlying type must
///   be `git_repository`.
///   - notesRef: The canonical name of the reference to use. Pass `nil` to
///   use `refs/notes/commits`.
///   - author: The signature of the notes commit author.
///   - committer: The signature of the notes commit committer.
///   - oid: The ID of the object from which to remove the note.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_remove()`](https://libgit2.org/docs/reference/main/notes/git_note_remove.html)
public func gitNoteRemove(
    repo        : OpaquePointer,
    notesRef    : String?,
    author      : GitSignature,
    committer   : GitSignature,
    oid         : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return try author.withCValue
        {
            cAuthor in
            
            return try committer.withCValue
            {
                cCommitter in
                
                return oid.withCValue
                {
                    cOID in
                    
                    return git_note_remove(
                        repo,
                        notesRef,
                        cAuthor,
                        cCommitter,
                        cOID
                    )
                }
            }
        }
    }
}



/// Removes the note for the given object.
/// - Parameters:
///   - notesCommitOut: The ``GitOID`` instance in which to store the note
///   commit ID.
///   - repo: The repository containing the note. The underlying type must
///   be `git_repository`.
///   - notesCommit: The notes commit object. The underlying type must be
///   `git_commit`.
///   - author: The signature of the notes commit author.
///   - committer: The signature of the notes commit committer.
///   - oid: The ID of the object from which to remove the note.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// When removing a note, a new tree containing all notes except for the note
/// being removed will be created. A new commit pointing to that tree will also
/// be created. The new tree may be empty.
///
/// ## C Equivalent
///
/// [`git_note_commit_remove()`](https://libgit2.org/docs/reference/main/notes/git_note_commit_remove.html)
public func gitNoteCommitRemove(
    notesCommitOut  : inout GitOID,
    repo            : OpaquePointer,
    notesCommit     : OpaquePointer,
    author          : GitSignature,
    committer       : GitSignature,
    oid             : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return try notesCommitOut.withMutatingCValue
        {
            cNotesCommitOut in
            
            return try author.withCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return oid.withCValue
                    {
                        cOID in
                        
                        return git_note_commit_remove(
                            cNotesCommitOut,
                            repo,
                            notesCommit,
                            cAuthor,
                            cCommitter,
                            cOID
                        )
                    }
                }
            }
        }
    }
}



/// Frees the memory allocated for the given `git_note` instance.
/// - Parameter note: The note to free. The underlying type must be `git_note`.
///
/// ## C Equivalent
///
/// [`git_note_free()`](https://libgit2.org/docs/reference/main/notes/git_note_free.html)
public func gitNoteFree(
    note: OpaquePointer?
)
{
    guard let note: OpaquePointer = note
    else
    {
        return
    }
    
    git_note_free(note)
}



/// Gets the default notes reference for the given repository.
/// - Parameters:
///   - out: The `String` instance in which to store the default notes
///   reference.
///   - repo: The repository to check. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_default_ref()`](https://libgit2.org/docs/reference/main/notes/git_note_default_ref.html)
public func gitNoteDefaultRef(
    out     : inout String?,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_note_default_ref(
                cOut,
                repo
            )
        }
    }
}



/// Loops over all the notes within the given repository.
/// - Parameters:
///   - repo: The repository to check. The underlying type must be
///   `git_repository`.
///   - notesRef: The canonical name of the reference to use. Pass `nil` to
///   use `refs/notes/commits`.
///   - noteCB: The ``GitNoteForEachCB`` callback to invoke for each note.
///   - payload: The payload to pass to `noteCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_foreach()`](https://libgit2.org/docs/reference/main/notes/git_note_foreach.html)
public func gitNoteForEach(
    repo        : OpaquePointer,
    notesRef    : String?,
    noteCB      : GitNoteForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_note_foreach(
            repo,
            notesRef,
            noteCB,
            payload
        )
    }
}
