//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the diff operation.
///
/// ## C Equivalent
///
/// [`git_diff_option_t`](https://libgit2.org/docs/reference/main/diff/git_diff_option_t.html)
public struct GitDiffOptionT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitDiffOptionT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitDiffOptionT`` instance from a `git_diff_option_t`
    /// instance.
    /// - Parameter diffOption: The `git_diff_option_t` instance to use.
    internal init(
        cValue diffOption: git_diff_option_t
    )
    {
        self.rawValue = diffOption.rawValue
    }
    
    
    
    /// Create a normal diff.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    public static let gitDiffNormal                         = GitDiffOptionT(rawValue: GIT_DIFF_NORMAL.rawValue)
    
    /// Reverses the sides of the diff.
    public static let gitDiffReverse                        = GitDiffOptionT(rawValue: GIT_DIFF_REVERSE.rawValue)
    
    /// Include ignored files in the diff.
    ///
    /// ## Discussion
    ///
    /// This flag includes all files of an ignored directory as a single entry
    /// in the diff. Use ``gitDiffRecurseIgnoredDirs`` to include all files of
    /// an ignored directory as separate entries.
    public static let gitDiffIncludeIgnored                 = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_IGNORED.rawValue)
    
    /// Add all ignored files in a directory as ignored entries.
    ///
    /// ## Discussion
    ///
    /// ``gitDiffIncludeIgnored`` includes all files of an ignored directory
    /// as a single entry in the diff. This includes all files of of an ignored
    /// directory as separate entries.
    public static let gitDiffRecurseIgnoredDirs             = GitDiffOptionT(rawValue: GIT_DIFF_RECURSE_IGNORED_DIRS.rawValue)
    
    /// Include untracked files in the diff.
    ///
    /// ## Discussion
    ///
    /// This flag includes all files of an untracked directory as a single
    /// entry in the diff. Use ``gitDiffRecurseUntrackedDirs`` to include all
    /// files of an untracked directory as separate entries.
    public static let gitDiffIncludeUntracked               = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_UNTRACKED.rawValue)
    
    /// Add all untracked files in a directory as untracked entries.
    ///
    /// ## Discussion
    ///
    /// ``gitDiffIncludeUntracked`` includes all files of an untracked
    /// directory as a single entry in the diff. This includes all files of an
    /// untracked directory as separate entries.
    public static let gitDiffRecurseUntrackedDirs           = GitDiffOptionT(rawValue: GIT_DIFF_RECURSE_UNTRACKED_DIRS.rawValue)
    
    /// Include unmodified files in the diff.
    public static let gitDiffIncludeUnmodified              = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_UNMODIFIED.rawValue)
    
    /// Use type change deltas in the diff.
    ///
    /// ## Discussion
    ///
    /// The normal behavior is to treat type changes as add/delete pairs in
    /// the diff.
    ///
    /// Blob-to-tree type changes are generally represented as a deleted delta,
    /// even with this flag enabled. Use ``gitDiffIncludeTypeChangeTrees`` to
    /// correctly label these changes.
    public static let gitDiffIncludeTypeChange              = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_TYPECHANGE.rawValue)
    
    /// Use type change deltas for blob-to-tree type changes.
    ///
    /// ## Discussion
    ///
    /// ``gitDiffIncludeTypeChange`` uses type change deltas in the diff,
    /// instead of add/delete pairs. However, blob-to-tree type changes are
    /// generally still represented as a deleted delta. This flag tries to
    /// correctly label these transitions as type changes with the new file's
    /// mode set to `tree`. The tree SHA will not be available.
    public static let gitDiffIncludeTypeChangeTrees         = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_TYPECHANGE_TREES.rawValue)
    
    /// Ignore file mode changes.
    public static let gitDiffIgnoreFileMode                 = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_FILEMODE.rawValue)
    
    /// Treat all submodules as unmodified.
    public static let gitDiffIgnoreSubmodules               = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_SUBMODULES.rawValue)
    
    /// Use case-insensitive filename comparisons.
    public static let gitDiffIgnoreCase                     = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_CASE.rawValue)
    
    /// Represent case changes as an add/delete pair.
    ///
    /// ## Discussion
    ///
    /// This flag may be combined with ``gitDiffIgnoreCase`` to represent case
    /// changes as an add/delete pair.
    public static let gitDiffIncludeCaseChange              = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_CASECHANGE.rawValue)
    
    /// Treat paths as literal paths instead of `fnmatch` patterns.
    ///
    /// ## Discussion
    ///
    /// If the pathspec is set in the diff options, this flags indicates that
    /// the paths should be treated as literal paths instead of `fnmatch`
    /// patterns.
    ///
    /// Each path in the list must be a full path to either a file or a
    /// directory. A trailing slash indicates that the path will only match a
    /// directory. If a directory is specified, all of its children will be
    /// included.
    public static let gitDiffDisablePathspecMatch           = GitDiffOptionT(rawValue: GIT_DIFF_DISABLE_PATHSPEC_MATCH.rawValue)
    
    /// Disable updating the `binary` flag in the delta records.
    ///
    /// ## Discussion
    ///
    /// When iterating over a diff, disabling updating the `binary` flag in
    /// the delta records is useful if the hunk and data callbacks are not
    /// needed. This avoids having to completely load each file.
    public static let gitDiffSkipBinaryCheck                = GitDiffOptionT(rawValue: GIT_DIFF_SKIP_BINARY_CHECK.rawValue)
    
    /// Label untracked directories as untracked, without scanning for ignored files.
    ///
    /// ## Discussion
    ///
    /// The normal Git behavior is to scan the entire content of an untracked
    /// directory. If all the content of an untracked directory is ignored,
    /// then the directory is labeled as ignored. If any of the content is not
    /// ignored, then the directory is labeled as untracked.
    ///
    /// This flag indicates that the scan should not be performed, and
    /// untracked directories should be immediately labeled as untracked.
    public static let gitDiffEnableFastUntrackedDirs        = GitDiffOptionT(rawValue: GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS.rawValue)
    
    /// Update the index with correct stat information from the index.
    ///
    /// ## Discussion
    ///
    /// This flag indicates that when the diff finds a file in the working
    /// directory with stat information different from the index, but with
    /// the same OID, the correct state information should be written into
    /// the index.
    ///
    /// If this flag is not enabled, the diff will always leave the index
    /// untouched.
    public static let gitDiffUpdateIndex                    = GitDiffOptionT(rawValue: GIT_DIFF_UPDATE_INDEX.rawValue)
    
    /// Include unreadable files in the diff.
    public static let gitDiffIncludeUnreadable              = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_UNREADABLE.rawValue)
    
    /// Include unreadable files in the diff as untracked.
    public static let gitDiffIncludeUnreadableAsUntracked   = GitDiffOptionT(rawValue: GIT_DIFF_INCLUDE_UNREADABLE_AS_UNTRACKED.rawValue)
    
    /// Use a heuristic that accounts for indentation and whitespace.
    ///
    /// ## Discussion
    ///
    /// This flag can generally produce better diffs when dealing with
    /// ambiguous diff hunks.
    public static let gitDiffIndentHeuristic                = GitDiffOptionT(rawValue: GIT_DIFF_INDENT_HEURISTIC.rawValue)
    
    /// Ignore blank lines.
    public static let gitDiffIgnoreBlankLines               = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_BLANK_LINES.rawValue)
    
    /// Treat all files as text, disabling binary attributes and detection.
    public static let gitDiffForceText                      = GitDiffOptionT(rawValue: GIT_DIFF_FORCE_TEXT.rawValue)
    
    /// Treat all files as binary, disabling text diffs.
    public static let gitDiffForceBinary                    = GitDiffOptionT(rawValue: GIT_DIFF_FORCE_BINARY.rawValue)
    
    /// Ignore all whitespace.
    public static let gitDiffIgnoreWhitespace               = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_WHITESPACE.rawValue)
    
    /// Ignore changes in the amount of whitespace.
    public static let gitDiffIgnoreWhitespaceChange         = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_WHITESPACE_CHANGE.rawValue)
    
    /// Ignore whitespace at the end of lines.
    public static let gitDiffIgnoreWhitespaceEOL            = GitDiffOptionT(rawValue: GIT_DIFF_IGNORE_WHITESPACE_EOL.rawValue)
    
    /// Include the content of untracked files when generating patch text.
    ///
    /// ## Discussion
    ///
    /// This flag will automatically disable ``gitDiffIncludeUntracked``, but
    /// will not automatically enable ``gitDiffRecurseUntrackedDirs``. Use the
    /// latter flag to add all untracked files in a directory as untracked
    /// entries.
    public static let gitDiffShowUntrackedContent           = GitDiffOptionT(rawValue: GIT_DIFF_SHOW_UNTRACKED_CONTENT.rawValue)
    
    /// Include the names of unmodified files when generating output, if the
    /// files are included in the diff.
    ///
    /// ## Discussion
    ///
    /// Normally, unmodified files are skipped in the formats that list files
    /// (for example, name-only, name-status, and raw). Even if this flag is
    /// enabled, these files will not be included in patch format.
    public static let gitDiffShowUnmodified                 = GitDiffOptionT(rawValue: GIT_DIFF_SHOW_UNMODIFIED.rawValue)
    
    /// Use the "patience diff" algorithm.
    public static let gitDiffPatience                       = GitDiffOptionT(rawValue: GIT_DIFF_PATIENCE.rawValue)
    
    /// Take extra time to find the minimal diff.
    public static let gitDiffMinimal                        = GitDiffOptionT(rawValue: GIT_DIFF_MINIMAL.rawValue)
    
    /// Include the necessary deflate/delta information so the apply process
    /// can apply the given diff information to binary files.
    public static let gitDiffShowBinary                     = GitDiffOptionT(rawValue: GIT_DIFF_SHOW_BINARY.rawValue)
    
    
    
    /// Converts the ``GitDiffOptionT`` instance into a `git_diff_option_t`
    /// instance.
    /// - Returns: The `git_diff_option_t` instance.
    internal func cValue() -> git_diff_option_t
    {
        return git_diff_option_t(rawValue)
    }
}



