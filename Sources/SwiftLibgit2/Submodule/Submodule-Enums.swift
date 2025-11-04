//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags representing the status of a submodule.
///
/// Submodule information is contained in the HEAD tree, the index, the
/// configuration files (both `/git/config` and `.gitmodules`), and the
/// working directory. All of these are considered when determining the status
/// of a submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_status_t`](https://libgit2.org/docs/reference/main/submodule/git_submodule_status_t.html)
public struct GitSubmoduleStatusT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitSubmoduleStatusT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitSubmoduleStatusT`` instance from the given
    /// `git_submodule_status_t` instance.
    /// - Parameter submoduleStatus: The `git_submodule_status_t` instance
    /// to use.
    internal init(
        cValue submoduleStatus: git_submodule_status_t
    )
    {
        self.rawValue = submoduleStatus.rawValue
    }
    
    
    
    /// The superproject HEAD contains the submodule.
    public static let gitSubmoduleStatusInHEAD              = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_IN_HEAD.rawValue)
    
    /// The superproject index contains the submodule.
    public static let gitSubmoduleStatusInIndex             = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_IN_INDEX.rawValue)
    
    /// The superproject `.gitmodules` contains the submodule.
    public static let gitSubmoduleStatusInConfig            = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_IN_CONFIG.rawValue)
    
    /// The superproject working directory contains the submodule.
    public static let gitSubmoduleStatusInWD                = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_IN_WD.rawValue)
    
    /// The submodule is in the superproject index, but not in HEAD.
    public static let gitSubmoduleStatusIndexAdded          = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_INDEX_ADDED.rawValue)
    
    /// The submodule is in the superproject HEAD, but not in the index.
    public static let gitSubmoduleStatusIndexDeleted        = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_INDEX_DELETED.rawValue)
    
    /// The submodule entry in the superproject index and HEAD do not match.
    public static let gitSubmoduleStatusIndexModified       = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_INDEX_MODIFIED.rawValue)
    
    /// The submodule working directory contains an empty directory.
    public static let gitSubmoduleStatusWDUninitialized     = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_UNINITIALIZED.rawValue)
    
    /// The submodule is in the superproject working directory, but not in
    /// the index.
    public static let gitSubmoduleStatusWDAdded             = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_ADDED.rawValue)
    
    /// The submodule is in the superproject index, but not in the working
    /// directory.
    public static let gitSubmoduleStatusWDDeleted           = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_DELETED.rawValue)
    
    /// The submodule entry in the superproject index and working directory
    /// do not match.
    public static let gitSubmoduleStatusWDModified          = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_MODIFIED.rawValue)
    
    /// The submodule working directory index is dirty.
    public static let gitSubmoduleStatusWDIndexModified     = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED.rawValue)
    
    /// The submodule working directory contains modified files.
    public static let gitSubmoduleStatusWDWDModified        = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_WD_MODIFIED.rawValue)
    
    /// The submodule working directory contains untracked files.
    public static let gitSubmoduleStatusWDUntracked         = GitSubmoduleStatusT(rawValue: GIT_SUBMODULE_STATUS_WD_UNTRACKED.rawValue)
    
    
    
    /// Converts the ``GitSubmoduleStatusT`` instance into a
    /// `git_submodule_status_t` instance.
    /// - Returns: The `git_submodule_status_t` instance.
    internal func cValue() -> git_submodule_status_t
    {
        return git_submodule_status_t(rawValue)
    }
}



/// Submodule update rules.
///
/// These cases represent the value of the `submodule.<name>.update`
/// configuration variable, which determines how to handle updating the
/// specified submodule.
///
/// The value is usually set in the `.gitmodules` file and copied to
/// `.git/config` when the submodule is initialized. Use
/// ``gitSubmoduleSetUpdate(repo:name:ignore:)`` to override the value on a
/// per-submodule basis.
///
/// ## C Equivalent
///
/// [`git_submodule_update_t`](https://libgit2.org/docs/reference/main/submodule/git_submodule_update_t.html)
public enum GitSubmoduleUpdateT: UInt32, CEnum
{
    /// When a submodule is updated, checkout the new detached HEAD to the
    /// submodule directory.
    case gitSubmoduleUpdateCheckout     = 1
    
    /// Update by rebasing the current checked out branch onto the commit
    /// from the superproject.
    case gitSubmoduleUpdateRebase       = 2
    
    /// Update by merging the commit in the superproject into the current
    /// checked out branch of the submodule.
    case gitSubmoduleUpdateMerge        = 3
    
    /// Do not update the submodule, even when the commit in the superproject
    /// is updated.
    case gitSubmoduleUpdateNone         = 4
    
    /// A sentinel value for internal use.
    case gitSubmoduleUpdateDefault      = 0
    
    
    
