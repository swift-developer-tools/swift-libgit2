//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



// TODO: Replace `git_config_set_writeorder()`, `git_config_open_default()`, `git_repository_config()` in documentation.
/// The priority level of a configuration file.
///
/// ## Discussion
///
/// These priority levels correspond to the natural escalation logic (from higher to lower) when reading
/// or searching for configuration entries in `git.git`. This means that for the same key, the
/// configuration in the local configuration is preferred over the configuration in the system configuration file.
///
/// Callers can add custom configuration beginning at ``gitConfigLevelApp``.
///
/// By default, writes occur in the highest priority level backend that is writable. This ordering can be
/// overridden with `git_config_set_writeorder()`.
///
/// `git_config_open_default()` and `git_repository_config()` honor those priority
/// levels as well.
///
/// ## C Equivalent
///
/// [`git_config_level_t`](https://libgit2.org/docs/reference/main/config/git_config_level_t.html)
public enum GitConfigLevelT: Int32, GitEnum
{
    /// System-wide on Windows.
    ///
    /// ## Discussion
    ///
    /// This is used for compatibility with Portable Git.
    case gitConfigLevelProgramData  = 1
    
    /// System-wide configuration file.
    ///
    /// ## Discussion
    ///
    /// This is typically `/etc/gitconfig` on Linux.
    case gitConfigLevelSystem       = 2
    
    /// XDG compatible configuration file.
    ///
    /// ## Discussion
    ///
    /// This is typically `~/.config/git/config`.
    case gitConfigLevelXDG          = 3
    
    /// Global configuration file is the user-specific configuration.
    ///
    /// ## Discussion
    ///
    /// This is typically `~/.gitconfig`.
    case gitConfigLevelGlobal       = 4
    
    /// Local configuration, the repository-specific configuration file.
    ///
    /// ## Discussion
    ///
    /// This is typically `$GIT_DIR/config`.
    case gitConfigLevelLocal        = 5
    
    /// Worktree-specific configuration.
    ///
    /// ## Discussion
    ///
    /// This is typically `$GIT_DIR/config.worktree`.
    case gitConfigLevelWorktree     = 6
    
    /// Application-specific configuration file.
    ///
    /// ## Discussion
    ///
    /// Callers into libgit2 can add custom configuration beginning at this level.
    case gitConfigLevelApp          = 7
    
    /// The most specific configuration file available that is loaded.
    ///
    /// ## Discussion
    ///
    /// This is not a configuration level. Callers can use this value when querying configuration levels
    /// to retrieve data from the current highest-level configuration.
    case gitConfigHighestLevel      = -1
    
    
    
    /// Creates a ``GitConfigLevelT`` instance from a `git_config_level_t` instance.
    /// - Parameter configLevel: The `git_config_level_t` instance to use.
    internal init?(
        cValue configLevel: git_config_level_t
    )
    {
        switch configLevel
        {
            case GIT_CONFIG_LEVEL_PROGRAMDATA   : self = .gitConfigLevelProgramData
            case GIT_CONFIG_LEVEL_SYSTEM        : self = .gitConfigLevelSystem
            case GIT_CONFIG_LEVEL_XDG           : self = .gitConfigLevelXDG
            case GIT_CONFIG_LEVEL_GLOBAL        : self = .gitConfigLevelGlobal
            case GIT_CONFIG_LEVEL_LOCAL         : self = .gitConfigLevelLocal
            case GIT_CONFIG_LEVEL_WORKTREE      : self = .gitConfigLevelWorktree
            case GIT_CONFIG_LEVEL_APP           : self = .gitConfigLevelApp
            case GIT_CONFIG_HIGHEST_LEVEL       : self = .gitConfigHighestLevel
            default                             : return nil
                
        }
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_config_level_t
    {
        switch self
        {
            case .gitConfigLevelProgramData : return GIT_CONFIG_LEVEL_PROGRAMDATA
            case .gitConfigLevelSystem      : return GIT_CONFIG_LEVEL_SYSTEM
            case .gitConfigLevelXDG         : return GIT_CONFIG_LEVEL_XDG
            case .gitConfigLevelGlobal      : return GIT_CONFIG_LEVEL_GLOBAL
            case .gitConfigLevelLocal       : return GIT_CONFIG_LEVEL_LOCAL
            case .gitConfigLevelWorktree    : return GIT_CONFIG_LEVEL_WORKTREE
            case .gitConfigLevelApp         : return GIT_CONFIG_LEVEL_APP
            case .gitConfigHighestLevel     : return GIT_CONFIG_HIGHEST_LEVEL
        }
    }
}