/// The flags for the delta object and the file objects on each side of the
/// delta.
///
/// ## Discussion
///
/// These flags are used for both the ``GitDiffDelta/flags`` property of
/// ``GitDiffDelta`` and the ``GitDiffFile/flags`` property of ``GitDiffFile``
/// that represent the old and new sides of the delta.
///
/// Values outside of the public supported range are reserved for internal or
/// future use.
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
    
    
    
    /// Creates a ``GitDiffFlagT`` instance from a `git_diff_flag_t` instance.
    /// - Parameter diffFlag: The `git_diff_flag_t` instance to use.
    internal init(
        cValue diffFlag: git_diff_flag_t
    )
    {
        self.rawValue = diffFlag.rawValue
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
    
    
    
    /// Converts the ``GitDiffFlagT`` instance into a `git_diff_flag_t`
    /// instance.
    /// - Returns: The `git_diff_flag_t` instance.
    internal func cValue() -> git_diff_flag_t
    {
        return git_diff_flag_t(rawValue)
    }
}



/// The type of change described by a diff delta.
///
/// ## Discussion
///
/// ``gitDeltaRenamed`` and ``gitDeltaCopied`` will only appear if
/// ``gitDiffFindSimilar(diff:options:)`` is called on the diff.
///
/// ``gitDeltaTypeChange`` will only appear if
/// ``GitDiffOptionT/gitDiffIncludeTypeChange`` is included in the option flags,
/// otherwise type changes will be split into add/delete pairs.
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
    
    /// The type of the entry changed between the old version and the new
    /// version.
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
    
    
    
    /// Converts the ``GitDeltaT`` instance into a `git_delta_t` instance.
    /// - Returns: The `git_delta_t` instance.
    internal func cValue() -> git_delta_t
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



