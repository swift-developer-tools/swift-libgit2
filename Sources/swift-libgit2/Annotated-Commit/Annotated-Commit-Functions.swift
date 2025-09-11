//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Creates an annotated commit from the given reference.
/// - Parameters:
///   - out: The pointer in which to store the result. The underlying type should be
///   `git_annotated_commit`.
///   - repo: The repository that contains the given reference. The underlying type should be
///   `git_repository`.
///   - ref: The reference to use to lookup the  annotated commit. The underlying type should be
///   `git_reference`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The resulting annotated commit must be freed with ``gitAnnotatedCommitFree(commit:)``.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_from_ref()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_from_ref.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitFromRef(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    ref     : OpaquePointer
) -> Int32
{
    return git_annotated_commit_from_ref(
        out,
        repo,
        ref
    )
}



/// Creates an annotated commit from the given fetch head data.
/// - Parameters:
///   - out: The pointer in which to store the result. The underlying type should be
///   `git_annotated_commit`.
///   - repo: The repository that contains the given commit. The underlying type should be
///   `git_repository`.
///   - branchName: The name of the (remote) branch.
///   - remoteURL: The URL of the remote.
///   - id: The commit object ID of the remote branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The resulting annotated commit must be freed with ``gitAnnotatedCommitFree(commit:)``.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_from_fetchhead()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_from_fetchhead.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitFromFetchhead(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    branchName  : String,
    remoteURL   : String,
    id          : UnsafePointer<git_oid>
) -> Int32
{
    return git_annotated_commit_from_fetchhead(
        out,
        repo,
        branchName,
        remoteURL,
        id
    )
}



/// Creates an annotated commit from the given commit ID.
/// - Parameters:
///   - out: The pointer in which to store the result. The underlying type should be
///   `git_annotated_commit`.
///   - repo: The repository that contains the given commit. The underlying type should be
///   `git_repository`.
///   - id: The commit object ID to lookup.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The resulting annotated commit must be freed with ``gitAnnotatedCommitFree(commit:)``.
///
/// An annotated commit contains information about how it was looked up, which may be useful for functions
/// like merge or rebase to provide context to the operation. For example, conflict files will include the name
/// of the source or target branches being merged. It is therefore preferable to use the most specific function
/// (e.g. ``gitAnnotatedCommitFromRef(out:repo:ref:)``) instead of this one, when that data is
/// known.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_lookup()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_lookup.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : UnsafePointer<git_oid>
) -> Int32
{
    return git_annotated_commit_lookup(
        out,
        repo,
        id
    )
}



/// Creates an annotated commit from a revision string.
/// - Parameters:
///   - out: The pointer in which to store the result. The underlying type should be
///   `git_annotated_commit`.
///   - repo: The repository that contains the given commit. The underlying type should be
///   `git_repository`.
///   - revspec: The extended SHA syntax string to use to lookup the commit.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The resulting annotated commit must be freed with ``gitAnnotatedCommitFree(commit:)``.
///
/// See `man gitrevisions`, or
/// [http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions](http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)
/// for information on the syntax accepted
///
/// ## C Equivalent
///
/// [`git_annotated_commit_from_revspec()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_from_revspec.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitFromRevspec(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    revspec : String
) -> Int32
{
    return git_annotated_commit_from_revspec(
        out,
        repo,
        revspec
    )
}



/// Gets the commit ID to which the given annotated commit refers.
/// - Parameter commit: The annotated commit.  The underlying type should be
/// `git_annotated_commit`.
/// - Returns: The commit ID.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_id()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_id.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitID(
    commit: OpaquePointer
) -> UnsafePointer<git_oid>
{
    return git_annotated_commit_id(commit)
}



/// Gets the reference name to which the given annotated commit refers.
/// - Parameter commit: The annotated commit. The underlying type should be
/// `git_annotated_commit`.
/// - Returns: The reference name.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_ref()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_ref.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitRef(
    commit: OpaquePointer
) -> UnsafePointer<CChar>?
{
    return git_annotated_commit_ref(commit)
}



/// Frees the memory allocated for an annotated commit.
/// - Parameter commit: The annotated commit to free. The underlying type should be
/// `git_annotated_commit`.
///
/// ## C Equivalent
///
/// [`git_annotated_commit_free()`](https://libgit2.org/docs/reference/main/annotated_commit/git_annotated_commit_free.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitAnnotatedCommitFree(
    commit: OpaquePointer?
)
{
    git_annotated_commit_free(commit)
}
