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
            
            
            
            let isThirdDescendantOfFirst: Bool? = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     thirdCommitOID,
                ancestor:   firstCommitOID
            )
            
            guard let isThirdDescendantOfFirst: Bool = isThirdDescendantOfFirst
            else
            {
                XCTFail("The third vs. first descendant result was nil.")
                return
            }
            
            XCTAssertTrue(isThirdDescendantOfFirst)
            
            
            
            let isThirdDescendantOfSecond: Bool? = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     thirdCommitOID,
                ancestor:   secondCommitOID
            )
            
            guard let isThirdDescendantOfSecond: Bool = isThirdDescendantOfSecond
            else
            {
                XCTFail("The third vs. second descendant result was nil.")
                return
            }
            
            XCTAssertTrue(isThirdDescendantOfSecond)
            
            
            
            let isFirstDescendantOfThird: Bool? = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     firstCommitOID,
                ancestor:   thirdCommitOID
            )
            
            guard let isFirstDescendantOfThird: Bool = isFirstDescendantOfThird
            else
            {
                XCTFail("The first vs. third descendant result was nil.")
                return
            }
            
            XCTAssertFalse(isFirstDescendantOfThird)
            
            
            
            let isFirstDescendantOfFirst: Bool? = gitGraphDescendantOf(
                repo:       repository.pointer,
                commit:     firstCommitOID,
                ancestor:   firstCommitOID
            )
            
            guard let isFirstDescendantOfFirst: Bool = isFirstDescendantOfFirst
            else
            {
                XCTFail("The first vs. first descendant result was nil.")
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
            
            
            
            let isBaseReachable: Bool? = gitGraphReachableFromAny(
                repo            : repository.pointer,
                commit          : baseCommitOID,
                descendantArray : [firstCommitOID, secondCommitOID, thirdCommitOID],
                length          : 3
            )
            
            guard let isBaseReachable: Bool = isBaseReachable
            else
            {
                XCTFail("The base-reachable result was nil.")
                return
            }
            
            XCTAssertTrue(isBaseReachable)
            
            
            
            let isFirstReachable: Bool? = gitGraphReachableFromAny(
                repo            : repository.pointer,
                commit          : firstCommitOID,
                descendantArray : [secondCommitOID, thirdCommitOID],
                length          : 2
            )
            
            guard let isFirstReachable: Bool = isFirstReachable
            else
            {
                XCTFail("The first-reachable result was nil.")
                return
            }
            
            XCTAssertFalse(isFirstReachable)
            
            
            
            let emptyArrayResult: Bool? = gitGraphReachableFromAny(
                repo            : repository.pointer,
                commit          : baseCommitOID,
                descendantArray : [],
                length          : 0
            )
            
            guard let emptyArrayResult: Bool = emptyArrayResult
            else
            {
                XCTFail("The empty array result was nil.")
                return
            }
            
            XCTAssertFalse(emptyArrayResult)
        }
    }
}
