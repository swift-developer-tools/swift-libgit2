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
/// Although this is called a "file", it could represent a file, a symbolic link, a submodule commit ID,
/// or even a tree (when tracking type changes or ignored or untracked directories).
///
/// ## C Equivalent
///
/// [`git_diff_file`](https://libgit2.org/docs/reference/main/diff/git_diff_file.html)
public struct GitDiffFile: GitStructReadable, WithCConvertible
{
    /// The ID of the item.
    ///
    /// ## Discussion
    ///
    /// If the entry represents an absent side of a diff (for example, the `old_file` of a
    /// ``GitDeltaT/gitDeltaAdded`` delta), then the ID will be all zeros.
    public let id       : GitOID
    
    /// The null-terminated path to the entry relative to the working directory of the repository.
    public let path     : String?
    
    /// The size of the entry in bytes.
    public let size     : GitObjectSizeT
    
    /// The flags for the delta object and the file objects on each side of the delta.
    public let flags    : GitDiffFlagT
    
    /// Approximately the `stat() st_mode` value for the item.
    public let mode     : GitFileModeT
    
    // TODO: Replace `GIT_OID_SHA1_HEXSIZE` in documentation.
    /// The known length of the ID field, when converted to a hex string.
    ///
    /// ## Discussion
    ///
    /// This is generally `GIT_OID_SHA1_HEXSIZE`, unless this delta was created from reading
    /// a patch file, in which case it may be abbreviated to something reasonable, like seven characters.
    public let idAbbrev : UInt16
    
    
    
    /// Creates a ``GitDiffFile`` instance from a `git_diff_file` instance.
    /// - Parameter diffFile: The `git_diff_file` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``mode`` defaults to ``GitFileModeT/gitFileModeUnreadable`` if an unexpected
    /// value is encountered, although this should never occur.
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
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_file` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
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
/// A delta is a file pair with old and new versions. The old version may be absent if the file was just
/// created and the new version may be absent if the file was deleted. A diff is mostly just a list of deltas.
///
/// When iterating over a diff, this will be passed to most callbacks and the file contents may be used to
/// understand exactly what has changed.
///
/// ``GitDiffDelta/oldFile`` represents the "from" side of the diff and
/// ``GitDiffDelta/newFile`` represents to "to" side of the diff. What those means depend on
/// the function that was used to generate the diff and is explained below. The
/// ``GitDiffOptionT/gitDiffReverse`` flag may be used to reverse this relationship.
///
/// Although the two sides of the delta are named ``GitDiffDelta/oldFile`` and
/// ``GitDiffDelta/newFile``, they actually may correspond to entries that represent a file,
/// a symbolic link, a submodule commit ID, or even a tree (when tracking type changes or ignored or
/// untracked directories).
///
/// Under some circumstances, in the name of efficiency, not all properties will be filled in, but generally
/// as much as possible will be filled in. For example, ``GitDiffDelta/flags`` may not have either
/// the ``GitDiffFlagT/gitDiffFlagBinary`` or the
/// ``GitDiffFlagT/gitDiffFlagNotBinary`` flag set to avoid examining file contents when no
/// hunk and/or line callbacks are passed in. In this case, the diff iteration process will use the Git attributes
/// for those files.
///
/// ``GitDiffDelta/similarity`` will be zero unless
/// ``gitDiffFindSimilar(diff:options:)`` is called, which performs a similarity analysis of
/// files in the diff. That function may be used to perform rename and copy detection, and to split heavily
/// modified files into add/delete pairs. After that call, deltas with a status of
/// ``GitDeltaT/gitDeltaRenamed`` or ``GitDeltaT/gitDeltaCopied`` will have a similarity
/// score between 0 and 100 indicating the similarity between the old version and the new version.
///
/// If ``gitDiffFindSimilar(diff:options:)`` is used to find heavily modified files to break, but
/// not to actually break the records, then ``GitDeltaT/gitDeltaModified`` records may have a
/// non-zero similarity score if the self-similarity is below the split threshold. To display this value like core
/// Git, invert the score by subtracting it from 100.
///
/// ## C Equivalent
///
/// [`git_diff_delta`](https://libgit2.org/docs/reference/main/diff/git_diff_delta.html)
public struct GitDiffDelta: GitStructReadable, WithCConvertible
{
    /// The type of change described by a diff delta.
    public let status       : GitDeltaT
    
    /// The flags for the delta object and the file objects on each side of the delta.
    public let flags        : GitDiffFlagT
    
    /// The similarity threshold (0 - 100) of the item for ``GitDeltaT/gitDeltaRenamed``
    /// and ``GitDeltaT/gitDeltaCopied`` changes.
    public let similarity   : UInt16
    
    /// The number of files in this delta.
    public let nFiles       : UInt16
    
    /// The old version of the file.
    public let oldFile      : GitDiffFile
    
    /// The new version of the file.
    public let newFile      : GitDiffFile
    
    
    
    /// Creates a ``GitDiffDelta`` instance from a `git_diff_delta` instance.
    /// - Parameter diffDelta: The `git_diff_delta` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``status`` defaults to ``GitDeltaT/gitDeltaUnmodified`` if an unexpected value
    /// is encountered, although this should never occur.
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
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_delta` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
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



/// The options for the diff operation.
///
/// ## C Equivalent
///
/// [`git_diff_options`](https://libgit2.org/docs/reference/main/diff/git_diff_options.html)
public struct GitDiffOptions: GitStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffOptionsVersion``.
    public var version          : UInt32                    = gitDiffOptionsVersion
    
