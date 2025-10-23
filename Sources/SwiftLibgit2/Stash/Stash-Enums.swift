//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling stash saving.
///
/// ## C Equivalent
///
/// [`git_stash_flags`](https://libgit2.org/docs/reference/main/stash/git_stash_flags.html)
public struct GitStashFlags: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitStashFlags`` instance from the given raw
    /// value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitStashFlags`` instance from the given
    /// `git_stash_flags` instance.
    /// - Parameter stashFlags: The `git_stash_flags` instance to use.
    internal init(
        cValue stashFlags: git_stash_flags
    )
    {
        self.rawValue = stashFlags.rawValue
    }
    
    
    
    /// Perform a default stash.
    public static let gitStashDefault           = GitStashFlags(rawValue: GIT_STASH_DEFAULT.rawValue)
    
    /// All changes already added to the index should be left intact in
    /// the working directory.
    public static let gitStashKeepIndex         = GitStashFlags(rawValue: GIT_STASH_KEEP_INDEX.rawValue)
    
    /// All untracked files should be stashed and then cleaned up from
    /// the working directory.
    public static let gitStashIncludeUntracked  = GitStashFlags(rawValue: GIT_STASH_INCLUDE_UNTRACKED.rawValue)
    
    /// All ignored files should be stashed and then cleaned up from the
    /// working directory.
    public static let gitStashIncludeIgnored    = GitStashFlags(rawValue: GIT_STASH_INCLUDE_IGNORED.rawValue)
    
    /// All changes in the index and working directory should be left intact.
    public static let gitStashKeepAll           = GitStashFlags(rawValue: GIT_STASH_KEEP_ALL.rawValue)
    
    
    
    /// Converts the ``GitStashFlags`` instance into a `git_stash_flags`
    /// instance.
    /// - Returns: The `git_stash_flags` instance.
    internal func cValue() -> git_stash_flags
    {
        return git_stash_flags(rawValue)
    }
}



/// The type of stash application.
///
/// ## C Equivalent
///
/// [`git_stash_apply_flags`](https://libgit2.org/docs/reference/main/stash/git_stash_apply_flags.html)
public enum GitStashApplyFlags: UInt32, CEnum
{
    /// Perform a default stash application.
    case gitStashApplyDefault           = 0
    
    /// Reinistate the index.
    case gitStashApplyReinstateIndex    = 1
    
    
    
    /// Initializes a ``GitStashApplyFlags`` instance from the given
    /// `git_stash_apply_flags` instance.
    /// - Parameter stashApplyFlags: The `git_stash_apply_flags` instance
    /// to use.
    internal init?(
        cValue stashApplyFlags: git_stash_apply_flags
    )
    {
        switch stashApplyFlags
        {
            case GIT_STASH_APPLY_DEFAULT            : self = .gitStashApplyDefault
            case GIT_STASH_APPLY_REINSTATE_INDEX    : self = .gitStashApplyReinstateIndex
            default                                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitStashApplyFlags`` instance into a
    /// `git_stash_apply_flags` instance.
    /// - Returns: The `git_stash_apply_flags` instance.
    internal func cValue() -> git_stash_apply_flags
    {
        switch self
        {
            case .gitStashApplyDefault          : return GIT_STASH_APPLY_DEFAULT
            case .gitStashApplyReinstateIndex   : return GIT_STASH_APPLY_REINSTATE_INDEX
        }
    }
}



/// The state of stash application.
///
/// ## C Equivalent
///
/// [`git_stash_apply_progress_t`](https://libgit2.org/docs/reference/main/stash/git_stash_apply_progress_t.html)
public enum GitStashApplyProgressT: UInt32, CEnum
{
    /// No progress has been made.
    case gitStashApplyProgressNone                  = 0
    
    /// The stashed data is being loaded from the object database.
    case gitStashApplyProgressLoadingStash          = 1
    
    /// The stored index is being analyzed.
    case gitStashApplyProgressAnalyzeIndex          = 2
    
    /// The modified files are being analyzed.
    case gitStashApplyProgressAnalyzeModified       = 3
    
    /// The untracked and ignored files are being analyzed.
    case gitStashApplyProgressAnalyzeUntracked      = 4
    
    /// The untracked files are being written to the disk.
    case gitStashApplyProgressCheckoutUntracked     = 5
    
    /// The modified files are being written to the disk.
    case gitStashApplyProgressCheckoutModified      = 6
    
    /// The stash has been successfully applied.
    case gitStashApplyProgressDone                  = 7
    
    
    
    /// Initializes a ``GitStashApplyProgressT`` instance from the given
    /// `git_stash_apply_progress_t` instance.
    /// - Parameter stashApplyProgress: The `git_stash_apply_progress_t`
    /// instance to use.
    internal init?(
        cValue stashApplyProgress: git_stash_apply_progress_t
    )
    {
        switch stashApplyProgress
        {
            case GIT_STASH_APPLY_PROGRESS_NONE                  : self = .gitStashApplyProgressNone
            case GIT_STASH_APPLY_PROGRESS_LOADING_STASH         : self = .gitStashApplyProgressLoadingStash
            case GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX         : self = .gitStashApplyProgressAnalyzeIndex
            case GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED      : self = .gitStashApplyProgressAnalyzeModified
            case GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED     : self = .gitStashApplyProgressAnalyzeUntracked
            case GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED    : self = .gitStashApplyProgressCheckoutUntracked
            case GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED     : self = .gitStashApplyProgressCheckoutModified
            case GIT_STASH_APPLY_PROGRESS_DONE                  : self = .gitStashApplyProgressDone
            default                                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitStashApplyProgressT`` instance into a
    /// `git_stash_apply_progress_t` instance.
    /// - Returns: The `git_stash_apply_progress_t` instance.
    internal func cValue() -> git_stash_apply_progress_t
    {
        switch self
        {
            case .gitStashApplyProgressNone                 : return GIT_STASH_APPLY_PROGRESS_NONE
            case .gitStashApplyProgressLoadingStash         : return GIT_STASH_APPLY_PROGRESS_LOADING_STASH
            case .gitStashApplyProgressAnalyzeIndex         : return GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX
            case .gitStashApplyProgressAnalyzeModified      : return GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED
            case .gitStashApplyProgressAnalyzeUntracked     : return GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED
            case .gitStashApplyProgressCheckoutUntracked    : return GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED
            case .gitStashApplyProgressCheckoutModified     : return GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED
            case .gitStashApplyProgressDone                 : return GIT_STASH_APPLY_PROGRESS_DONE
        }
    }
}
