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



final class RevwalkTests: XCTestCaseStopOnFail
{
    func testGitRevwalkAddHideCB() throws
    {
        try testAddHideCBFlow(unset: false)
    }
    
    
    
    func testGitRevwalkAddHideCBUnset() throws
    {
        try testAddHideCBFlow(unset: true)
    }
    
    
    
    func testGitRevwalkFree() throws
    {
        gitRevwalkFree(walk: nil)
    }
    
    
    
    func testGitRevwalkHide() throws
    {
        try withRevwalk
        {
            repository, revwalkPointer in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            let revwalkHideResult: GitErrorCode = gitRevwalkHide(
                walk:       revwalkPointer,
                commitID:   firstCommitOID
            )
            
            XCTAssertOK(revwalkHideResult)
            
            
            
            var commitOIDs  : [GitOID]  = []
            var nextOID     : GitOID    = GitOID()
            
            while true
            {
                let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                    out:    &nextOID,
                    walk:   revwalkPointer
                )
                
                if revwalkNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(revwalkNextResult)
                XCTAssertNotZeroOID(nextOID)
                
                commitOIDs.append(nextOID)
            }
            
            XCTAssertEqual(commitOIDs.count, 0)
        }
    }
    
    
    
    func testGitRevwalkHideGlob() throws
    {
        try withRevwalk(push: false)
        {
            repository, revwalkPointer in
            
            try Branch.createLocalBranch(
                named:      "hide-branch",
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let revwalkPushHEADResult: GitErrorCode
                = gitRevwalkPushHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkPushHEADResult)
            
            
            
            let revwalkHideGlobResult: GitErrorCode = gitRevwalkHideGlob(
                walk:   revwalkPointer,
                glob:   "refs/heads/hide-*"
            )
            
            XCTAssertOK(revwalkHideGlobResult)
            
            
            
            var nextOID: GitOID = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertEqual(revwalkNextResult, .gitIterOver)
            XCTAssertZeroOID(nextOID)
        }
    }
    
    
    
    func testGitRevwalkHideHEAD() throws
    {
        try withRevwalk
        {
            _, revwalkPointer in
            
            let revwalkHideHEADResult: GitErrorCode
                = gitRevwalkHideHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkHideHEADResult)
            
            
            
            var nextOID: GitOID = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertEqual(revwalkNextResult, .gitIterOver)
            XCTAssertZeroOID(nextOID)
        }
    }
    
    
    
    func testGitRevwalkHideRef() throws
    {
        try withRevwalk(push: false)
        {
            _, revwalkPointer in
            
            let revwalkPushHEADResult: GitErrorCode
                = gitRevwalkPushHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkPushHEADResult)
            
            
            
            let revwalkHideHEADResult: GitErrorCode
                = gitRevwalkHideHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkHideHEADResult)
            
            
            
            var nextOID: GitOID = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertEqual(revwalkNextResult, .gitIterOver)
            XCTAssertZeroOID(nextOID)
        }
    }
    
    
    
    func testGitRevwalkNew() throws
    {
        try withRevwalk
        {
            _, _ in
        }
    }
    
    
    
    func testGitRevwalkPushAndNext() throws
    {
        try withRevwalk
        {
            repository, revwalkPointer in
            
            let headOID : GitOID    = OID.getHEADCommitOID(in: repository)
            var nextOID : GitOID    = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertOK(revwalkNextResult)
            XCTAssertNotZeroOID(nextOID)
            XCTAssertEqual(nextOID, headOID)
        }
    }
    
    
    
    func testGitRevwalkPushGlob() throws
    {
        try withRevwalk(push: false)
        {
            repository, revwalkPointer in
            
            try Branch.createLocalBranch(
                named:      "feature",
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let revwalkPushGlobResult: GitErrorCode = gitRevwalkPushGlob(
                walk:   revwalkPointer,
                glob:   "refs/heads/*"
            )
            
            XCTAssertOK(revwalkPushGlobResult)
            
            
            
            var commitOIDs  : [GitOID]  = []
            var nextOID     : GitOID    = GitOID()
            
            while true
            {
                let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                    out:    &nextOID,
                    walk:   revwalkPointer
                )
                
                if revwalkNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(revwalkNextResult)
                XCTAssertNotZeroOID(nextOID)
                
                commitOIDs.append(nextOID)
            }
            
            XCTAssertGreaterThan(commitOIDs.count, 0)
        }
    }
    
    
    
    func testGitRevwalkPushHEAD() throws
    {
        try withRevwalk(push: false)
        {
            _, revwalkPointer in
            
            let revwalkPushHEADResult: GitErrorCode
                = gitRevwalkPushHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkPushHEADResult)
            
            
            
            var nextOID: GitOID = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertOK(revwalkNextResult)
            XCTAssertNotZeroOID(nextOID)
        }
    }
    
    
    
    func testGitRevwalkPushRange() throws
    {
        try withRevwalk(push: false)
        {
            repository, revwalkPointer in
            
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
            
            guard let firstCommitOIDString: String
                    = gitOIDToStrS(oid: firstCommitOID)
            else
            {
                XCTFail("The first commit OID string was nil.")
                return
            }
            
            guard let secondCommitOIDString: String
                    = gitOIDToStrS(oid: secondCommitOID)
            else
            {
                XCTFail("The second commit OID string was nil.")
                return
            }
            
            
            
            let revwalkPushRangeResult: GitErrorCode = gitRevwalkPushRange(
                walk:   revwalkPointer,
                range:  "\(firstCommitOIDString)..\(secondCommitOIDString)"
            )
            
            XCTAssertOK(revwalkPushRangeResult)
            
            
            
            var commitOIDs  : [GitOID]  = []
            var nextOID     : GitOID    = GitOID()
            
            while true
            {
                let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                    out:    &nextOID,
                    walk:   revwalkPointer
                )
                
                if revwalkNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(revwalkNextResult)
                XCTAssertNotZeroOID(nextOID)
                
                commitOIDs.append(nextOID)
            }
            
            XCTAssertEqual(commitOIDs.count, 1)
            XCTAssertEqual(commitOIDs.first, secondCommitOID)
        }
    }
    
    
    
    func testGitRevwalkPushRef() throws
    {
        try withRevwalk(push: false)
        {
            _, revwalkPointer in
            
            let revwalkPushRefResult: GitErrorCode
                = gitRevwalkPushRef(
                    walk:   revwalkPointer,
                    refName:    "HEAD"
                )
            
            XCTAssertOK(revwalkPushRefResult)
            
            
            
            var nextOID: GitOID = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertOK(revwalkNextResult)
            XCTAssertNotZeroOID(nextOID)
        }
    }
    
    
    
    func testGitRevwalkRepository() throws
    {
        try withRevwalk
        {
            repository, revwalkPointer in
            
            let revwalkRepo: OpaquePointer
                = gitRevwalkRepository(walk: revwalkPointer)
            
            XCTAssertEqual(revwalkRepo, repository.pointer)
        }
    }
    
    
    
    func testGitRevwalkReset() throws
    {
        try withRevwalk
        {
            _, revwalkPointer in
            
            let revwalkResetResult: GitErrorCode
                = gitRevwalkReset(walker: revwalkPointer)
            
            XCTAssertOK(revwalkResetResult)
            
            
            
            var nextOID: GitOID = GitOID()
            
            let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                out:    &nextOID,
                walk:   revwalkPointer
            )
            
            XCTAssertEqual(revwalkNextResult, .gitIterOver)
            XCTAssertZeroOID(nextOID)
        }
    }
    
    
    
    func testGitRevwalkSimplifyFirstParent() throws
    {
        try withRevwalk
        {
            _, revwalkPointer in
            
            let revwalkSimplifyFirstParentResult: GitErrorCode
                = gitRevwalkSimplifyFirstParent(walk: revwalkPointer)
            
            XCTAssertOK(revwalkSimplifyFirstParentResult)
            
            
            
            var commitOIDs  : [GitOID]  = []
            var nextOID     : GitOID    = GitOID()
            
            while true
            {
                let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                    out:    &nextOID,
                    walk:   revwalkPointer
                )
                
                if revwalkNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(revwalkNextResult)
                XCTAssertNotZeroOID(nextOID)
                
                commitOIDs.append(nextOID)
            }
            
            XCTAssertGreaterThan(commitOIDs.count, 0)
        }
    }
    
    
    
    func testGitRevwalkSorting() throws
    {
        try withRevwalk
        {
            _, revwalkPointer in
            
            let revwalkSortingResult: GitErrorCode = gitRevwalkSorting(
                walk:       revwalkPointer,
                sortMode:   [.gitSortTime, .gitSortReverse]
            )
            
            XCTAssertOK(revwalkSortingResult)
            
            
            
            var commitOIDs  : [GitOID]  = []
            var nextOID     : GitOID    = GitOID()
            
            while true
            {
                let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                    out:    &nextOID,
                    walk:   revwalkPointer
                )
                
                if revwalkNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(revwalkNextResult)
                XCTAssertNotZeroOID(nextOID)
                
                commitOIDs.append(nextOID)
            }
            
            XCTAssertGreaterThan(commitOIDs.count, 0)
        }
    }
    
    
    
    func testGitSortT() throws
    {
        XCTAssertEqual(GitSortT.gitSortNone.rawValue, GIT_SORT_NONE.rawValue)
        XCTAssertEqual(GitSortT.gitSortTopological.rawValue, GIT_SORT_TOPOLOGICAL.rawValue)
        XCTAssertEqual(GitSortT.gitSortTime.rawValue, GIT_SORT_TIME.rawValue)
        XCTAssertEqual(GitSortT.gitSortReverse.rawValue, GIT_SORT_REVERSE.rawValue)
        
        XCTAssertEqual(GitSortT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitSortT.gitSortNone.cValue(), GIT_SORT_NONE)
        XCTAssertEqual(GitSortT.gitSortTopological.cValue(), GIT_SORT_TOPOLOGICAL)
        XCTAssertEqual(GitSortT.gitSortTime.cValue(), GIT_SORT_TIME)
        XCTAssertEqual(GitSortT.gitSortReverse.cValue(), GIT_SORT_REVERSE)
        
        XCTAssertEqual(GitSortT(cValue: GIT_SORT_NONE), .gitSortNone)
        XCTAssertEqual(GitSortT(cValue: GIT_SORT_TOPOLOGICAL), .gitSortTopological)
        XCTAssertEqual(GitSortT(cValue: GIT_SORT_TIME), .gitSortTime)
        XCTAssertEqual(GitSortT(cValue: GIT_SORT_REVERSE), .gitSortReverse)
        
        
        
        let flags: GitSortT =
        [
            .gitSortTopological,
            .gitSortTime
        ]
        
        XCTAssertTrue(flags.contains(.gitSortTopological))
        XCTAssertTrue(flags.contains(.gitSortTime))
        XCTAssertFalse(flags.contains(.gitSortReverse))
    }
}



