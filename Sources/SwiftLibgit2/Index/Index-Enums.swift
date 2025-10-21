//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags for index entries.
///
/// ## C Equivalent
///
/// [`git_index_entry_flag_t`](https://libgit2.org/docs/reference/main/index/git_index_entry_flag_t.html)
public struct GitIndexEntryFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitIndexEntryFlagT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitIndexEntryFlagT`` instance from the given
    /// `git_index_entry_flag_t` instance.
    /// - Parameter indexEntryFlag: The `git_index_entry_flag_t` instance to
    /// use.
    internal init(
        cValue indexEntryFlag: git_index_entry_flag_t
    )
    {
        self.rawValue = indexEntryFlag.rawValue
    }
    
    
    
    /// The file is assumed to be unchanged.
    public static let gitIndexEntryExtended     = GitIndexEntryFlagT(rawValue: GIT_INDEX_ENTRY_EXTENDED.rawValue)
    
    /// Marks the entry as valid.
    public static let gitIndexEntryValid        = GitIndexEntryFlagT(rawValue: GIT_INDEX_ENTRY_VALID.rawValue)
    
    
    
    /// Converts the ``GitIndexEntryFlagT`` instance into a
    /// `git_index_entry_flag_t` instance.
    /// - Returns: The `git_index_entry_flag_t` instance.
    internal func cValue() -> git_index_entry_flag_t
    {
        return git_index_entry_flag_t(rawValue)
    }
}



/// The flags for on-disk fields of an index entry.
///
/// ## Discussion
///
/// The ``GitIndexEntry/flagsExtended`` property contains flags that are
/// persisted to the disk, and flags that exist only in memory for libgit2's
/// internal use.
///
/// ``gitIndexEntryIntentToAdd`` and ``gitIndexEntrySkipWorktree`` are
/// persisted to the disk. ``gitIndexEntryExtendedFlags`` is a combined mask
/// of these two flags. ``gitIndexEntryUpToDate`` is used only in-memory.
///
/// ## C Equivalent
///
/// [`git_index_entry_extended_flag_t`](https://libgit2.org/docs/reference/main/index/git_index_entry_extended_flag_t.html)
public struct GitIndexEntryExtendedFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitIndexEntryExtendedFlagT`` instance from the given
    /// raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitIndexEntryExtendedFlagT`` instance from the given
    /// `git_index_entry_extended_flag_t` instance.
    /// - Parameter indexEntryExtendedFlag: The
    /// `git_index_entry_extended_flag_t` instance to use.
    internal init(
        cValue indexEntryExtendedFlag: git_index_entry_extended_flag_t
    )
    {
        self.rawValue = indexEntryExtendedFlag.rawValue
    }
    
    
    
    /// The entry was added with `git add -N` and represents a placeholder.
    public static let gitIndexEntryIntentToAdd      = GitIndexEntryExtendedFlagT(rawValue: GIT_INDEX_ENTRY_INTENT_TO_ADD.rawValue)
    
    /// Skip the entry in the working tree.
    public static let gitIndexEntrySkipWorktree     = GitIndexEntryExtendedFlagT(rawValue: GIT_INDEX_ENTRY_SKIP_WORKTREE.rawValue)
    
    /// The combined mask of flags that are persisted to the disk.
    public static let gitIndexEntryExtendedFlags    = GitIndexEntryExtendedFlagT(rawValue: GIT_INDEX_ENTRY_EXTENDED_FLAGS.rawValue)
    
    /// An internal flag indicating that the entry is up-to-date in memory.
    public static let gitIndexEntryUpToDate         = GitIndexEntryExtendedFlagT(rawValue: GIT_INDEX_ENTRY_UPTODATE.rawValue)
    
    
    
    /// Converts the ``GitIndexEntryExtendedFlagT`` instance into a
    /// `git_index_entry_extended_flag_t` instance.
    /// - Returns: The `git_index_entry_extended_flag_t` instance.
    internal func cValue() -> git_index_entry_extended_flag_t
    {
        return git_index_entry_extended_flag_t(rawValue)
    }
}



/// The system capabilities that affect index actions.
///
/// ## C Equivalent
///
/// [`git_index_capability_t`](https://libgit2.org/docs/reference/main/index/git_index_capability_t.html)
public enum GitIndexCapabilityT: Int32, CEnum
{
    /// Ignore case when comparing file names.
    case gitIndexCapabilityIgnoreCase   = 1
    
    /// Do not track file mode changes.
    case gitIndexCapabilityNoFileMode   = 2
    
    /// Do not support symbolic links.
    case gitIndexCapabilityNoSymLinks   = 4
    
    /// Read capabilities from the repository configuration.
    case gitIndexCapabilityFromOwner    = -1
    
    
    
