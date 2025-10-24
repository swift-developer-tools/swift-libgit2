//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags representing the status of a file.
///
/// ## Discussion
///
/// These flags represent the status of the file after comparing the working
/// directory, the index, and HEAD. The index flags represent the status of the
/// file in the index relative to HEAD. The working directory flags represent
/// the status of the file in the working directory relative to the index.
///
/// ## C Equivalent
///
/// [`git_status_t`](https://libgit2.org/docs/reference/main/status/git_status_t.html)
public struct GitStatusT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitStatusT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitStatusT`` instance from the given `git_status_t`
    /// instance.
    /// - Parameter status: The `git_status_t` instance to use.
    internal init(
        cValue status: git_status_t
    )
    {
        self.rawValue = status.rawValue
    }
    
    
    
    /// The file is current.
    public static let gitStatusCurrent          = GitStatusT(rawValue: GIT_STATUS_CURRENT.rawValue)
    
    /// The file is new in the index.
    public static let gitStatusIndexNew         = GitStatusT(rawValue: GIT_STATUS_INDEX_NEW.rawValue)
    
    /// The file is modified in the index.
    public static let gitStatusIndexModified    = GitStatusT(rawValue: GIT_STATUS_INDEX_MODIFIED.rawValue)
    
    /// The file is deleted in the index.
    public static let gitStatusIndexDeleted     = GitStatusT(rawValue: GIT_STATUS_INDEX_DELETED.rawValue)
    
    /// The file is renamed in the index.
    public static let gitStatusIndexRenamed     = GitStatusT(rawValue: GIT_STATUS_INDEX_RENAMED.rawValue)
    
    /// The file's type has changed in the index.
    public static let gitStatusIndexTypeChange  = GitStatusT(rawValue: GIT_STATUS_INDEX_TYPECHANGE.rawValue)
    
    /// The file is new in the working directory.
    public static let gitStatusWTNew            = GitStatusT(rawValue: GIT_STATUS_WT_NEW.rawValue)
    
    /// The file is modified in the working directory.
    public static let gitStatusWTModified       = GitStatusT(rawValue: GIT_STATUS_WT_MODIFIED.rawValue)
    
    /// The file is deleted in the working directory.
    public static let gitStatusWTDeleted        = GitStatusT(rawValue: GIT_STATUS_WT_DELETED.rawValue)
    
    /// The file's type has changed in the working directory.
    public static let gitStatusWTTypeChange     = GitStatusT(rawValue: GIT_STATUS_WT_TYPECHANGE.rawValue)
    
    /// The file is renamed in the working directory.
    public static let gitStatusWTRenamed        = GitStatusT(rawValue: GIT_STATUS_WT_RENAMED.rawValue)
    
    /// The file is unreadable in the working directory.
    public static let gitStatusWTUnreadable     = GitStatusT(rawValue: GIT_STATUS_WT_UNREADABLE.rawValue)
    
    /// The file is ignored.
    public static let gitStatusIgnored          = GitStatusT(rawValue: GIT_STATUS_IGNORED.rawValue)
    
    /// The file has conflicts.
    public static let gitStatusConflicted       = GitStatusT(rawValue: GIT_STATUS_CONFLICTED.rawValue)
    
    
    
    /// Converts the ``GitStatusT`` instance into a `git_status_t` instance.
    /// - Returns: The `git_status_t` instance.
    internal func cValue() -> git_status_t
    {
        return git_status_t(rawValue)
    }
}



/// The type of file to select for status reporting.
///
/// ## C Equivalent
///
/// [`git_status_show_t`](https://libgit2.org/docs/reference/main/status/git_status_show_t.html)
public enum GitStatusShowT: UInt32, CEnum
{
    /// Show the status based on comparing the working directory, the index,
    /// and HEAD.
    ///
    /// ## Discussion
    ///
    /// This is similar to `git status --porcelain`, in relation to the
    /// included files and the order.
    case gitStatusShowIndexAndWorkdir   = 0
    
    /// Show the status based on comparing HEAD to the index only, and do not
    /// compare against the working directory.
    case gitStatusShowIndexOnly         = 1
    
    /// Show the status based on comparing the index to the working directory
    /// only, and do not compare the index to HEAD.
    case gitStatusShowWorkdirOnly       = 2
    
    
    
