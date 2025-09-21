//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Creates a new branch pointing at the given target commit.
/// - Parameters:
///   - out: The pointer in which to store the result. The underlying type should be `git_reference`.
///   - repo: The repository in which to create the branch. The underlying type should be
///   `git_repository`.
///   - branchName: The branch name. The name will be validated for consistency and should
///   not conflict with an existing branch name.
///   - target: The commit to which the branch should point. The underlying type should be
///   `git_commit`. The commit must belong to the given repository.
///   - force: Whether to overwrite an existing branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will write a proper reference in the `refs/heads` namespace, pointing to the
/// provided target commit.
///
/// ## C Equivalent
///
/// [`git_branch_create()`](https://libgit2.org/docs/reference/main/branch/git_branch_create.html)
public func gitBranchCreate(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    branchName  : String,
    target      : OpaquePointer,
    force       : Bool
) -> Int32
{
    return git_branch_create(
        out,
        repo,
        branchName,
        target,
        force.cValue
    )
}



/// Creates a new branch pointing at the given target annotated commit.
/// - Parameters:
///   - refOut: The pointer in which to store the result. The underlying type should be
///   `git_reference`.
///   - repo: The repository in which to create the branch. The underlying type should be
///   `git_repository`.
///   - branchName: The branch name. The name will be validated for consistency and should
///   not conflict with an existing branch name.
///   - target: The commit to which the branch should point. The underlying type should be
///   `git_annotated_commit`. The commit must belong to the given repository.
///   - force: Whether to overwrite an existing branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function behaves like ``gitBranchCreate(out:repo:branchName:target:force:)``,
/// but takes an annotated commit. This enables more exact reflog messages by being able to specify the
/// extended SHA syntax string which was specified by a user.
///
/// ## C Equivalent
///
/// [`git_branch_create_from_annotated()`](https://libgit2.org/docs/reference/main/branch/git_branch_create_from_annotated.html)
public func gitBranchCreateFromAnnotated(
    refOut      : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    branchName  : String,
    target      : OpaquePointer,
    force       : Bool
) -> Int32
{
    return git_branch_create_from_annotated(
        refOut,
        repo,
        branchName,
        target,
        force.cValue
    )
}



// TODO: Replace `git_reference_free()` in documentation.

/// Deletes an existing branch.
/// - Parameter branch: The branch to delete. The underlying type should be `git_reference`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If the deletion is successful, the given branch reference will no longer be valid and should be freed
/// immediately with `git_reference_free()`.
///
/// ## C Equivalent
///
/// [`git_branch_delete()`](https://libgit2.org/docs/reference/main/branch/git_branch_delete.html)
public func gitBranchDelete(
    branch: OpaquePointer
) -> Int32
{
    return git_branch_delete(branch)
}



/// Creates an iterator which loops over the requested branches.
/// - Parameters:
///   - out: The iterator. The underlying type should be `git_branch_iterator`.
///   - repo: The repository in which the branches exist. The underlying type should be
///   `git_repository`.
///   - listFlags: The filtering flags for the branch listing.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_branch_iterator_new()`](https://libgit2.org/docs/reference/main/branch/git_branch_iterator_new.html)
public func gitBranchIteratorNew(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    listFlags   : GitBranchT
) -> Int32
{
    return git_branch_iterator_new(
        out,
        repo,
        listFlags.cValue
    )
}



/// Retrieves the next branch from the given branch iterator.
/// - Parameters:
///   - out: The branch. The underlying type should be `git_reference`.
///   - outType: The type of branch.
///   - iter: The branch iterator. The underlying type should be `git_branch_iterator`.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_branch_next()`](https://libgit2.org/docs/reference/main/branch/git_branch_next.html)
public func gitBranchNext(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    outType : inout GitBranchT,
    iter    : OpaquePointer
) -> Int32
{
    var cOutType: git_branch_t = outType.cValue
    
    let branchNextResult: Int32 = git_branch_next(
        out,
        &cOutType,
        iter
    )
    
    if
        branchNextResult == GIT_OK.rawValue,
        let swiftOutType = GitBranchT(cValue: cOutType)
    {
        outType = swiftOutType
    }
    
    return branchNextResult
}



/// Frees the memory allocated for a `git_branch_iterator` instance.
/// - Parameter iter: The iterator to free. The underlying type should be
/// `git_branch_iterator`.
///
/// ## C Equivalent
///
/// [`git_branch_iterator_free()`](https://libgit2.org/docs/reference/main/branch/git_branch_iterator_free.html)
public func gitBranchIteratorFree(
    iter: OpaquePointer?
)
{
    return git_branch_iterator_free(iter)
}