/// The type of binary data.
///
/// ## Discussion
///
/// When producing a binary diff, the returned binary data will be the smaller
/// of the deflated full (literal) content of the file, or the deflated binary
/// data between the two sides.
///
/// ## C Equivalent
///
/// [`git_diff_binary_t`](https://libgit2.org/docs/reference/main/diff/git_diff_binary_t.html)
public enum GitDiffBinaryT: UInt32, GitEnum
{
    /// There is no binary delta.
    case gitDiffBinaryNone      = 0
    
    /// The binary delta is the deflated full (literal) content of the file.
    case gitDiffBinaryLiteral   = 1
    
    /// The binary data is the deflated delta between the two sides.
    case gitDiffBinaryDelta     = 2
    
    
    
    /// Creates a ``GitDiffBinaryT`` instance from a `git_diff_binary_t`
    /// instance.
    /// - Parameter diffBinary: The `git_diff_binary_t` instance to use.
    internal init?(
        cValue diffBinary: git_diff_binary_t
    )
    {
        switch diffBinary
        {
            case GIT_DIFF_BINARY_NONE       : self = .gitDiffBinaryNone
            case GIT_DIFF_BINARY_LITERAL    : self = .gitDiffBinaryLiteral
            case GIT_DIFF_BINARY_DELTA      : self = .gitDiffBinaryDelta
            default                         : return nil
        }
    }
    
    
    
