//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of the blame operation.
///
/// ## C Equivalent
///
/// [`git_blame_flag_t`](https://libgit2.org/docs/reference/main/blame/git_blame_flag_t.html)
public struct GitBlameFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitBlameFlagT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitBlameFlagT`` instance from the given
    /// `git_blame_flag_t` instance.
    /// - Parameter blameFlag: The `git_blame_flag_t` instance to use.
    internal init(
        cValue blameFlag: git_blame_flag_t
    )
    {
        self.rawValue = blameFlag.rawValue
    }
    
    
    
    /// Use the default blame behavior.
    public static let gitBlameNormal                        = GitBlameFlagT(rawValue: GIT_BLAME_NORMAL.rawValue)
    
    /// Track lines that have moved within a file.
    ///
    /// This is the equivalent of `git blame -M`.
    ///
    /// - Note: This has not been implemented in libgit2 yet, but is reserved
    /// for future use.
    public static let gitBlameTrackCopiesSameFile           = GitBlameFlagT(rawValue: GIT_BLAME_TRACK_COPIES_SAME_FILE.rawValue)
    
    /// Track lines that have moved across files in the same commit.
    ///
    /// This is the equivalent of `git blame -C`.
    ///
    /// - Note: This has not been implemented in libgit2 yet, but is reserved
    /// for future use.
    public static let gitBlameTrackCopiesSameCommitMoves    = GitBlameFlagT(rawValue: GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES.rawValue)
    
    /// Track lines that have been copied from another file that exists in the
    /// same commit.
    ///
    /// This is the equivalent of `git blame -CC`, and implies
    /// ``gitBlameTrackCopiesSameFile``.
    ///
    /// - Note: This has not been implemented in libgit2 yet, but is reserved
    /// for future use.
    public static let gitBlameTrackCopiesSameCommitCopies   = GitBlameFlagT(rawValue: GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES.rawValue)
    
    /// Track lines that have been copied from another file that exists in
    /// any commit.
    ///
    /// This is the equivalent of `git blame -CCC`, and implies
    /// ``gitBlameTrackCopiesSameCommitCopies``.
    ///
    /// - Note: This has not been implemented in libgit2 yet, but is reserved
    /// for future use.
    public static let gitBlameTrackCopiesAnyCommitCopies    = GitBlameFlagT(rawValue: GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES.rawValue)
    
    /// Restrict the search of commits to those reachable by following only
    /// the first parents.
    public static let gitBlameFirstParent                   = GitBlameFlagT(rawValue: GIT_BLAME_FIRST_PARENT.rawValue)
    
    /// Use the mailmap file to map author and committer names and email
    /// addresses to canonical real names and email addresses.
    ///
    /// The mailmap file will be read from the working directory, or from
    /// HEAD in a bare repository.
    public static let gitBlameUseMailmap                    = GitBlameFlagT(rawValue: GIT_BLAME_USE_MAILMAP.rawValue)
    
    /// Ignore whitespace differences.
    public static let gitBlameIgnoreWhitespace              = GitBlameFlagT(rawValue: GIT_BLAME_IGNORE_WHITESPACE.rawValue)
    
    
    
    /// Converts the ``GitBlameFlagT`` instance into a `git_blame_flag_t`
    /// instance.
    /// - Returns: The `git_blame_flag_t` instance.
    internal func cValue() -> git_blame_flag_t
    {
        return git_blame_flag_t(rawValue)
    }
}