// MARK: - Extensions

private extension RevwalkTests
{
    struct CallbackData
    {
        var callCount       : Int       = 0
        var hideCommitOID   : GitOID    = GitOID()
    }
    
    
    
    /// Tests revision walking, and adding and removing ``GitRevwalkHideCB``
    /// from the revision walker.
    /// - Parameter unset: Whether to unset the callback after setting it.
    /// - Throws: An error if an operation fails.
    func testAddHideCBFlow(
        unset: Bool
    ) throws
    {
        try withRevwalk(push: false)
        {
            repository, revwalkPointer in
            
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
            
            try repository.commit(
                "Third content",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            
            
            var callbackData = CallbackData()
                        
            let revwalkHideCB: GitRevwalkHideCB =
            {
                commitOID, payload in
                
                guard
                    let commitOID   : UnsafePointer<git_oid>    = commitOID,
                    let payload     : UnsafeMutableRawPointer   = payload
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                if gitOIDEqual(
                    a:  GitOID(cValue: commitOID.pointee),
                    b:  payloadPointer.pointee.hideCommitOID
                )
                {
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var revwalkAddHideCBResult: GitErrorCode
                    = gitRevwalkAddHideCB(
                        walk:       revwalkPointer,
                        hideCB:     revwalkHideCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(revwalkAddHideCBResult)
                
                
                
                if unset
                {
                    revwalkAddHideCBResult = gitRevwalkAddHideCB(
                        walk:       revwalkPointer,
                        hideCB:     nil,
                        payload:    nil
                    )
                    
                    XCTAssertOK(revwalkAddHideCBResult)
                }
                
                
                
                let revwalkPushHEADResult: GitErrorCode
                    = gitRevwalkPushHEAD(walk: revwalkPointer)
                
                XCTAssertOK(revwalkPushHEADResult)
                
                
                
                var commitOIDs  : [GitOID]  = []
                var nextOID     : GitOID    = GitOID()
                
                while true
                {
                    let revwalkNextResult: GitErrorCode = gitRevwalkNext(
                        out:    &nextOID,
                        walk:   revwalkPointer
                    )
                    
                    if revwalkNextResult == .gitIterOver
                    {
                        break
                    }
                    
                    XCTAssertOK(revwalkNextResult)
                    XCTAssertNotZeroOID(nextOID)
                    
                    commitOIDs.append(nextOID)
                }
                
                XCTAssertGreaterThanOrEqual(commitOIDs.count, 2)
                
                
                
                let containsFirstCommit: Bool = commitOIDs.contains(where:
                {
                    return gitOIDEqual(
                        a:  $0,
                        b:  firstCommitOID
                    )
                })
                
                XCTAssertTrue(containsFirstCommit)
                
                
                
                let containsSecondCommit: Bool = commitOIDs.contains(where:
                {
                    return gitOIDEqual(
                        a:  $0,
                        b:  secondCommitOID
                    )
                })
                
                XCTAssertTrue(containsSecondCommit)
            }
            
            if unset
            {
                XCTAssertEqual(callbackData.callCount, 0)
            }
            else
            {
                XCTAssertGreaterThan(callbackData.callCount, 0)
            }
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a revision walker.
    /// - Parameters:
    ///   - push: Whether to push the HEAD OID onto the revision walker.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withRevwalk(
        push    : Bool = true,
        _ body  : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
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
            
            
            
            if push
            {
                let headOID: GitOID = OID.getHEADCommitOID(in: repository)
                
                let revwalkPushResult: GitErrorCode = gitRevwalkPush(
                    walk:   revwalkPointer,
                    id:     headOID
                )
                
                XCTAssertOK(revwalkPushResult)
            }
            
            
            
            return try body(
                repository,
                revwalkPointer
            )
        }
    }
}
