//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Saves local changes in the given repository to a new stash.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the stash.
///   - repo: The repository containing the changes. The underlying type must
///   be `git_repository`.
///   - stasher: The actor signature to use.
///   - message: The stash message to use.
///   - flags: The stash flags to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_save()`](https://libgit2.org/docs/reference/main/stash/git_stash_save.html)
public func gitStashSave(
    out     : inout GitOID,
    repo    : OpaquePointer,
    stasher : GitSignature,
    message : String?,
    flags   : GitStashFlags
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try stasher.withCValue
            {
                cStasher in
                
                return git_stash_save(
                    cOut,
                    repo,
                    cStasher,
                    message,
                    flags.rawValue
                )
            }
        }
    }
}



/// Initializes the given `git_stash_save_options` instance.
/// - Parameters:
///   - opts: The `git_stash_save_options` instance to initialize.
///   - version: The version to use. Pass ``gitStashSaveOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_save_options_init()`](https://libgit2.org/docs/reference/main/stash/git_stash_save_options_init.html)
public func gitStashSaveOptionsInit(
    opts    : UnsafeMutablePointer<git_stash_save_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stash_save_options_init(
            opts,
            version
        )
    }
}



/// Saves local changes in the given repository to a new stash.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the stash.
///   - repo: The repository containing the changes. The underlying type must
///   be `git_repository`.
///   - opts: The stash saving options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_save_with_opts()`](https://libgit2.org/docs/reference/main/stash/git_stash_save_with_opts.html)
public func gitStashSaveWithOpts(
    out     : inout GitOID,
    repo    : OpaquePointer,
    opts    : GitStashSaveOptions
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try opts.withCValue
            {
                cOpts in
                
                return git_stash_save_with_opts(
                    cOut,
                    repo,
                    cOpts
                )
            }
        }
    }
}



/// Initializes the given `git_stash_apply_options` instance.
/// - Parameters:
///   - opts: The `git_stash_apply_options` instance to initialize.
///   - version: The version to use. Pass ``gitStashApplyOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_apply_options_init()`](https://libgit2.org/docs/reference/main/stash/git_stash_apply_options_init.html)
public func gitStashApplyOptionsInit(
    opts    : UnsafeMutablePointer<git_stash_apply_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stash_apply_options_init(
            opts,
            version
        )
    }
}



/// Applies the specified stashed state from the stash list of the given
/// repository.
/// - Parameters:
///   - repo: The repository containing the stash. The underlying type must
///   be `git_repository`.
///   - index: The index of the stashed state to apply.
///   - options: The stash apply options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If local changes in the working directory conflict with changes in the
/// stash, the index and working directory will remain unmodified. However,
/// if untracked or ignored files are being restored, and there is a conflict
/// when applying the modified files, then those files will remain in the
/// working directory.
///
/// If the ``GitStashApplyOptions/flags`` property specifies
/// ``GitStashApplyFlags/gitStashApplyReinstateIndex``, but reinstating the
/// index would cause conflicts, then the index and working directory will
/// remain unmodified.
///
/// ## C Equivalent
///
/// [`git_stash_apply()`](https://libgit2.org/docs/reference/main/stash/git_stash_apply.html)
public func gitStashApply(
    repo    : OpaquePointer,
    index   : Int,
    options : GitStashApplyOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_stash_apply(
                repo,
                index,
                cOptions
            )
        }
    }
}



/// Loops over all the stashed states in the given repository.
/// - Parameters:
///   - repo: The repository containing the stash. The underlying type must
///   be `git_repository`.
///   - callback: The ``GitStashCB`` callback to invoke for each stashed state.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_foreach()`](https://libgit2.org/docs/reference/main/stash/git_stash_foreach.html)
public func gitStashForEach(
    repo        : OpaquePointer,
    callback    : GitStashCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stash_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Removes the specified stashed state from the stash list of the given
/// repository.
/// - Parameters:
///   - repo: The repository containing the stash. The underlying type must
///   be `git_repository`.
///   - index: The index of the stashed state to drop.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_drop()`](https://libgit2.org/docs/reference/main/stash/git_stash_drop.html)
public func gitStashDrop(
    repo    : OpaquePointer,
    index   : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stash_drop(
            repo,
            index
        )
    }
}



/// Applies and then removes the specified stashed state from the stash list of
/// the given repository.
/// - Parameters:
///   - repo: The repository containing the stash. The underlying type must
///   be `git_repository`.
///   - index: The index of the stashed state to apply and then remove.
///   - options: The stash apply options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stash_pop()`](https://libgit2.org/docs/reference/main/stash/git_stash_pop.html)
public func gitStashPop(
    repo    : OpaquePointer,
    index   : Int,
    options : GitStashApplyOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_stash_pop(
                repo,
                index,
                cOptions
            )
        }
    }
}
