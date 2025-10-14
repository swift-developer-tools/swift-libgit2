//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_flag_t`](https://libgit2.org/docs/reference/main/merge/git_merge_flag_t.html)
public struct GitMergeFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitMergeFlagT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitMergeFlagT`` instance from a `git_merge_flag_t` instance.
    /// - Parameter mergeFlag: The `git_merge_flag_t` instance to use.
    internal init(
        cValue mergeFlag: git_merge_flag_t
    )
    {
        self.rawValue = mergeFlag.rawValue
    }
    
    
    
    /// Detect renames that occur between the common ancestor and "our" side,
    /// or the common ancestor and "their" side.
    ///
    /// ## Discussion
    ///
    /// This flag enables the ability to merge between a modified and renamed
    /// file.
    public static let gitMergeFindRenames       = GitMergeFlagT(rawValue: GIT_MERGE_FIND_RENAMES.rawValue)
    
    /// If a conflict occurs, exit immediately instead of attempting to
    /// continue resolving conflicts.
    ///
    /// ## Discussion
    ///
    /// If a conflict occurs, the merge operation will fail with ``GitErrorCode/gitEMergeConflict``,
    /// and no index will be returned.
    public static let gitMergeFailOnConflict    = GitMergeFlagT(rawValue: GIT_MERGE_FAIL_ON_CONFLICT.rawValue)
    
    /// Do not write the `REUC` extension on the generated index.
    public static let gitMergeSkipREUC          = GitMergeFlagT(rawValue: GIT_MERGE_SKIP_REUC.rawValue)
    
    /// If the commits being merged have multiple merge bases, do not build a
    /// recursive merge base (by merging the multiple merge bases), instead
    /// simply use the first base.
    ///
    /// ## Discussion
    ///
    /// This flag provides a similar merge base to `git-merge-resolve`.
    public static let gitMergeNoRecursive       = GitMergeFlagT(rawValue: GIT_MERGE_NO_RECURSIVE.rawValue)
    
    /// Treat this merge as if it will produce the virtual base of a recursive
    /// merge.
    ///
    /// ## Discussion
    ///
    /// This flag will ensure that there are no conflicts. Any conflicting
    /// regions will keep conflict markers in the merge result.
    public static let gitMergeVirtualBase       = GitMergeFlagT(rawValue: GIT_MERGE_VIRTUAL_BASE.rawValue)
    
    
    
    /// Converts the ``GitMergeFlagT`` instance into a `git_merge_flag_t`
    /// instance.
    /// - Returns: The `git_merge_flag_t` instance.
    internal func cValue() -> git_merge_flag_t
    {
        return git_merge_flag_t(rawValue)
    }
}



/// How to handle conflicting file regions during file-level merge operations.
///
/// ## C Equivalent
///
/// [`git_merge_file_favor_t`](https://libgit2.org/docs/reference/main/merge/git_merge_file_favor_t.html)
public enum GitMergeFileFavorT: UInt32, CEnum
{
    /// When a region of a file is changed in both branches, a conflict will
    /// be recorded in the index so that the checkout operation can produce a
    /// merge file with conflict markers in the working directory.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    case gitMergeFileFavorNormal    = 0
    
    /// When a region of a file is changed in both branches, the file created
    /// in the index will contain "our" side of any conflicting region.
    /// The index will not record a conflict.
    case gitMergeFileFavorOurs      = 1
    
    /// When a region of a file is changed in both branches, the file created
    /// in the index will contain "their" side of any conflicting region.
    /// The index will not record a conflict.
    case gitMergeFileFavorTheirs    = 2
    
    /// When a region of a file is changed in both branches, the file created
    /// in the index will contain each unique line from each side, which has
    /// the result of combining both files. The index will not record a
    /// conflict.
    case gitMergeFileFavorUnion     = 3
    
    
    
