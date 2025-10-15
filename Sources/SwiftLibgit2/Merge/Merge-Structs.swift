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



/// The file input to the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_file_input`](https://libgit2.org/docs/reference/main/merge/git_merge_file_input.html)
public struct GitMergeFileInput: CStructMutable, WithCConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitMergeFileInputVersion``.
    public var version  : UInt32
    
    /// The contents of the file.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var ptr      : Data?
    
    /// The length of ``ptr``.
    public var size     : Int
    {
        return ptr?.count ?? 0
    }
    
    /// The filename of the conflicted file.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. Pass `nil` to not merge the path.
    public var path     : String?
    
    /// The file mode of the conflicted file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`. Pass `0` to not merge the mode.
    public var mode     : UInt32
    
    
    
    /// Initializes a ``GitMergeFileInput`` instance, optionally specifying
    /// values for its properties.
    public init(
        version : UInt32    = gitMergeFileInputVersion,
        ptr     : Data?     = nil,
        path    : String?   = nil,
        mode    : UInt32    = 0
    )
    {
        self.version    = version
        self.ptr        = ptr
        self.path       = path
        self.mode       = mode
    }
    
    
    
    /// Initializes a ``GitMergeFileInput`` instance from the given
    /// `git_merge_file_input` instance.
    /// - Parameter mergeFileInput: The `git_merge_file_input` instance to use.
    internal init(
        cValue mergeFileInput: git_merge_file_input
    )
    {
        self.version    = mergeFileInput.version
        self.ptr        = mergeFileInput.ptr.map { Data(bytes: $0, count: mergeFileInput.size) }
        self.path       = String(optionalCString: mergeFileInput.path)
        self.mode       = mergeFileInput.mode
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_merge_file_input` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_merge_file_input>) throws -> T
    ) throws -> T
    {
        var mergeFileInput = git_merge_file_input()
        
        let mergeFileInputInitResult: GitErrorCode = gitMergeFileInputInit(
            opts:       &mergeFileInput,
            version:    version
        )
        
        if mergeFileInputInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        mergeFileInput.mode = mode
        
        return try ptr.withOptionalCBuffer
        {
            cPtr, cPtrCount in
            
            mergeFileInput.ptr      = cPtr
            mergeFileInput.size     = cPtrCount
            
            return try path.withOptionalCString
            {
                cPath in
                
                mergeFileInput.path = cPath
                
                return try body(&mergeFileInput)
            }
        }
    }
}



/// The options for the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_file_options`](https://libgit2.org/docs/reference/main/merge/git_merge_file_options.html)
public struct GitMergeFileOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitMergeFileOptionsVersion``.
    public var version          : UInt32
    
    /// The name of the common ancestor of conflicts
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var ancestorLabel    : String?
    
    /// The name of "our" side of conflicts.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var ourLabel         : String?
    
    /// The name of "their" side of conflicts.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var theirLabel       : String?
    
    /// How to handle conflicting file regions during file-level merge
    /// operations.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFileFavorT/gitMergeFileFavorNormal``.
    public var favor            : GitMergeFileFavorT
    
    /// The flags controlling the behavior of the file-merging operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFileFlagT/gitMergeFileDefault``.
    public var flags            : GitMergeFileFlagT
    
    /// The size of conflict markers.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitMergeConflictMarkerSize``.
    public var markerSize       : UInt16
    
    
    
    /// Initializes a ``GitMergeFileOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                = gitMergeFileOptionsVersion,
        ancestorLabel   : String?               = nil,
        ourLabel        : String?               = nil,
        theirLabel      : String?               = nil,
        favor           : GitMergeFileFavorT    = .gitMergeFileFavorNormal,
        flags           : GitMergeFileFlagT     = .gitMergeFileDefault,
        markerSize      : UInt16                = gitMergeConflictMarkerSize
    )
    {
        self.version        = version
        self.ancestorLabel  = ancestorLabel
        self.ourLabel       = ourLabel
        self.theirLabel     = theirLabel
        self.favor          = favor
        self.flags          = flags
        self.markerSize     = markerSize
    }
    
    
    
    /// Initializes a ``GitMergeFileOptions`` instance from the given
    /// `git_merge_file_options` instance.
    /// - Parameter mergeFileOptions: The `git_merge_file_options` instance
    /// to use.
    ///
    /// ## Discussion
    ///
    /// ``favor`` defaults to ``GitMergeFileFavorT/gitMergeFileFavorNormal``
    /// if an unexpected value is encountered, although this should never occur.
    internal init(
        cValue mergeFileOptions: git_merge_file_options
    )
    {
        self.version        = mergeFileOptions.version
        self.ancestorLabel  = String(optionalCString: mergeFileOptions.ancestor_label)
        self.ourLabel       = String(optionalCString: mergeFileOptions.our_label)
        self.theirLabel     = String(optionalCString: mergeFileOptions.their_label)
        self.favor          = GitMergeFileFavorT(cValue: mergeFileOptions.favor) ?? .gitMergeFileFavorNormal
        self.flags          = GitMergeFileFlagT(rawValue: mergeFileOptions.flags)
        self.markerSize     = mergeFileOptions.marker_size
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_merge_file_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_merge_file_options>) throws -> T
    ) throws -> T
    {
        var mergeFileOptions = git_merge_file_options()
        
        let mergeOptionsFileInitResult: GitErrorCode = gitMergeFileOptionsInit(
            opts:       &mergeFileOptions,
            version:    version
        )
        
        if mergeOptionsFileInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        mergeFileOptions.favor          = favor.cValue()
        mergeFileOptions.flags          = flags.rawValue
        mergeFileOptions.marker_size    = markerSize
        
        return try ancestorLabel.withOptionalCString
        {
            cAncestorLabel in
            
            mergeFileOptions.ancestor_label = cAncestorLabel
            
            return try ourLabel.withOptionalCString
            {
                cOurLabel in
                
                mergeFileOptions.our_label = cOurLabel
                
                return try theirLabel.withOptionalCString
                {
                    cTheirLabel in
                    
                    mergeFileOptions.their_label = cTheirLabel
                    
                    return try body(&mergeFileOptions)
                }
            }
        }
    }
}



