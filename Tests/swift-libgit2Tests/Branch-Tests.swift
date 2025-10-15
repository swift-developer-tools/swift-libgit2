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



final class BranchTests: XCTestCaseStopOnFail
{
    func testGitBranchIsValid() throws
    {
        var isValid: Bool = false
        
        var branchIsValidResult: GitErrorCode = gitBranchIsValid(
            valid:  &isValid,
            name:   "feature/hello-world"
        )
        
        XCTAssertOK(branchIsValidResult)
        XCTAssertTrue(isValid)
        
        
        
        let invalidBranchNames: [String] =
        [
            "-feature/hello-world",
            "feature/hello~world",
            "feature/hello^world",
            "feature:hello-world",
            "feature/hello-world?",
            "[feature]-hello-world",
            "feature*hello-world",
            "feature..hello-world",
            "feature...hello-world",
            "feature@{hello-world"
        ]
        
        for invalidBranchName in invalidBranchNames
        {
            isValid = false
            
            branchIsValidResult = gitBranchIsValid(
                valid:  &isValid,
                name:   invalidBranchName
            )
            
            XCTAssertOK(branchIsValidResult)
            XCTAssertFalse(isValid)
        }
    }
    
    
    
    func testGitBranchIteratorFree() throws
    {
        gitBranchIteratorFree(iter: nil)
    }
    
    
    
    func testGitBranchOperationsAndIteration() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let branchName: String = "feature/hello-world"
            
            
            
            try Branch.withNewLocalBranchPointer(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false
            )
            {
                branchPointer in
                
                guard let branchPointer: OpaquePointer = branchPointer
                else
                {
                    XCTFail("The branch pointer was nil.")
                    return
                }
                
                
                
                var movedBranchPointer: OpaquePointer? = nil
                
                defer
                {
                    Free.freeReference(movedBranchPointer)
                }
                
                
                
                let branchMoveResult: GitErrorCode = gitBranchMove(
                    out:            &movedBranchPointer,
                    branch:         branchPointer,
                    newBranchName:  "feature/goodbye-world",
                    force:          false
                )
                
                XCTAssertOK(branchMoveResult)
                
                guard let movedBranchPointer: OpaquePointer = movedBranchPointer
                else
                {
                    XCTFail("The moved branch pointer was nil.")
                    return
                }
                
                
                
                let branchDeleteResult: GitErrorCode
                    = gitBranchDelete(branch: movedBranchPointer)
                
                XCTAssertOK(branchDeleteResult)
            }
            
            
            
            /// Create the branch named `branchName` again, with `force`
            /// specified, and this time create it from an annotated commit.
            try Branch.createLocalBranch(
                named:      branchName,
                in:         repository,
                force:      true,
                annotated:  true,
                free:       true
            )
            
            
            
