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



/// The information about the progress of indexing a packfile.
///
/// ## C Equivalent
///
/// [`git_indexer_progress`](https://libgit2.org/docs/reference/main/indexer/git_indexer_progress.html)
public struct GitIndexerProgress: GitStructInternalMutable, CConvertible
{
    /// The number of objects being indexed.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var totalObjects    : UInt32    = 0
    
    /// The number of received objects that have been hashed.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var indexedObjects  : UInt32    = 0
    
    /// The number of objects that have been downloaded.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var receivedObjects : UInt32    = 0
    
    /// The number of locally-available objects that have been injected in
    /// order to fix a thin pack.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var localObjects    : UInt32    = 0
    
    /// The number of deltas being indexed.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var totalDeltas     : UInt32    = 0
    
    /// The number of deltas that have been indexed.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var indexedDeltas   : UInt32    = 0
    
    /// The number of bytes that been received up until the current time.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var receivedBytes   : Int       = 0
    
    
    
    /// Creates a ``GitIndexerProgress`` instance with the default
    /// configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitIndexerProgress`` instance from a `git_indexer_progress`
    /// instance.
    /// - Parameter indexerProgress: The `git_indexer_progress` instance to use.
    internal init(
        cValue indexerProgress: git_indexer_progress
    )
    {
        self.totalObjects       = indexerProgress.total_objects
        self.indexedObjects     = indexerProgress.indexed_objects
        self.receivedObjects    = indexerProgress.received_objects
        self.localObjects       = indexerProgress.local_objects
        self.totalDeltas        = indexerProgress.total_deltas
        self.indexedDeltas      = indexerProgress.indexed_deltas
        self.receivedBytes      = indexerProgress.received_bytes
    }
    
    
    
    /// Converts the ``GitIndexerProgress`` instance into a
    /// `git_indexer_progress` instance.
    /// - Returns: The `git_indexer_progress` instance.
    internal func cValue() -> git_indexer_progress
    {
        var indexerProgress = git_indexer_progress()
        
        indexerProgress.total_objects       = totalObjects
        indexerProgress.indexed_objects     = indexedObjects
        indexerProgress.received_objects    = receivedObjects
        indexerProgress.local_objects       = localObjects
        indexerProgress.total_deltas        = totalDeltas
        indexerProgress.indexed_deltas      = indexedDeltas
        indexerProgress.received_bytes      = receivedBytes
        
        return indexerProgress
    }
}



/// The indexer options.
///
/// ## C Equivalent
///
/// [`git_indexer_options`](https://libgit2.org/docs/reference/main/indexer/git_indexer_options.html)
public struct GitIndexerOptions: GitStructMutable, ThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitIndexerOptionsVersion``.
    public var version              : UInt32                    = gitIndexerOptionsVersion
    
    /// The callback to report progress during the indexing operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressCB           : GitIndexerProgressCB?     = nil
    
    /// The caller-specified payload passed to ``progressCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressCBPayload    : UnsafeMutableRawPointer?  = nil
    
    /// Whether connectivity checks should be performed for the received pack.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var verify               : Bool                      = false
    
    
    
    /// Creates a ``GitIndexerOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitIndexerOptions`` instance from a `git_indexer_options`
    /// instance.
    /// - Parameter indexerOptions: The `git_indexer_options` instance
    /// to use.
    internal init(
        cValue indexerOptions: git_indexer_options
    )
    {
        self.version            = indexerOptions.version
        self.progressCB         = indexerOptions.progress_cb
        self.progressCBPayload  = indexerOptions.progress_cb_payload
        self.verify             = Bool(indexerOptions.verify)
    }
    
    
    
    /// Converts the ``GitIndexerOptions`` instance into a `git_indexer_options`
    /// instance.
    /// - Returns: The `git_indexer_options` instance.
    /// - Throws: An error if the conversion fails.
    internal func cValue() throws -> git_indexer_options
    {
        var indexerOptions = git_indexer_options()
        
        let indexerOptionsInitResult: GitErrorCode = gitIndexerOptionsInit(
            opts:       &indexerOptions,
            version:    version
        )
        
        if indexerOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        indexerOptions.progress_cb          = progressCB
        indexerOptions.progress_cb_payload  = progressCBPayload
        indexerOptions.verify               = verify.uint8Value
        
        return indexerOptions
    }
}
