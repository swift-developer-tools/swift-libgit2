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



final class RebaseTests: XCTestCaseStopOnFail
{
    func testGitRebaseAbort() throws
    {
        try withPreparedRebase
        {
            _, rebasePointer in
            
            let rebaseAbortResult: GitErrorCode
                = gitRebaseAbort(rebase: rebasePointer)
            
            XCTAssertOK(rebaseAbortResult)
        }
    }
    
    
    
    func testGitRebaseEntryCount() throws
    {
        try withPreparedRebase
        {
            _, rebasePointer in
            
            let operationEntryCount: Int
                = gitRebaseOperationEntryCount(rebase: rebasePointer)
            
            XCTAssertGreaterThan(operationEntryCount, 0)
        }
    }
    
    
    
    func testGitRebaseFree() throws
    {
        gitRebaseFree(rebase: nil)
    }
    
    
    
    func testGitRebaseCommitNextAndFinish() throws
    {
        try testGitRebaseNextFlow(options: nil)
    }
    
    
    
    func testGitRebaseInMemoryIndex() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let baseCommitOID: GitOID = try repository.commit(
                "Base content",
                toFile:     "conflict.txt",
                message:    "Base commit"
            )
            
            try repository.commit(
                "Branch content",
                toFile:     "conflict.txt",
                message:    "Branch commit"
            )
            
            let branchCommitOID: GitOID = repository.headOID
            
            repository.reset(to: baseCommitOID)
            
            try repository.commit(
                "Upstream content",
                toFile:     "conflict.txt",
                message:    "Upstream commit"
            )
            
            
            
            var annotatedCommitPointer  : OpaquePointer?    = nil
            var rebasePointer           : OpaquePointer?    = nil
            var indexPointer            : OpaquePointer?    = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
                gitRebaseFree(rebase: rebasePointer)
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     branchCommitOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            XCTAssertNotNil(annotatedCommitPointer)
            
            
            
            var rebaseOptions = GitRebaseOptions()
            
            rebaseOptions.inMemory = true
            
            
            
            let rebaseInitResult: GitErrorCode = gitRebaseInit(
                out:        &rebasePointer,
                repo:       repository.pointer,
                branch:     nil,
                upstream:   annotatedCommitPointer,
                onto:       nil,
                opts:       rebaseOptions
            )
            
            XCTAssertOK(rebaseInitResult)
            
            guard let rebasePointer
            else
            {
                XCTFail("The rebase pointer was nil.")
                return
            }
            
            
            
            var nextRebaseOperation = GitRebaseOperation()
            
            let rebaseNextResult: GitErrorCode = gitRebaseNext(
                operation:  &nextRebaseOperation,
                rebase:     rebasePointer
            )
            
            XCTAssertOK(rebaseNextResult)
            XCTAssertNotZeroOID(nextRebaseOperation.id)
            
            
            
            let rebaseInMemoryIndexResult: GitErrorCode
                = gitRebaseInMemoryIndex(
                    index:      &indexPointer,
                    rebase:     rebasePointer
                )
            
            XCTAssertOK(rebaseInMemoryIndexResult)
            XCTAssertNotNil(indexPointer)
            
            
            
            let rebaseAbortResult: GitErrorCode
                = gitRebaseAbort(rebase: rebasePointer)
            
