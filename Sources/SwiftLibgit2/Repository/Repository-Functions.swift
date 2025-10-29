//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// Opens the repository at the specified location.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - path: The path to the repository to open. This must point to either a
///   `.git` directory or an existing working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will automatically detect if the repository at the specified
/// location is a normal or bare repository, and will fail if neither is true.
///
/// ## C Equivalent
///
/// [`git_repository_open()`](https://libgit2.org/docs/reference/main/repository/git_repository_open.html)
public func gitRepositoryOpen(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_open(
            out,
            path
        )
    }
}



/// Opens the working directory of the given worktree as a repository.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - wt: The worktree to open. The underlying type must be `git_worktree`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_open_from_worktree()`](https://libgit2.org/docs/reference/main/repository/git_repository_open_from_worktree.html)
public func gitRepositoryOpenFromWorktree(
    out : UnsafeMutablePointer<OpaquePointer?>,
    wt  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_open_from_worktree(
            out,
            wt
        )
    }
}



/// Creates a repository to wrap the given object database.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - odb: The object database to wrap. The underlying type must be `git_odb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function does not create a normal repository. The created repository
/// will not have any associated paths.
///
/// ## C Equivalent
///
/// [`git_repository_wrap_odb()`](https://libgit2.org/docs/reference/main/repository/git_repository_wrap_odb.html)
public func gitRepositoryWrapODB(
    out : UnsafeMutablePointer<OpaquePointer?>,
    odb : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_wrap_odb(
            out,
            odb
        )
    }
}



/// Searches for a repository at the specified location, and copies its path.
/// - Parameters:
///   - out: The `Data` instance in which to store the found path.
///   - startPath: The base path at which to begin searching.
///   - acrossFS: Whether to search across file system boundaries.
///   - ceilingDirs: A list of absolute symbolic link free paths, separated
///   by ``gitPathListSeparator``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The search will always begin with `startPath`, and will stop if any of
/// the paths in `ceilingDirs` are reached.
///
/// ## C Equivalent
///
/// [`git_repository_discover()`](https://libgit2.org/docs/reference/main/repository/git_repository_discover.html)
public func gitRepositoryDiscover(
    out         : inout Data,
    startPath   : String,
    acrossFS    : Bool,
    ceilingDirs : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_repository_discover(
                cOut,
                startPath,
                acrossFS.int32Value,
                ceilingDirs
            )
        }
    }
}



/// Opens the repository at the specified location.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - path: The path to the repository to open. This must point to either a
///   `.git` directory or an existing working directory.
///   - flags: The flags controlling repository opening.
///   - ceilingDirs: A list of absolute symbolic link free paths, separated
///   by ``gitPathListSeparator``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// `path` may be `nil` only if `flags` is
/// ``GitRepositoryOpenFlagT/gitRepositoryOpenFromEnv``.
///
/// ## C Equivalent
///
/// [`git_repository_open_ext()`](https://libgit2.org/docs/reference/main/repository/git_repository_open_ext.html)
public func gitRepositoryOpenExt(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    path        : String?,
    flags       : GitRepositoryOpenFlagT,
    ceilingDirs : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_open_ext(
            out,
            path,
            flags.rawValue,
            ceilingDirs
        )
    }
}



/// Opens a bare repository at the specified location.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - barePath: The path to the bare repository to open.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is a fast-open for bare repositories that can help improve performance
/// when hosting repositories.
///
/// ## C Equivalent
///
/// [`git_repository_open_bare()`](https://libgit2.org/docs/reference/main/repository/git_repository_open_bare.html)
public func gitRepositoryOpenBare(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    barePath    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_open_bare(
            out,
            barePath
        )
    }
}



/// Frees the memory allocated for the given `git_repository` instance.
/// - Parameter repo: The repository to free. The underlying type must be
/// `git_repository`.
///
/// ## Discussion
///
/// - Important: After a repository is freed, all its associated objects
/// will still exist until they are manually freed. Accessing any of the
/// objects will result in undefined behavior.
///
/// ## C Equivalent
///
/// [`git_repository_free()`](https://libgit2.org/docs/reference/main/repository/git_repository_free.html)
public func gitRepositoryFree(
    repo: OpaquePointer?
)
{
    guard let repo: OpaquePointer = repo
    else
    {
        return
    }
    
    git_repository_free(repo)
}