    /// Initializes a ``GitIndexCapabilityT`` instance from the given
    /// `git_index_capability_t` instance.
    /// - Parameter indexCapability: The `git_index_capability_t` instance to
    /// use.
    internal init?(
        cValue indexCapability: git_index_capability_t
    )
    {
        switch indexCapability
        {
            case GIT_INDEX_CAPABILITY_IGNORE_CASE   : self = .gitIndexCapabilityIgnoreCase
            case GIT_INDEX_CAPABILITY_NO_FILEMODE   : self = .gitIndexCapabilityNoFileMode
            case GIT_INDEX_CAPABILITY_NO_SYMLINKS   : self = .gitIndexCapabilityNoSymLinks
            case GIT_INDEX_CAPABILITY_FROM_OWNER    : self = .gitIndexCapabilityFromOwner
            default                                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitIndexCapabilityT`` instance into a
    /// `git_index_capability_t` instance.
    /// - Returns: The `git_index_capability_t` instance.
    internal func cValue() -> git_index_capability_t
    {
        switch self
        {
            case .gitIndexCapabilityIgnoreCase  : return GIT_INDEX_CAPABILITY_IGNORE_CASE
            case .gitIndexCapabilityNoFileMode  : return GIT_INDEX_CAPABILITY_NO_FILEMODE
            case .gitIndexCapabilityNoSymLinks  : return GIT_INDEX_CAPABILITY_NO_SYMLINKS
            case .gitIndexCapabilityFromOwner   : return GIT_INDEX_CAPABILITY_FROM_OWNER
        }
    }
}



/// The flags for adding files that match a pathspec.
///
/// ## C Equivalent
///
/// [`git_index_add_option_t`](https://libgit2.org/docs/reference/main/index/git_index_add_option_t.html)
public struct GitIndexAddOptionT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitIndexAddOptionT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitIndexAddOptionT`` instance from the given
    /// `git_index_add_option_t` instance.
    /// - Parameter indexAddOption: The `git_index_add_option_t` instance to
    /// use.
    internal init(
        cValue indexAddOption: git_index_add_option_t
    )
    {
        self.rawValue = indexAddOption.rawValue
    }
    
    
    
    /// Use the default behavior.
    public static let gitIndexAddDefault                = GitIndexAddOptionT(rawValue: GIT_INDEX_ADD_DEFAULT.rawValue)
    
    /// Force-add the file.
    public static let gitIndexAddForce                  = GitIndexAddOptionT(rawValue: GIT_INDEX_ADD_FORCE.rawValue)
    
    /// Disable pathspec matching.
    public static let gitIndexAddDisablePathspecMatch   = GitIndexAddOptionT(rawValue: GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH.rawValue)
    
    /// Check that each pathspec entry either matches a file or is already
    /// in the index.
    public static let gitIndexAddCheckPathspec          = GitIndexAddOptionT(rawValue: GIT_INDEX_ADD_CHECK_PATHSPEC.rawValue)
    
    
    
    /// Converts the ``GitIndexAddOptionT`` instance into a
    /// `git_index_add_option_t` instance.
    /// - Returns: The `git_index_add_option_t` instance.
    internal func cValue() -> git_index_add_option_t
    {
        return git_index_add_option_t(rawValue)
    }
}



/// The system capabilities that affect index actions.
///
/// ## C Equivalent
///
/// [`git_index_stage_t`](https://libgit2.org/docs/reference/main/index/git_index_stage_t.html)
public enum GitIndexStageT: Int32, CEnum
{
    /// Match any entry matching the path, regardless of stage.
    case gitIndexStageAny       = -1
    
    /// A normal staged file in the index.
    case gitIndexStageNormal    = 0
    
    /// The ancestor side of a conflict.
    case gitIndexStageAncestor  = 1
    
    /// "Our" side of a conflict.
    case gitIndexStageOurs      = 2
    
    /// "Their" side of a conflict.
    case gitIndexStageTheirs    = 3
    
    
    
    /// Initializes a ``GitIndexStageT`` instance from the given
    /// `git_index_stage_t` instance.
    /// - Parameter indexStage: The `git_index_stage_t` instance to use.
    internal init?(
        cValue indexStage: git_index_stage_t
    )
    {
        switch indexStage
        {
            case GIT_INDEX_STAGE_ANY        : self = .gitIndexStageAny
            case GIT_INDEX_STAGE_NORMAL     : self = .gitIndexStageNormal
            case GIT_INDEX_STAGE_ANCESTOR   : self = .gitIndexStageAncestor
            case GIT_INDEX_STAGE_OURS       : self = .gitIndexStageOurs
            case GIT_INDEX_STAGE_THEIRS     : self = .gitIndexStageTheirs
            default                         : return nil
        }
    }
    
    
    
    /// Converts the ``GitIndexStageT`` instance into a `git_index_stage_t`
    /// instance.
    /// - Returns: The `git_index_stage_t` instance.
    internal func cValue() -> git_index_stage_t
    {
        switch self
        {
            case .gitIndexStageAny      : return GIT_INDEX_STAGE_ANY
            case .gitIndexStageNormal   : return GIT_INDEX_STAGE_NORMAL
            case .gitIndexStageAncestor : return GIT_INDEX_STAGE_ANCESTOR
            case .gitIndexStageOurs     : return GIT_INDEX_STAGE_OURS
            case .gitIndexStageTheirs   : return GIT_INDEX_STAGE_THEIRS
        }
    }
}
