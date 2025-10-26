//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Compiles a pathspec.
/// - Parameters:
///   - out: The pointer in which to store the pathspec. The underlying type
///   must be `git_pathspec`.
///   - pathspec: The paths to match.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_pathspec_new()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_new.html)
public func gitPathspecNew(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    pathspec    : [String]
) -> GitErrorCode
{
    return withCConversion
    {
        return try pathspec.withGitStrArray
        {
            cPathspec in
            
            return git_pathspec_new(
                out,
                cPathspec
            )
        }
    }
}



/// Frees the memory allocated for the given `git_pathspec` instance.
/// - Parameter ps: The pathspec to free. The underlying type must be
/// `git_pathspec`.
///
/// ## C Equivalent
///
/// [`git_pathspec_free()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_free.html)
public func gitPathspecFree(
    ps: OpaquePointer?
)
{
    guard let ps: OpaquePointer = ps
    else
    {
        return
    }
    
    git_pathspec_free(ps)
}



/// Checks whether the given pathspec matches the given path.
/// - Parameters:
///   - ps: The pathspec to match. The underlying type must be `git_pathspec`.
///   - flags: The flags controlling the behavior of pathspec matching.
///   - path: The path name to match.
/// - Returns: Whether the given pathspec matches the given path.
///
/// ## Discussion
///
/// Unlike most other pathspec-matching functions, this function will not fall
/// back on the native file system case sensitivity. If no flags are provided,
/// this function will perform a case-sensitive match.
///
/// ## C Equivalent
///
/// [`git_pathspec_matches_path()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_matches_path.html)
public func gitPathspecMatchesPath(
    ps      : OpaquePointer,
    flags   : GitPathspecFlagT,
    path    : String
) -> Bool
{
    let matchesPath: Int32 = git_pathspec_matches_path(
        ps,
        flags.rawValue,
        path
    )
    
    return Bool(matchesPath)
}



/// Matches the given pathspec against the working directory of the given
/// repository.
/// - Parameters:
///   - out: The pointer in which to store the matching pathspecs. The
///   underlying type must be `git_pathspec_match_list`.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`. This repository must not be bare.
///   - flags: The flags controlling the behavior of pathspec matching.
///   - ps: The pathspec to match. The underlying type must be `git_pathspec`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_workdir()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_workdir.html)
public func gitPathspecMatchWorkdir(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    flags   : GitPathspecFlagT,
    ps      : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_pathspec_match_workdir(
            out,
            repo,
            flags.rawValue,
            ps
        )
    }
}



/// Matches the given pathspec against the given index.
/// - Parameters:
///   - out: The pointer in which to store the matching pathspecs. The
///   underlying type must be `git_pathspec_match_list`.
///   - index: The index to match. The underlying type must be `git_index`.
///   - flags: The flags controlling the behavior of pathspec matching.
///   - ps: The pathspec to match. The underlying type must be `git_pathspec`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: The case sensitivity of this match is controlled by the case
/// sensitivity of the given index. The given flags have no effect. This will
/// be corrected in a future version of libgit2.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_index()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_index.html)
public func gitPathspecMatchIndex(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    index   : OpaquePointer,
    flags   : GitPathspecFlagT,
    ps      : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_pathspec_match_index(
            out,
            index,
            flags.rawValue,
            ps
        )
    }
}



/// Matches the given pathspec against the given tree.
/// - Parameters:
///   - out: The pointer in which to store the matching pathspecs. The
///   underlying type must be `git_pathspec_match_list`.
///   - tree: The tree to match. The underlying type must be `git_tree`.
///   - flags: The flags controlling the behavior of pathspec matching.
///   - ps: The pathspec to match. The underlying type must be `git_pathspec`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_tree()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_tree.html)
public func gitPathspecMatchTree(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    tree    : OpaquePointer,
    flags   : GitPathspecFlagT,
    ps      : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_pathspec_match_tree(
            out,
            tree,
            flags.rawValue,
            ps
        )
    }
}



