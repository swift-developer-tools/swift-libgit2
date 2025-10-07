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



final class CherrypickTests: XCTestCaseStopOnFail
{
    func testGitCherrypick() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let (_, featureCommitOID): (GitOID, GitOID) = try setupCherrypickScenario(in: repository)
            
            
            
            var featureCommitPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeCommit(featureCommitPointer)
            }
            
            
            
            let featureCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &featureCommitPointer,
                repo:       repository.pointer,
                id:         featureCommitOID
            )
            
            XCTAssertOK(featureCommitLookupResult)
            
            guard let featureCommitPointer: OpaquePointer = featureCommitPointer
            else
            {
                XCTFail("The feature commit pointer was nil.")
                return
            }
            
            
            
            let cherrypickResult: GitErrorCode = gitCherrypick(
                repo:               repository.pointer,
                commit:             featureCommitPointer,
                cherrypickOptions:  nil
            )
            
            XCTAssertOK(cherrypickResult)
            
            
            
            try repository.verifyFileContent(
                path:       "feature.txt",
                content:    CherrypickTests.featureBranchContent
            )
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            repository.reset(to: headOID)
            
            
            
            var checkoutOptions = GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var cherrypickOptions = GitCherrypickOptions()
            
            cherrypickOptions.mainline      = 0
            cherrypickOptions.checkoutOpts  = checkoutOptions
            
            
            
            let cherrypickWithOptionsResult: GitErrorCode = gitCherrypick(
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
    
    
    
    func testGitCherrypickCommit() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let (mainCommitOID, featureCommitOID): (GitOID, GitOID) = try setupCherrypickScenario(in: repository)
            
            
            
            var mainCommitPointer       : OpaquePointer?    = nil
            var featureCommitPointer    : OpaquePointer?    = nil
            var indexPointer            : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(mainCommitPointer)
                Free.freeCommit(featureCommitPointer)
                Free.freeIndex(indexPointer)
            }
            
            
            
            let mainCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &mainCommitPointer,
                repo:       repository.pointer,
                id:         mainCommitOID
            )
            
            XCTAssertOK(mainCommitLookupResult)
            
            guard let mainCommitPointer: OpaquePointer = mainCommitPointer
            else
            {
                XCTFail("The main commit pointer was nil.")
                return
            }
            
            
            
            let featureCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &featureCommitPointer,
                repo:       repository.pointer,
                id:         featureCommitOID
            )
            
            XCTAssertOK(featureCommitLookupResult)
            
            guard let featureCommitPointer: OpaquePointer = featureCommitPointer
            else
            {
                XCTFail("The feature commit pointer was nil.")
                return
            }
            
            
            
            let cherrypickCommitResult: GitErrorCode = gitCherrypickCommit(
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
            
            
            
            let indexEntryCountResult: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCountResult, 0)
        }
    }
    
    
    
    func testGitCherrypickOptions() throws
    {
        let cherrypickOptions = GitCherrypickOptions()
        
        XCTAssertEqual(cherrypickOptions.version, gitCherrypickOptionsVersion)
        XCTAssertEqual(cherrypickOptions.mainline, 0)
        XCTAssertNil(cherrypickOptions.mergeOpts)
        XCTAssertNil(cherrypickOptions.checkoutOpts)
        
        XCTAssertEqual(gitCherrypickOptionsVersion, UInt32(GIT_CHERRYPICK_OPTIONS_VERSION))
        
        try cherrypickOptions.withCValue
        {
            cCherrypickOptions in
            
            XCTAssertEqual(cCherrypickOptions.pointee.version, gitCherrypickOptionsVersion)
            XCTAssertEqual(cCherrypickOptions.pointee.mainline, 0)
            XCTAssertNotNil(cCherrypickOptions.pointee.merge_opts)
            XCTAssertNotNil(cCherrypickOptions.pointee.checkout_opts)
        }
    }
}



// MARK: - Extensions

extension CherrypickTests
{
    private static let mainBranchContent    : String    = "Main branch feature\nHello World\n"
    private static let featureBranchContent : String    = "Feature branch change\nHello World\nGoodbye World\n"
    
    
    
    /// Creates a repository with branches suitable for cherry-picking.
    /// - Parameter repository: The repository in which to create the branches.
    /// - Returns: A tuple containing the main branch commit and the feature branch commit.
    private func setupCherrypickScenario(
        in repository: Repository
    ) throws -> (GitOID, GitOID)
    {
        let mainCommitOID: GitOID = try repository.commit(
            CherrypickTests.mainBranchContent,
            toFile:     "feature.txt",
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
            
            let checkoutTreeResult: GitErrorCode = gitCheckoutTree(
                repo:       repository.pointer,
                treeish:    nil,
                opts:       nil
            )
            
            XCTAssertOK(checkoutTreeResult)
        }
        
        
        
        let repositorySetHEADFeatureResult: Int32 = git_repository_set_head(
            repository.pointer,
            "refs/heads/feature"
        )
        
        XCTAssertOK(GitErrorCode(rawValue: repositorySetHEADFeatureResult))
        
        
        
        let featureCommitOID: GitOID = try repository.commit(
            CherrypickTests.featureBranchContent,
            toFile:     "feature.txt",
            message:    "Add feature branch changes"
        )
        
        
        
        let headOID             : GitOID            = OID.getHEADCommitOID(in: repository)
        var headCommitPointer   : OpaquePointer?    = nil
        var branchPointer       : OpaquePointer?    = nil
        
        defer
        {
            Free.freeCommit(headCommitPointer)
            Free.freeReference(branchPointer)
        }
        
        
        
        let commitLookupResult: GitErrorCode = gitCommitLookup(
            commit:     &headCommitPointer,
            repo:       repository.pointer,
            id:         headOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        
        
        let repositoryHEADResult: Int32 = git_repository_head(
            &branchPointer,
            repository.pointer
        )
        
        XCTAssertOK(GitErrorCode(rawValue: repositoryHEADResult))
        
        
        
        guard let referenceName: UnsafePointer<CChar> = git_reference_name(branchPointer)
        else
        {
            XCTFail("The branch name was nil.")
            
            throw NSError.makeError(
                code:       Int(GitErrorCode.gitEUser.rawValue),
                message:    "The branch name was nil."
            )
        }
        
        
        
        let repositorySetHEADResult: Int32 = git_repository_set_head(
            repository.pointer,
            referenceName
        )
        
        XCTAssertOK(GitErrorCode(rawValue: repositorySetHEADResult))
        
        
        
        return (mainCommitOID, featureCommitOID)
    }
}
