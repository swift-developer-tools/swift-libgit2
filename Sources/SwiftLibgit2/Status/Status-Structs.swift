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



/// The options for checking the status of files.
///
/// ## C Equivalent
///
/// [`git_status_options`](https://libgit2.org/docs/reference/main/status/git_status_options.html)
public struct GitStatusOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitStatusOptionsVersion``.
    public var version          : UInt32
    
    /// The type of file to select for status reporting.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitStatusShowT/gitStatusShowIndexAndWorkdir``.
    public var show             : GitStatusShowT
    
    /// The flags controlling status callbacks.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags            : GitStatusOptT
    
    /// The array of patterns to match using `fnmatch`-style matching, or
    /// to match exactly if ``flags`` specifies
    /// ``GitStatusOptT/gitStatusOptDisablePathspecMatch``.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var pathspec         : [String]
    
    /// The tree used for comparing the index and the working directory. The
    /// underlying type must be `git_tree`.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use HEAD.
    public var baseline         : OpaquePointer?
    
    /// The threshold above which similar files will be considered renames.
    ///
    /// ## Discussion
    ///
    /// The default value is `50`.
    ///
    /// This is equivalent to `git diff --find-renames`.
    public var renameThreshold  : UInt16
    
    
    
    /// Initializes a ``GitStatusOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32            = gitStatusOptionsVersion,
        show            : GitStatusShowT    = .gitStatusShowIndexAndWorkdir,
        flags           : GitStatusOptT     = [],
        pathspec        : [String]          = [],
        baseline        : OpaquePointer?    = nil,
        renameThreshold : UInt16            = 50
    )
    {
        self.version            = version
        self.show               = show
        self.flags              = flags
        self.pathspec           = pathspec
        self.baseline           = baseline
        self.renameThreshold    = renameThreshold
    }
    
    
    
    /// Initializes a ``GitStatusOptions`` instance from the given
    /// `git_status_options` instance.
    /// - Parameter statusOptions: The `git_status_options` instance to use.
    internal init(
        cValue statusOptions: git_status_options
    )
    {
        self.version            = statusOptions.version
        self.show               = GitStatusShowT(cValue: statusOptions.show) ?? .gitStatusShowIndexAndWorkdir
        self.flags              = GitStatusOptT(rawValue: statusOptions.flags)
        self.pathspec           = Array(statusOptions.pathspec)
        self.baseline           = statusOptions.baseline
        self.renameThreshold    = statusOptions.rename_threshold
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_status_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_status_options>) throws -> T
    ) throws -> T
    {
        var statusOptions = git_status_options()
        
        let statusOptionsInitResult: GitErrorCode = gitStatusOptionsInit(
            opts:       &statusOptions,
            version:    version
        )
        
        if statusOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        statusOptions.show              = show.cValue()
        statusOptions.flags             = flags.rawValue
        statusOptions.baseline          = baseline
        statusOptions.rename_threshold  = renameThreshold
        
        return try pathspec.withGitStrArray
        {
            cPathspec in
            
            statusOptions.pathspec = cPathspec.pointee
            
            return try body(&statusOptions)
        }
    }
}



/// A status entry representing differences of a file between the index,
/// the working directory, and HEAD.
///
/// ## C Equivalent
///
/// [`git_status_entry`](https://libgit2.org/docs/reference/main/status/git_status_entry.html)
public struct GitStatusEntry: CStructReadable, WithCConvertible, Sendable
{
    /// The status of the file.
    public let status           : GitStatusT
    
    /// The differences between HEAD and the index.
    public let headToIndex      : GitDiffDelta?
    
    /// The differences between the index and the working directory.
    public let indexToWorkdir   : GitDiffDelta?
    
    
    
    /// Initializes a ``GitStatusEntry`` instance from the given
    /// `git_status_entry` instance.
    /// - Parameter statusEntry: The `git_status_entry` instance to use.
    internal init(
        cValue statusEntry: git_status_entry
    )
    {
        self.status = GitStatusT(cValue: statusEntry.status)
        
        self.headToIndex = statusEntry.head_to_index != nil
            ? GitDiffDelta(cValue: statusEntry.head_to_index.pointee)
            : nil
        
        self.indexToWorkdir = statusEntry.index_to_workdir != nil
            ? GitDiffDelta(cValue: statusEntry.index_to_workdir.pointee)
            : nil
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_status_entry`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_status_entry>) throws -> T
    ) throws -> T
    {
        var statusEntry = git_status_entry()
        
        statusEntry.status = status.cValue()
        
        return try headToIndex.withOptionalCValue
        {
            cHeadToIndex in
            
            statusEntry.head_to_index = cHeadToIndex
            
            return try indexToWorkdir.withOptionalCValue
            {
                cIndexToWorkdir in
                
                statusEntry.index_to_workdir = cIndexToWorkdir
                
                return try body(&statusEntry)
            }
        }
    }
}
