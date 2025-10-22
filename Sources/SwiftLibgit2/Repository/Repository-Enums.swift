//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling repository opening.
///
/// ## C Equivalent
///
/// [`git_repository_open_flag_t`](https://libgit2.org/docs/reference/main/repository/git_repository_open_flag_t.html)
public struct GitRepositoryOpenFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitRepositoryOpenFlagT`` instance from the given raw
    /// value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitRepositoryOpenFlagT`` instance from the given
    /// `git_repository_open_flag_t` instance.
    /// - Parameter repositoryOpenFlag: The `git_repository_open_flag_t`
    /// instance to use.
    internal init(
        cValue repositoryOpenFlag: git_repository_open_flag_t
    )
    {
        self.rawValue = repositoryOpenFlag.rawValue
    }
    
    
    
    /// Only open the repository if it can be immediately found in the
    /// start path without looking at parent directories.
    public static let gitRepositoryOpenNoSearch     = GitRepositoryOpenFlagT(rawValue: GIT_REPOSITORY_OPEN_NO_SEARCH.rawValue)
    
    /// Continue searching across file system boundaries.
    public static let gitRepositoryOpenCrossFS      = GitRepositoryOpenFlagT(rawValue: GIT_REPOSITORY_OPEN_CROSS_FS.rawValue)
    
    /// Open the repository as a bare repository, regardless of
    /// `core.bare.config`, and defer loading the configuration file for
    /// faster setup.
    ///
    /// ## Discussion
    ///
    /// Unlike ``gitRepositoryOpenBare(out:barePath:)``, this flag can
    /// enable following Gitlinks.
    public static let gitRepositoryOpenBare         = GitRepositoryOpenFlagT(rawValue: GIT_REPOSITORY_OPEN_BARE.rawValue)
    
    /// Do not check for a repository by appending `/.git` to the start path,
    /// and only open the repository if the start path itself points to the
    /// `git` directory.
    public static let gitRepositoryOpenNoDotGit     = GitRepositoryOpenFlagT(rawValue: GIT_REPOSITORY_OPEN_NO_DOTGIT.rawValue)
    
    /// Find and open a repository, respecting the environment variables used
    /// by the Git command line tools.
    ///
    /// ## Discussion
    ///
    /// If this flag is enabled,
    /// ``gitRepositoryOpenExt(out:path:flags:ceilingDirs:)`` will ignore any
    /// other flags and the `ceilingDirs` parameter, and will allow a `nil`
    /// `path` to use `GIT_DIR` or search from the current directory.
    ///
    /// The search for a repository will respect `$GIT_CEILING_DIRECTORIES`
    /// and `$GIT_DISCOVERY_ACROSS_FILESYSTEM`.
    ///
    /// The opened repository will respect `$GIT_INDEX_FILE`, `$GIT_NAMESPACE`,
    /// `$GIT_OBJECT_DIRECTORY`, and `$GIT_ALTERNATE_OBEJCT_DIRECTORIES`.
    ///
    /// - Note: In future libgit2 versions, if this flag is enabled,
    /// ``gitRepositoryOpenExt(out:path:flags:ceilingDirs:)`` will also respect
    /// `$GIT_WORK_TREE` and `$GIT_COMMON_DIR`. Currently, the function will
    /// return an error if either of these are set.
    public static let gitRepositoryOpenFromEnv      = GitRepositoryOpenFlagT(rawValue: GIT_REPOSITORY_OPEN_FROM_ENV.rawValue)
    
    
    
    /// Converts the ``GitRepositoryOpenFlagT`` instance into a
    /// `git_repository_open_flag_t` instance.
    /// - Returns: The `git_repository_open_flag_t` instance.
    internal func cValue() -> git_repository_open_flag_t
    {
        return git_repository_open_flag_t(rawValue)
    }
}



