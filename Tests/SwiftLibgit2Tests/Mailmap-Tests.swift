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
@testable import SwiftLibgit2TestUtilities



final class MailmapTests: XCTestCaseStopOnFail
{
    func testGitMailmapAddEntryAndResolve() throws
    {
        var mailmapPointer: OpaquePointer? = nil
        
        defer
        {
            gitMailmapFree(mm: mailmapPointer)
        }
        
        
        
        let mailmapNewResult: GitErrorCode
            = gitMailmapNew(out: &mailmapPointer)
        
        XCTAssertOK(mailmapNewResult)
        
        guard let mailmapPointer: OpaquePointer = mailmapPointer
        else
        {
            XCTFail("The mailmap pointer was nil.")
            return
        }
        
        
        
        let realName    : String    = "Proper Name"
        let realEmail   : String    = "proper-name@example.com"
        let commitName  : String    = "Commit Name"
        let commitEmail : String    = "commit-name@example.com"
        
        
        
        let mailmapAddEntryResult: GitErrorCode = gitMailmapAddEntry(
            mm:             mailmapPointer,
            realName:       realName,
            realEmail:      realEmail,
            replaceName:    commitName,
            replaceEmail:   commitEmail
        )
        
        XCTAssertOK(mailmapAddEntryResult)
        
        
        
        var resolvedName    : String?   = nil
        var resolvedEmail   : String?   = nil
        
        let mailmapResolveResult: GitErrorCode = gitMailmapResolve(
            realName:   &resolvedName,
            realEmail:  &resolvedEmail,
            mm:         mailmapPointer,
            name:       commitName,
            email:      commitEmail
        )
        
        XCTAssertOK(mailmapResolveResult)
        
        guard let resolvedNameString = String(optionalCString: resolvedName)
        else
        {
            XCTFail("The resolved name string was nil.")
            return
        }
        
        guard let resolvedEmailString = String(optionalCString: resolvedEmail)
        else
        {
            XCTFail("The resolved email string was nil.")
            return
        }
        
        XCTAssertEqual(resolvedNameString, realName)
        XCTAssertEqual(resolvedEmailString, realEmail)
    }
    
    
    
    func testGitMailmapFree() throws
    {
        gitMailmapFree(mm: nil)
    }
    
    
    
    func testGitMailmapFromBuffer() throws
    {
        let firstRealName       : String    = "Proper Name"
        let firstRealEmail      : String    = "proper-name@example.com"
        let firstCommitEmail    : String    = "some-committer@example.com"
        
        let secondRealName      : String    = "Another Proper Name"
        let secondRealEmail     : String    = "another-proper-name@example.com"
        let secondCommitName    : String    = "Another Committer"
        let secondCommitEmail   : String    = "another-committer@example.com"
        
        let mailmapContent: String =
        """
        \(firstRealName) <\(firstRealEmail)> <\(firstCommitEmail)>
        \(secondRealName) <\(secondRealEmail)> \(secondCommitName) <\(secondCommitEmail)>
        """
        
        let mailmapData = Data(mailmapContent.utf8)
        
        
        
        var mailmapPointer: OpaquePointer? = nil
        
        defer
        {
            gitMailmapFree(mm: mailmapPointer)
        }
        
        
        
        let mailmapFromBufferResult: GitErrorCode = gitMailmapFromBuffer(
            out:    &mailmapPointer,
            buf:    mailmapData,
            len:    mailmapData.count
        )
        
        XCTAssertOK(mailmapFromBufferResult)
        
        guard let mailmapPointer: OpaquePointer = mailmapPointer
        else
        {
            XCTFail("The mailmap pointer was nil.")
            return
        }
        
        
        
        var resolvedName    : String?   = nil
        var resolvedEmail   : String?   = nil
        
        let mailmapResolveResult: GitErrorCode = gitMailmapResolve(
            realName:   &resolvedName,
            realEmail:  &resolvedEmail,
            mm:         mailmapPointer,
            name:       secondCommitName,
            email:      secondCommitEmail
        )
        
        XCTAssertOK(mailmapResolveResult)
        
        guard let resolvedNameString = String(optionalCString: resolvedName)
        else
        {
            XCTFail("The resolved name string was nil.")
            return
        }
        
        guard let resolvedEmailString = String(optionalCString: resolvedEmail)
        else
        {
            XCTFail("The resolved email string was nil.")
            return
        }
        
        XCTAssertEqual(resolvedNameString, secondRealName)
        XCTAssertEqual(resolvedEmailString, secondRealEmail)
    }
    
    
    
