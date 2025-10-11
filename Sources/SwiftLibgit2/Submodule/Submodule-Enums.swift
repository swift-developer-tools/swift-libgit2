//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



// TODO: Replace `git_submodule_set_ignore()`, `git_submodule_save()`, and `GIT_SUBMODULE_IGNORE_RESET` in documentation.
/// The submodule ignore options.
///
/// ## Discussion
///
/// These values represent the options for the `submodule.$name.ignore`
/// configuration value, which indicates how deeply to look at the working
/// directory when determining the submodule status.
///
/// This can be overriden in memory on a per-submodule basis with
/// `git_submodule_set_ignore()`, and can write the changed value to the disk
/// with `git_submodule_save()`. If the value has been overwritten, it can be
/// reverted to the on-disk value by using `GIT_SUBMODULE_IGNORE_RESET`.
///
/// ## C Equivalent
///
/// [`git_submodule_ignore_t`](https://libgit2.org/docs/reference/main/submodule/git_submodule_ignore_t.html)
public enum GitSubmoduleIgnoreT: Int32, GitEnum
{
    /// Use the submodule's configuration.
    case gitSubmoduleIgnoreUnspecified  = -1
    
    /// Do not ignore any change or untacked file.
    case gitSubmoduleIgnoreNone         = 1
    
    /// Ignore untracked files.
    ///
    /// ## Discussion
    ///
    /// Only changes to tracked files, the index, or the HEAD commit will
    /// matter.
    case gitSubmoduleIgnoreUntracked    = 2
    
    /// Ignore changes in the working directory, and only consider changes if
    /// the HEAD of the submodule has moved from the value in the superproject.
    case gitSubmoduleIgnoreDirty        = 3
    
    /// Never check if the submodule is dirty.
    case gitSubmoduleIgnoreAll          = 4
    
    
    
    /// Creates a ``GitSubmoduleIgnoreT`` instance from a
    /// `git_submodule_ignore_t` instance.
    /// - Parameter submoduleIgnore: The `git_submodule_ignore_t` instance to
    /// use.
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
