//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Gets the names of all the worktrees in the given repository.
/// - Parameters:
///   - out: The array of strings in which to store the worktree names.
///   - repo: The repository for which to get the worktree names. The
///   underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_list()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_list.html)
public func gitWorktreeList(
    out     : inout [String],
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitStrArray
        {
            cOut in
            
            return git_worktree_list(
                cOut,
                repo
            )
        }
    }
}



/// Looks up the specified worktree.
/// - Parameters:
///   - out: The pointer in which to store the worktree. The underlying type
///   must be `git_worktree`.
///   - repo: The repository containing the worktree. The underlying type must
///   be `git_repository`.
///   - name: The name of the worktree to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_lookup()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_lookup.html)
public func gitWorktreeLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_lookup(
            out,
            repo,
            name
        )
    }
}



/// Opens a worktree in the given repository.
///
/// If the given repository is a worktree instead of the main tree, this
/// function will look up the worktree inside the parent repository.
///
/// - Parameters:
///   - out: The pointer in which to store the worktree. The underlying type
///   must be `git_worktree`.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_open_from_repository()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_open_from_repository.html)
public func gitWorktreeOpenFromRepository(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_open_from_repository(
            out,
            repo
        )
    }
}



/// Frees the memory allocated for the given `git_worktree` instance.
/// - Parameter wt: The worktree to free. The underlying type must be
/// `git_worktree`.
///
/// ## C Equivalent
///
/// [`git_worktree_free()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_free.html)
public func gitWorktreeFree(
    wt: OpaquePointer?
)
{
    guard let wt
    else
    {
        return
    }
    
    git_worktree_free(wt)
}



/// Validates the given worktree.
///
/// A valid worktree requires both the Git data structures inside the linked
/// parent repository and the linked working directory to be present.
///
/// - Parameter wt: The worktree to validate. The underlying type must be
/// `git_worktree`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_validate()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_validate.html)
public func gitWorktreeValidate(
    wt: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_validate(wt)
    }
}



/// Initializes the given `git_worktree_add_options` instance.
/// - Parameters:
///   - opts: The `git_worktree_add_options` instance to initialize.
///   - version: The version to use. Pass ``gitWorktreeAddOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_add_options_init()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_add_options_init.html)
public func gitWorktreeAddOptionsInit(
    opts    : UnsafeMutablePointer<git_worktree_add_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_add_options_init(
            opts,
            version
        )
    }
}



/// Adds a new worktree to the given repository.
/// - Parameters:
///   - out: The pointer in which to store thte worktree. The underlying type
///   must be `git_worktree`.
///   - repo: The repository to which to add the worktree. The underlying type
///   must be `git_repository`.
///   - name: The worktree name to use.
///   - path: The path to the location at which to create the worktree.
///   - opts: The worktree adding options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_add()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_add.html)
public func gitWorktreeAdd(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String,
    path    : String,
    opts    : GitWorktreeAddOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_worktree_add(
                out,
                repo,
                name,
                path,
                cOpts
            )
        }
    }
}



/// Locks the given worktree.
/// - Parameters:
///   - wt: The worktree to lock. The underlying type must be `git_worktree`.
///   - reason: The reason why the worktree is being locked.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_lock()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_lock.html)
public func gitWorktreeLock(
    wt      : OpaquePointer,
    reason  : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_lock(
            wt,
            reason
        )
    }
}



/// Unlocks the given worktree.
/// - Parameter wt: The worktree to unlock. The underlying type must be
/// `git_worktree`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_unlock()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_unlock.html)
public func gitWorktreeUnlock(
    wt: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_unlock(wt)
    }
}



