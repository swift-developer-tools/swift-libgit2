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



/// The description of one side of a diff delta.
///
/// ## Discussion
///
/// Although this is called a "file", it could represent a file, a symbolic
/// link, a submodule commit ID, or even a tree (when tracking type changes
/// or ignored or untracked directories).
///
/// ## C Equivalent
///
/// [`git_diff_file`](https://libgit2.org/docs/reference/main/diff/git_diff_file.html)
public struct GitDiffFile: CStructReadable, WithCConvertible, Sendable
{
    /// The ID of the item.
    ///
    /// ## Discussion
    ///
    /// If the entry represents an absent side of a diff (for example, the
    /// `old_file` of a ``GitDeltaT/gitDeltaAdded`` delta), then the ID will
    /// be all zeros.
    public let id       : GitOID
    
    /// The null-terminated path to the entry relative to the working
    /// directory of the repository.
    public let path     : String?
    
    /// The size of the entry in bytes.
    public let size     : GitObjectSizeT
    
    /// The flags for the delta object and the file objects on each side of
    /// the delta.
    public let flags    : GitDiffFlagT
    
    /// Approximately the `stat() st_mode` value for the item.
    public let mode     : GitFileModeT
    
    /// The known length of the ID field, when converted to a hex string.
    ///
    /// ## Discussion
    ///
    /// This is generally the value of ``gitOIDSHA1HexSize``, unless the delta
    /// was created from reading a patch file, in which case it may be
    /// abbreviated to something reasonable, like seven characters.
    public let idAbbrev : UInt16
    
    
    
    /// Initializes a ``GitDiffFile`` instance from the given `git_diff_file`
    /// instance.
    /// - Parameter diffFile: The `git_diff_file` instance to use.
    internal init(
        cValue diffFile: git_diff_file
    )
    {
        self.id         = GitOID(cValue: diffFile.id)
        self.path       = String(optionalCString: diffFile.path)
        self.size       = diffFile.size
        self.mode       = GitFileModeT(rawValue: diffFile.mode) ?? .gitFileModeUnreadable
        self.flags      = GitDiffFlagT(rawValue: diffFile.flags)
        self.idAbbrev   = diffFile.id_abbrev
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_file`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_file>) throws -> T
    ) rethrows -> T
    {
        var diffFile = git_diff_file()
        
        diffFile.id         = id.cValue()
        diffFile.size       = size
        diffFile.flags      = flags.rawValue
        diffFile.mode       = mode.rawValue
        diffFile.id_abbrev  = idAbbrev
        
        return try path.withOptionalCString
        {
            cPath in
            
            diffFile.path = cPath
            
            return try body(&diffFile)
        }
    }
}



/// The description of changes to an entry.
///
/// ## Discussion
///
/// A delta is a file pair with old and new versions. The old version may be
/// absent if the file was just created and the new version may be absent if
/// the file was deleted. A diff is mostly just a list of deltas.
///
/// When iterating over a diff, this will be passed to most callbacks and the
/// file contents may be used to understand exactly what has changed.
///
/// ``GitDiffDelta/oldFile`` represents the "from" side of the diff and
/// ``GitDiffDelta/newFile`` represents to "to" side of the diff. What those
/// means depend on the function that was used to generate the diff and is
/// explained below. The ``GitDiffOptionT/gitDiffReverse`` flag may be used
/// to reverse this relationship.
///
/// Although the two sides of the delta are named ``GitDiffDelta/oldFile``
/// and ``GitDiffDelta/newFile``, they actually may correspond to entries that
/// represent a file, a symbolic link, a submodule commit ID, or even a tree
/// (when tracking type changes or ignored or untracked directories).
///
/// Under some circumstances, in the name of efficiency, not all properties
/// will be filled in, but generally as much as possible will be filled in.
/// For example, ``GitDiffDelta/flags`` may not have either the
/// ``GitDiffFlagT/gitDiffFlagBinary`` or the
/// ``GitDiffFlagT/gitDiffFlagNotBinary`` flag set to avoid examining file
/// contents when no hunk and/or line callbacks are passed in. In this case,
/// the diff iteration process will use the Git attributes for those files.
///
/// ``GitDiffDelta/similarity`` will be zero unless
/// ``gitDiffFindSimilar(diff:options:)`` is called, which performs a
/// similarity analysis of files in the diff. That function may be used to
/// perform rename and copy detection, and to split heavily modified files
/// into add/delete pairs. After that call, deltas with a status of
/// ``GitDeltaT/gitDeltaRenamed`` or ``GitDeltaT/gitDeltaCopied`` will have
/// a similarity score between 0 and 100 indicating the similarity between
/// the old version and the new version.
///
/// If ``gitDiffFindSimilar(diff:options:)`` is used to find heavily modified
/// files to break, but not to actually break the records, then
/// ``GitDeltaT/gitDeltaModified`` records may have a non-zero similarity score
/// if the self-similarity is below the split threshold. To display this value
/// like core Git, invert the score by subtracting it from 100.
///
/// ## C Equivalent
///
/// [`git_diff_delta`](https://libgit2.org/docs/reference/main/diff/git_diff_delta.html)
public struct GitDiffDelta: CStructReadable, WithCConvertible, Sendable
{
    /// The type of change described by a diff delta.
    public let status       : GitDeltaT
    
    /// The flags for the delta object and the file objects on each side of
    /// the delta.
    public let flags        : GitDiffFlagT
    
    /// The similarity threshold (0 - 100) of the item for
    /// ``GitDeltaT/gitDeltaRenamed`` and ``GitDeltaT/gitDeltaCopied`` changes.
    public let similarity   : UInt16
    
    /// The number of files in this delta.
    public let nFiles       : UInt16
    
    /// The old version of the file.
    public let oldFile      : GitDiffFile
    
    /// The new version of the file.
    public let newFile      : GitDiffFile
    
    
    
    /// Initializes a ``GitDiffDelta`` instance from the given `git_diff_delta`
    /// instance.
    /// - Parameter diffDelta: The `git_diff_delta` instance to use.
    internal init(
        cValue diffDelta: git_diff_delta
    )
    {
        self.status         = GitDeltaT(rawValue: diffDelta.status.rawValue) ?? .gitDeltaUnmodified
        self.flags          = GitDiffFlagT(rawValue: diffDelta.flags)
        self.similarity     = diffDelta.similarity
        self.nFiles         = diffDelta.nfiles
        self.oldFile        = GitDiffFile(cValue: diffDelta.old_file)
        self.newFile        = GitDiffFile(cValue: diffDelta.new_file)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_delta`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_delta>) throws -> T
    ) rethrows -> T
    {
        var diffDelta = git_diff_delta()
        
        diffDelta.status        = status.cValue()
        diffDelta.flags         = flags.rawValue
        diffDelta.similarity    = similarity
        diffDelta.nfiles        = nFiles
        
        return try oldFile.withCValue
        {
            cOldFile in
            
            diffDelta.old_file = cOldFile.pointee
            
            return try newFile.withCValue
            {
                cNewFile in
                
                diffDelta.new_file = cNewFile.pointee
                
                return try body(&diffDelta)
            }
        }
    }
}