    /// Converts the ``GitDiffBinaryT`` instance into a `git_diff_binary_t`
    /// instance.
    /// - Returns: The `git_diff_binary_t` instance.
    internal func cValue() -> git_diff_binary_t
    {
        switch self
        {
            case .gitDiffBinaryNone     : return GIT_DIFF_BINARY_NONE
            case .gitDiffBinaryLiteral  : return GIT_DIFF_BINARY_LITERAL
            case .gitDiffBinaryDelta    : return GIT_DIFF_BINARY_DELTA
        }
    }
}



/// The type of line origin.
///
/// ## C Equivalent
///
/// [`git_diff_line_t`](https://libgit2.org/docs/reference/main/diff/git_diff_line_t.html)
public enum GitDiffLineT: UInt32, GitEnum
{
    /// The line is unchanged and shown as context.
    case gitDiffLineContext         = 32
    
    /// The line was added in the new file.
    case gitDiffLineAddition        = 43
    
    /// The line was deleted from the old file.
    case gitDiffLineDeletion        = 45
    
    /// Both files have no LF at the end.
    case gitDiffLineContextEOFNL    = 61
    
    /// The old file has no LF at the end, but the new file does.
    case gitDiffLineAddEOFNL        = 62
    
    /// The new file has no LF at the end, but the old file does.
    case gitDiffLineDelEOFNL        = 60
    
    /// The line is part of a file header.
    case gitDiffLineFileHDR         = 70
    
    /// The line is part of a hunk header.
    case gitDiffLineHunkHDR         = 72
    
    /// The binary files are different.
    case gitDiffLineBinary          = 66
    
    
    