/// Checks whether the given worktree is locked.
/// - Parameters:
///   - reason: The `String` instance in which to store the reason why the
///   worktree is locked.
///   - wt: The worktree to check. The underlying type must be `git_worktree`.
/// - Returns: Whether the given worktree is locked, or `nil` if there was
/// an error.
///
/// ## C Equivalent
///
/// [`git_worktree_is_locked()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_is_locked.html)
public func gitWorktreeIsLocked(
    reason  : inout String?,
    wt      : OpaquePointer
) -> Bool?
{
    /// This function does not use a default-implemented mutating method,
    /// since those methods use ``isSuccess(_:defaultSuccess:)`` as a
    /// condition for mutating the receiver.
    ///
    /// This function's return value represents a boolean state, where `0`
    /// indicates an unlocked worktree, a positive value indicates a locked
    /// worktree, and a negative value indicates an error.
    ///
    /// Since ``isSuccess(_:defaultSuccess:)`` checks that the result is
    /// ``GitErrorCode/gitOK``, or `0`, this would incorrectly skip mutating
    /// the `reason` parameter when the worktree is locked.
    
    var buffer = git_buf()
    
    defer
    {
        gitBufDispose(buffer: &buffer)
    }
    
    
    
    let worktreeIsLockedResult: Int32 = git_worktree_is_locked(
        &buffer,
        wt
    )
    
    guard worktreeIsLockedResult >= 0
    else
    {
        return nil
    }
    
    reason = String(optionalCString: buffer.ptr)
    
    return Bool(worktreeIsLockedResult)
}



/// Gets the name of the given worktree.
/// - Parameter wt: The worktree for which to get the name. The underlying
/// type must be `git_worktree`.
/// - Returns: The name of the given worktree.
///
/// ## C Equivalent
///
/// [`git_worktree_name()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_name.html)
public func gitWorktreeName(
    wt: OpaquePointer
) -> String?
{
    let worktreeName: UnsafePointer<CChar>? = git_worktree_name(wt)
    
    return String(optionalCString: worktreeName)
}



/// Gets the path of the given worktree.
/// - Parameter wt: The worktree for which to get the path. The underlying
/// type must be `git_worktree`.
/// - Returns: The path of the given worktree.
///
/// ## C Equivalent
///
/// [`git_worktree_path()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_path.html)
public func gitWorktreePath(
    wt: OpaquePointer
) -> String?
{
    let worktreePath: UnsafePointer<CChar>? = git_worktree_path(wt)
    
    return String(optionalCString: worktreePath)
}



/// Initializes the given `git_worktree_prune_options` instance.
/// - Parameters:
///   - opts: The `git_worktree_prune_options` instance to initialize.
///   - version: The version to use. Pass ``gitWorktreePruneOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_prune_options_init()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_prune_options_init.html)
public func gitWorktreePruneOptionsInit(
    opts    : UnsafeMutablePointer<git_worktree_prune_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_worktree_prune_options_init(
            opts,
            version
        )
    }
}



/// Checks whether the given worktree is prunable.
///
/// A worktree is not prunable in the following scenarios:
///
/// - The worktree links to a valid on-disk worktree. Use the
/// ``GitWorktreePruneT/gitWorktreePruneValid`` flag to disable this check.
/// - The worktree is locked. Use the
/// ``GitWorktreePruneT/gitWorktreePruneLocked`` flag to disable this check.
///
/// - Parameters:
///   - wt: The worktree to check. The underlying type must be `git_worktree`.
///   - opts: The worktree pruning options to use.
/// - Returns: Whether the given worktree is prunable, or `nil` if there was
/// an error.
///
/// ## C Equivalent
///
/// [`git_worktree_is_prunable()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_is_prunable.html)
public func gitWorktreeIsPrunable(
    wt      : OpaquePointer,
    opts    : GitWorktreePruneOptions
) -> Bool?
{
    let isPrunableResult: Int32? = try? opts.withCValue
    {
        cOpts in
        
        return git_worktree_is_prunable(
            wt,
            cOpts
        )
    }
    
    guard
        let isPrunableResult,
        isPrunableResult >= 0
    else
    {
        return nil
    }
    
    return Bool(isPrunableResult)
}



/// Prunes the given worktree.
/// - Parameters:
///   - wt: The worktree to prune. The underlying type must be `git_worktree`.
///   - opts: The worktree pruning options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_worktree_prune()`](https://libgit2.org/docs/reference/main/worktree/git_worktree_prune.html)
public func gitWorktreePrune(
    wt      : OpaquePointer,
    opts    : GitWorktreePruneOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_worktree_prune(
                wt,
                cOpts
            )
        }
    }
}