/// The options for diff operations.
///
/// ## C Equivalent
///
/// [`git_diff_options`](https://libgit2.org/docs/reference/main/diff/git_diff_options.html)
public struct GitDiffOptions: CStructMutable, WithCConvertible
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffOptionsVersion``.
    public var version          : UInt32
    
    /// The flags controlling the diff operation.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags            : GitDiffOptionT
    
    /// The submodule ignore options.
    ///
    /// ## Discussion
    ///
    /// The default value is
    /// ``GitSubmoduleIgnoreT/gitSubmoduleIgnoreUnspecified``.
    public var ignoreSubmodules : GitSubmoduleIgnoreT
    
    /// The paths or `fnmatch` patterns to constrain the diff.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var pathspec         : [String]
    
    /// The callback for notifications of new diff deltas being added.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var notifyCB         : GitDiffNotifyCB?
    
    /// The callback invoked for notifications of which files are being
    /// examined.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressCB       : GitDiffProgressCB?
    
    /// The payload passed to ``notifyCB`` and ``progressCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload          : UnsafeMutableRawPointer?
    
    /// The number of unchanged lines that define the boundaries of a diff hunk,
    /// displayed before and after each hunk.
    ///
    /// ## Discussion
    ///
    /// The default value is `3`.
    public var contextLines     : UInt32
    
    /// The maximum number of unchanged lines between diff hunk boundaries
    /// before the hunks are merged.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var interHunkLines   : UInt32
    
    /// The type of ID to emit in diffs.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This is used by functions that operate without a repository. If a
    /// repository is available, the ID format of the repository will be used.
    /// Otherwise, if there is no repository available and this is `nil`,
    /// ``GitOIDT/gitOIDSHA1`` will be used.
    ///
    /// If this is specified and a repository is available, the specified type
    /// must match the repository's ID format.
    public var oidType          : GitOIDT?
    
    /// The abbreviation length to use when formatting IDs.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use the value of `core.abbrev` from the configuration
    /// file, or `7` if that value is unset.
    public var idAbbrev         : UInt16?
    
    /// The maximum size, in bytes, above which a blob will be automatically
    /// marked as binary.
    ///
    /// ## Discussion
    ///
    /// The default value is 512 MB.
    ///
    /// Pass a negative value to disable the limit.
    public var maxSize          : GitOffT
    
    /// The virtual directory prefix for old file names in diff hunk headers.
    ///
    /// ## Discussion
    ///
    /// The default value is `a`.
    public var oldPrefix        : String
    
    /// The virtual directory prefix for new file names in diff hunk headers.
    ///
    /// ## Discussion
    ///
    /// The default value is `b`.
    public var newPrefix        : String
    
    
    
    /// Initializes a ``GitDiffOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version             : UInt32                    = gitDiffOptionsVersion,
        flags               : GitDiffOptionT            = [],
        ignoreSubmodules    : GitSubmoduleIgnoreT       = .gitSubmoduleIgnoreUnspecified,
        pathspec            : [String]                  = [],
        notifyCB            : GitDiffNotifyCB?          = nil,
        progressCB          : GitDiffProgressCB?        = nil,
        payload             : UnsafeMutableRawPointer?  = nil,
        contextLines        : UInt32                    = 3,
        interHunkLines      : UInt32                    = 0,
        oidType             : GitOIDT?                  = nil,
        idAbbrev            : UInt16?                   = nil,
        maxSize             : GitOffT                   = 536_870_912,
        oldPrefix           : String                    = "a",
        newPrefix           : String                    = "b"
    )
    {
        self.version            = version
        self.flags              = flags
        self.ignoreSubmodules   = ignoreSubmodules
        self.pathspec           = pathspec
        self.notifyCB           = notifyCB
        self.progressCB         = progressCB
        self.payload            = payload
        self.contextLines       = contextLines
        self.interHunkLines     = interHunkLines
        self.oidType            = oidType
        self.idAbbrev           = idAbbrev
        self.maxSize            = maxSize
        self.oldPrefix          = oldPrefix
        self.newPrefix          = newPrefix
    }
    
    
    
    /// Initializes a ``GitDiffOptions`` instance from the given
    /// `git_diff_options` instance.
    /// - Parameter diffOptions: The `git_diff_options` instance to use.
    internal init(
        cValue diffOptions: git_diff_options
    )
    {
        self.version            = diffOptions.version
        self.flags              = GitDiffOptionT(rawValue: diffOptions.flags)
        self.ignoreSubmodules   = GitSubmoduleIgnoreT(cValue: diffOptions.ignore_submodules) ?? .gitSubmoduleIgnoreUnspecified
        self.pathspec           = Array(diffOptions.pathspec)
        self.notifyCB           = diffOptions.notify_cb
        self.progressCB         = diffOptions.progress_cb
        self.payload            = diffOptions.payload
        self.contextLines       = diffOptions.context_lines
        self.interHunkLines     = diffOptions.interhunk_lines
        self.oidType            = GitOIDT(cValue: diffOptions.oid_type)
        self.idAbbrev           = diffOptions.id_abbrev
        self.maxSize            = diffOptions.max_size
        self.oldPrefix          = String(optionalCString: diffOptions.old_prefix) ?? "a"
        self.newPrefix          = String(optionalCString: diffOptions.new_prefix) ?? "b"
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_options>) throws -> T
    ) throws -> T
    {
        var diffOptions = git_diff_options()
        
        let diffOptionsInitResult: GitErrorCode = gitDiffOptionsInit(
            opts:       &diffOptions,
            version:    version
        )
        
        if diffOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        diffOptions.flags               = flags.rawValue
        diffOptions.ignore_submodules   = ignoreSubmodules.cValue()
        diffOptions.notify_cb           = notifyCB
        diffOptions.progress_cb         = progressCB
        diffOptions.payload             = payload
        diffOptions.context_lines       = contextLines
        diffOptions.interhunk_lines     = interHunkLines
        diffOptions.oid_type            = oidType?.cValue() ?? GitOIDT.gitOIDSHA1.cValue()
        diffOptions.id_abbrev           = idAbbrev ?? 7
        diffOptions.max_size            = maxSize
        
        return try pathspec.withGitStrArray
        {
            cPathspec in
            
            diffOptions.pathspec = cPathspec.pointee
            
            return try oldPrefix.withCString
            {
                cOldPrefix in
                
                diffOptions.old_prefix = cOldPrefix
                
                return try newPrefix.withCString
                {
                    cNewPrefix in
                    
                    diffOptions.new_prefix = cNewPrefix
                    
                    return try body(&diffOptions)
                }
            }
        }
    }
}



