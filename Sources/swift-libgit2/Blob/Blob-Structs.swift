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



/// The options for the blob filtering process.
///
/// ## C Equivalent
///
/// [`git_blob_filter_options`](https://libgit2.org/docs/reference/main/blob/git_blob_filter_options.html)
public struct GitBlobFilterOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitBlobFilterOptionsVersion``.
    public var version      : UInt32
    
    /// The flags to use during the blob filtering process.
    public var flags        : GitBlobFilterFlagT
    
    /// The commit ID.
    ///
    /// ## Discussion
    ///
    /// This property is unused, but is reserved for API compatibility.
    public var commitID     : GitOID?
    
    /// The commit from which to load attributes when
    /// ``GitBlobFilterFlagT/gitBlobFilterAttributesFromCommit`` is specified.
    public var attrCommitID : GitOID?
    
    
    
    /// Creates a ``GitBlobFilterOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to
    /// ``gitBlobFilterOptionsVersion``.
    /// - Throws: An `NSError` if initialization failed.
    public init(
        version: UInt32 = gitBlameOptionsVersion
    ) throws
    {
        var blobFilterOptions = git_blob_filter_options()
        
        let blobFilterOptionsInitResult: Int32 = git_blob_filter_options_init(
            &blobFilterOptions,
            version
        )
        
        if blobFilterOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.create(
                code:       Int(blobFilterOptionsInitResult),
                message:    "Failed to initialize GitBlobFilterOptions."
            )
        }
        
        self.init(cValue: blobFilterOptions)
    }
    
    
    
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
        self.attrCommitID   = nil
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_blob_filter_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_blob_filter_options>) -> T
    ) throws -> T
    {
        var blobFilterOptions = git_blob_filter_options()
        
        let blobFilterOptionsInitResult: Int32 = git_blob_filter_options_init(
            &blobFilterOptions,
            version
        )
        
        if blobFilterOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.create(
                code:       Int(blobFilterOptionsInitResult),
                message:    "Failed to initialize GitBlobFilterOptions."
            )
        }
        
        blobFilterOptions.flags             = flags.rawValue
        blobFilterOptions.attr_commit_id    = attrCommitID?.cValue ?? git_oid()
        
        if let commitID: GitOID = commitID
        {
            var cCommitID: git_oid = commitID.cValue
            
            return withUnsafeMutablePointer(to: &cCommitID)
            {
                commitIDPointer in
                
                blobFilterOptions.commit_id = commitIDPointer
                
                return body(&blobFilterOptions)
            }
        }
        else
        {
            blobFilterOptions.commit_id = nil
            
            return body(&blobFilterOptions)
        }
    }
}