    /// Creates a ``GitMergeFileFavorT`` instance from a
    /// `git_merge_file_favor_t` instance.
    /// - Parameter mergeFileFavor: The `git_merge_file_favor_t` instance to
    /// use.
    internal init?(
        cValue mergeFileFavor: git_merge_file_favor_t
    )
    {
        switch mergeFileFavor
        {
            case GIT_MERGE_FILE_FAVOR_NORMAL    : self = .gitMergeFileFavorNormal
            case GIT_MERGE_FILE_FAVOR_OURS      : self = .gitMergeFileFavorOurs
            case GIT_MERGE_FILE_FAVOR_THEIRS    : self = .gitMergeFileFavorTheirs
            case GIT_MERGE_FILE_FAVOR_UNION     : self = .gitMergeFileFavorUnion
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitMergeFileFavorT`` instance into a
    /// `git_merge_file_favor_t` instance.
    /// - Returns: The `git_merge_file_favor_t` instance.
    internal func cValue() -> git_merge_file_favor_t
    {
        switch self
        {
            case .gitMergeFileFavorNormal   : return GIT_MERGE_FILE_FAVOR_NORMAL
            case .gitMergeFileFavorOurs     : return GIT_MERGE_FILE_FAVOR_OURS
            case .gitMergeFileFavorTheirs   : return GIT_MERGE_FILE_FAVOR_THEIRS
            case .gitMergeFileFavorUnion    : return GIT_MERGE_FILE_FAVOR_UNION
        }
    }
}



/// The flags controlling the behavior of the file-merging operation.
///
/// ## C Equivalent
///
/// [`git_merge_file_flag_t`](https://libgit2.org/docs/reference/main/merge/git_merge_file_flag_t.html)
public struct GitMergeFileFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitMergeFileFlagT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitMergeFileFlagT`` instance from a `git_merge_file_flag_t`
    /// instance.
    /// - Parameter mergeFileFlag: The `git_merge_file_flag_t` instance to use.
    internal init(
        cValue mergeFileFlag: git_merge_file_flag_t
    )
    {
        self.rawValue = mergeFileFlag.rawValue
    }
    
    
    
    /// The default merge behavior.
    public static let gitMergeFileDefault                   = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_DEFAULT.rawValue)
    
    /// Create standard conflicted merge files.
    public static let gitMergeFileStyleMerge                = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_STYLE_MERGE.rawValue)
    
    /// Create files in `diff3` format.
    public static let gitMergeFileStyleDiff3                = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_STYLE_DIFF3.rawValue)
    
    /// Condense non-alphanumeric regions for simplified diff files.
    public static let gitMergeFileSimplifyAlnum             = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_SIMPLIFY_ALNUM.rawValue)
    
    /// Ignore all whitespace.
    public static let gitMergeFileIgnoreWhitespace          = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_IGNORE_WHITESPACE.rawValue)
    
    /// Ignore changes in amount of whitespace.
    public static let gitMergeFileIgnoreWhitespaceChange    = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_IGNORE_WHITESPACE_CHANGE.rawValue)
    
    /// Ignore whitespace at the ends of lines.
    public static let gitMergeFileIgnoreWhitespaceEOL       = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_IGNORE_WHITESPACE_EOL.rawValue)
    
    /// Use the "patience diff" algorithm.
    public static let gitMergeFileDiffPatience              = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_DIFF_PATIENCE.rawValue)
    
    /// Take extra time to find minimal diff.
    public static let gitMergeFileDiffMinimal               = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_DIFF_MINIMAL.rawValue)
    
    /// Create files in `zdiff3` format.
    public static let gitMergeFileStyleZDiff3               = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_STYLE_ZDIFF3.rawValue)
    
    /// Do not produce file conflicts when common regions have changed.
    /// Instead, keep the conflict markers in the file and accept that as the
    /// merge result.
    public static let gitMergeFileAcceptConflicts           = GitMergeFileFlagT(rawValue: GIT_MERGE_FILE_ACCEPT_CONFLICTS.rawValue)
    
    
    
    /// Converts the ``GitMergeFileFlagT`` instance into a
    /// `git_merge_file_flag_t` instance.
    /// - Returns: The `git_merge_file_flag_t` instance.
    internal func cValue() -> git_merge_file_flag_t
    {
        return git_merge_file_flag_t(rawValue)
    }
}