    /// Initializes a ``GitSubmoduleUpdateT`` instance from the given
    /// `git_submodule_update_t` instance.
    /// - Parameter submoduleUpdate: The `git_submodule_update_t`
    /// instance to use.
    internal init?(
        cValue submoduleUpdate: git_submodule_update_t
    )
    {
        switch submoduleUpdate
        {
            case GIT_SUBMODULE_UPDATE_CHECKOUT  : self = .gitSubmoduleUpdateCheckout
            case GIT_SUBMODULE_UPDATE_REBASE    : self = .gitSubmoduleUpdateRebase
            case GIT_SUBMODULE_UPDATE_MERGE     : self = .gitSubmoduleUpdateMerge
            case GIT_SUBMODULE_UPDATE_NONE      : self = .gitSubmoduleUpdateNone
            case GIT_SUBMODULE_UPDATE_DEFAULT   : self = .gitSubmoduleUpdateDefault
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitSubmoduleUpdateT`` instance into a
    /// `git_submodule_update_t` instance.
    /// - Returns: The `git_submodule_update_t` instance.
    internal func cValue() -> git_submodule_update_t
    {
        switch self
        {
            case .gitSubmoduleUpdateCheckout    : return GIT_SUBMODULE_UPDATE_CHECKOUT
            case .gitSubmoduleUpdateRebase      : return GIT_SUBMODULE_UPDATE_REBASE
            case .gitSubmoduleUpdateMerge       : return GIT_SUBMODULE_UPDATE_MERGE
            case .gitSubmoduleUpdateNone        : return GIT_SUBMODULE_UPDATE_NONE
            case .gitSubmoduleUpdateDefault     : return GIT_SUBMODULE_UPDATE_DEFAULT
        }
    }
}



/// Submodule ignore rules.
///
/// These cases represent the value of the `submodule.<name>.ignore`
/// configuration variable, which determines how deeply to look at the working
/// directory when determining the submodule status.
///
/// Use ``gitSubmoduleSetIgnore(repo:name:ignore:)`` to override the value on
/// a per-submodule basis.
///
/// ## C Equivalent
///
/// [`git_submodule_ignore_t`](https://libgit2.org/docs/reference/main/submodule/git_submodule_ignore_t.html)
public enum GitSubmoduleIgnoreT: Int32, CEnum
{
    /// Use the submodule's configuration.
    case gitSubmoduleIgnoreUnspecified  = -1
    
    /// Do not ignore any change or untacked file.
    case gitSubmoduleIgnoreNone         = 1
    
    /// Only consider changes to tracked files, the index, or the HEAD commit.
    case gitSubmoduleIgnoreUntracked    = 2
    
    /// Ignore changes in the working directory, and only consider changes if
    /// the HEAD of the submodule has moved from the value in the superproject.
    case gitSubmoduleIgnoreDirty        = 3
    
    /// Never check if the submodule is dirty.
    case gitSubmoduleIgnoreAll          = 4
    
    
    
    /// Initializes a ``GitSubmoduleIgnoreT`` instance from the given
    /// `git_submodule_ignore_t` instance.
    /// - Parameter submoduleIgnore: The `git_submodule_ignore_t` instance
    /// to use.
    internal init?(
        cValue submoduleIgnore: git_submodule_ignore_t
    )
    {
        switch submoduleIgnore
        {
            case GIT_SUBMODULE_IGNORE_UNSPECIFIED   : self = .gitSubmoduleIgnoreUnspecified
            case GIT_SUBMODULE_IGNORE_NONE          : self = .gitSubmoduleIgnoreNone
            case GIT_SUBMODULE_IGNORE_UNTRACKED     : self = .gitSubmoduleIgnoreUntracked
            case GIT_SUBMODULE_IGNORE_DIRTY         : self = .gitSubmoduleIgnoreDirty
            case GIT_SUBMODULE_IGNORE_ALL           : self = .gitSubmoduleIgnoreAll
            default                                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitSubmoduleIgnoreT`` instance into a
    /// `git_submodule_ignore_t` instance.
    /// - Returns: The `git_submodule_ignore_t` instance.
    internal func cValue() -> git_submodule_ignore_t
    {
        switch self
        {
            case .gitSubmoduleIgnoreUnspecified : return GIT_SUBMODULE_IGNORE_UNSPECIFIED
            case .gitSubmoduleIgnoreNone        : return GIT_SUBMODULE_IGNORE_NONE
            case .gitSubmoduleIgnoreUntracked   : return GIT_SUBMODULE_IGNORE_UNTRACKED
            case .gitSubmoduleIgnoreDirty       : return GIT_SUBMODULE_IGNORE_DIRTY
            case .gitSubmoduleIgnoreAll         : return GIT_SUBMODULE_IGNORE_ALL
        }
    }
}



/// Submodule recursion rules.
///
/// These flags represent the value of the
/// `submodule.<name>.fetchRecurseSubmodules` configuration variable.
///
/// ## C Equivalent
///
/// [`git_submodule_recurse_t`](https://libgit2.org/docs/reference/main/submodule/git_submodule_recurse_t.html)
public enum GitSubmoduleRecurseT: UInt32, CEnum
{
    /// Do not recurse into submodules.
    case gitSubmoduleRecurseNo          = 0
    
    /// Recurse into submodules.
    case gitSubmoduleRecurseYes         = 1
    
    /// Only recurse into submodules when the commit is not already in the
    /// local clone.
    case gitSubmoduleRecurseOnDemand    = 2
    
    
    
    /// Initializes a ``GitSubmoduleRecurseT`` instance from the given
    /// `git_submodule_recurse_t` instance.
    /// - Parameter submoduleRecurse: The `git_submodule_recurse_t` instance
    /// to use.
    internal init?(
        cValue submoduleRecurse: git_submodule_recurse_t
    )
    {
        switch submoduleRecurse
        {
            case GIT_SUBMODULE_RECURSE_NO       : self = .gitSubmoduleRecurseNo
            case GIT_SUBMODULE_RECURSE_YES      : self = .gitSubmoduleRecurseYes
            case GIT_SUBMODULE_RECURSE_ONDEMAND : self = .gitSubmoduleRecurseOnDemand
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitSubmoduleRecurseT`` instance into a
    /// `git_submodule_recurse_t` instance.
    /// - Returns: The `git_submodule_recurse_t` instance.
    internal func cValue() -> git_submodule_recurse_t
    {
        switch self
        {
            case .gitSubmoduleRecurseNo         : return GIT_SUBMODULE_RECURSE_NO
            case .gitSubmoduleRecurseYes        : return GIT_SUBMODULE_RECURSE_YES
            case .gitSubmoduleRecurseOnDemand   : return GIT_SUBMODULE_RECURSE_ONDEMAND
        }
    }
}