    /// Creates a ``GitDiffLineT`` instance from a `git_diff_line_t` instance.
    /// - Parameter diffLine: The `git_diff_line_t` instance to use.
    internal init?(
        cValue diffLine: git_diff_line_t
    )
    {
        switch diffLine
        {
            case GIT_DIFF_LINE_CONTEXT          : self = .gitDiffLineContext
            case GIT_DIFF_LINE_ADDITION         : self = .gitDiffLineAddition
            case GIT_DIFF_LINE_DELETION         : self = .gitDiffLineDeletion
            case GIT_DIFF_LINE_CONTEXT_EOFNL    : self = .gitDiffLineContextEOFNL
            case GIT_DIFF_LINE_ADD_EOFNL        : self = .gitDiffLineAddEOFNL
            case GIT_DIFF_LINE_DEL_EOFNL        : self = .gitDiffLineDelEOFNL
            case GIT_DIFF_LINE_FILE_HDR         : self = .gitDiffLineFileHDR
            case GIT_DIFF_LINE_HUNK_HDR         : self = .gitDiffLineHunkHDR
            case GIT_DIFF_LINE_BINARY           : self = .gitDiffLineBinary
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitDiffLineT`` instance into a `git_diff_line_t`
    /// instance.
    /// - Returns: The `git_diff_line_t` instance.
    internal func cValue() -> git_diff_line_t
    {
        switch self
        {
            case .gitDiffLineContext        : return GIT_DIFF_LINE_CONTEXT
            case .gitDiffLineAddition       : return GIT_DIFF_LINE_ADDITION
            case .gitDiffLineDeletion       : return GIT_DIFF_LINE_DELETION
            case .gitDiffLineContextEOFNL   : return GIT_DIFF_LINE_CONTEXT_EOFNL
            case .gitDiffLineAddEOFNL       : return GIT_DIFF_LINE_ADD_EOFNL
            case .gitDiffLineDelEOFNL       : return GIT_DIFF_LINE_DEL_EOFNL
            case .gitDiffLineFileHDR        : return GIT_DIFF_LINE_FILE_HDR
            case .gitDiffLineHunkHDR        : return GIT_DIFF_LINE_HUNK_HDR
            case .gitDiffLineBinary         : return GIT_DIFF_LINE_BINARY
        }
    }
}



/// The flags controlling diff rename and copy detection.
///
/// ## C Equivalent
///
/// [`git_diff_find_t`](https://libgit2.org/docs/reference/main/diff/git_diff_find_t.html)
public struct GitDiffFindT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitDiffFindT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitDiffFindT`` instance from a `git_diff_find_t` instance.
    /// - Parameter diffFind: The `git_diff_find_t` instance to use.
    internal init(
        cValue diffFind: git_diff_find_t
    )
    {
        self.rawValue = diffFind.rawValue
    }
    
    
    
    /// Obey `diff.renames`.
    ///
    /// ## Discussion
    ///
    /// This is the default value. This flag will be overridden by any other
    /// flag.
    public static let gitDiffFindByConfig                   = GitDiffFindT(rawValue: GIT_DIFF_FIND_BY_CONFIG.rawValue)
    
    /// Look for renames.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --find-renames`.
    public static let gitDiffFindRenames                    = GitDiffFindT(rawValue: GIT_DIFF_FIND_RENAMES.rawValue)
    
    /// Consider the old side of modified files for renames.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --break-rewrites=N`.
    public static let gitDiffFindRenamesFromRewrites        = GitDiffFindT(rawValue: GIT_DIFF_FIND_RENAMES_FROM_REWRITES.rawValue)
    
    /// Look for copies.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --find-copies`.
    public static let gitDiffFindCopies                     = GitDiffFindT(rawValue: GIT_DIFF_FIND_COPIES.rawValue)
    
    /// Consider unmodified files as copy sources.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --find-copies-harder`.
    ///
    /// For this flag to work correctly, use
    /// ``GitDiffOptionT/gitDiffIncludeUnmodified`` when the initial diff is
    /// being generated.
    public static let gitDiffFindCopiesFromUnmodified       = GitDiffFindT(rawValue: GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED.rawValue)
    
    /// Mark significant rewrites for split.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --break-rewrites=/M`.
    public static let gitDiffFindRewrites                   = GitDiffFindT(rawValue: GIT_DIFF_FIND_REWRITES.rawValue)
    
    /// Split large rewrites into add/delete pairs.
    public static let gitDiffBreakRewrites                  = GitDiffFindT(rawValue: GIT_DIFF_BREAK_REWRITES.rawValue)
    
    /// Mark rewrites for splitting, and break them into add/delete pairs.
    public static let gitDiffFindAndBreakRewrites           = GitDiffFindT(rawValue: GIT_DIFF_FIND_AND_BREAK_REWRITES.rawValue)
    
    /// Find renames and copies for untracked files in the working directory.
    ///
    /// ## Discussion
    ///
    /// For this flag to work correctly, use
    /// ``GitDiffOptionT/gitDiffIncludeUntracked`` when the initial diff is
    /// being generated. The diff must be against the working directory for
    /// this flag to make sense.
    public static let gitDiffFindForUntracked               = GitDiffFindT(rawValue: GIT_DIFF_FIND_FOR_UNTRACKED.rawValue)
    
    /// Turn on all finding features.
    public static let gitDiffFindAll                        = GitDiffFindT(rawValue: GIT_DIFF_FIND_ALL.rawValue)
    
    /// Measure similarity ignoring leading whitespace.
    public static let gitDiffFindIgnoreLeadingWhitespace    = GitDiffFindT(rawValue: GIT_DIFF_FIND_IGNORE_LEADING_WHITESPACE.rawValue)
    
    /// Measure similarity ignoring all whitespace.
    public static let gitDiffFindIgnoreWhitespace           = GitDiffFindT(rawValue: GIT_DIFF_FIND_IGNORE_WHITESPACE.rawValue)
    
    /// Measure similarity including all data.
    public static let gitDiffFindDoNotIgnoreWhitespace      = GitDiffFindT(rawValue: GIT_DIFF_FIND_DONT_IGNORE_WHITESPACE.rawValue)
    
    /// Measure similarity only by comparing SHAs.
    ///
    /// ## Discussion
    ///
    /// This flag enabled fast and computationally cheap similarity measurement.
    public static let gitDiffFindExactMatchOnly             = GitDiffFindT(rawValue: GIT_DIFF_FIND_EXACT_MATCH_ONLY.rawValue)
    
    /// Do not break rewrites unless they contribute to a rename.
    ///
    /// ## Discussion
    ///
    /// Normally, the ``gitDiffFindAndBreakRewrites`` flag will measure the
    /// self-similarity of modified files, and split the ones that have changed
    /// significantly into an add/delete pair. Then, the sides of that pair
    /// will be considered candidates for rename and copy detection.
    ///
    /// If this flag is enabled, and the split pair is not used for an actual
    /// rename or copy, then the modified record will be restored to a regular
    /// modified record instead of being split.
    public static let gitDiffBreakRewritesForRenamesOnly    = GitDiffFindT(rawValue: GIT_DIFF_BREAK_REWRITES_FOR_RENAMES_ONLY.rawValue)
    
    /// Remove any unmodified deltas after the similarity measurement is done.
    ///
    /// ## Discussion
    ///
    /// Using the ``gitDiffFindCopiesFromUnmodified`` flag to emulate the
    /// behavior of `git diff --find-copies-harder` requires building a diff
    /// with the ``GitDiffOptionT/gitDiffIncludeUnmodified`` flag enabled.
    ///
    /// Use this flag to have unmodified records removed from the final result.
    public static let gitDiffFindRemoveUnmodified           = GitDiffFindT(rawValue: GIT_DIFF_FIND_REMOVE_UNMODIFIED.rawValue)
    
    
    
    /// Converts the ``GitDiffFindT`` instance into a `git_diff_find_t`
    /// instance.
    /// - Returns: The `git_diff_find_t` instance.
    internal func cValue() -> git_diff_find_t
    {
        return git_diff_find_t(rawValue)
    }
}



/// The possible diff data output formats.
///
/// ## C Equivalent
///
/// [`git_diff_format_t`](https://libgit2.org/docs/reference/main/diff/git_diff_format_t.html)
public enum GitDiffFormatT: UInt32, GitEnum
{
    /// Show the full Git diff.
    case gitDiffFormatPatch         = 1
    
