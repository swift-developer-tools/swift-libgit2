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



final class SignatureTests: XCTestCaseStopOnFail
{
    func testGitSignature() throws
    {
        let signature = GitSignature()
        
        XCTAssertTrue(signature.name.isEmpty)
        XCTAssertTrue(signature.email.isEmpty)
        XCTAssertNotNil(signature.when)
        
        signature.withCValue
        {
            cSignature in
            
            XCTAssertEqual(String(optionalCString: cSignature.pointee.name), "")
            XCTAssertEqual(String(optionalCString: cSignature.pointee.email), "")
            XCTAssertNotNil(cSignature.pointee.when)
        }
    }
    
    
    
    func testGitSignatureDefault() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var signature = GitSignature()
            
            let signatureDefaultResult: GitErrorCode = gitSignatureDefault(
                out:    &signature,
                repo:   repository.pointer
            )
            
            XCTAssertOK(signatureDefaultResult)
            XCTAssertFalse(signature.name.isEmpty)
            XCTAssertFalse(signature.email.isEmpty)
            XCTAssertNotNil(signature.when)
        }
    }
    
    
    
    func testGitSignatureDefaultFromBuffer() throws
    {
        var signature = GitSignature()
        
        let name    : String    = Repository.commitAuthorName
        let email   : String    = Repository.commitAuthorEmail
        let time    : GitTimeT  = 946684800
        let offset  : Int32     = 120
        
        var signatureFromBufferResult: GitErrorCode = gitSignatureFromBuffer(
            out:    &signature,
            buf:    "\(name) <\(email)> \(time) +0200"
        )
        
        XCTAssertOK(signatureFromBufferResult)
        XCTAssertEqual(signature.name, name)
        XCTAssertEqual(signature.email, email)
        XCTAssertEqual(signature.when.time, time)
        XCTAssertEqual(signature.when.offset, offset)
        
        
        
        signature = GitSignature()
        
        signatureFromBufferResult = gitSignatureFromBuffer(
            out:    &signature,
            buf:    "\(name) <\(email)> 0 -0000"
        )
        
        XCTAssertOK(signatureFromBufferResult)
        XCTAssertEqual(signature.name, name)
        XCTAssertEqual(signature.email, email)
        XCTAssertEqual(signature.when.time, 0)
        XCTAssertEqual(signature.when.offset, 0)
        
        
        
        let name2    : String    = "Another User"
        let email2   : String    = "another@example.com"
        let time2    : GitTimeT  = 978307200
        let offset2  : Int32     = -300
        
        signature = GitSignature()
        
        signatureFromBufferResult = gitSignatureFromBuffer(
            out:    &signature,
            buf:    "\(name2) <\(email2)> \(time2) -0500"
        )
        
        XCTAssertOK(signatureFromBufferResult)
        XCTAssertEqual(signature.name, name2)
        XCTAssertEqual(signature.email, email2)
        XCTAssertEqual(signature.when.time, time2)
        XCTAssertEqual(signature.when.offset, offset2)
        
        
        
        signature = GitSignature()
        
        signatureFromBufferResult = gitSignatureFromBuffer(
            out:    &signature,
            buf:    "Name invalid@example.com \(time) +0100"
        )
        
        XCTAssertNotOK(signatureFromBufferResult)
        XCTAssertTrue(signature.name.isEmpty)
        XCTAssertTrue(signature.email.isEmpty)
        XCTAssertNotNil(signature.when)
    }
    
    
    
    func testGitSignatureDefaultFromEnv() throws
    {
        try Repository.withRepository
        {
            repository in
            
            do
            {
                var authorSignature     : GitSignature?     = GitSignature()
                var committerSignature  : GitSignature?     = GitSignature()
                
                let bothResult: GitErrorCode = gitSignatureDefaultFromEnv(
                    authorOut:      &authorSignature,
                    committerOut:   &committerSignature,
                    repo:           repository.pointer
                )
                
                XCTAssertOK(bothResult)
                XCTAssertNotNil(authorSignature)
                XCTAssertFalse(authorSignature!.name.isEmpty)
                XCTAssertFalse(authorSignature!.email.isEmpty)
                XCTAssertNotNil(authorSignature!.when)
                XCTAssertNotNil(committerSignature)
                XCTAssertFalse(committerSignature!.name.isEmpty)
                XCTAssertFalse(committerSignature!.email.isEmpty)
                XCTAssertNotNil(committerSignature!.when)
            }
            
            
            
            do
            {
                var authorSignature     : GitSignature?     = GitSignature()
                var committerSignature  : GitSignature?     = nil
                
                let authorOnlyResult: GitErrorCode
                    = gitSignatureDefaultFromEnv(
                        authorOut:      &authorSignature,
                        committerOut:   &committerSignature,
                        repo:           repository.pointer
                    )
                
                XCTAssertOK(authorOnlyResult)
                XCTAssertNotNil(authorSignature)
                XCTAssertFalse(authorSignature!.name.isEmpty)
                XCTAssertFalse(authorSignature!.email.isEmpty)
                XCTAssertNotNil(authorSignature!.when)
                XCTAssertNil(committerSignature)
            }
            
            
            
            do
            {
                var authorSignature     : GitSignature?     = nil
                var committerSignature  : GitSignature?     = GitSignature()
                
                let committerOnlyResult: GitErrorCode
                    = gitSignatureDefaultFromEnv(
                        authorOut:      &authorSignature,
                        committerOut:   &committerSignature,
                        repo:           repository.pointer
                    )
                
                XCTAssertOK(committerOnlyResult)
                XCTAssertNil(authorSignature)
                XCTAssertNotNil(committerSignature)
                XCTAssertFalse(committerSignature!.name.isEmpty)
                XCTAssertFalse(committerSignature!.email.isEmpty)
                XCTAssertNotNil(committerSignature!.when)
            }
            
            
            
            do
            {
                var authorSignature     : GitSignature?     = nil
                var committerSignature  : GitSignature?     = nil
                
                let neitherResult: GitErrorCode = gitSignatureDefaultFromEnv(
                    authorOut:      &authorSignature,
                    committerOut:   &committerSignature,
                    repo:           repository.pointer
                )
                
                XCTAssertEqual(neitherResult, .gitEUser)
                XCTAssertNil(authorSignature)
                XCTAssertNil(committerSignature)
            }
        }
    }
    
    
    
    func testGitSignatureFree() throws
    {
        gitSignatureFree(sig: nil)
    }
    
    
    
    func testGitSignatureNewAndDup() throws
    {
        var signature = GitSignature()
        
        let name    : String    = Repository.commitAuthorName
        let email   : String    = Repository.commitAuthorEmail
        let time    : GitTimeT  = 946684800
        let offset  : Int32     = 120
        
        
        
        var signatureNewResult: GitErrorCode = gitSignatureNew(
            out:        &signature,
            name:       "",
            email:      "",
            time:       0,
            offset:     0
        )
        
        /// Signatures cannot have an empty name or email.
        XCTAssertNotOK(signatureNewResult)
        XCTAssertTrue(signature.name.isEmpty)
        XCTAssertTrue(signature.email.isEmpty)
        XCTAssertNotNil(signature.when)
        
        
        
        signature = GitSignature()
        
        signatureNewResult = gitSignatureNew(
            out:        &signature,
            name:       name,
            email:      email,
            time:       0,
            offset:     0
        )
        
        XCTAssertOK(signatureNewResult)
        XCTAssertEqual(signature.name, name)
        XCTAssertEqual(signature.email, email)
        XCTAssertEqual(signature.when.time, 0)
        XCTAssertEqual(signature.when.offset, 0)
        
        
        
        signature = GitSignature()
        
        signatureNewResult = gitSignatureNew(
            out:        &signature,
            name:       name,
            email:      email,
            time:       GitTimeT.max,
            offset:     Int32.max
        )
        
        XCTAssertOK(signatureNewResult)
        XCTAssertEqual(signature.name, name)
        XCTAssertEqual(signature.email, email)
        XCTAssertEqual(signature.when.time, GitTimeT.max)
        XCTAssertEqual(signature.when.offset, Int32.max)
        
        
        
        signature = GitSignature()
        
        signatureNewResult = gitSignatureNew(
            out:        &signature,
            name:       name,
            email:      email,
            time:       time,
            offset:     offset
        )
        
        XCTAssertOK(signatureNewResult)
        XCTAssertEqual(signature.name, name)
        XCTAssertEqual(signature.email, email)
        XCTAssertEqual(signature.when.time, time)
        XCTAssertEqual(signature.when.offset, offset)
        
        
        
        var duplicatedSignature = GitSignature()
        
        let signatureDupResult: GitErrorCode = gitSignatureDup(
            dest:   &duplicatedSignature,
            sig:    signature
        )
        
        XCTAssertOK(signatureDupResult)
        XCTAssertEqual(duplicatedSignature.name, name)
        XCTAssertEqual(duplicatedSignature.email, email)
        XCTAssertEqual(duplicatedSignature.when.time, time)
        XCTAssertEqual(duplicatedSignature.when.offset, offset)
        
        XCTAssertEqual(signature.name, duplicatedSignature.name)
        XCTAssertEqual(signature.email, duplicatedSignature.email)
        XCTAssertEqual(signature.when.time, duplicatedSignature.when.time)
        XCTAssertEqual(signature.when.offset, duplicatedSignature.when.offset)
    }
    
    
    
    func testGitSignatureNow() throws
    {
        var signature = GitSignature()
        
        let name        : String        = Repository.commitAuthorName
        let email       : String        = Repository.commitAuthorEmail
        let beforeTime  : TimeInterval  = Date().timeIntervalSince1970
        
        let signatureNowResult: GitErrorCode = gitSignatureNow(
            out:    &signature,
            name:   name,
            email:  email
        )
        
        XCTAssertOK(signatureNowResult)
        XCTAssertEqual(signature.name, name)
        XCTAssertEqual(signature.email, email)
        
        
        
        let signatureTime = TimeInterval(signature.when.time)
        
        XCTAssertGreaterThanOrEqual(signatureTime, beforeTime - 1)
        XCTAssertLessThanOrEqual(signatureTime, Date().timeIntervalSince1970 + 1)
    }
}