/// Creates a repository at the specified location.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - path: The path to the location at which to create the repository.
///   - isBare: Whether to create a bare repository.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_init()`](https://libgit2.org/docs/reference/main/repository/git_repository_init.html)
public func gitRepositoryInit(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    path    : String,
    isBare  : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_init(
            out,
            path,
            isBare.uint32Value
        )
    }
}



/// Initializes the given `git_repository_init_options` instance.
/// - Parameters:
///   - opts: The `git_repository_init_options` instance to initialize.
///   - version: The version to use. Pass ``gitRepositoryInitOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_init_options_init()`](https://libgit2.org/docs/reference/main/repository/git_repository_init_options_init.html)
public func gitRepositoryInitOptionsInit(
    opts    : UnsafeMutablePointer<git_repository_init_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_init_options_init(
            opts,
            version
        )
    }
}



/// Creates a repository at the specified location.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - repoPath: The path to the location at which to create the repository.
///   - opts: The repository initialization options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will auto-detect the case sensitivity of the file system and
/// whether it correctly supports file mode bits.
///
/// ## C Equivalent
///
/// [`git_repository_init_ext()`](https://libgit2.org/docs/reference/main/repository/git_repository_init_ext.html)
public func gitRepositoryInitExt(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repoPath    : String,
    opts        : GitRepositoryInitOptions
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withCValue
        {
            cOpts in
            
            return git_repository_init_ext(
                out,
                repoPath,
                cOpts
            )
        }
    }
}



/// Retrieves and resolves the HEAD reference in the given repository.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_head()`](https://libgit2.org/docs/reference/main/repository/git_repository_head.html)
public func gitRepositoryHEAD(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_head(
            out,
            repo
        )
    }
}



/// Retrieves the HEAD reference for the specified worktree.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
///   - name: The name of the worktree for which to retrieve the HEAD reference.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_head_for_worktree()`](https://libgit2.org/docs/reference/main/repository/git_repository_head_for_worktree.html)
public func gitRepositoryHEADForWorktree(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_head_for_worktree(
            out,
            repo,
            name
        )
    }
}



/// Checks whether the given repository's HEAD is detached.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: Whether the given repository's HEAD is detached, or `nil` if
/// there was an error.
///
/// ## Discussion
///
/// A repository's HEAD is detached when it points directly to a commit
/// instead of a branch.
///
/// ## C Equivalent
///
/// [`git_repository_head_detached()`](https://libgit2.org/docs/reference/main/repository/git_repository_head_detached.html)
public func gitRepositoryHEADDetached(
    repo: OpaquePointer
) -> Bool?
{
    let isHEADDetached: Int32 = git_repository_head_detached(repo)
    
    if
        isHEADDetached != 0,
        isHEADDetached != 1
    {
        return nil
    }
    
    return Bool(isHEADDetached)
}



/// Checks whether the specified worktree's HEAD is detached.
/// - Parameters:
///   - repo: The repository containing the specified worktree. The underlying
///   type must be `git_repository`.
///   - name: The name of the worktree to check.
/// - Returns: Whether the specified worktree's HEAD is detached, or `nil` if
/// there was an error.
///
/// ## Discussion
///
/// A worktree's HEAD is detached when it points directly to a commit instead
/// of a branch.
///
/// ## C Equivalent
///
/// [`git_repository_head_detached_for_worktree()`](https://libgit2.org/docs/reference/main/repository/git_repository_head_detached_for_worktree.html)
public func gitRepositoryHEADDetachedForWorktree(
    repo    : OpaquePointer,
    name    : String
) -> Bool?
{
    let isHEADDetached: Int32 = git_repository_head_detached_for_worktree(
        repo,
        name
    )
    
    if
        isHEADDetached != 0,
        isHEADDetached != 1
    {
        return nil
    }
    
    return Bool(isHEADDetached)
}