    /// The flags controlling the diff operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitDiffOptionT/gitDiffNormal``.
    public var flags            : GitDiffOptionT            = .gitDiffNormal
    
    /// The submodule ignore options.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitSubmoduleIgnoreT/gitSubmoduleIgnoreUnspecified``.
    public var ignoreSubmodules : GitSubmoduleIgnoreT       = .gitSubmoduleIgnoreUnspecified
    
    /// The paths or `fnmatch` patterns to constrain the diff.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var pathspec         : [String]                  = []
    
    /// The callback for notifications of new diff deltas being added during the diff operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var notifyCB         : GitDiffNotifyCB?          = nil
    
    /// The callback for notifications of which files are being examined during the diff operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressCB       : GitDiffProgressCB?        = nil
    
    /// The caller-specified payload passed to ``notifyCB`` and ``progressCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload          : UnsafeMutableRawPointer?  = nil
    
    /// The number of unchanged lines that define the boundaries of a diff hunk, and should
    /// be displayed before and after each hunk.
    ///
    /// ## Discussion
    ///
    /// The default value is `3`.
    public var contextLines     : UInt32                    = 3
    
    /// The maximum number of unchanged lines between diff hunk boundaries before the
    /// hunks should be merged.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var interHunkLines   : UInt32                    = 0
    
    /// The type of OID to emit in diffs.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This is used by functions that operate without a repository. If a repository is available,
    /// the OID format of the repository will be used. Otherwise, if there is no repository available
    /// and this is `nil` at runtime, libgit2 defaults to using ``GitOIDT/gitOIDSHA1``.
    ///
    /// If this is specified and a repository is available, the specified type should match the
    /// repository's OID format.
    public var oidType          : GitOIDT?                  = nil
    
    /// The abbreviation length to use when formatting OIDs.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// value of `core.abbrev` from the configuration file, or `7` if that value is unset.
    public var idAbbrev         : UInt16?                   = nil
    
    /// The maximum size, in bytes, above which a blob will be automatically marked as binary.
    ///
    /// ## Discussion
    ///
    /// The default value is  512 MB.
    ///
    /// Pass a negative value to disable the limit.
    public var maxSize          : GitOffT                   = 536_870_912
    
    /// The virtual directory prefix for old file names in diff hunk headers.
    ///
    /// ## Discussion
    ///
    /// The default value is `a`.
    public var oldPrefix        : String                    = "a"
    
    /// The virtual directory prefix for new file names in diff hunk headers.
    ///
    /// ## Discussion
    ///
    /// The default value is `b`.
    public var newPrefix        : String                    = "b"
    
    
    
    /// Creates a ``GitDiffOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitDiffOptions`` instance from a `git_diff_options` instance.
    /// - Parameter diffOptions: The `git_diff_options` instance to use.
    ///
    /// ## Discussion
    ///
    /// If unexpected values are encountered, the following defaults are used, although this should
    /// never occur.
    ///
    /// - ``ignoreSubmodules``: ``GitSubmoduleIgnoreT/gitSubmoduleIgnoreUnspecified``
    /// - ``oldPrefix``: `a`
    /// - ``newPrefix``: `b`
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
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
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
public struct GitDiffBinaryFile: GitStructReadable, WithCConvertible
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
    
    
    