/// The contents of one of the files in a binary diff.
///
/// ## C Equivalent
///
/// [`git_diff_binary_file`](https://libgit2.org/docs/reference/main/diff/git_diff_binary_file.html)
public struct GitDiffBinaryFile: CStructReadable, WithCConvertible, Sendable
{
    /// The type of binary data.
    public let type         : GitDiffBinaryT
    
    /// The deflated binary data.
    public let data         : Data?
    
    /// The length of ``data``.
    public var dataLen      : Int
    {
        return data?.count ?? 0
    }
    
    /// The length of the inflated binary data.
    public let inflatedLen  : Int
    
    
    
    /// Initializes a ``GitDiffBinaryFile`` instance from the given
    /// `git_diff_binary_file` instance.
    /// - Parameter diffBinaryFile: The `git_diff_binary_file` instance to use.
    internal init(
        cValue diffBinaryFile: git_diff_binary_file
    )
    {
        self.type           = GitDiffBinaryT(cValue: diffBinaryFile.type) ?? .gitDiffBinaryNone
        self.data           = diffBinaryFile.data.map { Data(bytes: $0, count: diffBinaryFile.datalen) }
        self.inflatedLen    = diffBinaryFile.inflatedlen
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_diff_binary_file` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_binary_file>) throws -> T
    ) throws -> T
    {
        var diffBinaryFile = git_diff_binary_file()
        
        diffBinaryFile.type = type.cValue()
        
        guard
            let data,
            !data.isEmpty
        else
        {
            diffBinaryFile.data         = nil
            diffBinaryFile.datalen      = 0
            diffBinaryFile.inflatedlen  = 0
            
            return try body(&diffBinaryFile)
        }
        
        return try data.withCString
        {
            cData, cDataCount in
            
            diffBinaryFile.data         = cData
            diffBinaryFile.datalen      = cDataCount
            diffBinaryFile.inflatedlen  = inflatedLen
            
            return try body(&diffBinaryFile)
        }
    }
}



/// The binary contents of a diff.
///
/// ## Discussion
///
/// A binary file or binary delta is a file (or pair of files) for which no
/// text diffs are generated. A diff can contain delta entries that are binary,
/// but no diff content is output for those files.
///
/// ## C Equivalent
///
/// [`git_diff_binary`](https://libgit2.org/docs/reference/main/diff/git_diff_binary.html)
public struct GitDiffBinary: CStructReadable, WithCConvertible, Sendable
{
    /// Whether there is data in the binary.
    ///
    /// ## Discussion
    ///
    /// If this is `false`, then the instance was generated knowing only that
    /// a binary file changed, but without providing the data.
    public let containsData : Bool
    
    /// The contents of the old file.
    public let oldFile      : GitDiffBinaryFile
    
    /// The contents of the new file.
    public let newFile      : GitDiffBinaryFile
    
    
    
    /// Initializes a ``GitDiffBinary`` instance from the given
    /// `git_diff_binary` instance.
    /// - Parameter diffBinary: The `git_diff_binary` instance to use.
    internal init(
        cValue diffBinary: git_diff_binary
    )
    {
        self.containsData   = Bool(diffBinary.contains_data)
        self.oldFile        = GitDiffBinaryFile(cValue: diffBinary.old_file)
        self.newFile        = GitDiffBinaryFile(cValue: diffBinary.new_file)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_binary`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_binary>) throws -> T
    ) throws -> T
    {
        var diffBinary = git_diff_binary()
        
        diffBinary.contains_data = containsData.uint32Value
        
        return try oldFile.withCValue
        {
            cOldFile in
            
            diffBinary.old_file = cOldFile.pointee
            
            return try newFile.withCValue
            {
                cNewFile in
                
                diffBinary.new_file = cNewFile.pointee
                
                return try body(&diffBinary)
            }
        }
    }
}



