//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation



/// The options for the blame process.
///
/// ## C Equivalent
///
/// [`git_blame_options`](https://libgit2.org/docs/reference/main/blame/git_blame_options.html)
public struct GitBlameOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitBlameOptionsVersion``.
    public var version              : UInt32
    
    /// The flags to use during the blame process.
    public var flags                : GitBlameFlagT
    
    /// The lower bound on the number of alphanumeric characters that must be detected as
    /// moving/copying within a file for it to associate those lines with the parent commit.
    ///
    /// ## Discussion
    ///
    /// The default value is `20`.
    ///
    /// This value only takes effect if any of
    /// ``GitBlameFlagT/gitBlameTrackCopiesSameFile``,
    /// ``GitBlameFlagT/gitBlameTrackCopiesSameCommitMoves``,
    /// ``GitBlameFlagT/gitBlameTrackCopiesSameCommitCopies``, or
    /// ``GitBlameFlagT/gitBlameTrackCopiesAnyCommitCopies`` are specified.
    public var minMatchCharacters   : UInt16?
    
    /// The ID of the newest commit to consider.
    ///
    /// ## Discussion
    ///
    /// The default value is HEAD.
    public var newestCommit         : GitOID
    
    /// The ID of the oldest commit to consider.
    ///
    /// ## Discussion
    ///
    /// The default value is the first commit encountered with a `NULL` parent.
    public var oldestCommit         : GitOID
    
    /// The first line in the file to blame.
    ///
    /// ## Discussion
    ///
    /// The default value is `1` (line numbers are 1-indexed).
    public var minLine              : Int?
    
    /// The last line in the file to blame.
    ///
    /// ## Discussion
    ///
    /// The default value is the last line of the file.
    public var maxLine              : Int?
    
    
    
    /// Creates a ``GitBlameOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to ``gitBlameOptionsVersion``.
    /// - Throws: An `NSError` if initialization failed.
    public init(
        version: UInt32 = gitBlameOptionsVersion
    ) throws(NSError)
    {
        var blameOptions = git_blame_options()
        
        let blameOptionsInitResult: Int32 = git_blame_options_init(
            &blameOptions,
            version
        )
        
        if blameOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError(
                domain:     "GitBlameOptions.\(#function)",
                code:       Int(blameOptionsInitResult),
                userInfo:   nil
            )
        }
        
        self.init(cValue: blameOptions)
    }
    
    
    
    /// Creates a ``GitBlameOptions`` instance from a `git_blame_options` instance.
    /// - Parameter blameOptions: The `git_blame_options` instance to use.
    internal init(
        cValue blameOptions: git_blame_options
    )
    {
        self.version                = blameOptions.version
        self.flags                  = GitBlameFlagT(rawValue: blameOptions.flags)
        self.minMatchCharacters     = nil
        self.newestCommit           = GitOID(cValue: blameOptions.newest_commit)
        self.oldestCommit           = GitOID(cValue: blameOptions.oldest_commit)
        self.minLine                = nil
        self.maxLine                = nil
    }
    
    
    
    /// The equivalent C value.
    ///
    /// ## Discussion
    ///
    /// This value will be `nil` if the initialization failed.
    internal var cValue: git_blame_options?
    {
        var blameOptions = git_blame_options()
        
        let blameOptionsInitResult: Int32 = git_blame_options_init(
            &blameOptions,
            version
        )
        
        if blameOptionsInitResult != GIT_OK.rawValue
        {
            return nil
        }
        
        blameOptions.flags          = flags.rawValue
        blameOptions.newest_commit  = newestCommit.cValue
        blameOptions.oldest_commit  = oldestCommit.cValue
        
        if let minMatchCharacters: UInt16 = minMatchCharacters
        {
            blameOptions.min_match_characters = minMatchCharacters
        }
        
        if let minLine: Int = minLine
        {
            blameOptions.min_line = minLine
        }
        
        if let maxLine: Int = maxLine
        {
            blameOptions.max_line = maxLine
        }
        
        return blameOptions
    }
}



/// A blame hunk.
///
/// ## C Equivalent
///
/// [`git_blame_hunk`](https://libgit2.org/docs/reference/main/blame/git_blame_hunk.html)
public struct GitBlameHunk
{
    /// The number of lines in this hunk.
    public let linesInHunk          : Int
    