            Branch.withExistingLocalBranchPointer(
                named:  branchName,
                in:     repository
            )
            {
                branchPointer in
                
                var branchIteratorPointer: OpaquePointer? = nil
                
                defer
                {
                    gitBranchIteratorFree(iter: branchIteratorPointer)
                }
                
                
                
                let branchIteratorNewResult: GitErrorCode
                    = gitBranchIteratorNew(
                        out:        &branchIteratorPointer,
                        repo:       repository.pointer,
                        listFlags:  GitBranchT.gitBranchLocal
                    )
                
                XCTAssertOK(branchIteratorNewResult)
                
                guard let branchIteratorPointer: OpaquePointer
                        = branchIteratorPointer
                else
                {
                    XCTFail("The branch iterator pointer was nil.")
                    return
                }
                
                
                
                var branchCount : Int           = 0
                var branchType  : GitBranchT    = .gitBranchLocal
                
                while true
                {
                    let branchNextResult: GitErrorCode = gitBranchNext(
                        out:        &branchPointer,
                        outType:    &branchType,
                        iter:       branchIteratorPointer
                    )
                    
                    if branchNextResult == .gitIterOver
                    {
                        break
                    }
                    
                    XCTAssertOK(branchNextResult)
                    XCTAssertNotNil(branchPointer)
                    XCTAssertEqual(branchType, GitBranchT.gitBranchLocal)
                    
                    branchCount += 1
                }
                
                /// The iterator should have found the `main` branch and the
                /// feature branch. The moved branch has been deleted by now.
                XCTAssertEqual(branchCount, 2)
            }
        }
    }
    
    
    
    func testGitBranchProperties() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let branchName: String = "feature/hello-world"
            
            
            
            try Branch.withNewLocalBranchPointer(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false
            )
            {
                branchPointer in
                
                guard let branchPointer: OpaquePointer = branchPointer
                else
                {
                    XCTFail("The branch pointer was nil.")
                    return
                }
                
                
                
                var branchNamePointer: UnsafePointer<CChar>? = nil
                
                let branchNameResult: GitErrorCode = gitBranchName(
                    out:    &branchNamePointer,
                    ref:    branchPointer
                )
                
                XCTAssertOK(branchNameResult)
                
                guard let branchNamePointer: UnsafePointer<CChar>
                        = branchNamePointer
                else
                {
                    XCTFail("The branch name pointer was nil.")
                    return
                }
                
                guard let branchNameString
                        = String(optionalCString: branchNamePointer)
                else
                {
                    XCTFail("The branch name string was nil.")
                    return
                }
                
                XCTAssertEqual(branchNameString, branchName)
                
                
                
                guard let branchIsHEADResult: Bool
                        = gitBranchIsHEAD(branch: branchPointer)
                else
                {
                    XCTFail("The branch-is-HEAD result was nil.")
                    return
                }
                
                XCTAssertFalse(branchIsHEADResult)
                
                
                
                guard let branchIsCheckedOutResult: Bool
                        = gitBranchIsCheckedOut(branch: branchPointer)
                else
                {
                    XCTFail("The branch-is-checked-out result was nil.")
                    return
                }
                
                XCTAssertFalse(branchIsCheckedOutResult)
                
                
                
                var upstreamPointer: OpaquePointer? = nil
                
                defer
                {
                    Free.freeReference(upstreamPointer)
                }
                
                
                
                let branchUpstreamResult: GitErrorCode = gitBranchUpstream(
                    out:    &upstreamPointer,
                    ref:    branchPointer
                )
                
                /// The operation should fail since there is no configured
                /// upstream.
                XCTAssertNotOK(branchUpstreamResult)
                
                
                
                let branchSetUpstreamResult: GitErrorCode
                    = gitBranchSetUpstream(
                        branch:         branchPointer,
                        branchName:     "origin/main"
                    )
                
                /// The operation should fail since there is no configured
                /// remote.
                XCTAssertNotOK(branchSetUpstreamResult)
            }
        }
    }
    
    
    
    func testGitBranchRemoteOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let referenceName: String = "refs/heads/main"
            
            
            
            var data = Data()
            
            let branchRemoteNameResult: GitErrorCode = gitBranchRemoteName(
                out:        &data,
                repo:       repository.pointer,
                refName:    referenceName
            )
            
            /// The operation should fail since there the reference is a
            /// local branch.
            XCTAssertNotOK(branchRemoteNameResult)
            
            
            
            let branchUpstreamRemoteResult: GitErrorCode
                = gitBranchUpstreamRemote(
                    buf:        &data,
                    repo:       repository.pointer,
                    refName:    referenceName
                )
            
            /// The operation should fail since there is no configured upstream.
            XCTAssertNotOK(branchUpstreamRemoteResult)
            
            
            
            let branchUpstreamMergeResult: GitErrorCode
                = gitBranchUpstreamMerge(
                    buf:        &data,
                    repo:       repository.pointer,
                    refName:    referenceName
                )
            
            /// The operation should fail since there is no configured upstream.
            XCTAssertNotOK(branchUpstreamMergeResult)
            
            
            
            let branchUpstreamNameResult: GitErrorCode = gitBranchUpstreamName(
                out:        &data,
                repo:       repository.pointer,
                refName:    referenceName
            )
            
            /// The operation should fail since there is no configured upstream.
            XCTAssertNotOK(branchUpstreamNameResult)
        }
    }
    
    
    
    func testGitBranchT() throws
    {
        XCTAssertEqual(GitBranchT.gitBranchLocal.rawValue, GIT_BRANCH_LOCAL.rawValue)
        XCTAssertEqual(GitBranchT.gitBranchRemote.rawValue, GIT_BRANCH_REMOTE.rawValue)
        XCTAssertEqual(GitBranchT.gitBranchAll.rawValue, GIT_BRANCH_ALL.rawValue)
        XCTAssertNil(GitBranchT(rawValue: 123))
        
        XCTAssertEqual(GitBranchT.gitBranchLocal.cValue(), GIT_BRANCH_LOCAL)
        XCTAssertEqual(GitBranchT.gitBranchRemote.cValue(), GIT_BRANCH_REMOTE)
        XCTAssertEqual(GitBranchT.gitBranchAll.cValue(), GIT_BRANCH_ALL)
        
        XCTAssertEqual(GitBranchT(cValue: GIT_BRANCH_LOCAL), .gitBranchLocal)
        XCTAssertEqual(GitBranchT(cValue: GIT_BRANCH_REMOTE), .gitBranchRemote)
        XCTAssertEqual(GitBranchT(cValue: GIT_BRANCH_ALL), .gitBranchAll)
        
        let allBranches: GitBranchT? = GitBranchT(rawValue:
            GIT_BRANCH_LOCAL.rawValue
            | GIT_BRANCH_REMOTE.rawValue
        )
        
        XCTAssertNotNil(allBranches)
        XCTAssertEqual(allBranches?.rawValue, GIT_BRANCH_ALL.rawValue)
    }
}
