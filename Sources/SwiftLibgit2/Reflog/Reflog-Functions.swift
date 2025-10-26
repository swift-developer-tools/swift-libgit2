//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Reads the reflog for the specified reference.
/// - Parameters:
///   - out: The pointer in which to store the reflog. The underlying type
///   must be `git_reflog`.
///   - repo: The repository containing the specified reference. The
///   underlying type must be `git_repository`.
///   - name: The name of the reference to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reflog_read()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_read.html)
public func gitReflogRead(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reflog_read(
            out,
            repo,
            name
        )
    }
}



/// Writes the given in-memory reflog back to the disk, using an atomic file
/// lock.
/// - Parameter reflog: The reflog to write. The underlying type must be
/// `git_reflog`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reflog_write()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_write.html)
public func gitReflogWrite(
    reflog: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reflog_write(reflog)
    }
}



/// Appends the specified entry to the given in-memory reflog.
/// - Parameters:
///   - reflog: The reflog to update. The underlying type must be `git_reflog`.
///   - id: The reference ID to use.
///   - committer: The committer signature to use.
///   - msg: The reflog messge to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reflog_append()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_append.html)
public func gitReflogAppend(
    reflog      : OpaquePointer,
    id          : GitOID,
    committer   : GitSignature,
    msg         : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withCValue
        {
            cID in
            
            return try committer.withCValue
            {
                cCommitter in
                
                return git_reflog_append(
                    reflog,
                    cID,
                    cCommitter,
                    msg
                )
            }
        }
    }
}



/// Renames the specified reflog.
/// - Parameters:
///   - repo: The repository containing the specified reflog. The underlying
///   type must be `git_reflog`.
///   - oldName: The old name of the reference to rename.
///   - name: The new reference name to use. This will be checked for validity.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reflog_rename()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_rename.html)
public func gitReflogRename(
    repo    : OpaquePointer,
    oldName : String,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reflog_rename(
            repo,
            oldName,
            name
        )
    }
}



/// Deletes the reflog for the specified reference.
/// - Parameters:
///   - repo: The repository containing the reflog. The underlying type must
///   be `git_reflog`.
///   - name: The name of the reflog to delete.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reflog_delete()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_delete.html)
public func gitReflogDelete(
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reflog_delete(
            repo,
            name
        )
    }
}



/// Gets the number of log entries in the given reflog.
/// - Parameter reflog: The reflog to evaluate. The underlying type must be
/// `git_reflog`.
/// - Returns: The number of log entries in the given reflog.
///
/// ## C Equivalent
///
/// [`git_reflog_entrycount()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_entrycount.html)
public func gitReflogEntryCount(
    reflog: OpaquePointer
) -> Int
{
    return git_reflog_entrycount(reflog)
}



/// Gets the reflog entry at the given index.
/// - Parameters:
///   - reflog: The reflog to search. The underlying type must be `git_reflog`.
///   - idx: The index of the entry within the given reflog.
/// - Returns: The reflog entry at the given index.
///
/// ## C Equivalent
///
/// [`git_reflog_entry_byindex()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_entry_byindex.html)
public func gitReflogEntryByIndex(
    reflog  : OpaquePointer,
    idx     : Int
) -> OpaquePointer?
{
    return git_reflog_entry_byindex(
        reflog,
        idx
    )
}



/// Removes the reflog entry at the given index.
/// - Parameters:
///   - reflog: The reflog to update. The underlying type must be `git_reflog`.
///   - idx: The index of the entry within the given reflog.
///   - rewritePreviousEntry: Whether to rewrite the reflog history to ensure
///   that there is no gap.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reflog_drop()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_drop.html)
public func gitReflogDrop(
    reflog                  : OpaquePointer,
    idx                     : Int,
    rewritePreviousEntry    : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reflog_drop(
            reflog,
            idx,
            rewritePreviousEntry.int32Value
        )
    }
}



/// Gets the old ID of the given reflog entry.
/// - Parameter entry: The reflog entry to use. The underlying type must be
/// `git_reflog_entry`.
/// - Returns: The old ID of the given reflog entry.
///
/// ## C Equivalent
///
/// [`git_reflog_entry_id_old()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_entry_id_old.html)
public func gitReflogEntryIDOld(
    entry: OpaquePointer
) -> GitOID?
{
    guard let oldEntryOID: UnsafePointer<git_oid>
            = git_reflog_entry_id_old(entry)
    else
    {
        return nil
    }
    
    return GitOID(cValue: oldEntryOID.pointee)
}



/// Gets the new ID of the given reflog entry.
/// - Parameter entry: The reflog entry to use. The underlying type must be
/// `git_reflog_entry`.
/// - Returns: The new ID of the given reflog entry.
///
/// ## C Equivalent
///
/// [`git_reflog_entry_id_new()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_entry_id_new.html)
public func gitReflogEntryIDNew(
    entry: OpaquePointer
) -> GitOID?
{
    guard let newEntryOID: UnsafePointer<git_oid>
            = git_reflog_entry_id_new(entry)
    else
    {
        return nil
    }
    
    return GitOID(cValue: newEntryOID.pointee)
}



/// Gets the committer signature of the given reflog entry.
/// - Parameter entry: The reflog entry to use. The underlying type must be
/// `git_reflog_entry`.
/// - Returns: The committer signature of the given reflog entry.
///
/// ## C Equivalent
///
/// [`git_reflog_entry_committer()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_entry_committer.html)
public func gitReflogEntryCommitter(
    entry: OpaquePointer
) -> GitSignature?
{
    guard let entryCommitterSignature: UnsafePointer<git_signature>
            = git_reflog_entry_committer(entry)
    else
    {
        return nil
    }
    
    return GitSignature(cValue: entryCommitterSignature.pointee)
}



/// Gets the log message of the given reflog entry.
/// - Parameter entry: The reflog entry to use. The underlying type must be
/// `git_reflog_entry`.
/// - Returns: The log message of the given reflog entry.
///
/// ## C Equivalent
///
/// [`git_reflog_entry_message()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_entry_message.html)
public func gitReflogEntryMessage(
    entry: OpaquePointer
) -> String?
{
    let entryMessage: UnsafePointer<CChar>? = git_reflog_entry_message(entry)
    
    return String(optionalCString: entryMessage)
}



/// Frees the memory allocated for the given `git_reflog` instance.
/// - Parameter reflog: The reflog to free. The underlying type must be
/// `git_reflog`.
///
/// ## C Equivalent
///
/// [`git_reflog_free()`](https://libgit2.org/docs/reference/main/reflog/git_reflog_free.html)
public func gitReflogFree(
    reflog: OpaquePointer?
)
{
    guard let reflog: OpaquePointer = reflog
    else
    {
        return
    }
    
    git_reflog_free(reflog)
}