/// The flags indicating the merge opportunities.
///
/// ## C Equivalent
///
/// [`git_merge_analysis_t`](https://libgit2.org/docs/reference/main/merge/git_merge_analysis_t.html)
public struct GitMergeAnalysisT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitMergeAnalysisT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitMergeAnalysisT`` instance from a `git_merge_analysis_t`
    /// instance.
    /// - Parameter mergeAnalysis: The `git_merge_analysis_t` instance to use.
    internal init(
        cValue mergeAnalysis: git_merge_analysis_t
    )
    {
        self.rawValue = mergeAnalysis.rawValue
    }
    
    
    
    /// No merge is possible.
    ///
    /// ## Discussion
    ///
    /// This flag is unused.
    public static let gitMergeAnalysisNone          = GitMergeAnalysisT(rawValue: GIT_MERGE_ANALYSIS_NONE.rawValue)
    
    /// Both HEAD and the given merge input have diverged from their common
    /// ancestor, and must be merged.
    public static let gitMergeAnalysisNormal        = GitMergeAnalysisT(rawValue: GIT_MERGE_ANALYSIS_NORMAL.rawValue)
    
    /// All given merge inputs are reachable from HEAD, and no merge is
    /// necessary.
    public static let gitMergeAnalysisUpToDate      = GitMergeAnalysisT(rawValue: GIT_MERGE_ANALYSIS_UP_TO_DATE.rawValue)
    
    /// The given merge input is a fast-forward from HEAD, and no merge is
    /// necessary.
    ///
    /// ## Discussion
    ///
    /// In this case, the caller may check out the given merge input.
    public static let gitMergeAnalysisFastForward   = GitMergeAnalysisT(rawValue: GIT_MERGE_ANALYSIS_FASTFORWARD.rawValue)
    
    /// The HEAD of the current repository is unborn and does not point to a
    /// valid commit, and no merge can be performed.
    ///
    /// ## Discussion
    ///
    /// In this case, the caller may set HEAD to the target commit(s).
    public static let gitMergeAnalysisUnborn        = GitMergeAnalysisT(rawValue: GIT_MERGE_ANALYSIS_UNBORN.rawValue)
    
    
    
    /// Converts the ``GitMergeAnalysisT`` instance into a
    /// `git_merge_analysis_t` instance.
    /// - Returns: The `git_merge_analysis_t` instance.
    internal func cValue() -> git_merge_analysis_t
    {
        return git_merge_analysis_t(rawValue)
    }
}



/// The flags indicating the merge opportunities.
///
/// ## C Equivalent
///
/// [`git_merge_preference_t`](https://libgit2.org/docs/reference/main/merge/git_merge_preference_t.html)
public struct GitMergePreferenceT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitMergePreferenceT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitMergePreferenceT`` instance from a
    /// `git_merge_preference_t` instance.
    /// - Parameter mergePreference: The `git_merge_preference_t` instance
    /// to use.
    internal init(
        cValue mergePreference: git_merge_preference_t
    )
    {
        self.rawValue = mergePreference.rawValue
    }
    
    
    
    /// No configuration was found that suggested preferred merge behavior.
    public static let gitMergePreferenceNone                = GitMergePreferenceT(rawValue: GIT_MERGE_PREFERENCE_NONE.rawValue)
    
    /// There is a `merge.ff=false` configuration setting, suggesting that
    /// fast-forward merges are not allowed.
    public static let gitMergePreferenceNoFastForward       = GitMergePreferenceT(rawValue: GIT_MERGE_PREFERENCE_NO_FASTFORWARD.rawValue)
    
    /// There is a `merge.ff=only` configuration setting, suggesting that
    /// only fast-foward merges are allowed.
    public static let gitMergePreferenceFastForwardOnly     = GitMergePreferenceT(rawValue: GIT_MERGE_PREFERENCE_FASTFORWARD_ONLY.rawValue)
    
    
    
    /// Converts the ``GitMergePreferenceT`` instance into a
    /// `git_merge_preference_t` instance.
    /// - Returns: The `git_merge_preference_t` instance.
    internal func cValue() -> git_merge_preference_t
    {
        return git_merge_preference_t(rawValue)
    }
}
