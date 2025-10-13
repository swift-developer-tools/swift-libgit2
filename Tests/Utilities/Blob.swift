//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import XCTest
@testable import SwiftLibgit2



/// Blob-related testing utilities.
enum Blob
{
    /// The source from which to create a blob.
    enum BlobCreationSource
    {
        /// Reads a file from the working directory of the given repository
        /// and writes it to the object database.
        case workingDirectory
        
        /// Reads a file from the file system (not necessarily inside the
        /// working directory of the repository) and writes it to the object
        /// database.
        /// - Parameter path: The path to the file from which the blob should
        /// be created.
        case disk(
            path: String
        )
        
        /// Closes the given stream and finalizes writing the blob to the
        /// object database.
        /// - Parameter stream: The stream to close.
        case streamCommit(
            stream: UnsafeMutablePointer<git_writestream>
        )
        
        /// Writes an in-memory buffer to the object database as a blob.
        /// - Parameter data: The data to be written into the blob.
        case buffer(
            data: Data
        )
    }
    
    
    
    /// Creates a blob from the given source and returns its ID.
    /// - Parameters:
    ///   - repository: The repository in which to create the blob.
    ///   - source: The source from which to create the blob.
    /// - Returns: The ID of the blob.
    static func createBlob(
        in      repository  : Repository,
        from    source      : BlobCreationSource
    ) -> GitOID
    {
        var blobOID             : GitOID        = GitOID()
        var blobCreateResult    : GitErrorCode  = .gitEUser
        
        switch source
        {
            case .workingDirectory:
                
                blobCreateResult = gitBlobCreateFromWorkdir(
                    id:             &blobOID,
                    repo:           repository.pointer,
                    relativePath:   Repository.readmeFileName
                )
                
            case .disk(let path):
                
                blobCreateResult = gitBlobCreateFromDisk(
                    id:     &blobOID,
                    repo:   repository.pointer,
                    path:   path
                )
                
            case .streamCommit(let stream):
                
                blobCreateResult = gitBlobCreateFromStreamCommit(
                    out:        &blobOID,
                    stream:     stream
                )
                
            case .buffer(let data):
                
                blobCreateResult = gitBlobCreateFromBuffer(
                    id:         &blobOID,
                    repo:       repository.pointer,
                    buffer:     data,
                    len:        data.count
                )
        }
        
        
        
        XCTAssertOK(blobCreateResult)
        
        return blobOID
    }
    
    
    
    /// Checks whether a blob contains the given content.
    /// - Parameters:
    ///   - repository: The repository containing the blob.
    ///   - blobOID: The ID of the blob.
    ///   - expectedContent: The expected content of the blob.
    static func validateBlobContent(
        in  repository      : Repository,
        id  blobOID         : GitOID,
        as  expectedContent : String
    )
    {
        var blobPointer: OpaquePointer? = nil
        
        defer
        {
            gitBlobFree(blob: blobPointer)
        }
        
        
        
        let blobLookupResult: GitErrorCode = gitBlobLookup(
            blob:   &blobPointer,
            repo:   repository.pointer,
            id:     blobOID
        )
        
        XCTAssertOK(blobLookupResult)
        
        guard let blobPointer: OpaquePointer = blobPointer
        else
        {
            XCTFail("The blob pointer was nil.")
            return
        }
        
        
        
        let blobRawContent  : UnsafeRawPointer  = gitBlobRawContent(blob: blobPointer)
        let blobRawSize     : UInt64            = gitBlobRawSize(blob: blobPointer)
        
        guard blobRawSize <= Int.max
        else
        {
            /// The blob's raw size being greater than or equal to `Int.max`
            /// is not necessarily a failing condition, but if this is the
            /// case, it cannot be cast to `Int` for the assertion.
            return
        }
        
        
        let blobData = Data(
            bytes:  blobRawContent,
            count:  Int(blobRawSize)
        )
        
        let blobContent = String(
            data:       blobData,
            encoding:   .utf8
        )
        
        XCTAssertEqual(blobContent, expectedContent)
    }
}