    /// Creates a ``GitDiffBinaryFile`` instance from a `git_diff_binary_file` instance.
    /// - Parameter diffBinaryFile: The `git_diff_binary_file` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``type`` defaults to ``GitDiffBinaryT/gitDiffBinaryNone`` if an unexpected value
    /// is encountered, although this should never occur.
    internal init(
        cValue diffBinaryFile: git_diff_binary_file
    )
    {
        self.type           = GitDiffBinaryT(cValue: diffBinaryFile.type) ?? .gitDiffBinaryNone
        self.data           = diffBinaryFile.data.map { Data(bytes: $0, count: diffBinaryFile.datalen) }
        self.inflatedLen    = diffBinaryFile.inflatedlen
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_binary_file` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_binary_file>) throws -> T
    ) throws -> T
    {
        var diffBinaryFile = git_diff_binary_file()
        
        diffBinaryFile.type = type.cValue()
        
        guard
            let data: Data = data,
            !data.isEmpty
        else
        {
            diffBinaryFile.data         = nil
            diffBinaryFile.datalen      = 0
            diffBinaryFile.inflatedlen  = 0
            
            return try body(&diffBinaryFile)
        }
        
        return try data.withCBuffer
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
/// A binary file or binary delta is a file (or pair of files) for which no text diffs should be generated.
/// A diff can contain delta entries that are binary, but no diff content will be output for those files.
///
/// ## C Equivalent
///
/// [`git_diff_binary`](https://libgit2.org/docs/reference/main/diff/git_diff_binary.html)
public struct GitDiffBinary: GitStructReadable, WithCConvertible
{
    /// Whether there is data in the binary.
    ///
    /// ## Discussion
    ///
    /// If this is `false`, then the instance was generated knowing only that a binary file changed,
    /// but without providing the data.
    public let containsData : Bool
    
    /// The contents of the old file.
    public let oldFile      : GitDiffBinaryFile
    
    /// The contents of the new file.
    public let newFile      : GitDiffBinaryFile
    
    
    
    /// Creates a ``GitDiffBinary`` instance from a `git_diff_binary` instance.
    /// - Parameter diffBinary: The `git_diff_binary` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``type`` defaults to ``GitDiffBinaryT/gitDiffBinaryNone`` if an unexpected value
    /// is encountered, although this should never occur.
    internal init(
        cValue diffBinary: git_diff_binary
    )
    {
        self.containsData   = Bool(diffBinary.contains_data)
        self.oldFile        = GitDiffBinaryFile(cValue: diffBinary.old_file)
        self.newFile        = GitDiffBinaryFile(cValue: diffBinary.new_file)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_binary` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_binary>) throws -> T
    ) throws -> T
    {
        var diffBinary = git_diff_binary()
        
        diffBinary.contains_data = UInt32(containsData.intValue)
        
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
/// A hunk is a span of modified lines in a diff delta along with some stable surrounding context. Each
/// hunk also comes with a header that described where it starts and ends in the delta, in both the old
/// and new files.
///
/// ## C Equivalent
///
/// [`git_diff_hunk`](https://libgit2.org/docs/reference/main/diff/git_diff_hunk.html)
public struct GitDiffHunk: GitStructInternalMutable, CConvertible
{
    /// The starting line number in the old file.
    public private(set) var oldStart    : Int32     = 0
    
    /// The number of lines in the old file.
    public private(set) var oldLines    : Int32     = 0
    
    /// The starting line number in the new file.
    public private(set) var newStart    : Int32     = 0
    
    /// The number of lines in the new file.
    public private(set) var newLines    : Int32     = 0
    
    /// The length of ``header``.
    public var headerLen                : Int
    {
        return header?.count ?? 0
    }
    
    /// The header text.
    public private(set) var header      : String?   = nil
    
    
    
    /// Creates a ``GitDiffHunk`` instance.
    public init() { }
    
    
    
    /// Creates a ``GitDiffHunk`` instance from a `git_diff_hunk` instance.
    /// - Parameter diffHunk: The `git_diff_hunk` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``type`` defaults to ``GitDiffBinaryT/gitDiffBinaryNone`` if an unexpected value
    /// is encountered, although this should never occur.
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
/// A line (or data span) is a range of characters inside a diff hunk. It could be a context line (a line that
/// exists in both the old and new versions), an added line (a line that exists only in the new version), or
/// a deleted line (a line that exists only in the old version).
///
/// ## C Equivalent
///
/// [`git_diff_line`](https://libgit2.org/docs/reference/main/diff/git_diff_line.html)
public struct GitDiffLine: GitStructInternalMutable, WithCConvertible
{
    /// The type of line origin.
    public private(set) var origin          : GitDiffLineT  = .gitDiffLineContext
    
    /// The line number in the old file, or `-1` to indicate an added line.
    public private(set) var oldLineNo       : Int32         = 0
    
    /// The line number in the new file, or `-1` to indicate a deleted line.
    public private(set) var newLineNo       : Int32         = 0
    
    /// The number of newline characters in the diff text.
    public private(set) var numLines        : Int32         = 0
    
    /// The length of ``content``.
    public var contentLen                   : Int
    {
        return content?.count ?? 0
    }
    
    /// The offset in the original file to the diff text.
    public private(set) var contentOffset   : GitOffT       = 0
    
    /// The diff text.
    public private(set) var content         : Data?         = nil
    
    
    
    /// Creates a ``GitDiffLine`` instance.
    public init() { }
    
    
    
    /// Creates a ``GitDiffLine`` instance from a `git_diff_line` instance.
    /// - Parameter diffLine: The `git_diff_line` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``origin`` defaults to ``GitDiffLineT/gitDiffLineContext`` if an unexpected value
    /// is encountered, although this should never occur.
    internal init(
        cValue diffLine: git_diff_line
    )
    {
        self.origin         = GitDiffLineT(rawValue: UInt32(diffLine.origin)) ?? .gitDiffLineContext
        self.oldLineNo      = diffLine.old_lineno
        self.newLineNo      = diffLine.new_lineno
        self.numLines       = diffLine.num_lines
        self.contentOffset  = diffLine.content_offset
        self.content        = diffLine.content.map { Data(bytes: $0, count: diffLine.content_len) }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_diff_line` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_diff_line>) throws -> T
    ) throws -> T
    {
        var diffLine = git_diff_line()
        
        diffLine.origin             = CChar(origin.rawValue)
        diffLine.old_lineno         = oldLineNo
        diffLine.new_lineno         = newLineNo
        diffLine.num_lines          = numLines
        diffLine.content_offset     = contentOffset
        
        guard
            let content: Data = content,
            !content.isEmpty
        else
        {
            diffLine.content_len    = 0
            diffLine.content        = nil
            
            return try body(&diffLine)
        }
        
        return try content.withCBuffer
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
/// ## Discussion
///
/// This struct is provided for documentation purposes, but is not used by other bindings.
///
/// `git_diff_similarity_metric` is treated as an opaque struct since its function pointers are
/// allocated and managed by libgit2, and cannot be meaningfully recreated or translated.
///
/// ## C Equivalent
///
/// [`git_diff_similarity_metric`](https://libgit2.org/docs/reference/main/diff/git_diff_similarity_metric.html)
public struct GitDiffSimilarityMetric: GitStruct
{
    /// The function to generate a signature for a file.
    public let fileSignature: @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafePointer<git_diff_file>?,
        UnsafePointer<CChar>?,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    /// The function to generate a signature for a buffer.
    public let bufferSignature: @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafePointer<git_diff_file>?,
        UnsafePointer<CChar>?,
        Int,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    /// The function to free a signature.
    public let freeSignature: @convention(c)
    (
        UnsafeMutableRawPointer?,
        UnsafeMutableRawPointer?
    ) -> Void
    
    /// The function to determine the similarity score of two files.
    public let similarity: @convention(c)
    (
        UnsafeMutablePointer<Int32>?,
        UnsafeMutableRawPointer?,
        UnsafeMutableRawPointer?,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    /// The payload provided by the caller.
    public let payload: UnsafeMutableRawPointer?
    
    
    
    /// Creates a ``GitDiffSimilarityMetric`` instance from a
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
}



/// The options for diff rename and copy detection.
///
/// ## C Equivalent
///
/// [`git_diff_find_options`](https://libgit2.org/docs/reference/main/diff/git_diff_find_options.html)
public struct GitDiffFindOptions: GitStructMutable, ThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffFindOptionsVersion``.
    public var version                      : UInt32                            = gitDiffFindOptionsVersion
    
    /// The flags controlling diff rename and copy detection.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitDiffFindT/gitDiffFindByConfig``.
    public var flags                        : GitDiffFindT                      = .gitDiffFindByConfig
    
    /// The threshold above which similar files will be considered renames.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to `git diff --find-renames`.
    public var renameThreshold              : UInt16                            = 50
    
    /// The threshold below which similar files will be eligible to be a rename source.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to the first part of `git diff --break-rewrites`.
    public var renameFromRewriteThreshold   : UInt16                            = 50
    
    /// The threshold above which similar files will be considered copies.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to `git diff --find-copies`.
    public var copyThreshold                : UInt16                            = 50
    
    /// The threshold below which similar files will be split into an add/delete pair.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to the last part of `git diff --break-rewrites`.
    public var breakRewriteThreshold        : UInt16                            = 50
    
    /// The maximum number of matches to consider for a particular file.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is slightly different from `git diff -l`, since libgit2 will still process up to the specified
    /// number of matches before abandoning the search.
    public var renameLimit                  : Int                               = 1000
    
    /// The pluggable similarity metric.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using a sampling hash
    /// of ranges of data in the file. This is a reliable similarity approximation that generally works well
    /// for both text and binary data, while maintaining speed and a fixed memory overhead.
    ///
    /// - Important: If a custom metric is provided, the caller is responsible for memory management.
    public var metric                       : UnsafeMutablePointer<
                                                git_diff_similarity_metric>?    = nil
    
    
    
    /// Creates a ``GitDiffFindOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitDiffFindOptions`` instance from a `git_diff_find_options` instance.
    /// - Parameter diffFindOptions: The `git_diff_find_options` instance to use.
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
    
    
    
    /// Converts the ``GitDiffFindOptions`` instance into a `git_diff_find_options`
    /// instance.
    /// - Returns: The `git_diff_find_options` instance.
    /// - Throws: An `NSError` if the conversion failed.
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
public struct GitDiffParseOptions: GitStructMutable, CConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffParseOptionsVersion``.
    public var version  : UInt32    = gitDiffParseOptionsVersion
    
    /// The OID type used in the patch file.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitOIDT/gitOIDSHA1``.
    public var oidType  : GitOIDT   = .gitOIDSHA1
    
    
    
    /// Creates a ``GitDiffParseOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitDiffParseOptions`` instance from a `git_diff_parse_options`
    /// instance.
    /// - Parameter diffParseOptions: The `git_diff_parse_options` instance to use.
    internal init(
        cValue diffParseOptions: git_diff_parse_options
    )
    {
        self.version    = diffParseOptions.version
        self.oidType    = GitOIDT(cValue: diffParseOptions.oid_type) ?? .gitOIDSHA1
    }
    
    
    
    /// Converts the ``GitDiffParseOptions`` instance into a `git_diff_parse_options`
    /// instance.
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
public struct GitDiffPatchIDOptions: GitStructMutable, ThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDiffPatchIDOptionsVersion``.
    public var version  : UInt32    = gitDiffPatchIDOptionsVersion
    
    
    
    /// Creates a ``GitDiffPatchIDOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitDiffPatchIDOptions`` instance from a `git_diff_patchid_options`
    /// instance.
    /// - Parameter diffPatchIDOptions: The `git_diff_patchid_options` instance
    /// to use.
    internal init(
        cValue diffPatchIDOptions: git_diff_patchid_options
    )
    {
        self.version = diffPatchIDOptions.version
    }
    
    
    
    /// Converts the ``GitDiffPatchIDOptions`` instance into a `git_diff_patchid_options`
    /// instance.
    /// - Returns: The `git_diff_patchid_options` instance.
    /// - Throws: An `NSError` if the conversion failed.
    internal func cValue() throws -> git_diff_patchid_options
    {
        var diffPatchIDOptions = git_diff_patchid_options()
        
        let diffPatchIDOptionsInitResult: GitErrorCode = gitDiffPatchIDOptionsInit(
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
