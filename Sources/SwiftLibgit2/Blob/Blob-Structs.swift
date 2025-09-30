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



/// The options for the blob filtering operation.
///
/// ## C Equivalent
///
/// [`git_blob_filter_options`](https://libgit2.org/docs/reference/main/blob/git_blob_filter_options.html)
public struct GitBlobFilterOptions: GitStructMutable, WithThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitBlobFilterOptionsVersion``.
    public var version      : UInt32                = gitBlobFilterOptionsVersion
    
    /// The flags to use during the blob filtering operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitBlobFilterFlagT/gitBlobFilterCheckForBinary``.
    public var flags        : GitBlobFilterFlagT    = .gitBlobFilterCheckForBinary
    
    /// The commit ID.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This property is unused, but is reserved for API compatibility.
    public var commitID     : GitOID?               = nil
    
    /// The commit from which to load attributes when
    /// ``GitBlobFilterFlagT/gitBlobFilterAttributesFromCommit`` is specified.
    ///
    /// ## Discussion
    ///
    /// The default value is a zero-initialized OID.
    public var attrCommitID : GitOID                = GitOID()
    
    
    
    /// Creates a ``GitBlobFilterOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitBlobFilterOptions`` instance from a
    /// `git_blob_filter_options` instance.
    /// - Parameter blobFilterOptions: The `git_blob_filter_options` instance to use.
    internal init(
        cValue blobFilterOptions: git_blob_filter_options
    )
    {
        self.version        = UInt32(blobFilterOptions.version)
        self.flags          = GitBlobFilterFlagT(rawValue: blobFilterOptions.flags)
        self.commitID       = nil
        self.attrCommitID   = GitOID(cValue: blobFilterOptions.attr_commit_id)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_blob_filter_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_blob_filter_options>) throws -> T
    ) throws -> T
    {
        var blobFilterOptions = git_blob_filter_options()
        
        let blobFilterOptionsInitResult: Int32 = git_blob_filter_options_init(
            &blobFilterOptions,
            version
        )
        
        if blobFilterOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.makeCConversionError()
        }
        
        blobFilterOptions.flags             = flags.rawValue
        blobFilterOptions.attr_commit_id    = attrCommitID.cValue()
        
        if let commitID: GitOID = commitID
        {
            var cCommitID: git_oid = commitID.cValue()
            
            return try withUnsafeMutablePointer(to: &cCommitID)
            {
                commitIDPointer in
                
                blobFilterOptions.commit_id = commitIDPointer
                
                return try body(&blobFilterOptions)
            }
        }
        else
        {
            blobFilterOptions.commit_id = nil
            
            return try body(&blobFilterOptions)
        }
    }
}