/// The result of a file-level merge.
///
/// ## C Equivalent
///
/// [`git_merge_file_result`](https://libgit2.org/docs/reference/main/merge/git_merge_file_result.html)
public struct GitMergeFileResult: CFreeable, CStructInternalMutable, WithCConvertible, Sendable
{
    /// Whether the output was auto-merged.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    ///
    /// If the output contains conflict markers, it cannot be auto-merged.
    public private(set) var automergeable   : Bool      = false
    
    /// The path that should be used by the resulting file, or `nil` if a
    /// filename conflict would have otherwise occurred.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var path            : String?   = nil
    
    /// The file mode that should be used by the resulting file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var mode            : UInt32    = 0
    
    /// The contents of the merge.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var ptr             : Data?     = nil
    
    /// The length of ``ptr``.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var len                          : Int
    {
        return ptr?.count ?? 0
    }
    
    
    
    /// Initializes a default ``GitMergeFileResult`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitMergeFileResult`` instance from the given
    /// `git_merge_file_result` instance.
    /// - Parameter mergeFileResult: The `git_merge_file_result` instance to
    /// use.
    internal init(
        cValue mergeFileResult: git_merge_file_result
    )
    {
        self.automergeable  = Bool(mergeFileResult.automergeable)
        self.path           = String(optionalCString: mergeFileResult.path)
        self.mode           = mergeFileResult.mode
        self.ptr            = mergeFileResult.ptr.map { Data(bytes: $0, count: mergeFileResult.len) }
    }
    
    
    