/// Checks whether the given repository's HEAD is unborn.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: Whether the given repository's HEAD is unborn, or `nil` if
/// there was an error.
///
/// ## Discussion
///
/// An unborn branch is one named from HEAD, but which does not exist in the
/// `refs` namespace because it does not point to a commit.
///
/// ## C Equivalent
///
/// [`git_repository_head_unborn()`](https://libgit2.org/docs/reference/main/repository/git_repository_head_unborn.html)
public func gitRepositoryHEADUnborn(
    repo: OpaquePointer
) -> Bool?
{
    let isHEADUnborn: Int32 = git_repository_head_unborn(repo)
    
    if
        isHEADUnborn != 0,
        isHEADUnborn != 1
    {
        return nil
    }
    
    return Bool(isHEADUnborn)
}



/// Checks whether the given repository is empty.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: Whether the given repository is empty, or `nil` if there was
/// an error.
///
/// ## Discussion
///
/// A repository is empty if it has just been initialized and contains no
/// references apart from HEAD, which must be pointing to the unborn main
/// branch, or the branch specified for the repository in the
/// `init.defaultBranch` configuration variable.
///
/// ## C Equivalent
///
/// [`git_repository_is_empty()`](https://libgit2.org/docs/reference/main/repository/git_repository_is_empty.html)
public func gitRepositoryIsEmpty(
    repo: OpaquePointer
) -> Bool?
{
    let isEmpty: Int32 = git_repository_is_empty(repo)
    
    if
        isEmpty != 0,
        isEmpty != 1
    {
        return nil
    }
    
    return Bool(isEmpty)
}



/// Gets the path of the specified file or directory in the given repository.
/// - Parameters:
///   - out: The `Data` instance in which to store the path.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
///   - item: The type of item for which to retrieve the path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_item_path()`](https://libgit2.org/docs/reference/main/repository/git_repository_item_path.html)
public func gitRepositoryItemPath(
    out     : inout Data,
    repo    : OpaquePointer,
    item    : GitRepositoryItemT
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_repository_item_path(
                cOut,
                repo,
                item.cValue()
            )
        }
    }
}



/// Gets the path of the given repository.
/// - Parameter repo: The repository for which to get the path. The underlying
/// type must be `git_repository`.
/// - Returns: The path of the given repository.
///
/// ## C Equivalent
///
/// [`git_repository_path()`](https://libgit2.org/docs/reference/main/repository/git_repository_path.html)
public func gitRepositoryPath(
    repo: OpaquePointer
) -> String?
{
    let repositoryPath: UnsafePointer<CChar>? = git_repository_path(repo)
    
    return String(optionalCString: repositoryPath)
}



/// Gets the path of the working directory of the given repository.
/// - Parameter repo: The repository for which to get the working directory
/// path. The underlying type must be `git_repository`.
/// - Returns: The path of the working directory of the given repository.
///
/// ## Discussion
///
/// - Note: A bare repository has no working directory.
///
/// ## C Equivalent
///
/// [`git_repository_workdir()`](https://libgit2.org/docs/reference/main/repository/git_repository_workdir.html)
public func gitRepositoryWorkdir(
    repo: OpaquePointer
) -> String?
{
    let repositoryWorkdirPath: UnsafePointer<CChar>?
        = git_repository_workdir(repo)
    
    return String(optionalCString: repositoryWorkdirPath)
}



/// Gets the path of the common directory of the given repository.
/// - Parameter repo: The repository for which to get the common directory
/// path. The underlying type must be `git_repository`.
/// - Returns: The path of the common directory of the given repository.
///
/// ## Discussion
///
/// If the given repository is bare, the common directory is the repository's
/// root directory. If the repository is a worktree, the common directory is
/// the parent repository's `.git` directory. Otherwise, the common directory
/// is the `.git` directory.
///
/// ## C Equivalent
///
/// [`git_repository_commondir()`](https://libgit2.org/docs/reference/main/repository/git_repository_commondir.html)
public func gitRepositoryCommonDir(
    repo: OpaquePointer
) -> String?
{
    let repositoryCommonDirPath: UnsafePointer<CChar>?
        = git_repository_commondir(repo)
    
    return String(optionalCString: repositoryCommonDirPath)
}



