//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



// TODO: Replace `git_repository_set_head()` in documentation.

/// The flags controlling the behavior of the checkout operation.
///
/// ## Discussion
///
/// In libgit2, checkout is used to update the working directory and index to match a target tree.
/// Unlike `git checkout`, it does not move the HEAD commit - use
/// `git_repository_set_head()` or a similar function for that purpose.
///
/// The checkout operation considers the following:
/// - The target tree to be checked out.
/// - The baseline tree of what was previously checked out.
/// - The working directory for actual files.
/// - The index for staged changes.
///
/// The caller provides one of two strategies for updating during the checkout operation:
/// - ``gitCheckoutSafe``: This is the default value, similar to Git's default, which will make
/// modifications that will not lose changes in the working directory.
/// - ``gitCheckoutForce``: This will take any action to make the working directory match the
/// target, including potentially discarding modified files.
///
/// To emulate `git checkout`, use ``gitCheckoutSafe`` with ``GitCheckoutNotifyCB``
/// to display information about dirty files. The default behavior will cancel the checkout when
/// conflicts occur.
///
/// To emulate `git checkout-index`, use ``gitCheckoutSafe`` with
/// ``GitCheckoutNotifyCB`` to cancel the operation if a dirty-but-existing file is found in the
/// working directory. This core Git command is not the same as forcing the changes, but is sensitive
/// about some types of changes.
///
/// To emulate `git checkout -f`, use ``gitCheckoutForce``.
///
/// ## C Equivalent
///
/// [`git_checkout_strategy_t`](https://libgit2.org/docs/reference/main/checkout/git_checkout_strategy_t.html)
public struct GitCheckoutStrategyT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitCheckoutStrategyT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Allow safe updates that cannot overwrite uncommitted data.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    ///
    /// If the uncommitted changes do not conflict with the checked out files, then the checkout will
    /// still proceed, leaving the changes intact.
    public static let gitCheckoutSafe                       = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_SAFE.rawValue)
    
    /// Allow all updates to force the working directory to look like the index, potentially losing data
    /// in the process.
    public static let gitCheckoutForce                      = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_FORCE.rawValue)
    
    /// Allow the checkout to recreate missing files.
    public static let gitCheckoutRecreateMissing            = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_RECREATE_MISSING.rawValue)
    
    /// Allow the checkout to make safe updates even if there are conflicts, instead of canceling the
    /// checkout operation.
    public static let gitCheckoutAllowConflicts             = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_ALLOW_CONFLICTS.rawValue)
    
    /// Remove untracked files that are not in the index (and are not ignored).
    public static let gitCheckoutRemoveUntracked            = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_REMOVE_UNTRACKED.rawValue)
    
    /// Remove ignored files that are not in the index.
    public static let gitCheckoutRemoveIgnored              = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_REMOVE_IGNORED.rawValue)
    
    /// Only updated existing files, but do not create new files.
    ///
    /// ## Discussion
    ///
    /// This will only update the content of files that already exist. Files will neither be created
    /// nor deleted. Adds, deletes, and type-changes will all be skipped.
    public static let gitCheckoutUpdateOnly                 = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_UPDATE_ONLY.rawValue)
    
    /// Do not update index entries as the checkout proceeds.
    ///
    /// ## Discussion
    ///
    /// This implies ``gitCheckoutDontWriteIndex``.
    public static let gitCheckoutDontUpdateIndex            = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_DONT_UPDATE_INDEX.rawValue)
    
    /// Do not refresh the index, config, etc. before the checkout.
    public static let gitCheckoutNoRefresh                  = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_NO_REFRESH.rawValue)
    
    /// Allow the checkout to skip unmerged files.
    public static let gitCheckoutSkipUnmerged               = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_SKIP_UNMERGED.rawValue)
    
    /// Checkout stage 2 from the index for unmerged files.
    public static let gitCheckoutUseOurs                    = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_USE_OURS.rawValue)
    
    /// Checkout stage 3 from the index for unmerged files.
    public static let gitCheckoutUseTheirs                  = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_USE_THEIRS.rawValue)
    
    /// Treat the pathspec as a simple list of exact-match file patterns.
    public static let gitCheckoutDisablePathspecMatch       = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH.rawValue)
    
    /// Ignore directories that are in use.
    ///
    /// ## Discussion
    ///
    /// The ignored directories will be left empty.
    public static let gitCheckoutSkipLockedDirectories      = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES.rawValue)
    
    /// Do not overwrite ignored files that exist in the checkout target.
    public static let gitCheckoutDontOverwriteIgnored       = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_DONT_OVERWRITE_IGNORED.rawValue)
    
    /// Write normal merge files for conflicts.
    public static let gitCheckoutConflictStyleMerge         = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_CONFLICT_STYLE_MERGE.rawValue)
    
    /// Include common ancestor data in `diff3` format files for conflicts.
    public static let gitCheckoutConflictStyleDiff3         = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_CONFLICT_STYLE_DIFF3.rawValue)
    
    /// Do not overwrite existing files or folders.
    ///
    /// ## Discussion
    ///
    /// This prevents the checkout operation from removing files or folders that fold to the same name
    /// on case-insensitive file systems. This may cause files to retain their existing names and write
    /// through existing symbolic links.
    public static let gitCheckoutDontRemoveExisting         = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_DONT_REMOVE_EXISTING.rawValue)
    
    /// Do not write the index upon completion.
    public static let gitCheckoutDontWriteIndex             = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_DONT_WRITE_INDEX.rawValue)
    
    /// Perform a dry run, reporting what would have been done, but without actually making changes
    /// in the working directory or in the index.
    public static let gitCheckoutDryRun                     = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_DRY_RUN.rawValue)
    
    /// Include common ancestor data in `zdiff3` format files for conflicts.
    public static let gitCheckoutConflictStyleZDiff3        = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_CONFLICT_STYLE_ZDIFF3.rawValue)
    
    // TODO: Replace `git_clone()` in documentation.
    /// Do not perform the checkout and do not fire callbacks.
    ///
    /// ## Discussion
    ///
    /// This is primarily useful only for internal functions that will perform the checkout themselves,
    /// but need to pass checkout options into another function, like `git_clone()`.
    public static let gitCheckoutNone                       = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_NONE.rawValue)
    
    /// Recursively checkout submodules with the same options.
    ///
    /// ## Discussion
    ///
    /// - Note: This has not yet been implemented, but is reserved for future use.
    public static let gitCheckoutUpdateSubmodules           = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_UPDATE_SUBMODULES.rawValue)
    
    /// Recursively checkout submodules with the same options, if HEAD moved in the super repository.
    ///
    /// ## Discussion
    ///
    /// - Note: This has not yet been implemented, but is reserved for future use.
    public static let gitCheckoutUpdateSubmodulesIfChanged  = GitCheckoutStrategyT(rawValue: GIT_CHECKOUT_UPDATE_SUBMODULES_IF_CHANGED.rawValue)
    
    
    
    /// Converts the ``GitCheckoutStrategyT`` instance into a `git_checkout_strategy_t`
    /// instance.
    /// - Returns: The `git_checkout_strategy_t` instance.
    internal func cValue() -> git_checkout_strategy_t
    {
        return git_checkout_strategy_t(rawValue)
    }
}



