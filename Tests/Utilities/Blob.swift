//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



/// Blob-related testing utilities.
enum Blob
{
    // MARK: - createBlob()
    
    /// Creates a blob from the repository's `README` file and returns its ID.
    /// - Parameter repository: The repository in which to create the blob.
    /// - Returns: The ID of the blob.
    static func createBlob(
        in repository: Repository
    ) -> git_oid
    {
        var blobOID = git_oid()
        
        let blobCreateFromWorkdirResult: Int32 = gitBlobCreateFromWorkdir(
            id:             &blobOID,
            repo:           repository.pointer,
            relativePath:   Repository.readmeFileName
        )
        
        XCTAssertOK(blobCreateFromWorkdirResult)
        
        return blobOID
    }
    
    
    
    // MARK: - validateBlobContent()
    
    /// Checks whether a blob contains the given content.
    /// - Parameters:
    ///   - repository: The repository containing the blob.
    ///   - blobOID: The ID of the blob.
    ///   - expectedContent: The expected content of the blob.
    static func validateBlobContent(
        in  repository      : Repository,
        id  blobOID         : UnsafeMutablePointer<git_oid>,
        as  expectedContent : String
    )
    {
        var blobPointer: OpaquePointer? = nil
        
        defer
        {
            gitBlobFree(blob: blobPointer)
        }
        
        
        
        let blobLookupResult: Int32 = gitBlobLookup(
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
