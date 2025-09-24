//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



// TODO: Replace `git_diff_find_similar()` and `GIT_DIFF_INCLUDE_TYPECHANGE` in documentation.
/// The type of change described by a diff delta.
///
/// ## Discussion
///
/// ``gitDeltaRenamed`` and ``gitDeltaCopied`` will only appear if
/// `git_diff_find_similar()` is called on the diff.
///
/// ``gitDeltaTypeChange`` will only appear if `GIT_DIFF_INCLUDE_TYPECHANGE` is included
/// in the option flags, otherwise type changes will be split into add/delete pairs.
///
/// ## C Equivalent
///
/// [`git_delta_t`](https://libgit2.org/docs/reference/main/diff/git_delta_t.html)
public enum GitDeltaT: UInt32, GitEnum
{
    /// There are no changes.
    case gitDeltaUnmodified     = 0
    
    /// The entry does not exist in the old version.
    case gitDeltaAdded          = 1
    
    /// The entry does not exist in the new version.
    case gitDeltaDeleted        = 2
    
    /// The entry content changed between the old version and the new version.
    case gitDeltaModified       = 3
    
    /// The entry was renamed between the old version and the new version.
    case gitDeltaRenamed        = 4
    
    /// The entry was copied from another old entry.
    case gitDeltaCopied         = 5
    
    /// The entry is an ignored item in the working directory.
    case gitDeltaIgnored        = 6
    
    /// The entry is an untracked item in the working directory.
    case gitDeltaUntracked      = 7
    
    /// The type of the entry changed between the old version and the new version.
    case gitDeltaTypeChange     = 8
    
    /// The entry is unreadable.
    case gitDeltaUnreadable     = 9
    
    /// The entry in the index is conflicted.
    case gitDeltaConflicted     = 10
    
    
    
    /// Creates a ``GitDeltaT`` instance from a `git_delta_t` instance.
    /// - Parameter delta: The `git_delta_t` instance to use.
    internal init?(
        cValue delta: git_delta_t
    )
    {
        switch delta
        {
            case GIT_DELTA_UNMODIFIED   : self = .gitDeltaUnmodified
            case GIT_DELTA_ADDED        : self = .gitDeltaAdded
            case GIT_DELTA_DELETED      : self = .gitDeltaDeleted
            case GIT_DELTA_MODIFIED     : self = .gitDeltaModified
            case GIT_DELTA_RENAMED      : self = .gitDeltaRenamed
            case GIT_DELTA_COPIED       : self = .gitDeltaCopied
            case GIT_DELTA_IGNORED      : self = .gitDeltaIgnored
            case GIT_DELTA_UNTRACKED    : self = .gitDeltaUntracked
            case GIT_DELTA_TYPECHANGE   : self = .gitDeltaTypeChange
            case GIT_DELTA_UNREADABLE   : self = .gitDeltaUnreadable
            case GIT_DELTA_CONFLICTED   : self = .gitDeltaConflicted
            default                     : return nil
        }
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_delta_t
    {
        switch self
        {
            case .gitDeltaUnmodified    : return GIT_DELTA_UNMODIFIED
            case .gitDeltaAdded         : return GIT_DELTA_ADDED
            case .gitDeltaDeleted       : return GIT_DELTA_DELETED
            case .gitDeltaModified      : return GIT_DELTA_MODIFIED
            case .gitDeltaRenamed       : return GIT_DELTA_RENAMED
            case .gitDeltaCopied        : return GIT_DELTA_COPIED
            case .gitDeltaIgnored       : return GIT_DELTA_IGNORED
            case .gitDeltaUntracked     : return GIT_DELTA_UNTRACKED
            case .gitDeltaTypeChange    : return GIT_DELTA_TYPECHANGE
            case .gitDeltaUnreadable    : return GIT_DELTA_UNREADABLE
            case .gitDeltaConflicted    : return GIT_DELTA_CONFLICTED
        }
    }
}



/// Flags for the delta object and the file objects on each side of the delta.
///
/// ## Discussion
///
/// These flags are used for both the ``GitDiffDelta/flags`` property of ``GitDiffDelta`` and
/// the ``GitDiffFile/flags`` property of ``GitDiffFile`` that represent the old and new
/// sides of the delta.
///
/// Values outside of the public supported range should be considered reserved for internal or future use.
///
/// ## C Equivalent
///
/// [`git_diff_flag_t`](https://libgit2.org/docs/reference/main/diff/git_diff_flag_t.html)
public struct GitDiffFlagT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitDiffFlagT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// The files are treated as binary data.
    public static let gitDiffFlagBinary     = GitDiffFlagT(rawValue: GIT_DIFF_FLAG_BINARY.rawValue)
    
    /// The files are treated as text data.
    public static let gitDiffFlagNotBinary  = GitDiffFlagT(rawValue: GIT_DIFF_FLAG_NOT_BINARY.rawValue)
    
    /// The ID value is known to be correct.
    public static let gitDiffFlagValidID    = GitDiffFlagT(rawValue: GIT_DIFF_FLAG_VALID_ID.rawValue)
    
    /// The file exists at this side of the delta.
    public static let gitDiffFlagExists     = GitDiffFlagT(rawValue: GIT_DIFF_FLAG_EXISTS.rawValue)
    
    /// The file size value is known to be correct.
    public static let gitDiffFlagValidSize  = GitDiffFlagT(rawValue: GIT_DIFF_FLAG_VALID_SIZE.rawValue)
    
    
    
    /// The equivalent C value.
    internal var cValue: git_diff_flag_t
    {
        return git_diff_flag_t(rawValue)
    }
}
