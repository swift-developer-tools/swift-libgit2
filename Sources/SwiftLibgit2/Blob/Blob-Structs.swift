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
public struct GitBlobFilterOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitBlobFilterOptionsVersion``.
    public var version      : Int32
    
    /// The flags to use during the blob filtering operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitBlobFilterFlagT/gitBlobFilterCheckForBinary``.
    public var flags        : GitBlobFilterFlagT
    
    /// The commit ID.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// - Note: This property is unused, but is reserved for API compatibility.
    public var commitID     : GitOID?
    
    /// The commit from which to load attributes when
    /// ``GitBlobFilterFlagT/gitBlobFilterAttributesFromCommit`` is specified.
    ///
    /// ## Discussion
    ///
    /// The default value is a zero-initialized ``GitOID`` instance.
    public var attrCommitID : GitOID
    
    
    
    /// Initializes a ``GitBlobFilterOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : Int32                 = gitBlobFilterOptionsVersion,
        flags           : GitBlobFilterFlagT    = .gitBlobFilterCheckForBinary,
        commitID        : GitOID?               = nil,
        attrCommitID    : GitOID                = GitOID()
    )
    {
        self.version        = version
        self.flags          = flags
        self.commitID       = commitID
        self.attrCommitID   = attrCommitID
    }
    
    
    
    /// Initializes a ``GitBlobFilterOptions`` instance from the given
    /// `git_blob_filter_options` instance.
    /// - Parameter blobFilterOptions: The `git_blob_filter_options` instance
    /// to use.
    internal init(
        cValue blobFilterOptions: git_blob_filter_options
    )
    {
        self.version        = blobFilterOptions.version
        self.flags          = GitBlobFilterFlagT(rawValue: blobFilterOptions.flags)
        self.commitID       = nil
        self.attrCommitID   = GitOID(cValue: blobFilterOptions.attr_commit_id)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_blob_filter_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_blob_filter_options>) throws -> T
    ) throws -> T
    {
        guard version >= 0
        else
        {
            throw NSError.makeCConversionError()
        }
        
        var blobFilterOptions = git_blob_filter_options()
        
        let blobFilterOptionsInitResult: GitErrorCode
            = gitBlobFilterOptionsInit(
                opts:       &blobFilterOptions,
                version:    UInt32(version)
            )
        
        if blobFilterOptionsInitResult != .gitOK
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