/// The flags controlling repository initialization.
///
/// ## C Equivalent
///
/// [`git_repository_init_flag_t`](https://libgit2.org/docs/reference/main/repository/git_repository_init_flag_t.html)
public struct GitRepositoryInitFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitRepositoryInitFlagT`` instance from the given raw
    /// value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitRepositoryInitFlagT`` instance from the given
    /// `git_repository_init_flag_t` instance.
    /// - Parameter repositoryInitFlag: The `git_repository_init_flag_t`
    /// instance to use.
    internal init(
        cValue repositoryInitFlag: git_repository_init_flag_t
    )
    {
        self.rawValue = repositoryInitFlag.rawValue
    }
    
    
    
    /// Create a bare repository with no working directory.
    public static let gitRepositoryInitBare                 = GitRepositoryInitFlagT(rawValue: GIT_REPOSITORY_INIT_BARE.rawValue)
    
    /// Return ``GitErrorCode/gitEExists`` if the `repo_path` appears to
    /// already be a Git repository.
    public static let gitRepositoryInitNoReinit             = GitRepositoryInitFlagT(rawValue: GIT_REPOSITORY_INIT_NO_REINIT.rawValue)
    
    /// Create the repository path and working directory path if necessary.
    ///
    /// ## Discussion
    ///
    /// The initialization is always willing to create the `.git` directory
    /// even without this flag being enabled. If this flag is enabled, the
    /// initialization will also create the trailing component of the
    /// repository and working directory paths if necessary.
    public static let gitRepositoryInitMkdir                = GitRepositoryInitFlagT(rawValue: GIT_REPOSITORY_INIT_MKDIR.rawValue)
    
    /// Recursively create all components of the repository path and working
    /// directory path if necessary.
    public static let gitRepositoryInitMkpath               = GitRepositoryInitFlagT(rawValue: GIT_REPOSITORY_INIT_MKPATH.rawValue)
    
    /// Use an external template to initialize the repository.
    ///
    /// ## Discussion
    ///
    /// libgit2 normally uses internal templates to initialize a new
    /// repository. If this flag is enabled, libgit2 will use
    /// ``GitRepositoryInitOptions/templatePath`` if set, or the
    /// `init.templateDir` global configuration otherwise, and will ultimately
    /// fall back on `/usr/share/git-core/templates` if it exists.
    public static let gitRepositoryInitExternalTemplate     = GitRepositoryInitFlagT(rawValue: GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE.rawValue)
    
    /// Use relative paths for `gitdir` and `core.worktree` if an alternate
    /// working directory is specified.
    public static let gitRepositoryInitRelativeGitlink      = GitRepositoryInitFlagT(rawValue: GIT_REPOSITORY_INIT_RELATIVE_GITLINK.rawValue)
    
    
    
    /// Converts the ``GitRepositoryInitFlagT`` instance into a
    /// `git_repository_init_flag_t` instance.
    /// - Returns: The `git_repository_init_flag_t` instance.
    internal func cValue() -> git_repository_init_flag_t
    {
        return git_repository_init_flag_t(rawValue)
    }
}



/// Repository initialization modes.
///
/// ## C Equivalent
///
/// [`git_repository_init_mode_t`](https://libgit2.org/docs/reference/main/repository/git_repository_init_mode_t.html)
public enum GitRepositoryInitModeT: UInt32, CEnum
{
    /// Use the permissions configured by `umask`.
    case gitRepositoryInitSharedUmask   = 0
    
    /// Use `--shared=group` permissions, and `chmod` the repository to be
    /// group writable and `g+sx` for stick group assignment.
    case gitRepositoryInitSharedGroup   = 1533
    
    /// Use `--shared=all` permissions to add world readability.
    case gitRepositoryInitSharedAll     = 1535
    
    
    
