//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_rebase_options` instance.
/// - Parameters:
///   - opts: The `git_rebase_options` instance to initialize.
///   - version: The version to use. Pass ``gitRebaseOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_rebase_options_init()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_options_init.html)
public func gitRebaseOptionsInit(
    opts    : UnsafeMutablePointer<git_rebase_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_rebase_options_init(
            opts,
            version
        )
    }
}



/// Creates a rebase object to rebase the changes in the given branch,
/// relative to the given upstream, onto the other given branch.
/// - Parameters:
///   - out: The pointer in which to store the rebase. The underlying type
///   must be `git_rebase`.
///   - repo: The repository in which to perform the rebase. The underlying
///   type must be `git_repository`.
///   - branch: The terminal commit to rebase. The underlying type must be
///   `git_annotated_commit`. Pass `nil` to rebase the current branch.
///   - upstream: The commit from which to begin rebasing. The underlying type
///   must be `git_annotated_commit`. Pass `nil` to rebase all reachable
///   commits.
///   - onto: The branch onto which to rebase. The underlying type must be
///   `git_annotated_commit`. Pass `nil` to rebase onto the given upstream.
///   - opts: The rebase options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: If the initialization is successful, call
/// ``gitRebaseNext(operation:rebase:)`` to begin the rebase operation.
///
/// ## C Equivalent
///
/// [`git_rebase_init()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_init.html)
public func gitRebaseInit(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    branch      : OpaquePointer?,
    upstream    : OpaquePointer?,
    onto        : OpaquePointer?,
    opts        : GitRebaseOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_rebase_init(
                out,
                repo,
                branch,
                upstream,
                onto,
                cOpts
            )
        }
    }
}



/// Opens an in-progress rebase.
/// - Parameters:
///   - out: The pointer in which to store the rebase. The underlying type
///   must be `git_rebase`.
///   - repo: The repository containing the in-progress rebase. The underlying
///   type must be `git_repository`.
///   - opts: The rebase options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function may be used to open a rebase that was started by
/// ``gitRebaseInit(out:repo:branch:upstream:onto:opts:)``, or by another
/// client.
///
/// ## C Equivalent
///
/// [`git_rebase_open()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_open.html)
public func gitRebaseOpen(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    opts    : GitRebaseOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_rebase_open(
                out,
                repo,
                cOpts
            )
        }
    }
}



/// Gets the original HEAD reference name for the given merge rebase.
/// - Parameter rebase: The in-progress rebase to use. The underlying type
/// must be `git_rebase`.
/// - Returns: The original HEAD reference name for the given merge rebase.
///
/// ## C Equivalent
///
/// [`git_rebase_orig_head_name()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_orig_head_name.html)
public func gitRebaseOrigHEADName(
    rebase: OpaquePointer
) -> String?
{
    let headReferenceName: UnsafePointer<CChar>?
        = git_rebase_orig_head_name(rebase)
    
    return String(optionalCString: headReferenceName)
}



/// Gets the original HEAD ID for the given merge rebase.
/// - Parameter rebase: The in-progress rebase to use. The underlying type
/// must be `git_rebase`.
/// - Returns: The original HEAD ID for the given merge rebase.
///
/// ## C Equivalent
///
/// [`git_rebase_orig_head_id()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_orig_head_id.html)
public func gitRebaseOrigHEADID(
    rebase: OpaquePointer
) -> GitOID?
{
    guard let headReferenceOID: UnsafePointer<git_oid>
            = git_rebase_orig_head_id(rebase)
    else
    {
        return nil
    }
    
    return GitOID(cValue: headReferenceOID.pointee)
}



/// Gets the `onto` name for the given merge rebase.
/// - Parameter rebase: The in-progress rebase to use. The underlying type
/// must be `git_rebase`.
/// - Returns: The `onto` name for the given merge rebase.
///
/// ## C Equivalent
///
/// [`git_rebase_onto_name()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_onto_name.html)
public func gitRebaseOntoName(
    rebase: OpaquePointer
) -> String?
{
    let ontoName: UnsafePointer<CChar>?
        = git_rebase_onto_name(rebase)
    
    return String(optionalCString: ontoName)
}



/// Gets the `onto` ID for the given merge rebase.
/// - Parameter rebase: The in-progress rebase to use. The underlying type
/// must be `git_rebase`.
/// - Returns: The `onto` ID for the given merge rebase.
///
/// ## C Equivalent
///
/// [`git_rebase_onto_id()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_onto_id.html)
public func gitRebaseOntoID(
    rebase: OpaquePointer
) -> GitOID?
{
    guard let ontoOID: UnsafePointer<git_oid> = git_rebase_onto_id(rebase)
    else
    {
        return nil
    }
    
    return GitOID(cValue: ontoOID.pointee)
}



/// Gets the number of rebase operations to apply.
/// - Parameter rebase: The in-progress rebase to use. The underlying type
/// must be `git_rebase`.
/// - Returns: The number of rebase operations to apply.
///
/// ## C Equivalent
///
/// [`git_rebase_operation_entrycount()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_operation_entrycount.html)
public func gitRebaseOperationEntryCount(
    rebase: OpaquePointer
) -> Int
{
    return git_rebase_operation_entrycount(rebase)
}



