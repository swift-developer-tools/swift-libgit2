//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates an annotated commit from the given reference.
/// - Parameters:
///   - out: The pointer in which to store the annotated commit. The underlying
///   type must be `git_annotated_commit`.
///   - repo: The repository containing the given reference. The underlying
///   type must be `git_repository`.
///   - ref: The reference to use to lookup the  annotated commit. The
///   underlying type must be `git_reference`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_from_ref()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_from_ref.html)
public func gitAnnotatedCommitFromRef(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    ref     : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_annotated_commit_from_ref(
            out,
            repo,
            ref
        )
    }
}



/// Creates an annotated commit from the given fetch head data.
/// - Parameters:
///   - out: The pointer in which to store the annotated commit. The underlying
///   type must be `git_annotated_commit`.
///   - repo: The repository containing the given commit. The underlying type
///   must be `git_repository`.
///   - branchName: The name of the (remote) branch.
///   - remoteURL: The URL of the remote.
///   - id: The commit ID of the remote branch.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_from_fetchhead()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_from_fetchhead.html)
public func gitAnnotatedCommitFromFetchhead(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    branchName  : String,
    remoteURL   : String,
    id          : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_annotated_commit_from_fetchhead(
            out,
            repo,
            branchName,
            remoteURL,
            &cID
        )
    }
}



/// Creates an annotated commit from the given commit ID.
/// - Parameters:
///   - out: The pointer in which to store the annotated commit. The underlying
///   type must be `git_annotated_commit`.
///   - repo: The repository containing the given commit. The underlying type
///   must be `git_repository`.
///   - id: The commit ID to lookup.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// An annotated commit contains information about how it was looked up, which
/// may be useful for functions like merge or rebase to provide context to the
/// operation. For example, conflict files will include the name of the source
/// or target branches being merged. When that data is known, use
/// ``gitAnnotatedCommitFromRef(out:repo:ref:)`` instead.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_lookup()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_lookup.html)
public func gitAnnotatedCommitLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_annotated_commit_lookup(
            out,
            repo,
            &cID
        )
    }
}



/// Creates an annotated commit from a revision string.
/// - Parameters:
///   - out: The pointer in which to store the annotated commit. The underlying
///   type must be `git_annotated_commit`.
///   - repo: The repository containing the given commit. The underlying type
///   must be `git_repository`.
///   - revspec: The extended SHA syntax string to use to lookup the commit.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: See the
/// [Git revisions documentation](http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)
/// for information on the accepted revspec syntax.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_from_revspec()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_from_revspec.html)
public func gitAnnotatedCommitFromRevspec(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    revspec : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_annotated_commit_from_revspec(
            out,
            repo,
            revspec
        )
    }
}



/// Gets the commit ID to which the given annotated commit refers.
/// - Parameter commit: The annotated commit.  The underlying type must be
/// `git_annotated_commit`.
/// - Returns: The commit ID to which the given annotated commit refers.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_id()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_id.html)
public func gitAnnotatedCommitID(
    commit: OpaquePointer
) -> GitOID
{
    let annotatedCommitOID: UnsafePointer<git_oid>
        = git_annotated_commit_id(commit)
    
    return GitOID(cValue: annotatedCommitOID.pointee)
}



/// Gets the reference name to which the given annotated commit refers.
/// - Parameter commit: The annotated commit. The underlying type must be
/// `git_annotated_commit`.
/// - Returns: The reference name to which the given annotated commit refers.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_ref()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_ref.html)
public func gitAnnotatedCommitRef(
    commit: OpaquePointer
) -> String?
{
    let referenceName: UnsafePointer<CChar>? = git_annotated_commit_ref(commit)
    
    return String(optionalCString: referenceName)
}



/// Frees the memory allocated for the given `git_annotated_commit` instance.
/// - Parameter commit: The annotated commit to free. The underlying type must
/// be `git_annotated_commit`.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_free()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_free.html)
public func gitAnnotatedCommitFree(
    commit: OpaquePointer?
)
{
    guard let commit: OpaquePointer = commit
    else
    {
        return
    }
    
    git_annotated_commit_free(commit)
}