/// Sets the working directory path of the given repository.
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - workdir: The working directory path to set.
///   - updateGitlink: Whether to create or update the Gitlink in the working
///   directory, and set the `core.worktree` configuration variable (if the
///   working direcory is not the parent of the `.git` directory).
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The working directory does not need to be the same directory that contains
/// the `.git` directory of the given repository.
///
/// If the given repository is bare, settings its working directory will
/// convert it to a normal repository capable of performing all the common
/// working directory operations, such as checkout and index manipulation.
///
/// ## C Equivalent
///
/// [`git_repository_set_workdir()`](https://libgit2.org/docs/reference/main/repository/git_repository_set_workdir.html)
public func gitRepositorySetWorkdir(
    repo            : OpaquePointer,
    workdir         : String,
    updateGitlink   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_workdir(
            repo,
            workdir,
            updateGitlink.int32Value
        )
    }
}



/// Checks whether the given repository is bare.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: Whether the given repository is bare.
///
/// ## C Equivalent
///
/// [`git_repository_is_bare()`](https://libgit2.org/docs/reference/main/repository/git_repository_is_bare.html)
public func gitRepositoryIsBare(
    repo: OpaquePointer
) -> Bool
{
    let isBare: Int32 = git_repository_is_bare(repo)
    
    return Bool(isBare)
}



/// Checks whether the given repository is a linked worktree.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: Whether the given repository is a linked worktree.
///
/// ## C Equivalent
///
/// [`git_repository_is_worktree()`](https://libgit2.org/docs/reference/main/repository/git_repository_is_worktree.html)
public func gitRepositoryIsWorktree(
    repo: OpaquePointer
) -> Bool
{
    let isWorktree: Int32 = git_repository_is_worktree(repo)
    
    return Bool(isWorktree)
}



/// Gets the configuration of the given repository.
/// - Parameters:
///   - out: The pointer in which to store the configuration. The underlying
///   type must be `git_config`.
///   - repo: The repository for which to get the configuration. The underlying
///   type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default configuration will be returned if a configuration file has not
/// been set. The default configuration includes global and system
/// configurations, if they are available.
///
/// ## C Equivalent
///
/// [`git_repository_config()`](https://libgit2.org/docs/reference/main/repository/git_repository_config.html)
public func gitRepositoryConfig(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_config(
            out,
            repo
        )
    }
}



/// Gets a snapshot of the configuration of the given repository.
/// - Parameters:
///   - out: The pointer in which to store the configuration snapshot. The
///   underlying type must be `git_config`.
///   - repo: The repository for which to get the configuration snapshot. The
///   underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The contents of the snapshot will not change, even if the underlying
/// configuration files are modified.
///
/// ## C Equivalent
///
/// [`git_repository_config_snapshot()`](https://libgit2.org/docs/reference/main/repository/git_repository_config_snapshot.html)
public func gitRepositoryConfigSnapshot(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_config_snapshot(
            out,
            repo
        )
    }
}



/// Gets the object database of the given repository.
/// - Parameters:
///   - out: The pointer in which to store the object database. The underlying
///   type must be `git_odb`.
///   - repo: The repository for which to get the object database. The
///   underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default object database will be returned if a custom object database
/// has not been set. The default object database is located in `.git/objects`.
///
/// ## C Equivalent
///
/// [`git_repository_odb()`](https://libgit2.org/docs/reference/main/repository/git_repository_odb.html)
public func gitRepositoryODB(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_odb(
            out,
            repo
        )
    }
}



