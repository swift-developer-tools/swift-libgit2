//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The filtering direction.
///
/// ## C Equivalent
///
/// [`git_filter_mode_t`](https://libgit2.org/docs/reference/main/filter/git_filter_mode_t.html)
public enum GitFilterModeT: UInt32, GitEnum
{
    /// Filters are applied when exporting a file from the object database to the working directory
    /// (smudging).
    ///
    /// ## Discussion
    ///
    /// This is equivalent to both `GIT_FILTER_TO_WORKTREE` and `GIT_FILTER_SMUDGE`.
    case gitFilterToWorktree    = 0
    
    /// Filters are applied when importing a file from the working directory to the object database
    /// (cleaning).
    ///
    /// ## Discussion
    ///
    /// This is equivalent to both `GIT_FILTER_TO_ODB` and `GIT_FILTER_CLEAN`.
    case gitFilterToODB         = 1
    
    
    
    /// Creates a ``GitFilterModeT`` instance from a `git_filter_mode_t` instance.
    /// - Parameter filterMode: The `git_filter_mode_t` instance to use.
    internal init?(
        cValue filterMode: git_filter_mode_t
    )
    {
        switch filterMode
        {
            case GIT_FILTER_TO_WORKTREE : self = .gitFilterToWorktree
            case GIT_FILTER_SMUDGE      : self = .gitFilterToWorktree
            case GIT_FILTER_TO_ODB      : self = .gitFilterToODB
            case GIT_FILTER_CLEAN       : self = .gitFilterToODB
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitFilterModeT`` instance into a `git_filter_mode_t` instance.
    /// - Returns: The `git_filter_mode_t` instance.
    internal func cValue() -> git_filter_mode_t
    {
        switch self
        {
            case .gitFilterToWorktree   : return GIT_FILTER_TO_WORKTREE
            case .gitFilterToODB        : return GIT_FILTER_TO_ODB
        }
    }
}



/// The flags controlling the filtering process.
///
/// ## C Equivalent
///
/// [`git_filter_flag_t`](https://libgit2.org/docs/reference/main/filter/git_filter_flag_t.html)
public struct GitFilterFlagT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitFilterFlagT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Use the default filtering behavior.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    public static let gitFilterDefault                  = GitFilterFlagT(rawValue: GIT_FILTER_DEFAULT.rawValue)
    
    /// Allow `safecrlf` violations to continue.
    public static let gitFilterAllowUnsafe              = GitFilterFlagT(rawValue: GIT_FILTER_ALLOW_UNSAFE.rawValue)
    
    /// Do not load `/etc/gitattributes` (or the system equivalent).
    public static let gitFilterNoSystemAttributes       = GitFilterFlagT(rawValue: GIT_FILTER_NO_SYSTEM_ATTRIBUTES.rawValue)
    
    /// Load attributes from `.gitattributes` in the root of HEAD.
    public static let gitFilterAttributesFromHEAD       = GitFilterFlagT(rawValue: GIT_FILTER_ATTRIBUTES_FROM_HEAD.rawValue)
    
    /// Load attributes from `.gitattributes` in a given commit.
    ///
    /// ## Discussion
    ///
    /// - Note: This flag may only be used as part of ``GitFilterOptions``.
    public static let gitFilterAttributesFromCommit     = GitFilterFlagT(rawValue: GIT_FILTER_ATTRIBUTES_FROM_COMMIT.rawValue)
    
    
    
    /// Converts the ``GitFilterFlagT`` instance into a `git_filter_flag_t` instance.
    /// - Returns: The `git_filter_flag_t` instance.
    internal func cValue() -> git_filter_flag_t
    {
        return git_filter_flag_t(rawValue)
    }
}