            XCTAssertOK(rebaseAbortResult)
        }
    }
    
    
    
    func testGitRebaseOpenAndGetters() throws
    {
        try withPreparedRebase
        {
            _, _ in
        }
    }
    
    
    
    func testGitRebaseOperationT() throws
    {
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationPick.rawValue, GIT_REBASE_OPERATION_PICK.rawValue)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationReword.rawValue, GIT_REBASE_OPERATION_REWORD.rawValue)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationEdit.rawValue, GIT_REBASE_OPERATION_EDIT.rawValue)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationSquash.rawValue, GIT_REBASE_OPERATION_SQUASH.rawValue)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationFixup.rawValue, GIT_REBASE_OPERATION_FIXUP.rawValue)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationExec.rawValue, GIT_REBASE_OPERATION_EXEC.rawValue)
        
        XCTAssertNil(GitRebaseOperationT(rawValue: 123))
        
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationPick.cValue(), GIT_REBASE_OPERATION_PICK)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationReword.cValue(), GIT_REBASE_OPERATION_REWORD)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationEdit.cValue(), GIT_REBASE_OPERATION_EDIT)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationSquash.cValue(), GIT_REBASE_OPERATION_SQUASH)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationFixup.cValue(), GIT_REBASE_OPERATION_FIXUP)
        XCTAssertEqual(GitRebaseOperationT.gitRebaseOperationExec.cValue(), GIT_REBASE_OPERATION_EXEC)
        
        XCTAssertEqual(GitRebaseOperationT(cValue: GIT_REBASE_OPERATION_PICK), .gitRebaseOperationPick)
        XCTAssertEqual(GitRebaseOperationT(cValue: GIT_REBASE_OPERATION_REWORD), .gitRebaseOperationReword)
        XCTAssertEqual(GitRebaseOperationT(cValue: GIT_REBASE_OPERATION_EDIT), .gitRebaseOperationEdit)
        XCTAssertEqual(GitRebaseOperationT(cValue: GIT_REBASE_OPERATION_SQUASH), .gitRebaseOperationSquash)
        XCTAssertEqual(GitRebaseOperationT(cValue: GIT_REBASE_OPERATION_FIXUP), .gitRebaseOperationFixup)
        XCTAssertEqual(GitRebaseOperationT(cValue: GIT_REBASE_OPERATION_EXEC), .gitRebaseOperationExec)
    }
    
    
    
    func testGitRebaseNoOperation() throws
    {
        XCTAssertEqual(gitRebaseNoOperation, GIT_REBASE_NO_OPERATION)
    }
    
    
    
    func testGitRebaseNoOperationValue() throws
    {
        try withPreparedRebase
        {
            _, rebasePointer in
            
            /// libgit2 returns `GIT_REBASE_NO_OPERATION` if there is no
            /// current rebase operation. This is equal to `SIZE_MAX`, which
            /// is equal to `UInt32.max` on 32-bit platforms, and `UInt64.max`
            /// on 64-bit platforms (or `UInt.max`).
            ///
            /// `git_rebase_operation_current()` returns a value of the type
            /// `size_t`, which Swift imports as `Int`. When libgit2 returns
            /// `SIZE_MAX`, the bit pattern of the maximum unsigned integer is
            /// reinterpreted as the signed integer `-1` in two's complement
            /// representation.
            let rebaseOperationCurrent: Int
                = gitRebaseOperationCurrent(rebase: rebasePointer)
            
            XCTAssertEqual(rebaseOperationCurrent, -1)
            XCTAssertEqual(gitRebaseNoOperation, UInt.max)
            XCTAssertEqual(Int(bitPattern: UInt.max), -1)
            
            
            
            let rebaseAbortResult: GitErrorCode
                = gitRebaseAbort(rebase: rebasePointer)
            
            XCTAssertOK(rebaseAbortResult)
        }
    }
    
    
    
    func testGitRebaseOpen() throws
    {
        try withPreparedRebase
        {
            repository, _ in
            
            var rebasePointer: OpaquePointer? = nil
            
            defer
            {
                gitRebaseFree(rebase: rebasePointer)
            }
            
            
            
            let rebaseOpenResult: GitErrorCode = gitRebaseOpen(
                out:    &rebasePointer,
                repo:   repository.pointer,
                opts:   nil
            )
            
            XCTAssertOK(rebaseOpenResult)
            XCTAssertNotNil(rebasePointer)
        }
    }
    
    
    
    func testGitRebaseOperation() throws
    {
        let rebaseOperation = GitRebaseOperation()
        
        XCTAssertEqual(rebaseOperation.type, .gitRebaseOperationPick)
        XCTAssertZeroOID(rebaseOperation.id)
        XCTAssertNil(rebaseOperation.exec)
        
        try rebaseOperation.withCValue
        {
            cRebaseOperation in
            
            XCTAssertEqual(GitRebaseOperationT(cValue: cRebaseOperation.pointee.type), .gitRebaseOperationPick)
            XCTAssertZeroOID(GitOID(cValue: cRebaseOperation.pointee.id))
            XCTAssertNil(cRebaseOperation.pointee.exec)
        }
    }
    
    
    
    func testGitRebaseOptions() throws
    {
        let rebaseOptions = GitRebaseOptions()
        
        XCTAssertEqual(rebaseOptions.version, gitRebaseOptionsVersion)
        XCTAssertFalse(rebaseOptions.quiet)
        XCTAssertFalse(rebaseOptions.inMemory)
        XCTAssertNil(rebaseOptions.rewriteNotesRef)
        XCTAssertNotNil(rebaseOptions.mergeOptions)
        XCTAssertNotNil(rebaseOptions.checkoutOptions)
        XCTAssertNil(rebaseOptions.commitCreateCB)
        XCTAssertNil(rebaseOptions.signingCB)
        XCTAssertNil(rebaseOptions.payload)
        
        try rebaseOptions.withCValue
        {
            cRebaseOptions in
            
            XCTAssertEqual(cRebaseOptions.pointee.version, gitRebaseOptionsVersion)
            XCTAssertFalse(Bool(cRebaseOptions.pointee.quiet))
            XCTAssertFalse(Bool(cRebaseOptions.pointee.inmemory))
            XCTAssertNil(cRebaseOptions.pointee.rewrite_notes_ref)
            XCTAssertNotNil(cRebaseOptions.pointee.merge_options)
            XCTAssertNotNil(cRebaseOptions.pointee.checkout_options)
            XCTAssertNil(cRebaseOptions.pointee.commit_create_cb)
            XCTAssertNil(cRebaseOptions.pointee.signing_cb)
            XCTAssertNil(cRebaseOptions.pointee.payload)
        }
    }
    
    
    
    func testGitRebaseOptionsInit() throws
    {
        var rebaseOptions = git_rebase_options()
        
        let rebaseOptionsInitResult: GitErrorCode = gitRebaseOptionsInit(
            opts:       &rebaseOptions,
            version:    gitRebaseOptionsVersion
        )
        
        XCTAssertOK(rebaseOptionsInitResult)
    }
    
    
    
    func testGitRebaseOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRebaseOptionsVersion), GIT_REBASE_OPTIONS_VERSION)
    }
    
    
    
    func testGitRebaseSigningCB() throws
    {
        var callbackData = CallbackData()
                    
        let rebaseSigningCB: GitRebaseOptions.SigningCB =
        {
            _, _, _, payload in
            
            guard let payload
            else
            {
                XCTFail("The payload was nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            let payloadPointer: UnsafeMutablePointer<CallbackData>
                = payload.assumingMemoryBound(to: CallbackData.self)
            
            payloadPointer.pointee.callCount += 1
            
            /// Let the rebase create the commit normally.
            return GitErrorCode.gitPassthrough.rawValue
        }
        
        
        
        try withUnsafeMutablePointer(to: &callbackData)
        {
            callbackDataPointer in
            
            var rebaseOptions = GitRebaseOptions()
            
            rebaseOptions.signingCB     = rebaseSigningCB
            rebaseOptions.payload       = UnsafeMutableRawPointer(callbackDataPointer)
            
            
            try testGitRebaseNextFlow(options: rebaseOptions)
        }
        
        XCTAssertGreaterThan(callbackData.callCount, 0)
    }
}



// MARK: - Extensions

private extension RebaseTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to an in-progress rebase, after preparing the repostiory for a rebase
    /// operation.
    /// - Parameters:
    ///   - options: The rebase options to use.
    ///   - body: The closure to call.
    /// - Throws: An error if an operations fails.
    func withPreparedRebase(
        options : GitRebaseOptions? = nil,
        _ body  : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            let baseCommitOID: GitOID = try repository.commit(
                "Base content",
                toFile:     "base.txt",
                message:    "Base commit"
            )
            
            let branchCommitOID: GitOID = try repository.commit(
                "Branch content",
                toFile:     "branch.txt",
                message:    "Branch commit"
            )
            
            repository.reset(to: baseCommitOID)
            
            try repository.commit(
                "Onto content",
                toFile:     "onto.txt",
                message:    "Onto commit"
            )
            
            
            
            var annotatedCommitPointer  : OpaquePointer?    = nil
            var rebasePointer           : OpaquePointer?    = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
                gitRebaseFree(rebase: rebasePointer)
            }
            
            
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     branchCommitOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            XCTAssertNotNil(annotatedCommitPointer)
            
            
            
            let rebaseInitResult: GitErrorCode = gitRebaseInit(
                out:        &rebasePointer,
                repo:       repository.pointer,
                branch:     nil,
                upstream:   annotatedCommitPointer,
                onto:       nil,
                opts:       options
            )
            
            XCTAssertOK(rebaseInitResult)
            
            guard let rebasePointer
            else
            {
                XCTFail("The rebase pointer was nil.")
                return
            }
            
            
            
            let originalHEADName: String?
                = gitRebaseOrigHEADName(rebase: rebasePointer)
            
            XCTAssertNotNil(originalHEADName)
            
            
            
            let originalHEADOID: GitOID?
                = gitRebaseOrigHEADID(rebase: rebasePointer)
            
            XCTAssertNotNil(originalHEADOID)
            XCTAssertNotZeroOID(originalHEADOID)
            
            
            
            _ = gitRebaseOntoName(rebase: rebasePointer)
            
            
            
            let ontoOID: GitOID? = gitRebaseOntoID(rebase: rebasePointer)
            
            XCTAssertNotNil(ontoOID)
            XCTAssertNotZeroOID(ontoOID)
            
            
            
            try body(
                repository,
                rebasePointer
            )
        }
    }
    
    
    
    /// Tests the full rebase operation.
    /// - Parameter options: The rebase options to use.
    /// - Throws: An error if an operation fails.
    func testGitRebaseNextFlow(
        options: GitRebaseOptions?
    ) throws
    {
        try withPreparedRebase(options: options)
        {
            repository, rebasePointer in
            
            let operationCurrentBeforeStart: Int
                = gitRebaseOperationCurrent(rebase: rebasePointer)
            
            /// See ``testGitRebaseNoOperationValue()``.
            XCTAssertEqual(operationCurrentBeforeStart, Int(bitPattern: gitRebaseNoOperation))
            
            
            
            let rebaseOperation: GitRebaseOperation?
                = gitRebaseOperationByIndex(
                    rebase:     rebasePointer,
                    idx:        0
                )
            
            XCTAssertNotNil(rebaseOperation)
            XCTAssertNotZeroOID(rebaseOperation?.id)
            
            
            
            var nextRebaseOperation = GitRebaseOperation()
            
            while true
            {
                let rebaseNextResult: GitErrorCode = gitRebaseNext(
                    operation:  &nextRebaseOperation,
                    rebase:     rebasePointer
                )
                
                if rebaseNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(rebaseNextResult)
                XCTAssertNotZeroOID(nextRebaseOperation.id)
                
                
                
                var rebasedCommitOID = GitOID()
                
                let rebaseCommitResult: GitErrorCode = gitRebaseCommit(
                    id:                 &rebasedCommitOID,
                    rebase:             rebasePointer,
                    author:             nil,
                    committer:          repository.signature,
                    messageEncoding:    nil,
                    message:            nil
                )
                
                if rebaseCommitResult != .gitEApplied
                {
                    XCTAssertOK(rebaseCommitResult)
                    XCTAssertNotZeroOID(rebasedCommitOID)
                }
            }
            
            
            
            let operationCurrentAfterStart: Int
                = gitRebaseOperationCurrent(rebase: rebasePointer)
            
            let operationEntryCount: Int
                = gitRebaseOperationEntryCount(rebase: rebasePointer)
            
            XCTAssertEqual(operationCurrentAfterStart, operationEntryCount - 1)
            
            
            
            let rebaseFinishResult: GitErrorCode = gitRebaseFinish(
                rebase:     rebasePointer,
                signature:  repository.signature
            )
            
            XCTAssertOK(rebaseFinishResult)
        }
    }
}