/// Gets the reference database of the given repository.
/// - Parameters:
///   - out: The pointer in which to store the reference database. The
///   underlying type must be `git_refdb`.
///   - repo: The repository for which to get the reference database. The
///   underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default reference database will be returned if a custom reference
/// database has not been set. The default reference database is the database
/// that manipulates loose and packed references in the `.git` directory.
///
/// ## C Equivalent
///
/// [`git_repository_refdb()`](https://libgit2.org/docs/reference/main/repository/git_repository_refdb.html)
public func gitRepositoryRefDB(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_refdb(
            out,
            repo
        )
    }
}



/// Gets the index of the given repository.
/// - Parameters:
///   - out: The pointer in which to store the index. The underlying type
///   must be `git_index`.
///   - repo: The repository for which to get the index. The underlying type
///   must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default index will be returned if a custom index has not been set.
/// The default index is located in `.git/index`.
///
/// ## C Equivalent
///
/// [`git_repository_index()`](https://libgit2.org/docs/reference/main/repository/git_repository_index.html)
public func gitRepositoryIndex(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_index(
            out,
            repo
        )
    }
}



/// Gets the prepared message of the given repository.
/// - Parameters:
///   - out: The `Data` instance in which to store the prepared message.
///   - repo: The repository for which to get the prepared message. The
///   underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function gets the contents of `.git/MERGE_MSG`. Operations such as
/// cherry-pick, revert, and merging with the `-n` flag stop just short of
/// creating a commit with the changes, and save their prepared message in
/// `.git/MERGE_MSG` so the next commit operation can present the message to
/// possibly be amended.
///
/// - Note: The `.git/MERGE_MSG` file must be removed after creating a commit.
///
/// ## C Equivalent
///
/// [`git_repository_message()`](https://libgit2.org/docs/reference/main/repository/git_repository_message.html)
public func gitRepositoryMessage(
    out     : inout Data,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_repository_message(
                cOut,
                repo
            )
        }
    }
}



/// Removes the prepared message of the given repository.
/// - Parameter repo: The repository for which to remove the prepared message.
/// The underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: See ``gitRepositoryMessage(out:repo:)`` for more information on
/// the prepared message.
///
/// ## C Equivalent
///
/// [`git_repository_message_remove()`](https://libgit2.org/docs/reference/main/repository/git_repository_message_remove.html)
public func gitRepositoryMessageRemove(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_message_remove(repo)
    }
}



/// Removes all the metadata associated with an ongoing operation in the
/// given repository.
/// - Parameter repo: The repository to clean up. The underlying type must
/// be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_state_cleanup()`](https://libgit2.org/docs/reference/main/repository/git_repository_state_cleanup.html)
public func gitRepositoryStateCleanup(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_state_cleanup(repo)
    }
}



/// Loops over each `FETCH_HEAD` entry in the given repository.
/// - Parameters:
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
///   - callback: The ``GitRepositoryFETCHHEADForEachCB`` callback to invoke
///   for each `FETCH_HEAD` entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_fetchhead_foreach()`](https://libgit2.org/docs/reference/main/repository/git_repository_fetchhead_foreach.html)
public func gitRepositoryFETCHHEADForEach(
    repo        : OpaquePointer,
    callback    : GitRepositoryFETCHHEADForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_fetchhead_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Loops over each `MERGE_HEAD` entry in the given repository.
/// - Parameters:
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
///   - callback: The ``GitRepositoryMERGEHEADForEachCB`` callback to invoke
///   for each `MERGE_HEAD` entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_mergehead_foreach()`](https://libgit2.org/docs/reference/main/repository/git_repository_mergehead_foreach.html)
public func gitRepositoryMERGEHEADForEach(
    repo        : OpaquePointer,
    callback    : GitRepositoryMERGEHEADForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_mergehead_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Calculates the hash of the specified on-disk file in the given repository.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the calculated ID hash.
///   - repo: The repository containing the specified file. The underlying type
///   must be `git_repository`.
///   - path: The path to the on-disk file to hash. If this is a relative path,
///   it will be considered a path within the working directory.
///   - type: The type of object to hash.
///   - asPath: The path to use to look up filtering rules. Pass an empty
///   string to apply no filters.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: To calculate the hash of an on-disk file without filters, use
/// ``gitODBHashFile(oid:path:objectType:)`` instead.
///
/// ## C Equivalent
///
/// [`git_repository_hashfile()`](https://libgit2.org/docs/reference/main/repository/git_repository_hashfile.html)
public func gitRepositoryHashFile(
    out     : inout GitOID,
    repo    : OpaquePointer,
    path    : String,
    type    : GitObjectT,
    asPath  : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_repository_hashfile(
                cOut,
                repo,
                path,
                type.cValue(),
                asPath
            )
        }
    }
}