    /// Initializes a ``GitRepositoryInitModeT`` instance from the given
    /// `git_repository_init_mode_t` instance.
    /// - Parameter repositoryInitMode: The `git_repository_init_mode_t`
    /// instance to use.
    internal init?(
        cValue repositoryInitMode: git_repository_init_mode_t
    )
    {
        switch repositoryInitMode
        {
            case GIT_REPOSITORY_INIT_SHARED_UMASK   : self = .gitRepositoryInitSharedUmask
            case GIT_REPOSITORY_INIT_SHARED_GROUP   : self = .gitRepositoryInitSharedGroup
            case GIT_REPOSITORY_INIT_SHARED_ALL     : self = .gitRepositoryInitSharedAll
            default                                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitRepositoryInitModeT`` instance into a
    /// `git_repository_init_mode_t` instance.
    /// - Returns: The `git_repository_init_mode_t` instance.
    internal func cValue() -> git_repository_init_mode_t
    {
        switch self
        {
            case .gitRepositoryInitSharedUmask  : return GIT_REPOSITORY_INIT_SHARED_UMASK
            case .gitRepositoryInitSharedGroup  : return GIT_REPOSITORY_INIT_SHARED_GROUP
            case .gitRepositoryInitSharedAll    : return GIT_REPOSITORY_INIT_SHARED_ALL
        }
    }
}



/// Items that belong to a repository.
///
/// ## C Equivalent
///
/// [`git_repository_item_t`](https://libgit2.org/docs/reference/main/repository/git_repository_item_t.html)
public enum GitRepositoryItemT: UInt32, CEnum
{
    /// The `.git` directory.
    case gitRepositoryItemGitDir            = 0
    
    /// The working directory.
    case gitRepositoryItemWorkdir           = 1
    
    /// The `common` directory.
    case gitRepositoryItemCommonDir         = 2
    
    /// The index file.
    case gitRepositoryItemIndex             = 3
    
    /// The `objects` directory.
    case gitRepositoryItemObjects           = 4
    
    /// The `refs` directory.
    case gitRepositoryItemRefs              = 5
    
    /// The `packed-refs` file.
    case gitRepositoryItemPackedRefs        = 6
    
    /// The `remotes` directory.
    case gitRepositoryItemRemotes           = 7
    
    /// The `config` file.
    case gitRepositoryItemConfig            = 8
    
    /// The `info` directory.
    case gitRepositoryItemInfo              = 9
    
    /// The `hooks` directory.
    case gitRepositoryItemHooks             = 10
    
    /// The `logs` directory.
    case gitRepositoryItemLogs              = 11
    
    /// The `modules` directory.
    case gitRepositoryItemModules           = 12
    
    /// The `worktrees` directory.
    case gitRepositoryItemWorktrees         = 13
    
    /// The worktree-specific `config` file.
    case gitRepositoryItemWorktreeConfig    = 14
    
    /// A sentinel value for internal use.
    case gitRepositoryItemLast              = 15
    
    
    
    /// Initializes a ``GitRepositoryItemT`` instance from the given
    /// `git_repository_item_t` instance.
    /// - Parameter repositoryItem: The `git_repository_item_t` instance to use.
    internal init?(
        cValue repositoryItem: git_repository_item_t
    )
    {
        switch repositoryItem
        {
            case GIT_REPOSITORY_ITEM_GITDIR             : self = .gitRepositoryItemGitDir
            case GIT_REPOSITORY_ITEM_WORKDIR            : self = .gitRepositoryItemWorkdir
            case GIT_REPOSITORY_ITEM_COMMONDIR          : self = .gitRepositoryItemCommonDir
            case GIT_REPOSITORY_ITEM_INDEX              : self = .gitRepositoryItemIndex
            case GIT_REPOSITORY_ITEM_OBJECTS            : self = .gitRepositoryItemObjects
            case GIT_REPOSITORY_ITEM_REFS               : self = .gitRepositoryItemRefs
            case GIT_REPOSITORY_ITEM_PACKED_REFS        : self = .gitRepositoryItemPackedRefs
            case GIT_REPOSITORY_ITEM_REMOTES            : self = .gitRepositoryItemRemotes
            case GIT_REPOSITORY_ITEM_CONFIG             : self = .gitRepositoryItemConfig
            case GIT_REPOSITORY_ITEM_INFO               : self = .gitRepositoryItemInfo
            case GIT_REPOSITORY_ITEM_HOOKS              : self = .gitRepositoryItemHooks
            case GIT_REPOSITORY_ITEM_LOGS               : self = .gitRepositoryItemLogs
            case GIT_REPOSITORY_ITEM_MODULES            : self = .gitRepositoryItemModules
            case GIT_REPOSITORY_ITEM_WORKTREES          : self = .gitRepositoryItemWorktrees
            case GIT_REPOSITORY_ITEM_WORKTREE_CONFIG    : self = .gitRepositoryItemWorktreeConfig
            case GIT_REPOSITORY_ITEM__LAST              : self = .gitRepositoryItemLast
            default                                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitRepositoryItemT`` instance into a
    /// `git_repository_item_t` instance.
    /// - Returns: The `git_repository_item_t` instance.
    internal func cValue() -> git_repository_item_t
    {
        switch self
        {
            case .gitRepositoryItemGitDir           : return GIT_REPOSITORY_ITEM_GITDIR
            case .gitRepositoryItemWorkdir          : return GIT_REPOSITORY_ITEM_WORKDIR
            case .gitRepositoryItemCommonDir        : return GIT_REPOSITORY_ITEM_COMMONDIR
            case .gitRepositoryItemIndex            : return GIT_REPOSITORY_ITEM_INDEX
            case .gitRepositoryItemObjects          : return GIT_REPOSITORY_ITEM_OBJECTS
            case .gitRepositoryItemRefs             : return GIT_REPOSITORY_ITEM_REFS
            case .gitRepositoryItemPackedRefs       : return GIT_REPOSITORY_ITEM_PACKED_REFS
            case .gitRepositoryItemRemotes          : return GIT_REPOSITORY_ITEM_REMOTES
            case .gitRepositoryItemConfig           : return GIT_REPOSITORY_ITEM_CONFIG
            case .gitRepositoryItemInfo             : return GIT_REPOSITORY_ITEM_INFO
            case .gitRepositoryItemHooks            : return GIT_REPOSITORY_ITEM_HOOKS
            case .gitRepositoryItemLogs             : return GIT_REPOSITORY_ITEM_LOGS
            case .gitRepositoryItemModules          : return GIT_REPOSITORY_ITEM_MODULES
            case .gitRepositoryItemWorktrees        : return GIT_REPOSITORY_ITEM_WORKTREES
            case .gitRepositoryItemWorktreeConfig   : return GIT_REPOSITORY_ITEM_WORKTREE_CONFIG
            case .gitRepositoryItemLast             : return GIT_REPOSITORY_ITEM__LAST
        }
    }
}



/// The possible repository states, based on the ongoing operation.
///
/// ## C Equivalent
///
/// [`git_repository_state_t`](https://libgit2.org/docs/reference/main/repository/git_repository_state_t.html)
public enum GitRepositoryStateT: UInt32, CEnum
{
    /// There is no ongoing operation.
    case gitRepositoryStateNone                     = 0
    
    /// A merge operation is in progress.
    case gitRepositoryStateMerge                    = 1
    
    /// A revert operation is in progress.
    case gitRepositoryStateRevert                   = 2
    
    /// A sequential revert operation is in progress.
    case gitRepositoryStateRevertSequence           = 3
    
    /// A cherry-pick operation is in progress.
    case gitRepositoryStateCherrypick               = 4
    
    /// A sequential cherry-pick operation is in progress.
    case gitRepositoryStateCherrypickSequence       = 5
    
    /// A bisect operation is in progress.
    case gitRepositoryStateBisect                   = 6
    
    /// A rebase operation is in progress.
    case gitRepositoryStateRebase                   = 7
    
    /// An interactive rebase operation is in progress.
    case gitRepositoryStateRebaseInteractive        = 8
    
    /// A rebase-merge operation is in progress.
    case gitRepositoryStateRebaseMerge              = 9
    
    /// A mailbox apply operation is in progress.
    case gitRepositoryStateApplyMailbox             = 10
    
    /// A mailbox apply operation or a rebase operation is in progress.
    case gitRepositoryStateApplyMailboxOrRebase     = 11
    
    
    
    /// Initializes a ``GitRepositoryStateT`` instance from the given
    /// `git_repository_state_t` instance.
    /// - Parameter repositoryState: The `git_repository_state_t` instance to
    /// use.
    internal init?(
        cValue repositoryState: git_repository_state_t
    )
    {
        switch repositoryState
        {
            case GIT_REPOSITORY_STATE_NONE                      : self = .gitRepositoryStateNone
            case GIT_REPOSITORY_STATE_MERGE                     : self = .gitRepositoryStateMerge
            case GIT_REPOSITORY_STATE_REVERT                    : self = .gitRepositoryStateRevert
            case GIT_REPOSITORY_STATE_REVERT_SEQUENCE           : self = .gitRepositoryStateRevertSequence
            case GIT_REPOSITORY_STATE_CHERRYPICK                : self = .gitRepositoryStateCherrypick
            case GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE       : self = .gitRepositoryStateCherrypickSequence
            case GIT_REPOSITORY_STATE_BISECT                    : self = .gitRepositoryStateBisect
            case GIT_REPOSITORY_STATE_REBASE                    : self = .gitRepositoryStateRebase
            case GIT_REPOSITORY_STATE_REBASE_INTERACTIVE        : self = .gitRepositoryStateRebaseInteractive
            case GIT_REPOSITORY_STATE_REBASE_MERGE              : self = .gitRepositoryStateRebaseMerge
            case GIT_REPOSITORY_STATE_APPLY_MAILBOX             : self = .gitRepositoryStateApplyMailbox
            case GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE   : self = .gitRepositoryStateApplyMailboxOrRebase
            default                                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitRepositoryStateT`` instance into a
    /// `git_repository_state_t` instance.
    /// - Returns: The `git_repository_state_t` instance.
    internal func cValue() -> git_repository_state_t
    {
        switch self
        {
            case .gitRepositoryStateNone                    : return GIT_REPOSITORY_STATE_NONE
            case .gitRepositoryStateMerge                   : return GIT_REPOSITORY_STATE_MERGE
            case .gitRepositoryStateRevert                  : return GIT_REPOSITORY_STATE_REVERT
            case .gitRepositoryStateRevertSequence          : return GIT_REPOSITORY_STATE_REVERT_SEQUENCE
            case .gitRepositoryStateCherrypick              : return GIT_REPOSITORY_STATE_CHERRYPICK
            case .gitRepositoryStateCherrypickSequence      : return GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE
            case .gitRepositoryStateBisect                  : return GIT_REPOSITORY_STATE_BISECT
            case .gitRepositoryStateRebase                  : return GIT_REPOSITORY_STATE_REBASE
            case .gitRepositoryStateRebaseInteractive       : return GIT_REPOSITORY_STATE_REBASE_INTERACTIVE
            case .gitRepositoryStateRebaseMerge             : return GIT_REPOSITORY_STATE_REBASE_MERGE
            case .gitRepositoryStateApplyMailbox            : return GIT_REPOSITORY_STATE_APPLY_MAILBOX
            case .gitRepositoryStateApplyMailboxOrRebase    : return GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE
        }
    }
}