    /// Show just the file headers of the patch.
    case gitDiffFormatPatchHeader   = 2
    
    /// Show the raw diff.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --raw`.
    case gitDiffFormatRaw           = 3
    
    /// Show only the name of each changed file in the post-image tree.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --name-only`.
    case gitDiffFormatNameOnly      = 4
    
    /// Show only the names and statuses of each changed file.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --name-status`.
    case gitDiffFormatNameStatus    = 5
    
    /// Show the normalized diff format used for computing patch IDs with
    /// `git patch-id`.
    case gitDiffFormatPatchID       = 6
    
    
    
    /// Creates a ``GitDiffFormatT`` instance from a `git_diff_format_t`
    /// instance.
    /// - Parameter diffFormat: The `git_diff_format_t` instance to use.
    internal init?(
        cValue diffFormat: git_diff_format_t
    )
    {
        switch diffFormat
        {
            case GIT_DIFF_FORMAT_PATCH          : self = .gitDiffFormatPatch
            case GIT_DIFF_FORMAT_PATCH_HEADER   : self = .gitDiffFormatPatchHeader
            case GIT_DIFF_FORMAT_RAW            : self = .gitDiffFormatRaw
            case GIT_DIFF_FORMAT_NAME_ONLY      : self = .gitDiffFormatNameOnly
            case GIT_DIFF_FORMAT_NAME_STATUS    : self = .gitDiffFormatNameStatus
            case GIT_DIFF_FORMAT_PATCH_ID       : self = .gitDiffFormatPatchID
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitDiffFormatT`` instance into a `git_diff_format_t`
    /// instance.
    /// - Returns: The `git_diff_format_t` instance.
    internal func cValue() -> git_diff_format_t
    {
        switch self
        {
            case .gitDiffFormatPatch        : return GIT_DIFF_FORMAT_PATCH
            case .gitDiffFormatPatchHeader  : return GIT_DIFF_FORMAT_PATCH_HEADER
            case .gitDiffFormatRaw          : return GIT_DIFF_FORMAT_RAW
            case .gitDiffFormatNameOnly     : return GIT_DIFF_FORMAT_NAME_ONLY
            case .gitDiffFormatNameStatus   : return GIT_DIFF_FORMAT_NAME_STATUS
            case .gitDiffFormatPatchID      : return GIT_DIFF_FORMAT_PATCH_ID
        }
    }
}



/// The flags controlling the formatting of diff statistics.
///
/// ## C Equivalent
///
/// [`git_diff_stats_format_t`](https://libgit2.org/docs/reference/main/diff/git_diff_stats_format_t.html)
public struct GitDiffStatsFormatT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitDiffStatsFormatT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitDiffStatsFormatT`` instance from a
    /// `git_diff_stats_format_t` instance.
    /// - Parameter diffStatsFormat: The `git_diff_stats_format_t` instance
    /// to use.
    internal init(
        cValue diffStatsFormat: git_diff_stats_format_t
    )
    {
        self.rawValue = diffStatsFormat.rawValue
    }
    
    
    
    /// Generate no statistics.
    public static let gitDiffStatsNone              = GitDiffStatsFormatT(rawValue: GIT_DIFF_STATS_NONE.rawValue)
    
    /// Generate full statistics.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --stat`.
    public static let gitDiffStatsFull              = GitDiffStatsFormatT(rawValue: GIT_DIFF_STATS_FULL.rawValue)
    
    /// Generate short statistics.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --shortstat`.
    public static let gitDiffStatsShort             = GitDiffStatsFormatT(rawValue: GIT_DIFF_STATS_SHORT.rawValue)
    
    /// Generate number statistics.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --numstat`.
    public static let gitDiffStatsNumber            = GitDiffStatsFormatT(rawValue: GIT_DIFF_STATS_NUMBER.rawValue)
    
    /// Generate a concise summary of extended header information, such as
    /// creations, renames, and mode changes.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git diff --summary`.
    public static let gitDiffStatsIncludeSummary    = GitDiffStatsFormatT(rawValue: GIT_DIFF_STATS_INCLUDE_SUMMARY.rawValue)
    
    
    
    /// Converts the ``GitDiffStatsFormatT`` instance into a
    /// `git_diff_stats_format_t` instance.
    /// - Returns: The `git_diff_stats_format_t` instance.
    internal func cValue() -> git_diff_stats_format_t
    {
        return git_diff_stats_format_t(rawValue)
    }
}