/// Sets the HEAD reference of the given repository.
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - refName: The canonical name of the reference to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the specified reference points to a tree or blob, then HEAD will not be
/// updated.
///
/// If the specified reference points to a branch, then HEAD will point to that
/// branch and will stay attached or will become attached, if it was not
/// already attached. If the branch does not exist yet, then HEAD will be
/// attached to an unborn branch.
///
/// If the specified reference points to a commit, HEAD will point to that
/// commit and will be detached.
///
/// ## C Equivalent
///
/// [`git_repository_set_head()`](https://libgit2.org/docs/reference/main/repository/git_repository_set_head.html)
public func gitRepositorySetHEAD(
    repo    : OpaquePointer,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_head(
            repo,
            refName
        )
    }
}



/// Points the HEAD reference of the given repository to the specified commit.
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - committish: The ID of the commit to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the specified committish object cannot be found in the given repository,
/// or cannot be peeled to a commit, then HEAD will not be updated.
///
/// Otherwise, HEAD will point to the specified commit and will be detached.
///
/// ## C Equivalent
///
/// [`git_repository_set_head_detached()`](https://libgit2.org/docs/reference/main/repository/git_repository_set_head_detached.html)
public func gitRepositorySetHEADDetached(
    repo        : OpaquePointer,
    committish  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return committish.withCValue
        {
            cCommittish in
            
            return git_repository_set_head_detached(
                repo,
                cCommittish
            )
        }
    }
}



/// Points the HEAD reference of the given repository to the specified commit.
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - committish: The annotated commit to use. The underlying type must be
///   `git_annotated_commit`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function behaves like
/// ``gitRepositorySetHEADDetached(repo:committish:)``, but takes an
/// annotated commit. This enables more exact reflog messages by being able to
/// specify the extended SHA syntax string which was specified by a user.
///
/// ## C Equivalent
///
/// [`git_repository_set_head_detached_from_annotated()`](https://libgit2.org/docs/reference/main/repository/git_repository_set_head_detached_from_annotated.html)
public func gitRepositorySetHEADDetachedFromAnnotated(
    repo        : OpaquePointer,
    committish  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_head_detached_from_annotated(
            repo,
            committish
        )
    }
}



/// Detaches the HEAD of the given repository.
/// - Parameter repo: The repository to update. The underlying type must be
/// `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If HEAD is already detached and points to a tag, then HEAD will be updated
/// to point to the peeled commit.
///
/// If HEAD is already detached and points to a non-committish object, then
/// HEAD will not be updated.
///
/// Otherwise, HEAD will point to the peeled commit and will be detached.
///
/// ## C Equivalent
///
/// [`git_repository_detach_head()`](https://libgit2.org/docs/reference/main/repository/git_repository_detach_head.html)
public func gitRepositoryDetachHEAD(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_detach_head(repo)
    }
}



/// Gets the state of the given repository.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: The state of the given repository.
///
/// ## C Equivalent
///
/// [`git_repository_state()`](https://libgit2.org/docs/reference/main/repository/git_repository_state.html)
public func gitRepositoryState(
    repo: OpaquePointer
) -> GitRepositoryStateT?
{
    let repositoryState: Int32 = git_repository_state(repo)
    
    if repositoryState < 0
    {
        return nil
    }
    
    return GitRepositoryStateT(rawValue: UInt32(repositoryState))
}