// TODO: Replace `git_reference_free()` in documentation.

/// Moves or renames the given local branch.
/// - Parameters:
///   - out: The new reference object for the updated name. The underlying type should be
///   `git_reference`.
///   - branch: The local branch. The underlying type should be `git_reference`.
///   - newBranchName: The target name of the branch, once the move has been performed.
///   The name will be validated for consistency.
///   - force: Whether to overwrite an existing branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If the move is successful, the given branch reference will no longer be valid and should be freed
/// immediately with `git_reference_free()`.
///
/// ## C Equivalent
///
/// [`git_branch_move()`](https://libgit2.org/docs/reference/main/branch/git_branch_move.html)
public func gitBranchMove(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    branch          : OpaquePointer,
    newBranchName   : String,
    force           : Bool
) -> Int32
{
    return git_branch_move(
        out,
        branch,
        newBranchName,
        force.cValue
    )
}



// TODO: Replace `git_reference_free()` in documentation.
/// Looks up a branch by its name in the given repository.
/// - Parameters:
///   - out: The looked-up branch. The underlying type should be `git_reference`.
///   - repo: The repository in which the branches exist. The underlying type should be
///   `git_repository`.
///   - branchName: The branch name. The name will be validated for consistency.
///   - branchType: The branch type.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The caller must free the generated reference using `git_reference_free()`.
///
/// ## C Equivalent
///
/// [`git_branch_lookup()`](https://libgit2.org/docs/reference/main/branch/git_branch_lookup.html)
public func gitBranchLookup(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    branchName  : String,
    branchType  : GitBranchT
) -> Int32
{
    return git_branch_lookup(
        out,
        repo,
        branchName,
        branchType.cValue
    )
}



/// Gets the branch name from the given reference.
/// - Parameters:
///   - out: The abbreviated reference name. This memory is owned by `ref` and should not be
///   freed by the caller.
///   - ref: A reference object, ideally pointing to a branch. The underlying type should be
///   `git_reference`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function checks that the given reference is actually a branch and, if it is a branch, returns the
/// branch part of the reference name.
///
/// Branches are references that exist in `refs/heads/` or `refs/remotes/`.
///
/// ## C Equivalent
///
/// [`git_branch_name()`](https://libgit2.org/docs/reference/main/branch/git_branch_name.html)
public func gitBranchName(
    out : UnsafeMutablePointer<UnsafePointer<CChar>?>,
    ref : OpaquePointer
) -> Int32
{
    return git_branch_name(
        out,
        ref
    )
}



/// Gets the upstream of the given local branch.
/// - Parameters:
///   - out: The pointer in which to store the upstream. The underlying type should be
///   `git_reference`.
///   - ref: The local branch for which to get the upstream. The underlying type should be
///   `git_reference`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function returns the reference object that corresponds to the given branch's remote-tracking branch.
///
/// ## C Equivalent
///
/// [`git_branch_upstream()`](https://libgit2.org/docs/reference/main/branch/git_branch_upstream.html)
public func gitBranchUpstream(
    out : UnsafeMutablePointer<OpaquePointer?>,
    ref : OpaquePointer
) -> Int32
{
    return git_branch_upstream(
        out,
        ref
    )
}



/// Sets the upstream of the given branch.
/// - Parameters:
///   - branch: The branch whose upstream should be set.
///   - branchName: The name of the remote-tracking or local branch to set as the upstream branch.
///   Pass `nil` to unset the upstream information.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The tracking reference must have already been created for the operation to succeed.
///
/// ## C Equivalent
///
/// [`git_branch_set_upstream()`](https://libgit2.org/docs/reference/main/branch/git_branch_set_upstream.html)
public func gitBranchSetUpstream(
    branch      : OpaquePointer,
    branchName  : String?
) -> Int32
{
    return git_branch_set_upstream(
        branch,
        branchName
    )
}



/// Gets the upstream name of the given local branch.
/// - Parameters:
///   - out: The buffer into which the upstream name should be written.
///   - repo: The repository in which the branches exist. The underlying type should be
///   `git_repository`.
///   - refName: The branch name.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return the remote-tracking branch information of the given local branch as a full
/// reference name.
///
/// For example, `feature/nice` would become `refs/remote/origin/feature/nice`,
/// depending on that branch's configuration.
///
/// ## C Equivalent
///
/// [`git_branch_upstream_name()`](https://libgit2.org/docs/reference/main/branch/git_branch_upstream_name.html)
public func gitBranchUpstreamName(
    out     : inout GitBuf,
    repo    : OpaquePointer,
    refName : String
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return git_branch_upstream_name(
            cOut,
            repo,
            refName
        )
    }
}