/// Gets the index of the rebase operation currently being applied.
/// - Parameter rebase: The in-progress rebase to use. The underlying type
/// must be `git_rebase`.
/// - Returns: The index of the rebase operation currently being applied.
///
/// ## C Equivalent
///
/// [`git_rebase_operation_current()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_operation_current.html)
public func gitRebaseOperationCurrent(
    rebase: OpaquePointer
) -> Int
{
    return git_rebase_operation_current(rebase)
}



/// Gets the rebase operation at the given index.
/// - Parameters:
///   - rebase: The in-progress rebase to use. The underlying type must be
///   `git_rebase`.
///   - idx: The index of the rebase operation to retrieve.
/// - Returns: The rebase operation at the given index.
///
/// ## C Equivalent
///
/// [`git_rebase_operation_byindex()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_operation_byindex.html)
public func gitRebaseOperationByIndex(
    rebase  : OpaquePointer,
    idx     : Int
) -> GitRebaseOperation?
{
    guard let rebaseOperation: UnsafeMutablePointer<git_rebase_operation>
            = git_rebase_operation_byindex(
                rebase,
                idx
            )
    else
    {
        return nil
    }
    
    return GitRebaseOperation(cValue: rebaseOperation.pointee)
}



/// Gets the next rebase opertion of the given in-progress rebase.
/// - Parameters:
///   - operation: The ``GitRebaseOperation`` instance in which to store the
///   rebase operation.
///   - rebase: The in-progress rebase to use. The underlying type must be
///   `git_rebase`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the next rebase opeartion is one that applies a patch (which is any
/// operation except ``GitRebaseOperationT/gitRebaseOperationExec``), then the
/// patch will be applied, and the index and working directory will be updated
/// with the changes. If there are conflicts, they must be resolved before
/// committing the changes.
///
/// ## C Equivalent
///
/// [`git_rebase_next()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_next.html)
public func gitRebaseNext(
    operation   : inout GitRebaseOperation,
    rebase      : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try operation.withBorrowingCValue
        {
            cOperation in
            
            return git_rebase_next(
                cOperation,
                rebase
            )
        }
    }
}



/// Gets the index produced by the last rebase operation.
/// - Parameters:
///   - index: The pointer in which to store the index. The underlying type
///   must be `git_index`.
///   - rebase: The in-progress rebase to use. The underlying type must be
///   `git_rebase`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is useful for resolving conflicts in an in-memory rebase
/// before committing the changes.
///
/// - Note: This is only applicable for in-memory rebases. For rebases within
/// a working directory, the changes are applied to the repository's index.
///
/// ## C Equivalent
///
/// [`git_rebase_inmemory_index()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_inmemory_index.html)
public func gitRebaseInMemoryIndex(
    index   : UnsafeMutablePointer<OpaquePointer?>,
    rebase  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_rebase_inmemory_index(
            index,
            rebase
        )
    }
}



/// Commits the current patch.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the commit ID.
///   - rebase: The in-progress rebase to use. The underlying type must be
///   `git_rebase`.
///   - author: The author signature to use. Pass `nil` to use the original
///   author.
///   - committer: The committer signature to use.
///   - messageEncoding: The commit message encoding to use. Pass `nil` to
///   use the original message encoding.
///   - message: The commit message to use. Pass `nil` to use the original
///   message.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `message` is `nil`, then `messageEncoding` should also be `nil` to use
/// the original message encoding. If `message` is not `nil`, then
/// `messageEncoding` may be `nil` to use UTF-8 and to not write an encoding
/// header.
///
/// - Note: Any conflicts that were introduced during the patch application
/// must be resolved before committing the patch.
///
/// ## C Equivalent
///
/// [`git_rebase_commit()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_commit.html)
public func gitRebaseCommit(
    id              : inout GitOID,
    rebase          : OpaquePointer,
    author          : GitSignature?,
    committer       : GitSignature,
    messageEncoding : String?,
    message         : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try author.withOptionalCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return git_rebase_commit(
                        cID,
                        rebase,
                        cAuthor,
                        cCommitter,
                        messageEncoding,
                        message
                    )
                }
            }
        }
    }
}



/// Aborts the given in-progress rebase, and resets the repository and
/// working directory to the pre-rebase state.
/// - Parameter rebase: The in-progress rebase to abort. The underlying type
/// must be `git_rebase`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_rebase_abort()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_abort.html)
public func gitRebaseAbort(
    rebase: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_rebase_abort(rebase)
    }
}



/// Finishes the given in-progress rebase.
/// - Parameters:
///   - rebase: The in-progress rebase to finish. The underlying type must be
///   `git_rebase`.
///   - signature: The actor signature to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_rebase_finish()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_finish.html)
public func gitRebaseFinish(
    rebase      : OpaquePointer,
    signature   : GitSignature?
) -> GitErrorCode
{
    return withCConversion
    {
        return try signature.withOptionalCValue
        {
            cSignature in
            
            return git_rebase_finish(
                rebase,
                cSignature
            )
        }
    }
}



/// Frees the memory allocated for the given `git_rebase` instance.
/// - Parameter rebase: The rebase to free. The underlying type must be
/// `git_rebase`.
///
/// ## C Equivalent
///
/// [`git_rebase_free()`](https://libgit2.org/docs/reference/main/rebase/git_rebase_free.html)
public func gitRebaseFree(
    rebase: OpaquePointer?
)
{
    guard let rebase
    else
    {
        return
    }
    
    git_rebase_free(rebase)
}