/// A hunk of a diff.
///
/// ## Discussion
///
/// A hunk is a span of modified lines in a diff delta along with some stable
/// surrounding context. Each hunk also comes with a header that described
/// where it starts and ends in the delta, in both the old and new files.
///
/// ## C Equivalent
///
/// [`git_diff_hunk`](https://libgit2.org/docs/reference/main/diff/git_diff_hunk.html)
public struct GitDiffHunk: CStructInternalMutable, CConvertible, Sendable
{
    /// The starting line number in the old file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var oldStart    : Int32     = 0
    
    /// The number of lines in the old file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var oldLines    : Int32     = 0
    
    /// The starting line number in the new file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var newStart    : Int32     = 0
    
    /// The number of lines in the new file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var newLines    : Int32     = 0
    
    /// The length of ``header``.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var headerLen                : Int
    {
        return header?.count ?? 0
    }
    
    /// The header text.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var header      : String?   = nil
    
    
    
    /// Initializes a default ``GitDiffHunk``.
    public init() { }
    
    
    
    /// Initializes a ``GitDiffHunk`` instance from the given `git_diff_hunk`
    /// instance.
    /// - Parameter diffHunk: The `git_diff_hunk` instance to use.
    internal init(
        cValue diffHunk: git_diff_hunk
    )
    {
        self.oldStart   = diffHunk.old_start
        self.oldLines   = diffHunk.old_lines
        self.newStart   = diffHunk.new_start
        self.newLines   = diffHunk.new_lines
        self.header     = String(cArray: diffHunk.header)
    }
    
    
    