    /// Initializes a ``GitStatusShow`` instance from the given
    /// `git_status_show_t` instance.
    /// - Parameter statusShow: The `git_status_show_t`
    /// instance to use.
    internal init?(
        cValue statusShow: git_status_show_t
    )
    {
        switch statusShow
        {
            case GIT_STATUS_SHOW_INDEX_AND_WORKDIR  : self = .gitStatusShowIndexAndWorkdir
            case GIT_STATUS_SHOW_INDEX_ONLY         : self = .gitStatusShowIndexOnly
            case GIT_STATUS_SHOW_WORKDIR_ONLY       : self = .gitStatusShowWorkdirOnly
            default                                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitStatusShow`` instance into a `git_status_show_t`
    /// instance.
    /// - Returns: The `git_status_show_t` instance.
    internal func cValue() -> git_status_show_t
    {
        switch self
        {
            case .gitStatusShowIndexAndWorkdir  : return GIT_STATUS_SHOW_INDEX_AND_WORKDIR
            case .gitStatusShowIndexOnly        : return GIT_STATUS_SHOW_INDEX_ONLY
            case .gitStatusShowWorkdirOnly      : return GIT_STATUS_SHOW_WORKDIR_ONLY
        }
    }
}



/// The flags controlling status callbacks.
///
/// ## C Equivalent
///
/// [`git_status_opt_t`](https://libgit2.org/docs/reference/main/status/git_status_opt_t.html)
public struct GitStatusOptT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitStatusOptT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitStatusOptT`` instance from the given
    /// `git_status_opt_t` instance.
    /// - Parameter statusOpt: The `git_status_opt_t` instance to use.
    internal init(
        cValue statusOpt: git_status_opt_t
    )
    {
        self.rawValue = statusOpt.rawValue
    }
    
    
    
    /// Include untracked files only if the working directory files are
    /// included in the status.
    public static let gitStatusOptIncludeUntracked              = GitStatusOptT(rawValue: GIT_STATUS_OPT_INCLUDE_UNTRACKED.rawValue)
    
    /// Include ignored files only if the working directory files are included
    /// in the status.
    public static let gitStatusOptIncludeIgnored                = GitStatusOptT(rawValue: GIT_STATUS_OPT_INCLUDE_IGNORED.rawValue)
    
    /// Include unmodified files.
    public static let gitStatusOptIncludeUnmodified             = GitStatusOptT(rawValue: GIT_STATUS_OPT_INCLUDE_UNMODIFIED.rawValue)
    
    /// Do not include submodules.
    ///
    /// ## Discussion
    ///
    /// This only applies if there are no pending type changes to the
    /// submodule, either from another type or to another type.
    public static let gitStatusOptExcludeSubmodules             = GitStatusOptT(rawValue: GIT_STATUS_OPT_EXCLUDE_SUBMODULES.rawValue)
    
    /// Include all files in untracked directories, instead of only including
    /// the top-level directory.
    public static let gitStatusOptRecurseUntrackedDirs          = GitStatusOptT(rawValue: GIT_STATUS_OPT_RECURSE_UNTRACKED_DIRS.rawValue)
    
    /// Treat paths as literal paths instead of `fnmatch` patterns.
    public static let gitStatusOptDisablePathspecMatch          = GitStatusOptT(rawValue: GIT_STATUS_OPT_DISABLE_PATHSPEC_MATCH.rawValue)
    
    /// Include all files in ignored directories.
    ///
    /// ## Discussion
    ///
    /// This is similar to `git ls-files -o -i --exclude-standard`.
    public static let gitStatusOptRecurseIgnoredDirs            = GitStatusOptT(rawValue: GIT_STATUS_OPT_RECURSE_IGNORED_DIRS.rawValue)
    
    /// Detect renames detection between HEAD and the index, and enable
    /// ``GitStatusT/gitStatusIndexRenamed`` as a possible status flag.
    public static let gitStatusOptRenamesHEADToIndex            = GitStatusOptT(rawValue: GIT_STATUS_OPT_RENAMES_HEAD_TO_INDEX.rawValue)
    
    /// Detect renames between the index and the working directory, and enable
    /// ``GitStatusT/gitStatusWTRenamed`` as a possible status flag.
    public static let gitStatusOptRenamesIndexToWorkdir         = GitStatusOptT(rawValue: GIT_STATUS_OPT_RENAMES_INDEX_TO_WORKDIR.rawValue)
    
    /// Override the native file system case sensitivity and force the output
    /// to be in case-sensitive order.
    public static let gitStatusOptSortCaseSensitively           = GitStatusOptT(rawValue: GIT_STATUS_OPT_SORT_CASE_SENSITIVELY.rawValue)
    
    /// Override the native file system case sensitivity and force the output
    /// to be in case-insensitive order.
    public static let gitStatusOptSortCaseInsensitively         = GitStatusOptT(rawValue: GIT_STATUS_OPT_SORT_CASE_INSENSITIVELY.rawValue)
    
    /// Include rewritten files when detecting renames.
    public static let gitStatusOptRenamesFromRewrites           = GitStatusOptT(rawValue: GIT_STATUS_OPT_RENAMES_FROM_REWRITES.rawValue)
    
    /// Bypass the default status behavior of performing a soft index reload.
    ///
    /// ## Discussion
    ///
    /// A soft index reload involves reloading the index data if the file on
    /// the disk has been modified outside libgit2.
    public static let gitStatusOptNoRefresh                     = GitStatusOptT(rawValue: GIT_STATUS_OPT_NO_REFRESH.rawValue)
    
    /// Refresh the cache in the index for files that unchanged, but have
    /// out-of-date information in the index.
    ///
    /// ## Discussion
    ///
    /// If this flag is enabled, it will result in less work being performed
    /// on subsequent status calls. This flag cannot be combined with the
    /// ``gitStatusOptNoRefresh`` flag.
    public static let gitStatusOptUpdateIndex                   = GitStatusOptT(rawValue: GIT_STATUS_OPT_UPDATE_INDEX.rawValue)
    
    /// Include files that cannot be opened or read, and report their status
    /// as unreadable.
    public static let gitStatusOptIncludeUnreadable             = GitStatusOptT(rawValue: GIT_STATUS_OPT_INCLUDE_UNREADABLE.rawValue)
    
    /// Include files that cannot be opened or read, and report their status
    /// as untracked.
    public static let gitStatusOptIncludeUnreadableAsUntracked  = GitStatusOptT(rawValue: GIT_STATUS_OPT_INCLUDE_UNREADABLE_AS_UNTRACKED.rawValue)
    
    
    
    
    /// Converts the ``GitStatusOptT`` instance into a `git_status_opt_t`
    /// instance.
    /// - Returns: The `git_status_opt_t` instance.
    internal func cValue() -> git_status_opt_t
    {
        return git_status_opt_t(rawValue)
    }
}
