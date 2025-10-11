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
                XCTAssertOK(gitBufDispose(buffer: &buffer))
                
                XCTAssertNil(buffer.ptr)
                XCTAssertEqual(buffer.reserved, 0)
                XCTAssertEqual(buffer.size, 0)
                
                /// Test disposing the buffer again.
                XCTAssertOK(gitBufDispose(buffer: &buffer))
                
                XCTAssertNil(buffer.ptr)
                XCTAssertEqual(buffer.reserved, 0)
                XCTAssertEqual(buffer.size, 0)
            }
            
            
            
            XCTAssertNil(buffer.ptr)
            XCTAssertEqual(buffer.reserved, 0)
            XCTAssertEqual(buffer.size, 0)
            
            buffer.withCValue
            {
                cBuffer in
                
                XCTAssertNil(cBuffer.pointee.ptr)
                XCTAssertEqual(cBuffer.pointee.reserved, 0)
                XCTAssertEqual(cBuffer.pointee.size, 0)
            }
            
            
            
            let branchRemoteNameResult: GitErrorCode = gitBranchRemoteName(
                out:        &buffer,
                repo:       repository.pointer,
                refName:    "refs/heads/main"
            )
            
            /// The operation should fail since there the reference is a
            /// local branch.
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
            
            
            
            var blobFilterResult: GitErrorCode = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       nil
            )
            
            XCTAssertOK(blobFilterResult)
            
            let firstBufferSize: Int = buffer.size
            
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(firstBufferSize, 0)
            
            buffer.withCValue
            {
                cBuffer in
                
                XCTAssertNotNil(cBuffer.pointee.ptr)
                XCTAssertEqual(cBuffer.pointee.size, firstBufferSize)
            }
            
            
            
            let blobFilterOptions = GitBlobFilterOptions()
            
            /// Test reuse behavior of the same buffer.
            blobFilterResult = gitBlobFilter(
                out:        &buffer,
                blob:       blobPointer,
                asPath:     Repository.readmeFileName,
                opts:       blobFilterOptions
            )
            
            XCTAssertOK(blobFilterResult)
            XCTAssertEqual(buffer, content)
            
            
            
            buffer.withCValue
            {
                cBuffer in
                
                guard let bufferPointer: UnsafeMutablePointer<CChar>
                        = cBuffer.pointee.ptr
                else
                {
                    XCTFail("The C buffer pointer was nil.")
                    return
                }
                
                guard let bufferContent = String(optionalCString: bufferPointer)
                else
                {
                    XCTFail("The C buffer content was nil.")
                    return
                }
                
                XCTAssertEqual(cBuffer.pointee.size, firstBufferSize)
                XCTAssertEqual(bufferContent, content)
            }
        }
    }
    
    
    
    func testGitBufDispose() throws
    {
        var buffer = GitBuf()
        
        XCTAssertOK(gitBufDispose(buffer: &buffer))
        XCTAssertOK(gitBufDispose(buffer: &buffer))
    }
}
