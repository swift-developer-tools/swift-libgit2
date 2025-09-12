//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



final class BranchTests: XCTestCaseStopOnFail
{
    // MARK: - testGitBranchIsValid()
    
    func testGitBranchIsValid() throws
    {
        var isValid: Int32 = 0
        
        var branchIsValidResult: Int32 = gitBranchIsValid(
            valid:  &isValid,
            name:   "feature/hello-world"
        )
        
        XCTAssertOK(branchIsValidResult)
        XCTAssertEqual(isValid, 1)
        
        
        
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
            isValid = 0
            
            branchIsValidResult = gitBranchIsValid(
                valid:  &isValid,
                name:   invalidBranchName
            )
            
            XCTAssertOK(branchIsValidResult)
            XCTAssertEqual(isValid, 0)
        }
    }
    
    
    
    // MARK: - testGitBranchOperationsAndIteration()
    
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
                    Free.freeReference(&movedBranchPointer)
                }
                
                
                
                let branchMoveResult: Int32 = gitBranchMove(
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
                
                
                
                let branchDeleteResult: Int32 = gitBranchDelete(branch: movedBranchPointer)
                
                XCTAssertOK(branchDeleteResult)
            }
            
            
            
            /// Create the branch named `branchName` again, with `force` specified, and
            /// this time create it from an annotated commit. Free it automatically.
            _ = try Branch.createLocalBranch(
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
                
                
                
                let branchIteratorNewResult: Int32 = gitBranchIteratorNew(
                    out:        &branchIteratorPointer,
                    repo:       repository.pointer,
                    listFlags:  GitBranchT.gitBranchLocal
                )
                
                XCTAssertOK(branchIteratorNewResult)
                
                guard let branchIteratorPointer: OpaquePointer = branchIteratorPointer
                else
                {
                    XCTFail("The branch iterator pointer was nil.")
                    return
                }
                
                
                
                var branchCount : Int           = 0
                var branchType  : GitBranchT    = .gitBranchLocal
                
                while true
                {
                    let branchNextResult: Int32 = gitBranchNext(
                        out:        &branchPointer,
                        outType:    &branchType,
                        iter:       branchIteratorPointer
                    )
                    
                    if branchNextResult == GIT_ITEROVER.rawValue
                    {
                        break
                    }
                    
                    XCTAssertOK(branchNextResult)
                    XCTAssertNotNil(branchPointer)
                    XCTAssertEqual(branchType, GitBranchT.gitBranchLocal)
                    
                    branchCount += 1
                }
                
                /// The iterator should have found the `main` branch and the feature branch.
                /// The moved branch has been deleted by this point.
                XCTAssertEqual(branchCount, 2)
            }
        }
    }
    
    
    
    // MARK: - testGitBranchProperties()
    
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
                
                let branchNameResult: Int32 = gitBranchName(
                    out:    &branchNamePointer,
                    ref:    branchPointer
                )
                
                XCTAssertOK(branchNameResult)
                
                guard let branchNamePointer: UnsafePointer<CChar> = branchNamePointer
                else
                {
                    XCTFail("The branch name pointer was nil.")
                    return
                }
                
                XCTAssertEqual(String(cString: branchNamePointer), branchName)
                
                
                
                let branchIsHEADResult: Int32 = gitBranchIsHEAD(branch: branchPointer)
                
                XCTAssertEqual(branchIsHEADResult, 0)
                
                
                
                let branchIsCheckedOutResult: Int32 = gitBranchIsCheckedOut(branch: branchPointer)
                
                XCTAssertEqual(branchIsCheckedOutResult, 0)
                
                
                
                var upstreamPointer: OpaquePointer? = nil
                
                defer
                {
                    Free.freeReference(&upstreamPointer)
                }
                
                
                
                let branchUpstreamResult: Int32 = gitBranchUpstream(
                    out:    &upstreamPointer,
                    ref:    branchPointer
                )
                
                /// The operation should fail since there is no configured upstream.
                XCTAssertNotEqual(branchUpstreamResult, GIT_OK.rawValue)
                
                
                
                let branchSetUpstreamResult: Int32 = gitBranchSetUpstream(
                    branch:         branchPointer,
                    branchName:     "origin/main"
                )
                
                /// The operation should fail since there is no configured remote.
                XCTAssertNotEqual(branchSetUpstreamResult, GIT_OK.rawValue)
            }
        }
    }
    
    
    
    // MARK: - testGitBranchRemoteOperations()
    
    func testGitBranchRemoteOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let referenceName: String = "refs/heads/main"
            
            
            
            var buffer = GitBuf()
            
            defer
            {
                gitBufDispose(buffer: &buffer)
            }
            
            
            
            let branchRemoteNameResult: Int32 = gitBranchRemoteName(
                out:        &buffer,
                repo:       repository.pointer,
                refName:    referenceName
            )
            
            /// The operation should fail since there the reference is a local branch.
            XCTAssertNotEqual(branchRemoteNameResult, GIT_OK.rawValue)
            
            
            
            let branchUpstreamRemoteResult: Int32 = gitBranchUpstreamRemote(
                buf:        &buffer,
                repo:       repository.pointer,
                refName:    referenceName
            )
            
            /// The operation should fail since there is no configured upstream.
            XCTAssertNotEqual(branchUpstreamRemoteResult, GIT_OK.rawValue)
            
            
            
            let branchUpstreamMergeResult: Int32 = gitBranchUpstreamMerge(
                buf:        &buffer,
                repo:       repository.pointer,
                refName:    referenceName
            )
            
            /// The operation should fail since there is no configured upstream.
            XCTAssertNotEqual(branchUpstreamMergeResult, GIT_OK.rawValue)
            
            
            
            let branchUpstreamNameResult: Int32 = gitBranchUpstreamName(
                out:        &buffer,
                repo:       repository.pointer,
                refName:    referenceName
            )
            
            /// The operation should fail since there is no configured upstream.
            XCTAssertNotEqual(branchUpstreamNameResult, GIT_OK.rawValue)
        }
    }
    
    
    
    // MARK: - testGitBranchT()
    
    func testGitBranchT() throws
    {
        XCTAssertEqual(GitBranchT.gitBranchLocal.rawValue, GIT_BRANCH_LOCAL.rawValue)
        XCTAssertEqual(GitBranchT.gitBranchRemote.rawValue, GIT_BRANCH_REMOTE.rawValue)
        XCTAssertEqual(GitBranchT.gitBranchAll.rawValue, GIT_BRANCH_ALL.rawValue)
        XCTAssertNil(GitBranchT(rawValue: 123))
        
        XCTAssertEqual(GitBranchT.gitBranchLocal.cValue, GIT_BRANCH_LOCAL)
        XCTAssertEqual(GitBranchT.gitBranchRemote.cValue, GIT_BRANCH_REMOTE)
        XCTAssertEqual(GitBranchT.gitBranchAll.cValue, GIT_BRANCH_ALL)
        
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
