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



final class PackTests: XCTestCaseStopOnFail
{
    func testGitPackbuilderForEach() throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, packbuilderPointer in
            
            var callbackData = CallbackData()
            
            let packbuilderForEachCB: GitPackbuilderForEachCB =
            {
                _, _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let packbuilderForEachResult: GitErrorCode
                    = gitPackbuilderForEach(
                        pb:         packbuilderPointer,
                        cb:         packbuilderForEachCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(packbuilderForEachResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
        }
    }
    
    
    
    func testGitPackbuilderFree() throws
    {
        gitPackbuilderFree(pb: nil)
    }
    
    
    
    func testGitPackbuilderInsertCommitAndTree() throws
    {
        try withPackbuilder
        {
            repository, packbuilderPointer in
            
            let packbuilderInsertCommitResult: GitErrorCode
                = gitPackbuilderInsertCommit(
                    pb:     packbuilderPointer,
                    id:     repository.headOID
                )
            
            XCTAssertOK(packbuilderInsertCommitResult)
            
            
            
            let objectCountAfterCommitInserted: Int
                = gitPackbuilderObjectCount(pb: packbuilderPointer)
            
            XCTAssertGreaterThan(objectCountAfterCommitInserted, 0)
            
            
            
            let treeOID: GitOID? = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTreeID(commit: commitPointer)
            }
            
            guard let treeOID: GitOID = treeOID
            else
            {
                XCTFail("The tree OID was nil.")
                return
            }
            
            
            
            var treePackbuilderPointer: OpaquePointer? = nil
            
            defer
            {
                gitPackbuilderFree(pb: treePackbuilderPointer)
            }
            
            
            
            let packbuilderNewResult: GitErrorCode = gitPackbuilderNew(
                out:    &treePackbuilderPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(packbuilderNewResult)
            
            guard let treePackbuilderPointer: OpaquePointer
                    = treePackbuilderPointer
            else
            {
                XCTFail("The tree packbuilder pointer was nil.")
                return
            }
            
            
            
            let packbuilderInsertTreeResult: GitErrorCode
                = gitPackbuilderInsertTree(
                    pb:     treePackbuilderPointer,
                    id:     treeOID
                )
            
            XCTAssertOK(packbuilderInsertTreeResult)
            
            
            
            let objectCountAfterTreeInserted: Int
                = gitPackbuilderObjectCount(pb: treePackbuilderPointer)
            
            XCTAssertGreaterThan(objectCountAfterTreeInserted, 0)
        }
    }
    
    
    
    func testGitPackbuilderInsertAndObjectCount() throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, _ in
            
        }
    }
    
    
    
    func testGitPackbuilderInsertRecur() throws
    {
        try withPackbuilder(insertCommit: .recursive)
        {
            _, _ in
            
        }
    }
    
    
    
    func testGitPackbuilderInsertWalk() throws
    {
        try withPackbuilder
        {
            repository, packbuilderPointer in
            
            try repository.commit(
                "First commit",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            try repository.commit(
                "Second commit",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            var revwalkPointer: OpaquePointer? = nil
            
            defer
            {
                gitRevwalkFree(walk: revwalkPointer)
            }
            
            
            
            let revwalkNewResult: GitErrorCode = gitRevwalkNew(
                out:    &revwalkPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(revwalkNewResult)
            
            guard let revwalkPointer: OpaquePointer = revwalkPointer
            else
            {
                XCTFail("The revwalk pointer was nil.")
                return
            }
            
            
            
            let revwalkPushHEADResult: GitErrorCode
                = gitRevwalkPushHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkPushHEADResult)
            
            
            
            let packbuilderInsertRevwalkResult: GitErrorCode
                = gitPackbuilderInsertWalk(
                    pb:     packbuilderPointer,
                    walk:   revwalkPointer
                )
            
            XCTAssertOK(packbuilderInsertRevwalkResult)
            
            
            
            let objectCount: Int
                = gitPackbuilderObjectCount(pb: packbuilderPointer)
            
            XCTAssertGreaterThan(objectCount, 0)
        }
    }
    
    
    
    func testGitPackbuilderHashAndName() throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, packbuilderPointer in
            
            let packbuilderWrite: GitErrorCode = gitPackbuilderWrite(
                pb:                 packbuilderPointer,
                path:               nil,
                mode:               0,
                progressCB:         nil,
                progressCBPayload:  nil
            )
            
            XCTAssertOK(packbuilderWrite)
            
            
            
            let packfileOID: GitOID?
                = gitPackbuilderHash(pb: packbuilderPointer)
            
            XCTAssertNotNil(packfileOID)
            XCTAssertNotZeroOID(packfileOID)
            
            
            
            let packfileName: String?
                = gitPackbuilderName(pb: packbuilderPointer)
            
            XCTAssertNotNil(packfileName)
            XCTAssertFalse(packfileName?.isEmpty ?? true)
        }
    }
    
    
    
    func testGitPackbuilderNew() throws
    {
        try withPackbuilder
        {
            _, _ in
        }
    }
    
    
    
    func testGitPackbuilderSetCallbacks() throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, packbuilderPointer in
            
            var callbackData = CallbackData()
            
            let packbuilderProgressCB: GitPackbuilderProgressCB =
            {
                _, _, _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let packbuilderSetCallbacksReuslt: GitErrorCode
                    = gitPackbuilderSetCallbacks(
                        pb:                 packbuilderPointer,
                        progressCB:         packbuilderProgressCB,
                        progressCBPayload:  UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(packbuilderSetCallbacksReuslt)
            }
            
            
            
            var packData = Data()
            
            let packbuilderWriteBufResult: GitErrorCode
                = gitPackbuilderWriteBuf(
                    buf:    &packData,
                    pb:     packbuilderPointer
                )
            
            XCTAssertOK(packbuilderWriteBufResult)
            XCTAssertGreaterThan(packData.count, 0)
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
        }
    }
    
    
    
    func testGitPackbuilderSetThreads() throws
    {
        try withPackbuilder
        {
            _, packbuilderPointer in
            
            let actualThreadCount: UInt32 = gitPackbuilderSetThreads(
                pb:     packbuilderPointer,
                n:      4
            )
            
            XCTAssertGreaterThan(actualThreadCount, 0)
        }
    }
    
    
    
    func testGitPackbuilderStageT() throws
    {
        XCTAssertEqual(GitPackbuilderStageT.gitPackbuilderAddingObjects.rawValue, GIT_PACKBUILDER_ADDING_OBJECTS.rawValue)
        XCTAssertEqual(GitPackbuilderStageT.gitPackbuilderDeltafication.rawValue, GIT_PACKBUILDER_DELTAFICATION.rawValue)
        
        XCTAssertNil(GitPackbuilderStageT(rawValue: 123))
        
        XCTAssertEqual(GitPackbuilderStageT.gitPackbuilderAddingObjects.cValue(), GIT_PACKBUILDER_ADDING_OBJECTS)
        XCTAssertEqual(GitPackbuilderStageT.gitPackbuilderDeltafication.cValue(), GIT_PACKBUILDER_DELTAFICATION)
        
        XCTAssertEqual(GitPackbuilderStageT(cValue: GIT_PACKBUILDER_ADDING_OBJECTS), .gitPackbuilderAddingObjects)
        XCTAssertEqual(GitPackbuilderStageT(cValue: GIT_PACKBUILDER_DELTAFICATION), .gitPackbuilderDeltafication)
    }
    
    
    
    func testGitPackbuilderWrite() throws
    {
        try testGitWithPackbuilderWriteFlow(withCallback: true)
        try testGitWithPackbuilderWriteFlow(withCallback: false)
    }
    
    
    
    func testGitPackbuilderWriteBuf() throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, packbuilderPointer in
            
            var packData = Data()
            
            let packbuilderWriteBufResult: GitErrorCode
                = gitPackbuilderWriteBuf(
                    buf:    &packData,
                    pb:     packbuilderPointer
                )
            
            XCTAssertOK(packbuilderWriteBufResult)
            XCTAssertGreaterThan(packData.count, 0)
        }
    }
    
    
    
    func testGitPackbuilderWritten() throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, packbuilderPointer in
            
            let writtenBefore: Int
                = gitPackbuilderWritten(pb: packbuilderPointer)
            
            XCTAssertEqual(writtenBefore, 0)
            
            
            
            var packData = Data()
            
            let packbuilderWriteBufResult: GitErrorCode
                = gitPackbuilderWriteBuf(
                    buf:    &packData,
                    pb:     packbuilderPointer
                )
            
            XCTAssertOK(packbuilderWriteBufResult)
            XCTAssertGreaterThan(packData.count, 0)
            
            
            
            let writtenAfter: Int
                = gitPackbuilderWritten(pb: packbuilderPointer)
            
            let objectCount: Int
                = gitPackbuilderObjectCount(pb: packbuilderPointer)
            
            XCTAssertGreaterThan(writtenAfter, 0)
            XCTAssertGreaterThan(objectCount, 0)
            XCTAssertEqual(writtenAfter, objectCount)
        }
    }
}