    /// The OID of the commit where this hunk was last changed.
    public let finalCommitID        : GitOID
    
    /// The 1-indexed line number where this hunk begins, in the final version of the file.
    public let finalStartLineNumber : Int
    
    /// The author of ``GitBlameHunk/finalCommitID``.
    ///
    /// ## Discussion
    ///
    /// If ``GitBlameFlagT/gitBlameUseMailmap`` has been specified, this will contain the
    /// canonical real name and email address.
    public let finalSignature       : UnsafeMutablePointer<git_signature>?
    
    /// The committer of ``GitBlameHunk/finalCommitID``.
    ///
    /// ## Discussion
    ///
    /// If ``GitBlameFlagT/gitBlameUseMailmap`` has been specified, this will contain the
    /// canonical real name and email address.
    public let finalCommitter       : UnsafeMutablePointer<git_signature>?
    
    /// The OID of the commit where this hunk was found.
    ///
    /// ## Discussion
    ///
    /// This will usually be the same as ``GitBlameHunk/finalCommitID``, except when
    /// ``GitBlameFlagT/gitBlameTrackCopiesAnyCommitCopies`` has been specified.
    public let origCommitID         : GitOID
    
    /// The path to the file where this hunk originated, as of the commit specified by
    /// ``GitBlameHunk/origCommitID``.
    public let origPath             : String?
    
    /// The 1-indexed line number where this hunk begins in the file named by
    /// ``GitBlameHunk/origPath`` in the commit specified by
    /// ``GitBlameHunk/origCommitID``.
    public let origStartLineNumber  : Int
    
    /// The author of ``GitBlameHunk/origCommitID``.
    ///
    /// ## Discussion
    ///
    /// If ``GitBlameFlagT/gitBlameUseMailmap`` has been specified, this will contain the
    /// canonical real name and email address.
    public let origSignature        : UnsafeMutablePointer<git_signature>?
    
    /// The committer of ``GitBlameHunk/origCommitID``.
    ///
    /// ## Discussion
    ///
    /// If ``GitBlameFlagT/gitBlameUseMailmap`` has been specified, this will contain the
    /// canonical real name and email address.
    public let origCommitter        : UnsafeMutablePointer<git_signature>?
    
    /// The summary of the commit where this hunk was last changed.
    public let summary              : String?
    
    /// Whether this hunk was traced to a boundary commit.
    ///
    /// ## Discussion
    ///
    /// This value will be `true` if and only if the hunk has been tracked to a boundary commit
    /// (the root, or the commit specified in ``GitBlameOptions/oldestCommit``).
    /// Otherwise, it will be `false`.
    public let boundary             : Bool
    
    
    
    /// Creates a ``GitBlameHunk`` instance from a `git_blame_hunk` instance.
    /// - Parameter blameHunk: The `git_blame_hunk` instance to use.
    internal init(
        cValue blameHunk: git_blame_hunk
    )
    {
        self.linesInHunk            = blameHunk.lines_in_hunk
        self.finalCommitID          = GitOID(cValue: blameHunk.final_commit_id)
        self.finalStartLineNumber   = blameHunk.final_start_line_number
        self.finalSignature         = blameHunk.final_signature
        self.finalCommitter         = blameHunk.final_committer
        self.origCommitID           = GitOID(cValue: blameHunk.orig_commit_id)
        self.origPath               = blameHunk.orig_path.map { String(cString: $0 )}
        self.origStartLineNumber    = blameHunk.orig_start_line_number
        self.origSignature          = blameHunk.orig_signature
        self.origCommitter          = blameHunk.orig_committer
        self.summary                = blameHunk.summary.map { String(cString: $0 )}
        self.boundary               = blameHunk.boundary == 1
    }
}



/// A line in a blamed file.
///
/// ## C Equivalent
///
/// [`git_blame_line`](https://libgit2.org/docs/reference/main/blame/git_blame_line.html)
public struct GitBlameLine
{
    /// The line content.
    public let ptr : String?
    
    /// The length of the line content.
    public let len : Int
    
    
    
    /// Creates a ``GitBlameLine`` instance from a `git_blame_line` instance.
    /// - Parameter blameLine: The `git_blame_line` instance to use.
    internal init(
        cValue blameLine: git_blame_line
    )
    {
        self.ptr    = blameLine.ptr.map { String(cString: $0 )}
        self.len    = blameLine.len
    }
}
