//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_status_options` instance.
/// - Parameters:
///   - opts: The `git_status_options` instance to initialize.
///   - version: The version to use. Pass ``gitStatusOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_status_options_init()`](https://libgit2.org/docs/reference/main/status/git_status_options_init.html)
public func gitStatusOptionsInit(
    opts    : UnsafeMutablePointer<git_status_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_status_options_init(
            opts,
            version
        )
    }
}



/// Loops over all the file statuses in the given repository.
/// - Parameters:
///   - repo: The repository containing the files. The underlying type must
///   be `git_repository`.
///   - callback: The callback to invoke for each status.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_status_foreach()`](https://libgit2.org/docs/reference/main/status/git_status_foreach.html)
public func gitStatusForEach(
    repo        : OpaquePointer,
    callback    : GitStatusCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_status_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Loops over all the file statuses in the given repository.
/// - Parameters:
///   - repo: The repository containing the files. The underlying type must
///   be `git_repository`.
///   - opts: The status options to use.
///   - callback: The callback to invoke for each status.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If ``GitStatusOptions/pathspec`` is provided in the given options to
/// filter the statuses, then the results of rename detection may not be
/// accurate. In order to properly detect renames by considering all files,
/// do not provide any pathspecs.
///
/// ## C Equivalent
///
/// [`git_status_foreach_ext()`](https://libgit2.org/docs/reference/main/status/git_status_foreach_ext.html)
public func gitStatusForEachExt(
    repo        : OpaquePointer,
    opts        : GitStatusOptions?,
    callback    : GitStatusCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_status_foreach_ext(
                repo,
                cOpts,
                callback,
                payload
            )
        }
    }
}



/// Gets the status for the specified file.
/// - Parameters:
///   - statusFlags: The ``GitStatusT`` instance in which to store the status.
///   - repo: The repository containing the file. The underlying type must be
///   `git_repository`.
///   - path: The exact path to the file to evaluate.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function does not perform any rename detection due to lack of
/// information as a result of path filtering. To detect renames, use
/// ``gitStatusListNew(out:repo:opts:)`` instead.
///
/// ## C Equivalent
///
/// [`git_status_file()`](https://libgit2.org/docs/reference/main/status/git_status_file.html)
public func gitStatusFile(
    statusFlags : inout GitStatusT,
    repo        : OpaquePointer,
    path        : String
) -> GitErrorCode
{
    return withCConversion
    {
        return statusFlags.withMutatingRawValue
        {
            cStatusFlags in
            
            return git_status_file(
                cStatusFlags,
                repo,
                path
            )
        }
    }
}



/// Gets the statuses of the files in the given repository.
/// - Parameters:
///   - out: The pointer in which to store the statuses. The underlying type
///   must be `git_status_list`.
///   - repo: The repository containing the files. The underlying type must
///   be `git_repository`.
///   - opts: The status options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If ``GitStatusOptions/pathspec`` is provided in the given options to
/// filter the statuses, then the results of rename detection may not be
/// accurate. In order to properly detect renames by considering all files,
/// do not provide any pathspecs.
///
/// ## C Equivalent
///
/// [`git_status_list_new()`](https://libgit2.org/docs/reference/main/status/git_status_list_new.html)
public func gitStatusListNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    opts    : GitStatusOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_status_list_new(
                out,
                repo,
                cOpts
            )
        }
    }
}



/// Gets the number of status entries in the given status list.
/// - Parameter statusList: The status list to check. The underlying type must
/// be `git_status_list`.
/// - Returns: The number of status entries in the given status list.
///
/// ## C Equivalent
///
/// [`git_status_list_entrycount()`](https://libgit2.org/docs/reference/main/status/git_status_list_entrycount.html)
public func gitStatusListEntryCount(
    statusList: OpaquePointer
) -> Int
{
    return git_status_list_entrycount(statusList)
}



/// Gets the status entry at the specified index in the given status list.
/// - Parameters:
///   - statusList: The status list to check. The underlying type must be
///   `git_status_list`.
///   - idx: The index of the status entry to retrieve.
/// - Returns: The status entry at the specified index in the given status list.
///
/// ## C Equivalent
///
/// [`git_status_byindex()`](https://libgit2.org/docs/reference/main/status/git_status_byindex.html)
public func gitStatusByIndex(
    statusList  : OpaquePointer,
    idx         : Int
) -> GitStatusEntry?
{
    guard let statusEntry: UnsafePointer<git_status_entry>
            = git_status_byindex(
                statusList,
                idx
            )
    else
    {
        return nil
    }
    
    return GitStatusEntry(cValue: statusEntry.pointee)
}



/// Frees the memory allocated for the given `git_status_list` instance.
/// - Parameter statusList: The status list to free. The underlying type must
/// be `git_status_list`.
///
/// ## C Equivalent
///
/// [`git_status_list_free()`](https://libgit2.org/docs/reference/main/status/git_status_list_free.html)
public func gitStatusListFree(
    statusList: OpaquePointer?
)
{
    guard let statusList: OpaquePointer = statusList
    else
    {
        return
    }
    
    git_status_list_free(statusList)
}



/// Checks whether ignore rules apply, or would apply, to the specified file.
/// - Parameters:
///   - ignored: The `Bool` instance in which to store whether ignore rules
///   apply to the specified file
///   - repo: The repository containing the specified file. The underlying
///   type must be `git_repository`.
///   - path: The path to the file to check.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_status_should_ignore()`](https://libgit2.org/docs/reference/main/status/git_status_should_ignore.html)
public func gitStatusShouldIgnore(
    ignored : inout Bool,
    repo    : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return ignored.withMutatingBool
        {
            cIgnored in
            
            return git_status_should_ignore(
                cIgnored,
                repo,
                path
            )
        }
    }
}
