//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// The options for the blame operation.
///
/// ## C Equivalent
///
/// [`git_blame_options`](https://libgit2.org/docs/reference/main/blame/git_blame_options.html)
public struct GitBlameOptions: GitStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitBlameOptionsVersion``.
    public var version              : UInt32            = gitBlameOptionsVersion
    
    /// The flags to use during the blame operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitBlameFlagT/gitBlameNormal``.
    public var flags                : GitBlameFlagT     = .gitBlameNormal
    
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
    public var minMatchCharacters   : UInt16            = 20
    
    /// The ID of the newest commit to consider.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using HEAD.
    public var newestCommit         : GitOID?           = nil
    
    /// The ID of the oldest commit to consider.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the first
    /// commit encountered with a `nil` parent.
    public var oldestCommit         : GitOID?           = nil
    
    /// The first line in the file to blame.
    ///
    /// ## Discussion
    ///
    /// The default value is `1` (line numbers are 1-indexed).
    public var minLine              : Int               = 1
    
    /// The last line in the file to blame.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using last line
    /// of the file.
    public var maxLine              : Int?              = nil
    
    
    
    /// Creates a ``GitBlameOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitBlameOptions`` instance from a `git_blame_options` instance.
    /// - Parameter blameOptions: The `git_blame_options` instance to use.
    internal init(
        cValue blameOptions: git_blame_options
    )
    {
        self.version                = blameOptions.version
        self.flags                  = GitBlameFlagT(rawValue: blameOptions.flags)
        self.minMatchCharacters     = 20
        self.newestCommit           = GitOID(cValue: blameOptions.newest_commit)
        self.oldestCommit           = GitOID(cValue: blameOptions.oldest_commit)
        self.minLine                = 1
        self.maxLine                = nil
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_blame_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_blame_options>) throws -> T
    ) throws -> T
    {
        var blameOptions = git_blame_options()
        
        let blameOptionsInitResult: Int32 = gitBlameOptionsInit(
            opts:       &blameOptions,
            version:    version
        )
        
        if blameOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.makeCConversionError()
        }
        
        blameOptions.flags                  = flags.rawValue
        blameOptions.newest_commit          = newestCommit?.cValue() ?? git_oid()
        blameOptions.oldest_commit          = oldestCommit?.cValue() ?? git_oid()
        blameOptions.min_match_characters   = minMatchCharacters
        blameOptions.min_line               = minLine
        
        if let maxLine: Int = maxLine
        {
            blameOptions.max_line = maxLine
        }
        
        return try body(&blameOptions)
    }
}



/// A blame hunk.
///
/// ## C Equivalent
///
/// [`git_blame_hunk`](https://libgit2.org/docs/reference/main/blame/git_blame_hunk.html)
public struct GitBlameHunk: GitStructReadable, WithCConvertible
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
    public let finalSignature       : GitSignature?
    
    /// The committer of ``GitBlameHunk/finalCommitID``.
    ///
    /// ## Discussion
    ///
    /// If ``GitBlameFlagT/gitBlameUseMailmap`` has been specified, this will contain the
    /// canonical real name and email address.
    public let finalCommitter       : GitSignature?
    
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
    public let origSignature        : GitSignature?
    
    /// The committer of ``GitBlameHunk/origCommitID``.
    ///
    /// ## Discussion
    ///
    /// If ``GitBlameFlagT/gitBlameUseMailmap`` has been specified, this will contain the
    /// canonical real name and email address.
    public let origCommitter        : GitSignature?
    
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
    ///
    /// ## Discussion
    ///
    /// - Warning: This initializer must not be called with a `git_blame_hunk` instance that
    /// was not created by libgit2, unless the signature fields have been set to non-`nil` values.
    /// Doing so will cause a crash when ``GitSignature.init(cValue:)`` tries to unwrap
    /// the `nil` signature fields.
    internal init(
        cValue blameHunk: git_blame_hunk
    )
    {
        self.linesInHunk            = blameHunk.lines_in_hunk
        self.finalCommitID          = GitOID(cValue: blameHunk.final_commit_id)
        self.finalStartLineNumber   = blameHunk.final_start_line_number
        self.finalSignature         = GitSignature(cValue: blameHunk.final_signature.pointee)
        self.finalCommitter         = GitSignature(cValue: blameHunk.final_committer.pointee)
        self.origCommitID           = GitOID(cValue: blameHunk.orig_commit_id)
        self.origPath               = String(optionalCString: blameHunk.orig_path)
        self.origStartLineNumber    = blameHunk.orig_start_line_number
        self.origSignature          = GitSignature(cValue: blameHunk.orig_signature.pointee)
        self.origCommitter          = GitSignature(cValue: blameHunk.orig_committer.pointee)
        self.summary                = String(optionalCString: blameHunk.summary)
        self.boundary               = Bool(blameHunk.boundary)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_blame_hunk` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_blame_hunk>) throws -> T
    ) throws -> T
    {
        var blameHunk = git_blame_hunk()
        
        blameHunk.lines_in_hunk             = linesInHunk
        blameHunk.final_commit_id           = finalCommitID.cValue()
        blameHunk.final_start_line_number   = finalStartLineNumber
        blameHunk.orig_commit_id            = origCommitID.cValue()
        blameHunk.orig_start_line_number    = origStartLineNumber
        blameHunk.boundary                  = CChar(boundary.intValue)
        
        return try finalSignature.withOptionalCValue
        {
            cFinalSignature in
            
            blameHunk.final_signature = cFinalSignature
            
            return try finalCommitter.withOptionalCValue
            {
                cFinalCommitter in
                
                blameHunk.final_committer = cFinalCommitter
                
                return try origPath.withOptionalCString
                {
                    cOrigPath in
                    
                    blameHunk.orig_path = cOrigPath
                    
                    return try origSignature.withOptionalCValue
                    {
                        cOrigSignature in
                        
                        blameHunk.orig_signature = cOrigSignature
                        
                        return try origCommitter.withOptionalCValue
                        {
                            cOrigCommitter in
                            
                            blameHunk.orig_committer = cOrigCommitter
                            
                            return try summary.withOptionalCString
                            {
                                cSummary in
                                
                                blameHunk.summary = cSummary
                                
                                return try body(&blameHunk)
                            }
                        }
                    }
                }
            }
        }
    }
}



/// A line in a blamed file.
///
/// ## C Equivalent
///
/// [`git_blame_line`](https://libgit2.org/docs/reference/main/blame/git_blame_line.html)
public struct GitBlameLine: GitStructReadable, WithCConvertible
{
    /// The line content.
    public let ptr : Data?
    
    /// The length of the line content.
    public let len : Int
    
    
    
    /// Creates a ``GitBlameLine`` instance from a `git_blame_line` instance.
    /// - Parameter blameLine: The `git_blame_line` instance to use.
    internal init(
        cValue blameLine: git_blame_line
    )
    {
        self.ptr    = blameLine.ptr.map { Data(bytes: $0, count: blameLine.len) }
        self.len    = blameLine.len
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_blame_line` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_blame_line>) throws -> T
    ) throws -> T
    {
        var blameLine = git_blame_line()
        
        return try ptr.withOptionalCBuffer
        {
            ptrBuffer, ptrBufferCount in
            
            blameLine.ptr   = ptrBuffer
            blameLine.len   = ptrBufferCount
            
            return try body(&blameLine)
        }
    }
}