// MARK: - Extensions

private extension PackTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
    
    
    
    enum CommitInsertType
    {
        case standard
        case recursive
    }
    
    
    
    /// Tests writing a packfile with or without a callback.
    /// - Parameter withCallback: Whether to write the packfile with a callback.
    /// - Throws: An error if an operation fails.
    func testGitWithPackbuilderWriteFlow(
        withCallback: Bool
    ) throws
    {
        try withPackbuilder(insertCommit: .standard)
        {
            _, packbuilderPointer in
            
            var callbackData = CallbackData()
            
            let indexerProgressCB: GitIndexerProgressCB =
            {
                _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let packbuilderWriteResult: GitErrorCode
                
                if withCallback
                {
                    packbuilderWriteResult = gitPackbuilderWrite(
                        pb:                 packbuilderPointer,
                        path:               nil,
                        mode:               0,
                        progressCB:         indexerProgressCB,
                        progressCBPayload:  UnsafeMutableRawPointer(callbackDataPointer)
                    )
                }
                else
                {
                    packbuilderWriteResult = gitPackbuilderWrite(
                        pb:                 packbuilderPointer,
                        path:               nil,
                        mode:               0,
                        progressCB:         nil,
                        progressCBPayload:  nil
                    )
                }
                
                XCTAssertOK(packbuilderWriteResult)
            }
            
            if withCallback
            {
                XCTAssertGreaterThan(callbackData.callCount, 0)
            }
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a packbuilder.
    /// - Parameters:
    ///   - insertCommit: Whether to create and insert a commit, and how to
    ///   insert that commit.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withPackbuilder(
        insertCommit    : CommitInsertType? = nil,
        _ body          : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var packbuilderPointer: OpaquePointer? = nil
            
            defer
            {
                gitPackbuilderFree(pb: packbuilderPointer)
            }
            
            
            
            let packbuilderNewResult: GitErrorCode = gitPackbuilderNew(
                out:    &packbuilderPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(packbuilderNewResult)
            
            guard let packbuilderPointer: OpaquePointer = packbuilderPointer
            else
            {
                XCTFail("The packbuilder pointer was nil.")
                return
            }
            
            
            
            if let insertCommit: CommitInsertType = insertCommit
            {
                let commitOID: GitOID = try repository.commit(
                    "Test content",
                    toFile:     "test.txt",
                    message:    "Test commit"
                )
                
                
                
                let packbuilderInsertResult: GitErrorCode
                
                switch insertCommit
                {
                    case .standard:
                        
                        packbuilderInsertResult = gitPackbuilderInsert(
                            pb:     packbuilderPointer,
                            id:     commitOID,
                            name:   nil
                        )
                        
                    case .recursive:
                        
                        packbuilderInsertResult = gitPackbuilderInsertRecur(
                            pb:     packbuilderPointer,
                            id:     commitOID,
                            name:   nil
                        )
                }
                
                XCTAssertOK(packbuilderInsertResult)
                
                
                
                let objectCount: Int
                    = gitPackbuilderObjectCount(pb: packbuilderPointer)
                
                XCTAssertGreaterThan(objectCount, 0)
            }
            
            
            
            try body(
                repository,
                packbuilderPointer
            )
        }
    }
}