/// The flags controlling the behavior of checkout notifications.
///
/// ## Discussion
///
/// The checkout operation will invoke a checkout notification callback for certain cases specified
/// by the given flags.
///
/// Returning a non-zero value from this callback will cancel the checkout. The non-zero return value
/// will be propagated back and returned by the origin checkout caller.
///
/// Notification callbacks are made prior to modifying any files on disk, so canceling on any notification
/// will still happen prior to any files being modified.
///
/// ## C Equivalent
///
/// [`git_checkout_notify_t`](https://libgit2.org/docs/reference/main/checkout/git_checkout_notify_t.html)
public struct GitCheckoutNotifyT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitCheckoutNotifyT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Do not send notifications.
    public static let gitCheckoutNotifyNone         = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_NONE.rawValue)
    
    /// Send notifications for conflicting paths.
    public static let gitCheckoutNotifyConflict     = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_CONFLICT.rawValue)
    
    /// Send notifications for dirty files.
    ///
    /// ## Discussion
    ///
    /// This notifies about files with uncommitted changes that would be overwritten by the checkout
    /// operation. Core Git displays these files when the checkout operation runs, but will not stop the
    /// operation.
    public static let gitCheckoutNotifyDirty        = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_DIRTY.rawValue)
    
    /// Send notifications for any changed file.
    public static let gitCheckoutNotifyUpdated      = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_UPDATED.rawValue)
    
    /// Send notifications for any untracked file.
    public static let gitCheckoutNotifyUntracked    = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_UNTRACKED.rawValue)
    
    /// Send notifications for any ignored file.
    public static let gitCheckoutNotifyIgnored      = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_IGNORED.rawValue)
    
    /// Send notifications for any file.
    public static let gitCheckoutNotifyAll          = GitCheckoutNotifyT(rawValue: GIT_CHECKOUT_NOTIFY_ALL.rawValue)
    
    
    
    /// Converts the ``GitCheckoutNotifyT`` instance into a `git_checkout_notify_t`
    /// instance.
    /// - Returns: The `git_checkout_notify_t` instance.
    internal func cValue() -> git_checkout_notify_t
    {
        return git_checkout_notify_t(rawValue)
    }
}