/// Matches the given pathspec against the given diff.
/// - Parameters:
///   - out: The pointer in which to store the matching pathspecs. The
///   underlying type must be `git_pathspec_match_list`.
///   - diff: The diff to match. The underlying type must be `git_diff`.
///   - flags: The flags controlling the behavior of pathspec matching.
///   - ps: The pathspec to match. The underlying type must be `git_pathspec`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_diff()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_diff.html)
public func gitPathspecMatchDiff(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    diff    : OpaquePointer,
    flags   : GitPathspecFlagT,
    ps      : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_pathspec_match_diff(
            out,
            diff,
            flags.rawValue,
            ps
        )
    }
}



/// Frees the memory allocated for the given `git_pathspec_match_list` instance.
/// - Parameter m: The pathspec match list to free. The underlying type must be
/// `git_pathspec_match_list`.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_list_free()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_list_free.html)
public func gitPathspecMatchListFree(
    m: OpaquePointer?
)
{
    guard let m: OpaquePointer = m
    else
    {
        return
    }
    
    git_pathspec_match_list_free(m)
}



/// Gets the number of entries in the given pathspec match list.
/// - Parameter m: The pathspec match list to use. The underlying type must be
/// `git_pathspec_match_list`.
/// - Returns: The number of entries in the given pathspec match list.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_list_entrycount()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_list_entrycount.html)
public func gitPathspecMatchListEntryCount(
    m: OpaquePointer
) -> Int
{
    return git_pathspec_match_list_entrycount(m)
}



/// Gets the file name of the specified entry in the given pathspec match list.
/// - Parameters:
///   - m: The pathspec match list to use. The underlying type must be
///   `git_pathspec_match_list`.
///   - pos: The index of the entry to retrieve.
/// - Returns: The file name of the specified entry in the given pathspec match
/// list.
///
/// ## Discussion
///
/// This function will always return `nil` if the given pathspec match list was
/// generated by ``gitPathspecMatchDiff(out:diff:flags:ps:)``
///
/// ## C Equivalent
///
/// [`git_pathspec_match_list_entry()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_list_entry.html)
public func gitPathspecMatchListEntry(
    m   : OpaquePointer,
    pos : Int
) -> String?
{
    let fileName: UnsafePointer<CChar>? = git_pathspec_match_list_entry(
        m,
        pos
    )
    
    return String(optionalCString: fileName)
}



/// Gets the delta of the specified entry in the given pathspec match list.
/// - Parameters:
///   - m: The pathspec match list to use. The underlying type must be
///   `git_pathspec_match_list`.
///   - pos: The index of the entry to retrieve.
/// - Returns: The delta of the specified entry in the given pathspec match
/// list.
///
/// ## Discussion
///
/// This function will always return `nil` if the given pathspec match list was
/// not generated by ``gitPathspecMatchDiff(out:diff:flags:ps:)``
///
/// ## C Equivalent
///
/// [`git_pathspec_match_list_diff_entry()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_list_diff_entry.html)
public func gitPathspecMatchListDiffEntry(
    m   : OpaquePointer,
    pos : Int
) -> GitDiffDelta?
{
    guard let diffDelta: UnsafePointer<git_diff_delta>
            = git_pathspec_match_list_diff_entry(
                m,
                pos
            )
    else
    {
        return nil
    }
    
    return GitDiffDelta(cValue: diffDelta.pointee)
}



/// Gets the number of unmatched entries in the given pathspec match list.
/// - Parameter m: The pathspec match list to use. The underlying type must be
/// `git_pathspec_match_list`.
/// - Returns: The number of unmatched entries in the given pathspec match list.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_list_failed_entrycount()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_list_failed_entrycount.html)
public func gitPathspecMatchListFailedEntryCount(
    m: OpaquePointer
) -> Int
{
    return git_pathspec_match_list_failed_entrycount(m)
}



/// Gets the file name of the specified unmatched entry in the given pathspec
/// match list.
/// - Parameters:
///   - m: The pathspec match list to use. The underlying type must be
///   `git_pathspec_match_list`.
///   - pos: The index of the entry to retrieve.
/// - Returns: The file name of the specified unmatched entry in the given
/// pathspec match list.
///
/// ## C Equivalent
///
/// [`git_pathspec_match_list_failed_entry()`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_match_list_failed_entry.html)
public func gitPathspecMatchListFailedEntry(
    m   : OpaquePointer,
    pos : Int
) -> String?
{
    let fileName: UnsafePointer<CChar>? = git_pathspec_match_list_failed_entry(
        m,
        pos
    )
    
    return String(optionalCString: fileName)
}