    /// Frees the memory allocated for the C value.
    /// - Parameter pointer: The pointer to the memory to free.
    internal static func freeCValue(
        _ pointer: P
    )
    {
        gitMergeFileResultFree(result: pointer)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_merge_file_result` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_merge_file_result>) throws -> T
    ) rethrows -> T
    {
        var mergeFileResult = git_merge_file_result()
        
        mergeFileResult.automergeable   = automergeable.uint32Value
        mergeFileResult.mode            = mode
        
        return try path.withOptionalCString
        {
            cPath in
            
            mergeFileResult.path = cPath
            
            guard
                let ptr: Data = ptr,
                !ptr.isEmpty
            else
            {
                mergeFileResult.ptr     = nil
                mergeFileResult.len     = 0
                
                return try body(&mergeFileResult)
            }
            
            return try ptr.withCBuffer
            {
                cPtr, cPtrCount in
                
                mergeFileResult.ptr     = cPtr
                mergeFileResult.len     = cPtrCount
                
                return try body(&mergeFileResult)
            }
        }
    }
}



/// The options for the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_options`](https://libgit2.org/docs/reference/main/merge/git_merge_options.html)
public struct GitMergeOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitMergeOptionsVersion``.
    public var version          : UInt32
    
    /// The flags controlling the behavior of the merge operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFlagT/gitMergeFindRenames``.
    public var flags            : GitMergeFlagT
    
    /// The similarity percentage beyond which a file should be treated as
    /// a rename.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// If ``GitMergeFlagT/gitMergeFindRenames`` is enabled, added files will
    /// be compared with deleted files to determine their similarity. Files
    /// that are more similar than the rename threshold (percentage-wise) will
    /// be treated as a rename.
    public var renameThreshold  : UInt32
    
    /// Maximum similarity sources to examine for renames.
    ///
    /// ## Discussion
    ///
    /// The default value is `200`.
    ///
    /// If the number of rename candidates (add/delete pairs) is greater than
    /// this value, exact rename detection will be aborted.
    ///
    /// This overrides the `merge.renameLimit` configuration value.
    public var targetLimit      : UInt32
    
    /// The pluggable similarity metric.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using the internal metric.
    public var metric           : UnsafeMutablePointer<
                                    git_diff_similarity_metric>?
    
    /// The maximum number of times to merge common ancestors to build a
    /// virtual merge base when faced with criss-cross merges.
    ///
    /// ## Discussion
    ///
    /// The default value is `0` (unlimited).
    ///
    /// When this limit is reached, the next ancestor will simply be used
    /// instead of attempting to merge it.
    public var recursionLimit   : UInt32
    
    /// The default merge driver to be used when both sides of a merge have
    /// changed.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using the `text` driver.
    public var defaultDriver    : String?
    
    /// How to handle conflicting file regions during file-level merge
    /// operations.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFileFavorT/gitMergeFileFavorNormal``.
    public var fileFavor        : GitMergeFileFavorT
    
    /// The flags controlling the behavior of the file-merging operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFileFlagT/gitMergeFileDefault``.
    public var fileFlags        : GitMergeFileFlagT
    
    
    
    /// Initializes a ``GitMergeOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                            = gitMergeOptionsVersion,
        flags           : GitMergeFlagT                     = .gitMergeFindRenames,
        renameThreshold : UInt32                            = 50,
        targetLimit     : UInt32                            = 200,
        metric          : UnsafeMutablePointer<
                            git_diff_similarity_metric>?    = nil,
        recursionLimit  : UInt32                            = 0,
        defaultDriver   : String?                           = nil,
        fileFavor       : GitMergeFileFavorT                = .gitMergeFileFavorNormal,
        fileFlags       : GitMergeFileFlagT                 = .gitMergeFileDefault
    )
    {
        self.version            = version
        self.flags              = flags
        self.renameThreshold    = renameThreshold
        self.targetLimit        = targetLimit
        self.metric             = metric
        self.recursionLimit     = recursionLimit
        self.defaultDriver      = defaultDriver
        self.fileFavor          = fileFavor
        self.fileFlags          = fileFlags
    }
    
    
    
    /// Initializes a ``GitMergeOptions`` instance from the given
    /// `git_merge_options` instance.
    /// - Parameter mergeOptions: The `git_merge_options` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``fileFavor`` defaults to ``GitMergeFileFavorT/gitMergeFileFavorNormal``
    /// if an unexpected value is encountered, although this should never occur.
    internal init(
        cValue mergeOptions: git_merge_options
    )
    {
        self.version            = mergeOptions.version
        self.flags              = GitMergeFlagT(rawValue: mergeOptions.flags)
        self.renameThreshold    = mergeOptions.rename_threshold
        self.targetLimit        = mergeOptions.target_limit
        self.metric             = mergeOptions.metric
        self.recursionLimit     = mergeOptions.recursion_limit
        self.defaultDriver      = String(optionalCString: mergeOptions.default_driver)
        self.fileFavor          = GitMergeFileFavorT(cValue: mergeOptions.file_favor) ?? .gitMergeFileFavorNormal
        self.fileFlags          = GitMergeFileFlagT(rawValue: mergeOptions.file_flags)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_merge_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_merge_options>) throws -> T
    ) throws -> T
    {
        var mergeOptions = git_merge_options()
        
        let mergeOptionsInitResult: GitErrorCode = gitMergeOptionsInit(
            opts:       &mergeOptions,
            version:    version
        )
        
        if mergeOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        mergeOptions.flags              = flags.rawValue
        mergeOptions.rename_threshold   = renameThreshold
        mergeOptions.target_limit       = targetLimit
        mergeOptions.metric             = metric
        mergeOptions.recursion_limit    = recursionLimit
        mergeOptions.file_favor         = fileFavor.cValue()
        mergeOptions.file_flags         = fileFlags.rawValue
        
        return try defaultDriver.withOptionalCString
        {
            cDefaultDriver in
            
            mergeOptions.default_driver = cDefaultDriver
            
            return try body(&mergeOptions)
        }
    }
}