    /// Converts the ``GitDiffHunk`` instance into a `git_diff_hunk` instance.
    /// - Returns: The `git_diff_hunk` instance.
    internal func cValue() -> git_diff_hunk
    {
        var diffHunk = git_diff_hunk()
        
        diffHunk.old_start      = oldStart
        diffHunk.old_lines      = oldLines
        diffHunk.new_start      = newStart
        diffHunk.new_lines      = newLines
        
        header?.copyMemory(
            to:         &diffHunk.header.0,
            byteCount:  128
        )
        
        diffHunk.header_len = strlen(&diffHunk.header.0)
        
        return diffHunk
    }
}



/// A line of a diff.
///
/// ## Discussion
///
/// A line (or data span) is a range of characters inside a diff hunk.
/// It could be a context line (a line that exists in both the old and new
/// versions), an added line (a line that exists only in the new version),
/// or a deleted line (a line that exists only in the old version).
///
/// ## C Equivalent
///
/// [`git_diff_line`](https://libgit2.org/docs/reference/main/diff/git_diff_line.html)
public struct GitDiffLine: CStructInternalMutable, WithCConvertible, Sendable
{
    /// The type of line origin.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitDiffLineT/gitDiffLineContext``.
    public private(set) var origin          : GitDiffLineT  = .gitDiffLineContext
    
    /// The line number in the old file, or `-1` to indicate an added line.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var oldLineNo       : Int32         = 0
    
    /// The line number in the new file, or `-1` to indicate a deleted line.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var newLineNo       : Int32         = 0
    
    /// The number of newline characters in the diff text.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var numLines        : Int32         = 0
    
    /// The length of ``content``.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var contentLen                   : Int
    {
        return content?.count ?? 0
    }
    
    /// The offset in the original file to the diff text.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var contentOffset   : GitOffT       = 0
    
    /// The diff text.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var content         : Data?         = nil
    
    
    
