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



/// The options for the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_options`](https://libgit2.org/docs/reference/main/merge/git_merge_options.html)
public struct GitMergeOptions: GitStructMutable, WithThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitMergeOptionsVersion``.
    public var version          : UInt32                            = gitMergeOptionsVersion
    
    /// The flags controlling the behavior of the merge operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFlagT/gitMergeFindRenames``.
    public var flags            : GitMergeFlagT                     = .gitMergeFindRenames
    
    /// The similarity percentage beyond which a file should be treated as a rename.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// If ``GitMergeFlagT/gitMergeFindRenames`` is enabled, added files will be compared
    /// with deleted files to determine their similarity. Files that are more similar than the rename threshold
    /// (percentage-wise) will be treated as a rename.
    public var renameThreshold  : UInt32                            = 50
    
    /// Maximum similarity sources to examine for renames.
    ///
    /// ## Discussion
    ///
    /// The default value is `200`.
    ///
    /// If the number of rename candidates (add/delete pairs) is greater than this value, exact rename
    /// detection will be aborted.
    ///
    /// This overrides the `merge.renameLimit` configuration value.
    public var targetLimit      : UInt32                            = 200
    
    /// The pluggable similarity metric.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the internal metric.
    public var metric           : UnsafeMutablePointer<
                                    git_diff_similarity_metric>?    = nil
    
    /// The maximum number of times to merge common ancestors to build a virtual merge base when
    /// faced with criss-cross merges.
    ///
    /// ## Discussion
    ///
    /// The default value is `0` (unlimited).
    ///
    /// When this limit is reached, the next ancestor will simply be used instead of attempting to merge it.
    public var recursionLimit   : UInt32                            = 0
    
    /// The default merge driver to be used when both sides of a merge have changed.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the `text` driver.
    public var defaultDriver    : String?                           = nil
    
    /// The flags controlling the handling of conflicting file regions during file-level merge operations.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFileFavorT/gitMergeFileFavorNormal``.
    public var fileFavor        : GitMergeFileFavorT                = .gitMergeFileFavorNormal
    
    /// The flags controlling the behavior of the file merging process.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitMergeFileFlagT/gitMergeFileDefault``.
    public var fileFlags        : GitMergeFileFlagT                 = .gitMergeFileDefault
    
    
    
    /// Creates a ``GitMergeOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitMergeOptions`` instance from a `git_merge_options` instance.
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
    
    
    
    /// Calls the given closure with a pointer to a `git_merge_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_merge_options>) throws -> T
    ) throws -> T
    {
        var mergeOptions = git_merge_options()
        
        let mergeOptionsInitResult: Int32 = git_merge_options_init(
            &mergeOptions,
            version
        )
        
        if mergeOptionsInitResult != GIT_OK.rawValue
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
