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



final class CherrypickTests: XCTestCaseStopOnFail
{
    // MARK: - testGitCherrypick()
    
    func testGitCherrypick() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var (_, featureCommitOID): (git_oid, git_oid) = try setupCherrypickScenario(in: repository)
            
            
            
            var featureCommitPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeCommit(&featureCommitPointer)
            }
            
            
            
            let featureCommitLookupResult: Int32 = git_commit_lookup(
                &featureCommitPointer,
                repository.pointer,
                &featureCommitOID
            )
            
            XCTAssertOK(featureCommitLookupResult)
            
            guard let featureCommitPointer: OpaquePointer = featureCommitPointer
            else
            {
                XCTFail("The feature commit pointer was nil.")
                return
            }
            
            
            
            let cherrypickResult: Int32 = gitCherrypick(
                repo:               repository.pointer,
                commit:             featureCommitPointer,
                cherrypickOptions:  nil
            )
            
            XCTAssertOK(cherrypickResult)
            
            
            
            try repository.verifyFileContent(
                path:       "feature.txt",
                content:    CherrypickTests.featureBranchContent
            )
            
            
            
            var headOID: git_oid = OID.getHEADCommitOID(in: repository)
            
            repository.resetToCommit(
                commitOID:  &headOID,
                resetType:  GIT_RESET_HARD
            )
            
            
            
            var checkoutOptions = try GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var cherrypickOptions = try GitCherrypickOptions()
            
            cherrypickOptions.mainline      = 0
            cherrypickOptions.checkoutOpts  = checkoutOptions
            
            
            
            let cherrypickWithOptionsResult: Int32 = gitCherrypick(
                repo:               repository.pointer,
                commit:             featureCommitPointer,
                cherrypickOptions:  cherrypickOptions
            )
            
            XCTAssertOK(cherrypickWithOptionsResult)
            
            
            
            try repository.verifyFileContent(
                path:       "feature.txt",
                content:    CherrypickTests.featureBranchContent
            )
        }
    }
    
    
    
    // MARK: - testGitCherrypickCommit()
    
    func testGitCherrypickCommit() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var (mainCommitOID, featureCommitOID): (git_oid, git_oid) = try setupCherrypickScenario(in: repository)
            
            
            
            var mainCommitPointer       : OpaquePointer?    = nil
            var featureCommitPointer    : OpaquePointer?    = nil
            var indexPointer            : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(&mainCommitPointer)
                Free.freeCommit(&featureCommitPointer)
                Free.freeIndex(&indexPointer)
            }
            
            
            
            let mainCommitLookupResult: Int32 = git_commit_lookup(
                &mainCommitPointer,
                repository.pointer,
                &mainCommitOID
            )
            
            XCTAssertOK(mainCommitLookupResult)
            
            guard let mainCommitPointer: OpaquePointer = mainCommitPointer
            else
            {
                XCTFail("The main commit pointer was nil.")
                return
            }
            
            
            
            let featureCommitLookupResult: Int32 = git_commit_lookup(
                &featureCommitPointer,
                repository.pointer,
                &featureCommitOID
            )
            
            XCTAssertOK(featureCommitLookupResult)
            
            guard let featureCommitPointer: OpaquePointer = featureCommitPointer
            else
            {
                XCTFail("The feature commit pointer was nil.")
                return
            }
            
            
            
            let cherrypickCommitResult: Int32 = gitCherrypickCommit(
                out:                &indexPointer,
                repo:               repository.pointer,
                cherrypickCommit:   featureCommitPointer,
                ourCommit:          mainCommitPointer,
                mainline:           0,
                mergeOptions:       nil
            )
            
            XCTAssertOK(cherrypickCommitResult)
            
            guard let indexPointer: OpaquePointer = indexPointer
            else
            {
                XCTFail("The index pointer was nil.")
                return
            }
            
            
            
            let indexEntryCountResult: Int = git_index_entrycount(indexPointer)
            
            XCTAssertGreaterThan(indexEntryCountResult, 0)
        }
    }
    
    
    
    // MARK: - testGitCherrypickOptions()
    
    func testGitCherrypickOptions() throws
    {
        var cherrypickOptions = try GitCherrypickOptions()
        
        XCTAssertEqual(cherrypickOptions.version, gitCherrypickOptionsVersion)
        XCTAssertEqual(cherrypickOptions.mainline, 0)
        XCTAssertNotNil(cherrypickOptions.mergeOpts)
        XCTAssertNotNil(cherrypickOptions.checkoutOpts)
        
        XCTAssertEqual(gitCherrypickOptionsVersion, UInt32(GIT_CHERRYPICK_OPTIONS_VERSION))
        
        
        
        cherrypickOptions.mainline = 123
        
        XCTAssertEqual(cherrypickOptions.mainline, 123)
    }
}



extension CherrypickTests
{
    private static let mainBranchContent    : String    = "Main branch feature\nHello World\n"
    private static let featureBranchContent : String    = "Feature branch change\nHello World\nGoodbye World\n"
    
    
    
    // MARK: - setupCherrypickScenario()
    
    /// Creates a repository with branches suitable for cherry-picking.
    /// - Parameter repository: The repository in which to create the branches.
    /// - Returns: A tuple containing the main branch commit and the feature branch commit.
    private func setupCherrypickScenario(
        in repository: Repository
    ) throws -> (git_oid, git_oid)
    {
        let mainCommitOID: git_oid = try repository.createCommit(
            path:       "feature.txt",
            content:    CherrypickTests.mainBranchContent,
            message:    "Add feature on main branch"
        )
        
        
        
        try Branch.withNewLocalBranchPointer(
            named:      "feature",
            in:         repository,
            force:      false,
            annotated:  false
        )
        {
            branchPointer in
            
            let checkoutTreeResult: Int32 = git_checkout_tree(
                repository.pointer,
                nil,
                nil
            )
            
            XCTAssertOK(checkoutTreeResult)
        }
        
        
        
        let repositorySetHEADFeatureResult: Int32 = git_repository_set_head(
            repository.pointer,
            "refs/heads/feature"
        )
        
        XCTAssertOK(repositorySetHEADFeatureResult)
        
        
        
        let featureCommitOID: git_oid = try repository.createCommit(
            path:       "feature.txt",
            content:    CherrypickTests.featureBranchContent,
            message:    "Add feature branch changes"
        )
        
        
        
        var headOID: git_oid = OID.getHEADCommitOID(in: repository)
        
        var headCommitPointer   : OpaquePointer?    = nil
        var branchPointer       : OpaquePointer?    = nil
        
        defer
        {
            Free.freeCommit(&headCommitPointer)
            Free.freeReference(&branchPointer)
        }
        
        
        
        let commitLookupResult: Int32 = git_commit_lookup(
            &headCommitPointer,
            repository.pointer,
            &headOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        
        
        let repositoryHEADResult: Int32 = git_repository_head(
            &branchPointer,
            repository.pointer
        )
        
        XCTAssertOK(repositoryHEADResult)
        
        
        
        guard let referenceNameResult: UnsafePointer<CChar> = git_reference_name(branchPointer)
        else
        {
            XCTFail("The branch name was nil.")
            
            throw NSError(
                domain:     "CherrypickTests.\(#function)",
                code:       Int(GIT_EUSER.rawValue),
                userInfo:   nil
            )
        }
        
        
        
        let repositorySetHEADResult: Int32 = git_repository_set_head(
            repository.pointer,
            referenceNameResult
        )
        
        XCTAssertOK(repositorySetHEADResult)
        
        
        
        return (mainCommitOID, featureCommitOID)
    }
}
