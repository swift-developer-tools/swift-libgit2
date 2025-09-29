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



final class TypesTests: XCTestCaseStopOnFail
{
    func testGitOffT() throws
    {
        let offset1 : GitOffT   = 1024
        let offset2 : GitOffT   = GitOffT.max
        let offset3 : GitOffT   = GitOffT.min
        
        XCTAssertEqual(offset1, 1024)
        XCTAssertEqual(MemoryLayout<GitOffT>.size, MemoryLayout<Int64>.size)
        XCTAssertGreaterThan(offset2, 0)
        XCTAssertLessThan(offset3, 0)
    }
    
    
    
    func testGitTime() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var signature = GitSignature()
            
            let signatureNowResult: Int32 = gitSignatureNow(
                out:    &signature,
                name:   Repository.commitAuthorName,
                email:  Repository.commitAuthorEmail
            )
            
            XCTAssertOK(signatureNowResult)
            
            
            
            let cTime   : git_time  = signature.when.cValue()
            let gitTime : GitTime   = GitTime(cValue: cTime)
            
            XCTAssertGreaterThan(gitTime.time, 0)
            XCTAssertEqual(gitTime.time, cTime.time)
            XCTAssertEqual(gitTime.offset, cTime.offset)
            XCTAssertEqual(gitTime.sign, cTime.sign)
            
            let currentTime = Int64(Date().timeIntervalSince1970)
            
            XCTAssertGreaterThan(gitTime.time, currentTime - 3600)
            XCTAssertLessThanOrEqual(gitTime.time, currentTime + 60)
        }
    }
    
    
    
    func testGitTimeT() throws
    {
        let timestamp1  : GitTimeT  = 946684800
        let timestamp2  : GitTimeT  = GitTimeT.max
        let timestamp3  : GitTimeT  = GitTimeT.min
        
        XCTAssertEqual(timestamp1, 946684800)
        XCTAssertEqual(MemoryLayout<GitTimeT>.size, MemoryLayout<Int64>.size)
        XCTAssertGreaterThan(timestamp2, 0)
        XCTAssertLessThan(timestamp3, 0)
    }
    
    
    
    func testGitWritestream() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var streamPointer: UnsafeMutablePointer<git_writestream>? = nil
            
            let blobCreateFromStreamResult: Int32 = gitBlobCreateFromStream(
                out:        &streamPointer,
                repo:       repository.pointer,
                hintPath:   nil
            )
            
            XCTAssertOK(blobCreateFromStreamResult)
            
            guard let streamPointer: UnsafeMutablePointer<git_writestream> = streamPointer
            else
            {
                XCTFail("The stream pointer was nil.")
                return
            }
            
            
            
            let writestream = GitWritestream(cValue: streamPointer.pointee)
            
            XCTAssertNotNil(writestream.write)
            XCTAssertNotNil(writestream.close)
            XCTAssertNotNil(writestream.free)
            
            
            
            let content: String = "Hello World!"
            
            let writeResult: Int32 = content.withCString
            {
                cContent in
                
                return writestream.write(
                    streamPointer,
                    cContent,
                    content.utf8.count
                )
            }
            
            XCTAssertOK(writeResult)
            
            
            
            var blobOID = GitOID()
            
            let blobCreateFromStreamCommitResult: Int32 = gitBlobCreateFromStreamCommit(
                out:        &blobOID,
                stream:     streamPointer
            )
            
            XCTAssertOK(blobCreateFromStreamCommitResult)
            
            
            
            Blob.validateBlobContent(
                in:     repository,
                id:     &blobOID,
                as:     content
            )
        }
    }
}
