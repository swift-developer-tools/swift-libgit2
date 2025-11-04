//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Counts the number of unique commits between the given commits.
///
/// There is no need for the branches containing the commits to have any
/// upstream relationship, but it helps to think of one as a branch and the
/// other as its upstream. The ahead and behind values will be what Git would
/// report for the branches in such a scenario.
///
/// - Parameters:
///   - ahead: The pointer in which to store the number of unique commits in
///   `upstream`.
///   - behind: The pointer in which to store the number of unique commits in
///   `local`.
///   - repo: The repository containing the given commits. The underlying type
///   must be `git_repository`.
///   - local: The ID of the local commit to evaluate.
///   - upstream: The ID of the upstream commit to evaluate.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_graph_ahead_behind()`](https://libgit2.org/docs/reference/main/graph/git_graph_ahead_behind.html)
public func gitGraphAheadBehind(
    ahead       : UnsafeMutablePointer<Int>,
    behind      : UnsafeMutablePointer<Int>,
    repo        : OpaquePointer,
    local       : GitOID,
    upstream    : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return local.withCValue
        {
            cLocal in
            
            return upstream.withCValue
            {
                cUpstream in
                
                return git_graph_ahead_behind(
                    ahead,
                    behind,
                    repo,
                    cLocal,
                    cUpstream
                )
            }
        }
    }
}



/// Checks whether the given commit is the descendant of the given ancestor
/// commit.
///
/// In contrast to `git merge-base --is-ancestor`, this function does not
/// consider a commit to be a descendant of itself.
///
/// - Parameters:
///   - repo: The repository containing the given commits. The underlying type
///   must be `git_repository`.
///   - commit: The ID of the commit to check.
///   - ancestor: The ID of the ancestor commit to check against.
/// - Returns: Whether the given commit is the descendant of the given ancestor
/// commit, or `nil` if there was an error.
///
/// ## C Equivalent
///
/// [`git_graph_descendant_of()`](https://libgit2.org/docs/reference/main/graph/git_graph_descendant_of.html)
public func gitGraphDescendantOf(
    repo        : OpaquePointer,
    commit      : GitOID,
    ancestor    : GitOID
) -> Bool?
{
    let isDescendant: Int32 = commit.withCValue
    {
        cCommit in
        
        return ancestor.withCValue
        {
            cAncestor in
            
            return git_graph_descendant_of(
                repo,
                cCommit,
                cAncestor
            )
        }
    }
    
    if
        isDescendant != 0,
        isDescendant != 1
    {
        return nil
    }
    
    return Bool(isDescendant)
}



/// Checks whether the given commit is reachable from any of the given commits,
/// by following parent edges.
/// - Parameters:
///   - repo: The repository containing the given commits. The underlying type
///   must be `git_repository`.
///   - commit: The ID of the commit to evaluate.
///   - descendantArray: The IDs of the potential descendant commits.
///   - length: The length of `descendantArray`.
/// - Returns: Whether the given commit is reachable from any of the given
/// commits, or `nil` if there was an error.
///
/// ## C Equivalent
///
/// [`git_graph_reachable_from_any()`](https://libgit2.org/docs/reference/main/graph/git_graph_reachable_from_any.html)
public func gitGraphReachableFromAny(
    repo            : OpaquePointer,
    commit          : GitOID,
    descendantArray : [GitOID],
    length          : Int
) -> Bool?
{
    let isReachableFromAny: Int32 = commit.withCValue
    {
        cCommit in
        
        return descendantArray.withArrayOfGitOIDs
        {
            cDescendantArray, cDescendantArrayCount in
            
            return git_graph_reachable_from_any(
                repo,
                cCommit,
                cDescendantArray,
                cDescendantArrayCount
            )
        }
    }
    
    if
        isReachableFromAny != 0,
        isReachableFromAny != 1
    {
        return nil
    }
    
    return Bool(isReachableFromAny)
}
