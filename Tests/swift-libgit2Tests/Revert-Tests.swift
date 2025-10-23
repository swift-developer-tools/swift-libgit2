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



final class RevertTests: XCTestCaseStopOnFail
{
    func testGitRevert() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let fileName            : String    = "revert.txt"
            let initialFileContent  : String    = "Initial content"
            
            let fileURL: URL = repository.url.appending(
                path:           fileName,
                directoryHint:  .notDirectory
            )
            
            
            
            try repository.commit(
                "Initial content",
                toFile:     fileName,
                message:    "Initial commit"
            )
            
            let modifiedCommitOID: GitOID = try repository.commit(
                "Modified content",
                toFile:     fileName,
                message:    "Modifying commit"
            )
            
            
            
            var commitPointer   : OpaquePointer?    = nil
            var indexPointer    : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: commitPointer)
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         modifiedCommitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            let revertResult: GitErrorCode = gitRevert(
                repo:       repository.pointer,
                commit:     commitPointer,
                givenOpts:  GitRevertOptions()
            )
            
            XCTAssertOK(revertResult)
            
            
            
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
            
            
            
            let indexEntryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCount, 0)
            
            
            
            let hasConflicts: Bool = gitIndexHasConflicts(index: indexPointer)
            
            XCTAssertFalse(hasConflicts)
            
            
            
            let checkoutIndexResult: GitErrorCode = gitCheckoutIndex(
                repo:   repository.pointer,
                index:  indexPointer,
                opts:   nil
            )
            
            XCTAssertOK(checkoutIndexResult)
            
            
            
            let fileContent = try String(contentsOf: fileURL)
            
            XCTAssertEqual(fileContent, initialFileContent)
        }
    }
    
    
    
    func testGitRevertCommit() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let fileName            : String    = "revert.txt"
            let initialFileContent  : String    = "Initial content"
            
            let fileURL: URL = repository.url.appending(
                path:           fileName,
                directoryHint:  .notDirectory
            )
            
            
            
            try repository.commit(
                "Initial content",
                toFile:     fileName,
                message:    "Initial commit"
            )
            
            let modifiedCommitOID: GitOID = try repository.commit(
                "Modified content",
                toFile:     fileName,
                message:    "Modifying commit"
            )
            
            
            
            var revertCommitPointer : OpaquePointer?    = nil
            var ourCommitPointer    : OpaquePointer?    = nil
            var indexPointer        : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: revertCommitPointer)
                gitCommitFree(commit: ourCommitPointer)
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let revertCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &revertCommitPointer,
                repo:       repository.pointer,
                id:         modifiedCommitOID
            )
            
            XCTAssertOK(revertCommitLookupResult)
            
            guard let revertCommitPointer: OpaquePointer = revertCommitPointer
            else
            {
                XCTFail("The revert commit pointer was nil.")
                return
            }
            
            
            
            let ourCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &ourCommitPointer,
                repo:       repository.pointer,
                id:         modifiedCommitOID
            )
            
            XCTAssertOK(ourCommitLookupResult)
            
            guard let ourCommitPointer: OpaquePointer = ourCommitPointer
            else
            {
                XCTFail("Our commit pointer was nil.")
                return
            }
            
            
            
            let revertCommitResult: GitErrorCode = gitRevertCommit(
                out:            &indexPointer,
                repo:           repository.pointer,
                revertCommit:   revertCommitPointer,
                ourCommit:      ourCommitPointer,
                mainline:       0,
                mergeOptions:   GitMergeOptions()
            )
            
            XCTAssertOK(revertCommitResult)
            
            guard let indexPointer: OpaquePointer = indexPointer
            else
            {
                XCTFail("The index pointer was nil.")
                return
            }
            
            
            
            let indexEntryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCount, 0)
            
            
            
            let hasConflicts: Bool = gitIndexHasConflicts(index: indexPointer)
            
            XCTAssertFalse(hasConflicts)
            
            
            
            let checkoutIndexResult: GitErrorCode = gitCheckoutIndex(
                repo:   repository.pointer,
                index:  indexPointer,
                opts:   nil
            )
            
            XCTAssertOK(checkoutIndexResult)
            
            
            
            let fileContent = try String(contentsOf: fileURL)
            
            XCTAssertEqual(fileContent, initialFileContent)
        }
    }
    
    
    
    func testGitRevertOptions() throws
    {
        let revertOptions = GitRevertOptions()
        
        XCTAssertEqual(revertOptions.version, gitRevertOptionsVersion)
        XCTAssertEqual(revertOptions.mainline, 0)
        XCTAssertNotNil(revertOptions.mergeOpts)
        XCTAssertNotNil(revertOptions.checkoutOpts)
        
        try revertOptions.withCValue
        {
            cRevertOptions in
            
            XCTAssertEqual(cRevertOptions.pointee.version, gitRevertOptionsVersion)
            XCTAssertEqual(cRevertOptions.pointee.mainline, 0)
            XCTAssertNotNil(cRevertOptions.pointee.merge_opts)
            XCTAssertNotNil(cRevertOptions.pointee.checkout_opts)
        }
    }
    
    
    
    func testGitRevertOptionsInit() throws
    {
        var revertOptions = git_revert_options()
        
        let revertOptionsInitResult: GitErrorCode = gitRevertOptionsInit(
            opts:       &revertOptions,
            version:    gitRevertOptionsVersion
        )
        
        XCTAssertOK(revertOptionsInitResult)
    }
    
    
    
    func testGitRevertOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRevertOptionsVersion), GIT_REVERT_OPTIONS_VERSION)
    }
}