    /// Initializes a default ``GitDiffLine`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitDiffLine`` instance from the given `git_diff_line`
    /// instance.
    /// - Parameter diffLine: The `git_diff_line` instance to use.
    internal init(
        cValue diffLine: git_diff_line
    )
    {
        if
            diffLine.origin >= 0,
            let diffLineT = GitDiffLineT(rawValue: UInt32(diffLine.origin))
        {
            self.origin = diffLineT
        }
        else
        {
            self.origin = .gitDiffLineContext
        }
        
        self.oldLineNo      = diffLine.old_lineno
        self.newLineNo      = diffLine.new_lineno
        self.numLines       = diffLine.num_lines
        self.contentOffset  = diffLine.content_offset
        self.content        = diffLine.content.map { Data(bytes: $0, count: diffLine.content_len) }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_line`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_line>) throws -> T
    ) throws -> T
    {
        var diffLine = git_diff_line()
        
        guard origin.rawValue <= CChar.max
        else
        {
            throw NSError.makeCConversionError()
        }
        
        diffLine.origin             = CChar(origin.rawValue)
        diffLine.old_lineno         = oldLineNo
        diffLine.new_lineno         = newLineNo
        diffLine.num_lines          = numLines
        diffLine.content_offset     = contentOffset
        
        guard
            let content,
            !content.isEmpty
        else
        {
            diffLine.content_len    = 0
            diffLine.content        = nil
            
            return try body(&diffLine)
        }
        
        return try content.withCString
        {
            cContent, cContentCount in
            
            diffLine.content_len    = cContentCount
            diffLine.content        = cContent
            
            return try body(&diffLine)
        }
    }
}



/// A pluggable similarity metric.
///
/// ## C Equivalent
///
/// [`git_diff_similarity_metric`](https://libgit2.org/docs/reference/main/diff/git_diff_similarity_metric.html)
public struct GitDiffSimilarityMetric: CStructMutable, CConvertible
{
    /// Generates a signature for the given file.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var fileSignature    : GitDiffSimilarityMetric.FileSignature?    = nil
    
    /// Generates a signature for the given buffer.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var bufferSignature  : GitDiffSimilarityMetric.BufferSignature?  = nil
    
    /// Frees the memory allocated for the given signature.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var freeSignature    : GitDiffSimilarityMetric.FreeSignature?    = nil
    
    /// Calculates the similarity of the given signatures.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var similarity       : GitDiffSimilarityMetric.Similarity?       = nil
    
    /// The payload provided by the caller.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload          : UnsafeMutableRawPointer?                  = nil
    
    
    
    /// Initializes a ``GitDiffSimilarityMetric`` instance, optionally
    /// specifying values for its properties.
    public init(
        fileSignature   : FileSignature?            = nil,
        bufferSignature : BufferSignature?          = nil,
        freeSignature   : FreeSignature?            = nil,
        similarity      : Similarity?               = nil,
        payload         : UnsafeMutableRawPointer?  = nil
    )
    {
        self.fileSignature      = fileSignature
        self.bufferSignature    = bufferSignature
        self.freeSignature      = freeSignature
        self.similarity         = similarity
        self.payload            = payload
    }
    
    
    
    /// Initializes a ``GitDiffSimilarityMetric`` instance from the given
    /// `git_diff_similarity_metric` instance.
    /// - Parameter diffSimilarityMetric: The `git_diff_similarity_metric`
    /// instance to use.
    internal init(
        cValue diffSimilarityMetric: git_diff_similarity_metric
    )
    {
        self.fileSignature      = diffSimilarityMetric.file_signature
        self.bufferSignature    = diffSimilarityMetric.buffer_signature
        self.freeSignature      = diffSimilarityMetric.free_signature
        self.similarity         = diffSimilarityMetric.similarity
        self.payload            = diffSimilarityMetric.payload
    }
    
    
    
    /// Converts the ``GitDiffSimilarityMetric`` instance into a
    /// `git_diff_similarity_metric` instance.
    /// - Returns: The `git_diff_similarity_metric` instance.
    internal func cValue() -> git_diff_similarity_metric
    {
        var diffSimilarityMetric = git_diff_similarity_metric()
        
        diffSimilarityMetric.file_signature     = fileSignature
        diffSimilarityMetric.buffer_signature   = bufferSignature
        diffSimilarityMetric.free_signature     = freeSignature
        diffSimilarityMetric.similarity         = similarity
        diffSimilarityMetric.payload            = payload
        
        return diffSimilarityMetric
    }
    
    
    
    /// The callback invoked to generate a signature for the given file.
    /// - Parameters:
    ///   - out: The pointer in which to store the signature.
    ///   - file: The file for which to generate a signature.
    ///   - fullPath: The full path to the file for which to generate a
    ///   signature.
    ///   - payload: The payload provided by the caller.
    /// - Returns: `0` on success, or an error code.
    public typealias FileSignature = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafePointer<git_diff_file>?,
        UnsafePointer<CChar>?,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    
    
    /// The callback invoked to generate a signature for the given file,
    /// using the given buffer containing the contents of the file.
    /// - Parameters:
    ///   - out: The pointer in which to store the signature.
    ///   - file: The file for which to generate a signature.
    ///   - buf: The buffer containing the contents of the file.
    ///   - bufLen: The length of `buf`.
    ///   - payload: The payload provided by the caller.
    /// - Returns: `0` on success, or an error code.
    public typealias BufferSignature = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafePointer<git_diff_file>?,
        UnsafePointer<CChar>?,
        Int,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// signature.
    /// - Parameters:
    ///   - sig: The signature to free.
    ///   - payload: The payload provided by the caller.
    public typealias FreeSignature = @convention(c)
    (
        UnsafeMutableRawPointer?,
        UnsafeMutableRawPointer?
    ) -> Void
    
    
    
    /// The callback invoked to calculate the similarity of the given
    /// signatures.
    /// - Parameters:
    ///   - score: The pointer in which to store the similarity score.
    ///   - sigA: The first signature to compare.
    ///   - sigB: The second signature to compare.
    ///   - payload: The payload provided by the caller.
    /// - Returns: `0` on success, or an error code.
    public typealias Similarity = @convention(c)
    (
        UnsafeMutablePointer<Int32>?,
        UnsafeMutableRawPointer?,
        UnsafeMutableRawPointer?,
        UnsafeMutableRawPointer?
    ) -> Int32
}



/// The options for diff rename and copy detection.
///
/// ## C Equivalent
///
/// [`git_diff_find_options`](https://libgit2.org/docs/reference/main/diff/git_diff_find_options.html)
public struct GitDiffFindOptions: CStructMutable, ThrowingCConvertible
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffFindOptionsVersion``.
    public var version                      : UInt32
    
    /// The flags controlling diff rename and copy detection.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags                        : GitDiffFindT
    
    /// The threshold above which similar files will be considered renames.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to `git diff --find-renames`.
    public var renameThreshold              : UInt16
    
    /// The threshold below which similar files will be eligible to be a
    /// rename source.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to the first part of `git diff --break-rewrites`.
    public var renameFromRewriteThreshold   : UInt16
    
    /// The threshold above which similar files will be considered copies.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to `git diff --find-copies`.
    public var copyThreshold                : UInt16
    
    /// The threshold below which similar files will be split into an
    /// add/delete pair.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to the last part of `git diff --break-rewrites`.
    public var breakRewriteThreshold        : UInt16
    
    /// The maximum number of matches to consider for a particular file.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is slightly different from `git diff -l`, since libgit2 will
    /// still process up to the specified number of matches before abandoning
    /// the search.
    public var renameLimit                  : Int
    
    /// The pluggable similarity metric.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use a sampling hash of ranges of data in the file. This
    /// is a reliable similarity approximation that generally works well for
    /// both text and binary data, while maintaining speed and a fixed memory
    /// overhead.
    ///
    /// - Important: If a custom metric is provided, the caller will be
    /// responsible for memory management.
    public var metric                       : UnsafeMutablePointer<
                                                git_diff_similarity_metric>?
    
    
    
    /// Initializes a ``GitDiffFindOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version                     : UInt32                            = gitDiffFindOptionsVersion,
        flags                       : GitDiffFindT                      = [],
        renameThreshold             : UInt16                            = 50,
        renameFromRewriteThreshold  : UInt16                            = 50,
        copyThreshold               : UInt16                            = 50,
        breakRewriteThreshold       : UInt16                            = 50,
        renameLimit                 : Int                               = 1000,
        metric                      : UnsafeMutablePointer<
                                        git_diff_similarity_metric>?    = nil
    )
    {
        self.version                        = version
        self.flags                          = flags
        self.renameThreshold                = renameThreshold
        self.renameFromRewriteThreshold     = renameFromRewriteThreshold
        self.copyThreshold                  = copyThreshold
        self.breakRewriteThreshold          = breakRewriteThreshold
        self.renameLimit                    = renameLimit
        self.metric                         = metric
    }
    
    
    
    /// Initializes a ``GitDiffFindOptions`` instance from the given
    /// `git_diff_find_options` instance.
    /// - Parameter diffFindOptions: The `git_diff_find_options` instance to
    /// use.
    internal init(
        cValue diffFindOptions: git_diff_find_options
    )
    {
        self.version                        = diffFindOptions.version
        self.flags                          = GitDiffFindT(rawValue: diffFindOptions.flags)
        self.renameThreshold                = diffFindOptions.rename_threshold
        self.renameFromRewriteThreshold     = diffFindOptions.rename_from_rewrite_threshold
        self.copyThreshold                  = diffFindOptions.copy_threshold
        self.breakRewriteThreshold          = diffFindOptions.break_rewrite_threshold
        self.renameLimit                    = diffFindOptions.rename_limit
        self.metric                         = diffFindOptions.metric
    }
    
    
    
    /// Converts the ``GitDiffFindOptions`` instance into a
    /// `git_diff_find_options` instance.
    /// - Returns: The `git_diff_find_options` instance.
    /// - Throws: An error if the conversion fails.
    internal func cValue() throws -> git_diff_find_options
    {
        var diffFindOptions = git_diff_find_options()
        
        let diffFindOptionsInitResult: GitErrorCode = gitDiffFindOptionsInit(
            opts:       &diffFindOptions,
            version:    version
        )
        
        if diffFindOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        diffFindOptions.flags                           = flags.rawValue
        diffFindOptions.rename_threshold                = renameThreshold
        diffFindOptions.rename_from_rewrite_threshold   = renameFromRewriteThreshold
        diffFindOptions.copy_threshold                  = copyThreshold
        diffFindOptions.break_rewrite_threshold         = breakRewriteThreshold
        diffFindOptions.rename_limit                    = renameLimit
        diffFindOptions.metric                          = metric
        
        return diffFindOptions
    }
}



/// The options for parsing a diff or patch file.
///
/// ## C Equivalent
///
/// [`git_diff_parse_options`](https://libgit2.org/docs/reference/main/diff/git_diff_parse_options.html)
public struct GitDiffParseOptions: CStructMutable, CConvertible, Sendable
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffParseOptionsVersion``.
    public var version  : UInt32
    
    /// The ID type used in the patch file.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitOIDT/gitOIDSHA1``.
    public var oidType  : GitOIDT
    
    
    
    /// Initializes a ``GitDiffParseOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version : UInt32    = gitDiffParseOptionsVersion,
        oidType : GitOIDT   = .gitOIDSHA1
    )
    {
        self.version    = version
        self.oidType    = oidType
    }
    
    
    
    /// Initializes a ``GitDiffParseOptions`` instance from the given
    /// `git_diff_parse_options` instance.
    /// - Parameter diffParseOptions: The `git_diff_parse_options` instance
    /// to use.
    internal init(
        cValue diffParseOptions: git_diff_parse_options
    )
    {
        self.version    = diffParseOptions.version
        self.oidType    = GitOIDT(cValue: diffParseOptions.oid_type) ?? .gitOIDSHA1
    }
    
    
    
    /// Converts the ``GitDiffParseOptions`` instance into a
    /// `git_diff_parse_options` instance.
    /// - Returns: The `git_diff_parse_options` instance.
    internal func cValue() -> git_diff_parse_options
    {
        var diffParseOptions = git_diff_parse_options()
        
        diffParseOptions.version    = version
        diffParseOptions.oid_type   = oidType.cValue()
        
        return diffParseOptions
    }
}



/// The options for calculating patch IDs.
///
/// ## Discussion
///
/// - Note: This is reserved for future use. No options are currently available.
///
/// ## C Equivalent
///
/// [`git_diff_patchid_options`](https://libgit2.org/docs/reference/main/diff/git_diff_patchid_options.html)
public struct GitDiffPatchIDOptions: CStructMutable, ThrowingCConvertible, Sendable
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffPatchIDOptionsVersion``.
    public var version  : UInt32
    
    
    
    /// Initializes a ``GitDiffPatchIDOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version: UInt32 = gitDiffPatchIDOptionsVersion
    )
    {
        self.version = version
    }
    
    
    
    /// Initializes a ``GitDiffPatchIDOptions`` instance from the given
    /// `git_diff_patchid_options` instance.
    /// - Parameter diffPatchIDOptions: The `git_diff_patchid_options` instance
    /// to use.
    internal init(
        cValue diffPatchIDOptions: git_diff_patchid_options
    )
    {
        self.version = diffPatchIDOptions.version
    }
    
    
    
    /// Converts the ``GitDiffPatchIDOptions`` instance into a
    /// `git_diff_patchid_options` instance.
    /// - Returns: The `git_diff_patchid_options` instance.
    /// - Throws: An error if the conversion fails.
    internal func cValue() throws -> git_diff_patchid_options
    {
        var diffPatchIDOptions = git_diff_patchid_options()
        
        let diffPatchIDOptionsInitResult: GitErrorCode
            = gitDiffPatchIDOptionsInit(
                opts:       &diffPatchIDOptions,
                version:    version
            )
        
        if diffPatchIDOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        return diffPatchIDOptions
    }
}
