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



final class BlobTests: XCTestCaseStopOnFail
{
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
            
            
            
            var blobOID: GitOID = Blob.createBlob(
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
            
            
            
            var blobOID: GitOID = Blob.createBlob(
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
    
    
    
    func testGitBlobCreateFromStream() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var streamPointer: UnsafeMutablePointer<git_writestream>? = nil
            
            let blobCreateFromStreamResult: GitErrorCode = gitBlobCreateFromStream(
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
            
            XCTAssertOK(GitErrorCode(rawValue: writeResult))
            
            
            
            var blobOID: GitOID = Blob.createBlob(
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
    
    
    
    func testGitBlobCreateFromWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeBlob(blobPointer)
            }
            
            
            
            let blobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            
            
            
            let blobLookupPrefixResult: GitErrorCode = gitBlobLookupPrefix(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     blobOID,
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
            
            
            
            guard let blobID: GitOID = gitBlobID(blob: blobPointer)
            else
            {
                XCTFail("The blob ID was nil.")
                return
            }
            
            XCTAssertEqual(blobOID, blobID)
            
            
            
            let owner: OpaquePointer = gitBlobOwner(blob: blobPointer)
            
            XCTAssertEqual(owner, repository.pointer)
        }
    }
    
    
    
    func testGitBlobDataIsBinary() throws
    {
        let data = Data("Hello World!".utf8)
        
        let isBinary: Bool? = gitBlobDataIsBinary(
            data:   data,
            len:    data.count
        )
        
        guard let isBinary: Bool = isBinary
        else
        {
            XCTFail("The boolean was nil.")
            return
        }
        
        XCTAssertFalse(isBinary)
    }
    
    
    
    func testGitBlobFilter() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeBlob(blobPointer)
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
            
            
            
            var buffer = GitBuf()
            
            defer
            {
                XCTAssertOK(gitBufDispose(buffer: &buffer))
            }
            
            
            
            var blobFilterResult: GitErrorCode = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       nil
            )
            
            XCTAssertOK(blobFilterResult)
            
            
            
            let blobFilterOptions = GitBlobFilterOptions()
            
            blobFilterResult = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       blobFilterOptions
            )
            
            XCTAssertOK(blobFilterResult)
        }
    }
    
    
    
    func testGitBlobFilterFlagT() throws
    {
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterCheckForBinary.rawValue, GIT_BLOB_FILTER_CHECK_FOR_BINARY.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterNoSystemAttributes.rawValue, GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterAttributesFromHEAD.rawValue, GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD.rawValue)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterAttributesFromCommit.rawValue, GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT.rawValue)
        
        XCTAssertEqual(GitBlobFilterFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterCheckForBinary.cValue(), GIT_BLOB_FILTER_CHECK_FOR_BINARY)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterNoSystemAttributes.cValue(), GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterAttributesFromHEAD.cValue(), GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD)
        XCTAssertEqual(GitBlobFilterFlagT.gitBlobFilterAttributesFromCommit.cValue(), GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT)
        
        
        
        let flags: GitBlobFilterFlagT =
        [
            .gitBlobFilterCheckForBinary,
            .gitBlobFilterNoSystemAttributes
        ]
        
        XCTAssertTrue(flags.contains(.gitBlobFilterCheckForBinary))
        XCTAssertTrue(flags.contains(.gitBlobFilterNoSystemAttributes))
        XCTAssertFalse(flags.contains(.gitBlobFilterAttributesFromHEAD))
    }
    
    
    
    func testGitBlobFilterOptions() throws
    {
        let blobFilterOptions = GitBlobFilterOptions()
        
        XCTAssertEqual(blobFilterOptions.version, gitBlobFilterOptionsVersion)
        XCTAssertEqual(blobFilterOptions.flags, .gitBlobFilterCheckForBinary)
        XCTAssertNil(blobFilterOptions.commitID)
        XCTAssertZeroOID(blobFilterOptions.attrCommitID)
        
        XCTAssertEqual(gitBlobFilterOptionsVersion, UInt32(GIT_BLOB_FILTER_OPTIONS_VERSION))
        
        try blobFilterOptions.withCValue
        {
            cBlobFilterOptions in
            
            XCTAssertEqual(cBlobFilterOptions.pointee.version, Int32(gitBlobFilterOptionsVersion))
            XCTAssertEqual(GitBlobFilterFlagT(rawValue: cBlobFilterOptions.pointee.flags), .gitBlobFilterCheckForBinary)
            XCTAssertNil(cBlobFilterOptions.pointee.commit_id)
            XCTAssertZeroOID(GitOID(cValue: cBlobFilterOptions.pointee.attr_commit_id))
        }
    }
    
    
    
    func testGitBlobIsDup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            
            
            var originalBlobPointer     : OpaquePointer?    = nil
            var duplicatedBlobPointer   : OpaquePointer?    = nil
            
            defer
            {
                Free.freeBlob(originalBlobPointer)
                Free.freeBlob(duplicatedBlobPointer)
            }
            
            
            
            let blobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &originalBlobPointer,
                repo:   repository.pointer,
                id:     blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            
            guard let originalBlobPointer: OpaquePointer = originalBlobPointer
            else
            {
                XCTFail("The original blob pointer was nil.")
                return
            }
            
            
            
            let blobDupResult: GitErrorCode = gitBlobDup(
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
                let originalBlobID      : GitOID    = gitBlobID(blob: originalBlobPointer),
                let duplicatedBlobID    : GitOID    = gitBlobID(blob: duplicatedBlobPointer)
            else
            {
                XCTFail("The original or duplicated blob IDs were nil.")
                return
            }
            
            XCTAssertEqual(originalBlobID, duplicatedBlobID)
            
            
            
            let originalBlobRawSize     : UInt64    = gitBlobRawSize(blob: originalBlobPointer)
            let duplicatedBlobRawSize   : UInt64    = gitBlobRawSize(blob: duplicatedBlobPointer)
            
            XCTAssertEqual(originalBlobRawSize, duplicatedBlobRawSize)
        }
    }
    
    
    
    func testGitBlobIsBinary() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobOID = GitOID()
            
            let data = Data(
            [
                0x00,
                0x01,
                0x02,
                0x03,
                0xFF,
                0xFE
            ])
            
            
            
            let blobCreateFromBufferResult: GitErrorCode = data.withUnsafeBytes
            {
                bytes in
                
                guard
                    let baseAddress: UnsafeRawPointer = bytes.baseAddress,
                    bytes.count > 0
                else
                {
                    XCTFail("The bytes count was zero.")
                    return .gitEUser
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
                Free.freeBlob(blobPointer)
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
            
            
            
            XCTAssertTrue(gitBlobIsBinary(blob: blobPointer))
        }
    }
}
