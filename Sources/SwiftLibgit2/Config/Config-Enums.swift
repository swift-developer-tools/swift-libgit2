//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



// TODO: Replace `git_repository_config()` in documentation.
/// The priority level of a configuration file.
///
/// ## Discussion
///
/// These priority levels correspond to the natural escalation logic (from
/// higher to lower) when reading or searching for configuration entries in
/// `git.git`. This means that for the same key, the configuration in the
/// local configuration is preferred over the configuration in the system
/// configuration file.
///
/// Callers can add custom configuration beginning at ``gitConfigLevelApp``.
///
/// By default, writes occur in the highest priority level backend that is
/// writable. This ordering can be overridden with
/// ``gitConfigSetWriteOrder(cfg:levels:len:)``.
///
/// ``gitConfigOpenDefault(out:)`` and `git_repository_config()` honor those
/// priority levels as well.
///
/// ## C Equivalent
///
/// [`git_config_level_t`](https://libgit2.org/docs/reference/main/config/git_config_level_t.html)
public enum GitConfigLevelT: Int32, CEnum
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
    /// Callers into libgit2 can add custom configuration beginning at this
    /// level.
    case gitConfigLevelApp          = 7
    
    /// The most specific configuration file available that is loaded.
    ///
    /// ## Discussion
    ///
    /// This is not a configuration level. Callers can use this value when
    /// querying configuration levels to retrieve data from the current
    /// highest-level configuration.
    case gitConfigHighestLevel      = -1
    
    
    
    /// Initializes a ``GitConfigLevelT`` instance from the given
    /// `git_config_level_t` instance.
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
    
    
    
    /// Converts the ``GitConfigLevelT`` instance into a `git_config_level_t`
    /// instance.
    /// - Returns: The `git_config_level_t` instance.
    internal func cValue() -> git_config_level_t
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



/// The configuration variable mapping type.
///
/// ## Discussion
///
/// This defines the different types of values that can be matched when using
/// configuration mapping functions. Each type determines how the configuration
/// value should be interpreted during the mapping operation.
///
/// ## C Equivalent
///
/// [`git_configmap_t`](https://libgit2.org/docs/reference/main/config/git_configmap_t.html)
public enum GitConfigMapT: UInt32, CEnum
{
    /// The configuration variable matches boolean false values.
    ///
    /// ## Discussion
    ///
    /// Boolean false values include `false`, `FALSE`, `no`, `off`, `0`,
    /// and other similar values.
    case gitConfigMapFalse      = 0
    
    /// The configuration variable matches boolean true values.
    ///
    /// ## Discussion
    ///
    /// Boolean true values include `true`, `TRUE`, `yes`, `on`, `1`,
    /// and other similar values.
    case gitConfigMapTrue       = 1
    
    /// The configuration variable matches 32-bit signed integer values.
    case gitConfigMapInt32      = 2
    
    /// The configuration variable matches case-insensitive string values.
    case gitConfigMapString     = 3
    
    
    
    /// Initializes a ``GitConfigMapT`` instance from the given
    /// `git_configmap_t` instance.
    /// - Parameter git_configmap_t: The `git_configmap_t` instance to use.
    internal init?(
        cValue configMap: git_configmap_t
    )
    {
        switch configMap
        {
            case GIT_CONFIGMAP_FALSE    : self = .gitConfigMapFalse
            case GIT_CONFIGMAP_TRUE     : self = .gitConfigMapTrue
            case GIT_CONFIGMAP_INT32    : self = .gitConfigMapInt32
            case GIT_CONFIGMAP_STRING   : self = .gitConfigMapString
            default                     : return nil
                
        }
    }
    
    
    
    /// Converts the ``GitConfigMapT`` instance into a `git_configmap_t`
    /// instance.
    /// - Returns: The `git_configmap_t` instance.
    internal func cValue() -> git_configmap_t
    {
        switch self
        {
            case .gitConfigMapFalse     : return GIT_CONFIGMAP_FALSE
            case .gitConfigMapTrue      : return GIT_CONFIGMAP_TRUE
            case .gitConfigMapInt32     : return GIT_CONFIGMAP_INT32
            case .gitConfigMapString    : return GIT_CONFIGMAP_STRING
        }
    }
}
