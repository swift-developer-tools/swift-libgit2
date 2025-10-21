//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of pathspec matching.
///
/// ## C Equivalent
///
/// [`git_pathspec_flag_t`](https://libgit2.org/docs/reference/main/pathspec/git_pathspec_flag_t.html)
public struct GitPathspecFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitPathspecFlagT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitPathspecFlagT`` instance from the given
    /// `git_pathspec_flag_t` instance.
    /// - Parameter pathspecFlag: The `git_pathspec_flag_t` instance to use.
    internal init(
        cValue pathspecFlag: git_pathspec_flag_t
    )
    {
        self.rawValue = pathspecFlag.rawValue
    }
    
    
    
    /// Use the default behavior.
    public static let gitPathspecDefault        = GitPathspecFlagT(rawValue: GIT_PATHSPEC_DEFAULT.rawValue)
    
    /// Force case-insensitive matching.
    ///
    /// ## Discussion
    ///
    /// If this flag is not enabled, the native filesystem case match
    /// sensitivity will be used.
    public static let gitPathspecIgnoreCase     = GitPathspecFlagT(rawValue: GIT_PATHSPEC_IGNORE_CASE.rawValue)
    
    /// Force case-sensitive matching.
    ///
    /// ## Discussion
    ///
    /// If this flag is not enabled, the native filesystem case match
    /// sensitivity will be used.
    public static let gitPathspecUseCase        = GitPathspecFlagT(rawValue: GIT_PATHSPEC_USE_CASE.rawValue)
    
    /// Disable glob patterns and use simple string comparison matching.
    public static let gitPathspecNoGlob         = GitPathspecFlagT(rawValue: GIT_PATHSPEC_NO_GLOB.rawValue)
    
    /// Return an error code if no match is found.
    public static let gitPathspecNoMatchError   = GitPathspecFlagT(rawValue: GIT_PATHSPEC_NO_MATCH_ERROR.rawValue)
    
    /// Track which patterns matched while files, and identify patterns that
    /// did not match any files.
    public static let gitPathspecFindFailures   = GitPathspecFlagT(rawValue: GIT_PATHSPEC_FIND_FAILURES.rawValue)
    
    /// Do not keep the matching filenames.
    ///
    /// ## Discussion
    ///
    /// This flag can be used to test if there were any matches at all, or in
    /// combination with ``gitPathspecFindFailures`` to validate a pathspec.
    public static let gitPathspecFailuresOnly   = GitPathspecFlagT(rawValue: GIT_PATHSPEC_FAILURES_ONLY.rawValue)
    
    
    
    /// Converts the ``GitPathspecFlagT`` instance into a `git_pathspec_flag_t`
    /// instance.
    /// - Returns: The `git_pathspec_flag_t` instance.
    internal func cValue() -> git_pathspec_flag_t
    {
        return git_pathspec_flag_t(rawValue)
    }
}