/// Checks if HEAD points to the given local branch.
/// - Parameter branch: The local branch. The underlying type should be `git_reference`.
/// - Returns: `1` if HEAD points to the branch, `0` if HEAD does not point to the branch, or
/// an error code.
///
/// ## C Equivalent
///
/// [`git_branch_is_head()`](https://libgit2.org/docs/reference/main/branch/git_branch_is_head.html)
public func gitBranchIsHEAD(
    branch: OpaquePointer
) -> Int32
{
    return git_branch_is_head(branch)
}



/// Checks if any HEAD points to the given local branch.
/// - Parameter branch: The local branch. The underlying type should be `git_reference`.
/// - Returns: `1` if any HEAD points to the branch, `0` if no HEAD points to the branch, or
/// an error code.
///
/// ## Discussion
///
/// This function iterates over all known linked repositories (usually in the form of worktrees) to determine
/// whether any HEAD points to the branch.
///
/// ## C Equivalent
///
/// [`git_branch_is_checked_out()`](https://libgit2.org/docs/reference/main/branch/git_branch_is_checked_out.html)
public func gitBranchIsCheckedOut(
    branch: OpaquePointer
) -> Int32
{
    return git_branch_is_checked_out(branch)
}



/// Gets the remote name of the given remote-tracking branch.
/// - Parameters:
///   - out: The buffer into which the remote name should be written.
///   - repo: The repository in which the branch exists. The underlying type should be
///   `git_repository`.
///   - refName: The full reference name of the branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return the name of the remote whose refspec matches the given branch.
///
/// For example, `refs/remotes/test/main` has a remote name of `test`.
///
/// If refspecs from multiple remotes match, the error code returned will be `GIT_EAMBIGUOUS`.
///
/// ## C Equivalent
///
/// [`git_branch_remote_name()`](https://libgit2.org/docs/reference/main/branch/git_branch_remote_name.html)
public func gitBranchRemoteName(
    out     : inout GitBuf,
    repo    : OpaquePointer,
    refName : String
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return git_branch_remote_name(
            cOut,
            repo,
            refName
        )
    }
}



/// Gets the upstream remote name of the given local branch.
/// - Parameters:
///   - buf: The buffer into which the upstream remote name should be written.
///   - repo: The repository in which the branch exists. The underlying type should be
///   `git_repository`.
///   - refName: The full reference name of the branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return the currently-configured `branch.*.remote` for the given branch.
///
/// ## C Equivalent
///
/// [`git_branch_upstream_remote()`](https://libgit2.org/docs/reference/main/branch/git_branch_upstream_remote.html)
public func gitBranchUpstreamRemote(
    buf     : inout GitBuf,
    repo    : OpaquePointer,
    refName : String
) -> Int32
{
    return buf.withMutatingCValue
    {
        cBuf in
        
        return git_branch_upstream_remote(
            cBuf,
            repo,
            refName
        )
    }
}



/// Gets the upstream merge name of the given local branch.
/// - Parameters:
///   - buf: The buffer into which the upstream merge name should be written.
///   - repo: The repository in which the branch exists. The underlying type should be
///   `git_repository`.
///   - refName: The full reference name of the branch.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return the currently-configured `branch.*.merge` for the given branch.
///
/// ## C Equivalent
///
/// [`git_branch_upstream_merge()`](https://libgit2.org/docs/reference/main/branch/git_branch_upstream_merge.html)
public func gitBranchUpstreamMerge(
    buf     : inout GitBuf,
    repo    : OpaquePointer,
    refName : String
) -> Int32
{
    return buf.withMutatingCValue
    {
        cBuf in
        
        return git_branch_upstream_merge(
            cBuf,
            repo,
            refName
        )
    }
}



/// Checks whether the given branch name is valid.
/// - Parameters:
///   - valid: The pointer in which to store the result.
///   - name: The branch name.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_branch_name_is_valid()`](https://libgit2.org/docs/reference/main/branch/git_branch_name_is_valid.html)
public func gitBranchIsValid(
    valid   : UnsafeMutablePointer<Bool>,
    name    : String
) -> Int32
{
    var intValid: Int32 = 0
    
    let branchNameIsValidResult: Int32 = git_branch_name_is_valid(
        &intValid,
        name
    )
    
    valid.pointee = intValid == 1
    
    return branchNameIsValidResult
}
