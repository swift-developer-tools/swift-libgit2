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



final class BlobTests: XCTestCaseStopOnFail
{
    // MARK: - testGitBlobCreateFromBuffer()
    
    func testGitBlobCreateFromBuffer() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let content: String = "Hello World!"
            
            guard let data: Data = content.data(using: .utf8)
            else
            {
                XCTFail("The content data was nil.")
                return
            }
            
            
            
            var blobOID: git_oid = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: data)
            )
            
            Blob.validateBlobContent(
                in:     repository,
                id:     &blobOID,
                as:     content
            )
        }
    }
    
    
    
    // MARK: - testGitBlobCreateFromDisk()
    
    func testGitBlobCreateFromDisk() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let fileContent: String = "Hello World!"
            
            let fileURL: URL = try repository.modifyFile(
                path:       "test.txt",
                content:    fileContent
            )
            
            
            
            var blobOID: git_oid = Blob.createBlob(
                in:     repository,
                from:   .disk(path: fileURL.path)
            )
            
            Blob.validateBlobContent(
                in:     repository,
                id:     &blobOID,
                as:     fileContent
            )
        }
    }
    
    
    
    // MARK: - testGitBlobCreateFromStream()
    
    func testGitBlobCreateFromStream() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var streamPointer: UnsafeMutablePointer<git_writestream>? = nil
            
            let blobCreateFromStreamResult: Int32 = gitBlobCreateFromStream(
                out:        &streamPointer,
                repo:       repository.pointer,
                hintPath:   "test.txt"
            )
            
            XCTAssertOK(blobCreateFromStreamResult)
            
            guard let streamPointer: UnsafeMutablePointer<git_writestream> = streamPointer
            else
            {
                XCTFail("The stream pointer was nil.")
                return
            }
            
            
            
            let content: String = "Hello World!"
            
            guard let data: Data = content.data(using: .utf8)
            else
            {
                XCTFail("The content data was nil.")
                return
            }
            
            
            
            let writeResult: Int32 = data.withUnsafeBytes
            {
                bytes in
                
                return streamPointer.pointee.write(
                    streamPointer,
                    bytes.baseAddress?.assumingMemoryBound(to: CChar.self),
                    bytes.count
                )
            }
            
            XCTAssertOK(writeResult)
            
            
            
            var blobOID: git_oid = Blob.createBlob(
                in:     repository,
                from:   .streamCommit(stream: streamPointer)
            )
            
            Blob.validateBlobContent(
                in:     repository,
                id:     &blobOID,
                as:     content
            )
        }
    }
    
    
    
    // MARK: - testGitBlobCreateFromWorkdir()
    
    func testGitBlobCreateFromWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobOID: git_oid = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                gitBlobFree(blob: blobPointer)
            }
            
            
            
            let blobLookupResult: Int32 = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     &blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            
            
            
            let blobLookupPrefixResult: Int32 = gitBlobLookupPrefix(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     &blobOID,
                len:    8
            )
            
            XCTAssertOK(blobLookupPrefixResult)
            
            
            
            guard let blobPointer: OpaquePointer = blobPointer
            else
            {
                XCTFail("The blob pointer was nil.")
                return
            }
            
            
            
            XCTAssertFalse(gitBlobIsBinary(blob: blobPointer))
            
            
            
            guard let blobID: UnsafePointer<git_oid> = gitBlobID(blob: blobPointer)
            else
            {
                XCTFail("The blob ID was nil.")
                return
            }
            
            OID.assertOIDsEqual(&blobOID, blobID)
            
            
            
            let owner: OpaquePointer = gitBlobOwner(blob: blobPointer)
            
            XCTAssertEqual(owner, repository.pointer)
        }
    }
    
    
    
    // MARK: - testGitBlobDataIsBinary()
    
    func testGitBlobDataIsBinary() throws
    {
        let text: String = "Hello World!"
        
        let isBinary: Bool = gitBlobDataIsBinary(
            data:   text,
            len:    text.utf8.count
        )
        
        XCTAssertFalse(isBinary)
    }
    
    
    
    // MARK: - testGitBlobFilter()
    
    func testGitBlobFilter() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobOID: git_oid = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                gitBlobFree(blob: blobPointer)
            }
            
            
            
            let blobLookupResult: Int32 = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     &blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            
            guard let blobPointer: OpaquePointer = blobPointer
            else
            {
                XCTFail("The blob pointer was nil.")
                return
            }
            
            
            
            var buffer = GitBuf()
            
            defer
            {
                gitBufDispose(buffer: &buffer)
            }
            
            
            
            var blobFilterResult: Int32 = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       nil
            )
            
            XCTAssertOK(blobFilterResult)
            
            
            
            let blobFilterOptions = try GitBlobFilterOptions()
            
            blobFilterResult = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       blobFilterOptions
            )
            
            XCTAssertOK(blobFilterResult)
        }
    }
    
    
    
    // MARK: - testGitBlobFilterFlagT()
    
    func testGitBlobFilterFlagT() throws
    {
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterCheckForBinary.rawValue, GIT_BLOB_FILTER_CHECK_FOR_BINARY.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterNoSystemAttributes.rawValue, GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterAttributesFromHEAD.rawValue, GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterAttributesFromCommit.rawValue, GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT(rawValue: 123).rawValue, 123)
        
        
        
        let flags: GitBlobFilterFlagT =
        [
            .gitBlobFilterCheckForBinary,
            .gitBlobFilterNoSystemAttributes
        ]
        
        XCTAssertTrue(flags.contains(.gitBlobFilterCheckForBinary))
        XCTAssertTrue(flags.contains(.gitBlobFilterNoSystemAttributes))
        XCTAssertFalse(flags.contains(.gitBlobFilterAttributesFromHEAD))
    }
    
    
        
    // MARK: - testGitBlobFilterOptions()
    
    func testGitBlobFilterOptions() throws
    {
        var blobFilterOptions = try GitBlobFilterOptions()
        
        XCTAssertEqual(blobFilterOptions.version, gitBlobFilterOptionsVersion)
        XCTAssertEqual(blobFilterOptions.flags, GitBlobFilterFlagT.gitBlobFilterCheckForBinary)
        XCTAssertNil(blobFilterOptions.commitID)
        
        XCTAssertEqual(gitBlobFilterOptionsVersion, UInt32(GIT_BLOB_FILTER_OPTIONS_VERSION))
        
        
        
        blobFilterOptions.flags = GitBlobFilterFlagT(rawValue: 123)
        
        XCTAssertEqual(blobFilterOptions.flags, GitBlobFilterFlagT(rawValue: 123))
        
        
        
        blobFilterOptions.flags =
        [
            .gitBlobFilterCheckForBinary,
            .gitBlobFilterAttributesFromHEAD
        ]
        
        XCTAssertTrue(blobFilterOptions.flags.contains(.gitBlobFilterCheckForBinary))
        XCTAssertTrue(blobFilterOptions.flags.contains(.gitBlobFilterAttributesFromHEAD))
        XCTAssertFalse(blobFilterOptions.flags.contains(.gitBlobFilterNoSystemAttributes))
    }
    
    
    
    // MARK: - testGitBlobIsDup()
    
    func testGitBlobIsDup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobOID: git_oid = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            
            
            var originalBlobPointer     : OpaquePointer?    = nil
            var duplicatedBlobPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitBlobFree(blob: originalBlobPointer)
                gitBlobFree(blob: duplicatedBlobPointer)
            }
            
            
            
            let blobLookupResult: Int32 = gitBlobLookup(
                blob:   &originalBlobPointer,
                repo:   repository.pointer,
                id:     &blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            
            guard let originalBlobPointer: OpaquePointer = originalBlobPointer
            else
            {
                XCTFail("The original blob pointer was nil.")
                return
            }
            
            
            
            let blobDupResult: Int32 = gitBlobDup(
                out:        &duplicatedBlobPointer,
                source:     originalBlobPointer
            )
            
            XCTAssertOK(blobDupResult)
            
            guard let duplicatedBlobPointer: OpaquePointer = duplicatedBlobPointer
            else
            {
                XCTFail("The duplicated blob pointer was nil.")
                return
            }
            
            
            
            guard
                let originalBlobID      : UnsafePointer<git_oid>    = gitBlobID(blob: originalBlobPointer),
                let duplicatedBlobID    : UnsafePointer<git_oid>    = gitBlobID(blob: duplicatedBlobPointer)
            else
            {
                XCTFail("The original or duplicated blob IDs were nil.")
                return
            }
            
            OID.assertOIDsEqual(originalBlobID, duplicatedBlobID)
            
            
            
            let originalBlobRawSize     : UInt64    = gitBlobRawSize(blob: originalBlobPointer)
            let duplicatedBlobRawSize   : UInt64    = gitBlobRawSize(blob: duplicatedBlobPointer)
            
            XCTAssertEqual(originalBlobRawSize, duplicatedBlobRawSize)
        }
    }
    
    
    
    // MARK: - testGitBlobIsBinary()
    
    func testGitBlobIsBinary() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobOID = git_oid()
            
            let data = Data(
            [
                0x00,
                0x01,
                0x02,
                0x03,
                0xFF,
                0xFE
            ])
            
            
            
            let blobCreateFromBufferResult: Int32 = data.withUnsafeBytes
            {
                bytes in
                
                guard
                    let baseAddress: UnsafeRawPointer = bytes.baseAddress,
                    bytes.count > 0
                else
                {
                    XCTFail("The bytes count was zero.")
                    return GIT_EUSER.rawValue
                }
                
                
                
                return gitBlobCreateFromBuffer(
                    id:         &blobOID,
                    repo:       repository.pointer,
                    buffer:     baseAddress,
                    len:        bytes.count
                )
            }
            
            XCTAssertOK(blobCreateFromBufferResult)
            
            
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                gitBlobFree(blob: blobPointer)
            }
            
            
            
            let blobLookupResult: Int32 = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     &blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            
            guard let blobPointer: OpaquePointer = blobPointer
            else
            {
                XCTFail("The blob pointer was nil.")
                return
            }
            
            
            
            XCTAssertTrue(gitBlobIsBinary(blob: blobPointer))
        }
    }
}
