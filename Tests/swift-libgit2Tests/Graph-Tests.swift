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



final class GraphTests: XCTestCaseStopOnFail
{
    func testGitGraphAheadBehind() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let baseCommitOID: GitOID = try repository.commit(
                "Base content",
                toFile:     "base.txt",
                message:    "Base commit"
            )
            
            let firstCommitOID: GitOID = try repository.commit(
                "Branch1 content",
                toFile:     "branch1.txt",
                message:    "Branch1 commit"
            )
            
            
            
            repository.reset(to: baseCommitOID)
            
            
            
            let secondCommitOID: GitOID = try repository.commit(
                "Branch2 content",
                toFile:     "branch2.txt",
                message:    "Branch2 commit"
            )
            
            try repository.commit(
                "Branch2 second content",
                toFile:     "branch2-second.txt",
                message:    "Branch2 second commit"
            )
            
            
            
            var ahead   : Int   = 0
            var behind  : Int   = 0
            
            let aheadBehindResult: GitErrorCode = gitGraphAheadBehind(
                ahead:      &ahead,
                behind:     &behind,
                repo:       repository.pointer,
                local:      firstCommitOID,
                upstream:   secondCommitOID
            )
            
            XCTAssertOK(aheadBehindResult)
            XCTAssertEqual(ahead, 1)
            XCTAssertEqual(behind, 1)
        }
    }
    
    
    
    func testGitGraphDescendantOf() throws
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
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Third content",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            
            
            guard let isThirdDescendantOfFirst: Bool = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     thirdCommitOID,
                ancestor:   firstCommitOID
            )
            else
            {
                XCTFail("The isThirdDescendantOfFirst boolean was nil.")
                return
            }
            
            XCTAssertTrue(isThirdDescendantOfFirst)
            
            
            
            guard let isThirdDescendantOfSecond: Bool = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     thirdCommitOID,
                ancestor:   secondCommitOID
            )
            else
            {
                XCTFail("The isThirdDescendantOfSecond boolean was nil.")
                return
            }
            
            XCTAssertTrue(isThirdDescendantOfSecond)
            
            
            
            guard let isFirstDescendantOfThird: Bool = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     firstCommitOID,
                ancestor:   thirdCommitOID
            )
            else
            {
                XCTFail("The isFirstDescendantOfThird boolean was nil.")
                return
            }
            
            XCTAssertFalse(isFirstDescendantOfThird)
            
            
            
            guard let isFirstDescendantOfFirst: Bool = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     firstCommitOID,
                ancestor:   firstCommitOID
            )
            else
            {
                XCTFail("The isFirstDescendantOfFirst boolean was nil.")
                return
            }
            
            XCTAssertFalse(isFirstDescendantOfFirst)
        }
    }
    
    
    
    func testGitGraphReachableFromAny() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let baseCommitOID: GitOID = try repository.commit(
                "Base content",
                toFile:     "base.txt",
                message:    "Base commit"
            )
            
            let firstCommitOID: GitOID = try repository.commit(
                "Branch1 content",
                toFile:     "branch1.txt",
                message:    "Branch1 commit"
            )
            
            
            
            repository.reset(to: baseCommitOID)
            
            
            
            let secondCommitOID: GitOID = try repository.commit(
                "Branch2 content",
                toFile:     "branch2.txt",
                message:    "Branch2 commit"
            )
            
            
            
            repository.reset(to: baseCommitOID)
            
            
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Branch3 content",
                toFile:     "branch3.txt",
                message:    "Branch3 commit"
            )
            
            
            
            let descendantArray: [GitOID] =
            [
                firstCommitOID,
                secondCommitOID,
                thirdCommitOID
            ]
            
            
            
            guard let isBaseReachable: Bool = gitGraphReachableFromAny(
                repo            : repository.pointer,
                commit          : baseCommitOID,
                descendantArray : descendantArray,
                length          : 3
            )
            else
            {
                XCTFail("The isBaseReachable boolean was nil.")
                return
            }
            
            XCTAssertTrue(isBaseReachable)
            
            
            
            guard let isFirstReachable: Bool = gitGraphReachableFromAny(
                repo            : repository.pointer,
                commit          : firstCommitOID,
                descendantArray : [secondCommitOID, thirdCommitOID],
                length          : 2
            )
            else
            {
                XCTFail("The isFirstReachable boolean was nil.")
                return
            }
            
            XCTAssertFalse(isFirstReachable)
            
            
            
            guard let isEmptyReachableFromAny: Bool = gitGraphReachableFromAny(
                repo            : repository.pointer,
                commit          : baseCommitOID,
                descendantArray : [],
                length          : 0
            )
            else
            {
                XCTFail("The isEmptyReachableFromAny boolean was nil.")
                return
            }
            
            XCTAssertFalse(isEmptyReachableFromAny)
        }
    }
}