    func testGitMailmapFromRepository() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let realName    : String    = "Proper Name"
            let realEmail   : String    = "proper-name@example.com"
            let commitName  : String    = "Commit Name"
            let commitEmail : String    = "commit-name@example.com"
            
            let mailmapContent: String =
            """
            \(realName) <\(realEmail)> <\(commitEmail)>
            """
            
            
            
            let mailmapURL: URL = repository.url.appending(
                path:           ".mailmap",
                directoryHint:  .notDirectory
            )
            
            try mailmapContent.atomicWrite(to: mailmapURL)
            
            
            
            var mailmapPointer: OpaquePointer? = nil
            
            defer
            {
                gitMailmapFree(mm: mailmapPointer)
            }
            
            
            
            let mailmapFromRepositoryResult: GitErrorCode
                = gitMailmapFromRepository(
                    out:    &mailmapPointer,
                    repo:   repository.pointer
                )
            
            XCTAssertOK(mailmapFromRepositoryResult)
            
            guard let mailmapPointer: OpaquePointer = mailmapPointer
            else
            {
                XCTFail("The mailmap pointer was nil.")
                return
            }
            
            
            
            var resolvedName    : String?   = nil
            var resolvedEmail   : String?   = nil
            
            let mailmapResolveResult: GitErrorCode = gitMailmapResolve(
                realName:   &resolvedName,
                realEmail:  &resolvedEmail,
                mm:         mailmapPointer,
                name:       commitName,
                email:      commitEmail
            )
            
            XCTAssertOK(mailmapResolveResult)
            
            guard let resolvedNameString
                    = String(optionalCString: resolvedName)
            else
            {
                XCTFail("The resolved name string was nil.")
                return
            }
            
            guard let resolvedEmailString
                    = String(optionalCString: resolvedEmail)
            else
            {
                XCTFail("The resolved email string was nil.")
                return
            }
            
            XCTAssertEqual(resolvedNameString, realName)
            XCTAssertEqual(resolvedEmailString, realEmail)
        }
    }
    
    
    
    func testGitMailmapNew() throws
    {
        var mailmapPointer: OpaquePointer? = nil
        
        defer
        {
            gitMailmapFree(mm: mailmapPointer)
        }
        
        
        
        let mailmapNewResult: GitErrorCode
            = gitMailmapNew(out: &mailmapPointer)
        
        XCTAssertOK(mailmapNewResult)
        XCTAssertNotNil(mailmapPointer)
    }
    
    
    
    func testGitMailmapResolveSignature() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let realName    : String    = "Proper Name"
            let realEmail   : String    = "proper-name@example.com"
            
            let mailmapContent: String =
            """
            \(realName) <\(realEmail)> <\(Repository.commitAuthorEmail)>
            """
            
            
            
            let mailmapURL: URL = repository.url.appending(
                path:           ".mailmap",
                directoryHint:  .notDirectory
            )
            
            try mailmapContent.atomicWrite(to: mailmapURL)
            
            
            
            var mailmapPointer: OpaquePointer? = nil
            
            defer
            {
                gitMailmapFree(mm: mailmapPointer)
            }
            
            
            
            let mailmapFromRepositoryResult: GitErrorCode
                = gitMailmapFromRepository(
                    out:    &mailmapPointer,
                    repo:   repository.pointer
                )
            
            XCTAssertOK(mailmapFromRepositoryResult)
            
            guard let mailmapPointer: OpaquePointer = mailmapPointer
            else
            {
                XCTFail("The mailmap pointer was nil.")
                return
            }
            
            
            
            var resolvedSignature = GitSignature()
            
            let mailmapResolveSignatureResult: GitErrorCode
                = gitMailmapResolveSignature(
                    out:    &resolvedSignature,
                    mm:     mailmapPointer,
                    sig:    repository.signature
                )
            
            XCTAssertOK(mailmapResolveSignatureResult)
            XCTAssertEqual(resolvedSignature.name, realName)
            XCTAssertEqual(resolvedSignature.email, realEmail)
            XCTAssertEqual(resolvedSignature.when.time, repository.signature.when.time)
        }
    }
}
