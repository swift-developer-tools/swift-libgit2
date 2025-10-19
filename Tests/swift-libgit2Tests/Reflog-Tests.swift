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



final class ReflogTests: XCTestCaseStopOnFail
{
    func testGitReflogFree() throws
    {
        gitReflogFree(reflog: nil)
    }
    
    
    
    func testGitReflogAppendAndEntryCount() throws
    {
        try withReflogPointer
        {
            repository, reflogPointer in
            
            let entryCountBeforeAppend: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertGreaterThan(entryCountBeforeAppend, 0)
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let reflogAppendResult: GitErrorCode = gitReflogAppend(
                reflog:     reflogPointer,
                id:         headOID,
                committer:  repository.signature,
                msg:        "Hello World!"
            )
            
            XCTAssertOK(reflogAppendResult)
            
            
            
            let entryCountAfterAppend: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertEqual(entryCountAfterAppend, entryCountBeforeAppend + 1)
            
            
            
            let reflogAppendNilResult: GitErrorCode = gitReflogAppend(
                reflog:     reflogPointer,
                id:         headOID,
                committer:  repository.signature,
                msg:        nil
            )
            
            XCTAssertOK(reflogAppendNilResult)
            
            
            
            let finalEntryCount: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertEqual(finalEntryCount, entryCountAfterAppend + 1)
        }
    }
    
    
    
    func testGitReflogDelete() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let branchName  : String    = "feature/something"
            let refName     : String    = "refs/heads/\(branchName)"
            
            try Branch.createLocalBranch(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            var reflogPointer: OpaquePointer? = nil
            
            defer
            {
                gitReflogFree(reflog: reflogPointer)
            }
            
            
            
            let reflogReadResult: GitErrorCode = gitReflogRead(
                out:    &reflogPointer,
                repo:   repository.pointer,
                name:   refName
            )
            
            XCTAssertOK(reflogReadResult)
            XCTAssertNotNil(reflogPointer)
            
            
            
            let reflogDeleteResult: GitErrorCode = gitReflogDelete(
                repo:   repository.pointer,
                name:   refName
            )
            
            XCTAssertOK(reflogDeleteResult)
            
            
            
            gitReflogFree(reflog: reflogPointer)
            reflogPointer = nil
            
            
            
            let reflogReadAfterDeleteResult: GitErrorCode = gitReflogRead(
                out:    &reflogPointer,
                repo:   repository.pointer,
                name:   refName
            )
            
            XCTAssertOK(reflogReadAfterDeleteResult)
            
            guard let reflogPointer: OpaquePointer = reflogPointer
            else
            {
                XCTFail("The reflog pointer was nil.")
                return
            }
            
            
            
            let entryCount: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertEqual(entryCount, 0)
        }
    }
    
    
    
    func testGitReflogDrop() throws
    {
        try withReflogPointer
        {
            repository, reflogPointer in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            for index in 1...3
            {
                let reflogAppendResult: GitErrorCode = gitReflogAppend(
                    reflog:     reflogPointer,
                    id:         headOID,
                    committer:  repository.signature,
                    msg:        "Entry \(index)"
                )
                
                XCTAssertOK(reflogAppendResult)
            }
            
            
            
            let entryCountBeforeDrop: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertGreaterThanOrEqual(entryCountBeforeDrop, 3)
            
            
            
            var reflogDropResult: GitErrorCode = gitReflogDrop(
                reflog:                 reflogPointer,
                idx:                    0,
                rewritePreviousEntry:   false
            )
            
            XCTAssertOK(reflogDropResult)
            
            
            
            let entryCountAfterDrop: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertEqual(entryCountAfterDrop, entryCountBeforeDrop - 1)
            
            
            
            reflogDropResult = gitReflogDrop(
                reflog:                 reflogPointer,
                idx:                    0,
                rewritePreviousEntry:   true
            )
            
            XCTAssertOK(reflogDropResult)
            
            
            
            let finalEntryCount: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertEqual(finalEntryCount, entryCountAfterDrop - 1)
        }
    }
    
    
    
    func testGitReflogEntryByIndexAndGetters() throws
    {
        try withReflogPointer
        {
            _, reflogPointer in
            
            guard let entryPointer: OpaquePointer = gitReflogEntryByIndex(
                reflog:     reflogPointer,
                idx:        0
            )
            else
            {
                XCTFail("The reflog entry pointer was nil.")
                return
            }
            
            
            
            let oldOID: GitOID? = gitReflogEntryIDOld(entry: entryPointer)
            let newOID: GitOID? = gitReflogEntryIDOld(entry: entryPointer)
            
            XCTAssertNotNil(oldOID)
            XCTAssertNotNil(newOID)
            XCTAssertNotZeroOID(oldOID)
            XCTAssertNotZeroOID(newOID)
            
            
            
            let committer: GitSignature?
                = gitReflogEntryCommitter(entry: entryPointer)
            
            XCTAssertNotNil(committer)
            XCTAssertEqual(committer?.name, Repository.commitAuthorName)
            XCTAssertEqual(committer?.email, Repository.commitAuthorEmail)
            
            
            
            let message: String? = gitReflogEntryMessage(entry: entryPointer)
            
            XCTAssertNotNil(message)
        }
    }
    
    
    
    func testGitReflogReadAndWrite() throws
    {
        try withReflogPointer
        {
            _, reflogPointer in
            
            let reflogWriteResult: GitErrorCode
                = gitReflogWrite(reflog: reflogPointer)
            
            XCTAssertOK(reflogWriteResult)
        }
    }
    
    
    
    func testGitReflogRename() throws
    {
        try withReflogPointer
        {
            repository, reflogPointer in
            
            let oldBranchName   : String    = "feature/something"
            let oldRefName      : String    = "refs/heads/\(oldBranchName)"
            let newBranchName   : String    = "feature/something-else"
            let newRefName      : String    = "refs/heads/\(newBranchName)"
            
            try Branch.createLocalBranch(
                named:      oldBranchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let reflogRenameResult: GitErrorCode = gitReflogRename(
                repo:       repository.pointer,
                oldName:    oldRefName,
                name:       newRefName
            )
            
            XCTAssertOK(reflogRenameResult)
            
            
            
            var newReflogPointer: OpaquePointer? = nil
            
            defer
            {
                gitReflogFree(reflog: newReflogPointer)
            }
            
            
            
            let reflogReadAfterRenameResult: GitErrorCode = gitReflogRead(
                out:    &newReflogPointer,
                repo:   repository.pointer,
                name:   "HEAD"
            )
            
            XCTAssertOK(reflogReadAfterRenameResult)
            XCTAssertNotNil(newReflogPointer)
        }
    }
}



// MARK: - Extensions

private extension ReflogTests
{
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a reflog.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withReflogPointer(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var reflogPointer: OpaquePointer? = nil
            
            defer
            {
                gitReflogFree(reflog: reflogPointer)
            }
            
            
            
            let reflogReadResult: GitErrorCode = gitReflogRead(
                out:    &reflogPointer,
                repo:   repository.pointer,
                name:   "HEAD"
            )
            
            XCTAssertOK(reflogReadResult)
            
            guard let reflogPointer: OpaquePointer = reflogPointer
            else
            {
                throw NSError.makeError("The reflog pointer was nil.")
            }
            
            
            
            let entryCount: Int
                = gitReflogEntryCount(reflog: reflogPointer)
            
            XCTAssertGreaterThan(entryCount, 0)
            
            
            
            return try body(
                repository,
                reflogPointer
            )
        }
    }
}
