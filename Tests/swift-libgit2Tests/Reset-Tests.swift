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



final class ResetTests: XCTestCaseStopOnFail
{
    func testGitReset() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            let headOIDBeforeReset: GitOID
                = OID.getHEADCommitOID(in: repository)
            
            XCTAssertEqual(headOIDBeforeReset, secondCommitOID)
            
            
            
            repository.reset(to: firstCommitOID)
            
            
            
            let headOIDAfterReset: GitOID
                = OID.getHEADCommitOID(in: repository)
            
            XCTAssertEqual(headOIDAfterReset, firstCommitOID)
        }
    }
    
    
    
    func testGitResetDefault() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstFileName   : String    = "first.txt"
            let secondFileName  : String    = "second.txt"
            let thirdFileName   : String    = "third.txt"
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     firstFileName,
                message:    "First commit"
            )
            
            let secondFileURL: URL = repository.url.appending(
                path:           secondFileName,
                directoryHint:  .notDirectory
            )
            
            try "Second content".atomicWrite(to: secondFileURL)
            
            let thirdFileURL: URL = repository.url.appending(
                path:           thirdFileName,
                directoryHint:  .notDirectory
            )
            
            try "Third content".atomicWrite(to: thirdFileURL)
            
            
            
            var indexPointer    : OpaquePointer?    = nil
            var commitPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
                gitCommitFree(commit: commitPointer)
            }
            
            
            
            let repoIndexResult: GitErrorCode = gitRepositoryIndex(
                out:    &indexPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoIndexResult)
            
            guard let indexPointer: OpaquePointer = indexPointer
            else
            {
                XCTFail("The index pointer was nil.")
                return
            }
            
            
            
            for fileName in [secondFileName, thirdFileName]
            {
                let indexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                    index:  indexPointer,
                    path:   fileName
                )
                
                XCTAssertOK(indexAddByPathResult)
            }
            
            
            
            let indexWriteResult: GitErrorCode
                = gitIndexWrite(index: indexPointer)
            
            XCTAssertOK(indexWriteResult)
            
            
            
            let indexEntryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThanOrEqual(indexEntryCount, 3)
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         firstCommitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            var resetDefaultResult: GitErrorCode = gitResetDefault(
                repo:       repository.pointer,
                target:     commitPointer,
                pathspecs:  [secondFileName]
            )
            
            XCTAssertOK(resetDefaultResult)
            
            
            
            var indexReadResult: GitErrorCode = gitIndexRead(
                index:  indexPointer,
                force:  true
            )
            
            XCTAssertOK(indexReadResult)
            
            
            
            let secondIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   secondFileName,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(secondIndexEntry)
            
            
            
            let thirdIndexEntryBeforeReset: GitIndexEntry?
                = gitIndexGetByPath(
                    index:  indexPointer,
                    path:   thirdFileName,
                    stage:  .gitIndexStageNormal
                )
                
            XCTAssertNotNil(thirdIndexEntryBeforeReset)
            
            
            
            /// Reset again with a `nil` target to remove the third file also.
            resetDefaultResult = gitResetDefault(
                repo:       repository.pointer,
                target:     nil,
                pathspecs:  [thirdFileName]
            )
            
            XCTAssertOK(resetDefaultResult)
            
            
            
            indexReadResult = gitIndexRead(
                index:  indexPointer,
                force:  true
            )
            
            XCTAssertOK(indexReadResult)
            
            
            
            let thirdIndexEntryAfterReset: GitIndexEntry?
                = gitIndexGetByPath(
                    index:  indexPointer,
                    path:   thirdFileName,
                    stage:  .gitIndexStageNormal
                )
                
            XCTAssertNil(thirdIndexEntryAfterReset)
        }
    }
    
    
    
    func testGitResetFromAnnotated() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            let headOIDBeforeReset: GitOID
                = OID.getHEADCommitOID(in: repository)
            
            XCTAssertEqual(headOIDBeforeReset, secondCommitOID)
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            }
            
            
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     firstCommitOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let resetFromAnnotatedResult: GitErrorCode
                = gitResetFromAnnotated(
                    repo:           repository.pointer,
                    target:         annotatedCommitPointer,
                    resetType:      .gitResetHard,
                    checkoutOpts:   nil
                )
            
            XCTAssertOK(resetFromAnnotatedResult)
            
            
            
            let headOIDAfterReset: GitOID
                = OID.getHEADCommitOID(in: repository)
            
            XCTAssertEqual(headOIDAfterReset, firstCommitOID)
        }
    }
    
    
    
    func testGitResetT() throws
    {
        XCTAssertEqual(GitResetT.gitResetSoft.rawValue, GIT_RESET_SOFT.rawValue)
        XCTAssertEqual(GitResetT.gitResetMixed.rawValue, GIT_RESET_MIXED.rawValue)
        XCTAssertEqual(GitResetT.gitResetHard.rawValue, GIT_RESET_HARD.rawValue)
        
        XCTAssertNil(GitResetT(rawValue: 123))
        
        XCTAssertEqual(GitResetT.gitResetSoft.cValue(), GIT_RESET_SOFT)
        XCTAssertEqual(GitResetT.gitResetMixed.cValue(), GIT_RESET_MIXED)
        XCTAssertEqual(GitResetT.gitResetHard.cValue(), GIT_RESET_HARD)
        
        XCTAssertEqual(GitResetT(cValue: GIT_RESET_SOFT), .gitResetSoft)
        XCTAssertEqual(GitResetT(cValue: GIT_RESET_MIXED), .gitResetMixed)
        XCTAssertEqual(GitResetT(cValue: GIT_RESET_HARD), .gitResetHard)
    }
}