/// Sets the active namespace of the given repository.
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - nmspace: The namespace to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The given namespace must not contain the `refs` directory. For example, to
/// namespace all references under `refs/namespaces/name`, pass only `name`.
///
/// ## C Equivalent
///
/// [`git_repository_set_namespace()`](https://libgit2.org/docs/reference/main/repository/git_repository_set_namespace.html)
public func gitRepositorySetNamespace(
    repo    : OpaquePointer,
    nmspace : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_namespace(
            repo,
            nmspace
        )
    }
}



/// Gets the active namespace of the given repository.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: The active namespace of the given repository.
///
/// ## C Equivalent
///
/// [`git_repository_get_namespace()`](https://libgit2.org/docs/reference/main/repository/git_repository_get_namespace.html)
public func gitRepositoryGetNamespace(
    repo: OpaquePointer
) -> String?
{
    let namespace: UnsafePointer<CChar>? = git_repository_get_namespace(repo)
    
    return String(optionalCString: namespace)
}



/// Checks whether the given repository is a shallow clone.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: Whether the given repository is a shallow clone, or `nil` if
/// there was an error.
///
/// ## C Equivalent
///
/// [`git_repository_is_shallow()`](https://libgit2.org/docs/reference/main/repository/git_repository_is_shallow.html)
public func gitRepositoryIsShallow(
    repo: OpaquePointer
) -> Bool?
{
    let isShallow: Int32 = git_repository_is_shallow(repo)
    
    if
        isShallow != 0,
        isShallow != 1
    {
        return nil
    }
    
    return Bool(isShallow)
}




/// Gets the reflog identity of the given repository.
/// - Parameters:
///   - name: The `String` instance in which to store the name.
///   - email: The `String` instance in which to store the email.
///   - repo: The repository to check. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_ident()`](https://libgit2.org/docs/reference/main/repository/git_repository_ident.html)
public func gitRepositoryIdent(
    name    : inout String?,
    email   : inout String?,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return name.withOptionalMutatingCString
        {
            cName in
            
            return email.withOptionalMutatingCString
            {
                cEmail in
                
                return git_repository_ident(
                    cName,
                    cEmail,
                    repo
                )
            }
        }
    }
}




/// Sets the reflog identity of the given repository.
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - name: The name to use for reflog entries. Pass `nil` to unset the name.
///   - email: The email to use for reflog entries. Pass `nil` to unset the
///   email.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the reflog identity is unset, the identity will be taken from the
/// repository's configuration.
///
/// ## C Equivalent
///
/// [`git_repository_set_ident()`](https://libgit2.org/docs/reference/main/repository/git_repository_set_ident.html)
public func gitRepositorySetIdent(
    repo    : OpaquePointer,
    name    : String?,
    email   : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_ident(
            repo,
            name,
            email
        )
    }
}



/// Gets the type of ID used by the given repository.
/// - Parameter repo: The repository to check. The underlying type must be
/// `git_repository`.
/// - Returns: The type of ID used by the given repository.
///
/// ## C Equivalent
///
/// [`git_repository_oid_type()`](https://libgit2.org/docs/reference/main/repository/git_repository_oid_type.html)
public func gitRepositoryOIDType(
    repo: OpaquePointer
) -> GitOIDT?
{
    let oidType: git_oid_t = git_repository_oid_type(repo)
    
    return GitOIDT(cValue: oidType)
}



/// Gets the parents of the next commit, considering the state of the given
/// repository.
/// - Parameters:
///   - commits: The array of `OpaquePointer` instances in which to store the
///   parents of the next commit. The underlying type of the pointers must be
///   `git_commit`.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The parent of the next commit is generally HEAD, except when performing a
/// merge, in which case the parents are two or more commits.
///
/// ## C Equivalent
///
/// [`git_repository_commit_parents()`](https://libgit2.org/docs/reference/main/repository/git_repository_commit_parents.html)
public func gitRepositoryCommitParents(
    commits : inout [OpaquePointer],
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return commits.withMutatingGitCommitArray
        {
            cCommits in
            
            return git_repository_commit_parents(
                cCommits,
                repo
            )
        }
    }
}
