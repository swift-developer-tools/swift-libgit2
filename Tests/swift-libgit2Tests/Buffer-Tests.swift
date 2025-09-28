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



final class BufferTests: XCTestCaseStopOnFail
{
    func testGitBuf() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var buffer = GitBuf()
            
            defer
            {
                gitBufDispose(buffer: &buffer)
                
                XCTAssertNil(buffer.ptr)
                XCTAssertEqual(buffer.reserved, 0)
                XCTAssertEqual(buffer.size, 0)
                
                /// Test disposing the buffer again.
                gitBufDispose(buffer: &buffer)
                
                XCTAssertNil(buffer.ptr)
                XCTAssertEqual(buffer.reserved, 0)
                XCTAssertEqual(buffer.size, 0)
            }
            
            
            
            XCTAssertNil(buffer.ptr)
            XCTAssertEqual(buffer.reserved, 0)
            XCTAssertEqual(buffer.size, 0)
            
            
            
            let branchRemoteNameResult: Int32 = gitBranchRemoteName(
                out:        &buffer,
                repo:       repository.pointer,
                refName:    "refs/heads/main"
            )
            
            /// The operation should fail since there the reference is a local branch.
            XCTAssertNotOK(branchRemoteNameResult)
            
            
            
            let content: String = Repository.readmeFileContent
            
            guard let data: Data = content.data(using: .utf8)
            else
            {
                XCTFail("The content data was nil.")
                return
            }
            
            
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: data)
            )
            
            
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeBlob(blobPointer)
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
            
            
            
            var blobFilterResult: Int32 = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       nil
            )
            
            XCTAssertOK(blobFilterResult)
            
            let firstBufferSize: Int = buffer.size
            
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(firstBufferSize, 0)
            
            
            
            let blobFilterOptions = GitBlobFilterOptions()
            
            /// Test reuse behavior of the same buffer.
            blobFilterResult = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       blobFilterOptions
            )
            
            XCTAssertOK(blobFilterResult)
            
            guard let bufferPointer: UnsafeMutablePointer<CChar> = buffer.ptr
            else
            {
                XCTFail("The buffer pointer was nil.")
                return
            }
            
            guard let bufferContent = String(optionalCString: bufferPointer)
            else
            {
                XCTFail("The buffer content was nil.")
                return
            }
            
            XCTAssertEqual(buffer.size, firstBufferSize)
            XCTAssertEqual(bufferContent, content)
        }
    }
}
