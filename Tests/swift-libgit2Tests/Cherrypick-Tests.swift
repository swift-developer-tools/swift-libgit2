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
            
            let (_, featureCommitOID): (GitOID, GitOID)
                = try setupCherrypickScenario(in: repository)
            
            
            
            var featureCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitCommitFree(commit: featureCommitPointer)
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
            
            
            
            try repository.assertFileContent(
                at:         "feature.txt",
                equals:     CherrypickTests.featureBranchContent
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
            
            
            
            try repository.assertFileContent(
                at:         "feature.txt",
                equals:     CherrypickTests.featureBranchContent
            )
        }
    }
    
    
    
    func testGitCherrypickCommit() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let (mainCommitOID, featureCommitOID): (GitOID, GitOID)
                = try setupCherrypickScenario(in: repository)
            
            
            
            var mainCommitPointer       : OpaquePointer?    = nil
            var featureCommitPointer    : OpaquePointer?    = nil
            var indexPointer            : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: mainCommitPointer)
                gitCommitFree(commit: featureCommitPointer)
                gitIndexFree(index: indexPointer)
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
            
            
            
            let indexEntryCountResult: Int
                = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCountResult, 0)
        }
    }
    
    
    
    func testGitCherrypickOptions() throws
    {
        let cherrypickOptions = GitCherrypickOptions()
        
        XCTAssertEqual(cherrypickOptions.version, gitCherrypickOptionsVersion)
        XCTAssertEqual(cherrypickOptions.mainline, 0)
        XCTAssertNotNil(cherrypickOptions.mergeOpts)
        XCTAssertNotNil(cherrypickOptions.checkoutOpts)
        
        try cherrypickOptions.withCValue
        {
            cCherrypickOptions in
            
            XCTAssertEqual(cCherrypickOptions.pointee.version, gitCherrypickOptionsVersion)
            XCTAssertEqual(cCherrypickOptions.pointee.mainline, 0)
            XCTAssertNotNil(cCherrypickOptions.pointee.merge_opts)
            XCTAssertNotNil(cCherrypickOptions.pointee.checkout_opts)
        }
    }
    
    
    
    func testGitCherrypickOptionsInit() throws
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: GitErrorCode
            = gitCherrypickOptionsInit(
                opts:       &cherrypickOptions,
                version:    gitCherrypickOptionsVersion
            )
        
        XCTAssertOK(cherrypickOptionsInitResult)
    }
    
    
    
    func testGitCherrypickOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitCherrypickOptionsVersion), GIT_CHERRYPICK_OPTIONS_VERSION)
    }
}



// MARK: - Extensions

private extension CherrypickTests
{
    static let mainBranchContent    : String    = "Main branch feature\nHello World\n"
    static let featureBranchContent : String    = "Feature branch change\nHello World\nGoodbye World\n"
    
    
    
    /// Creates a repository with branches suitable for cherry-picking.
    /// - Parameter repository: The repository in which to create the branches.
    /// - Returns: A tuple containing the main branch commit and the feature
    /// branch commit.
    /// - Throws: An error if an operation fails.
    func setupCherrypickScenario(
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
        
        
        
        let repoSetHEADFeatureResult: GitErrorCode = gitRepositorySetHEAD(
            repo:       repository.pointer,
            refName:    "refs/heads/feature"
        )
        
        XCTAssertOK(repoSetHEADFeatureResult)
        
        
        
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
            gitCommitFree(commit: headCommitPointer)
            gitReferenceFree(ref: branchPointer)
        }
        
        
        
        let commitLookupResult: GitErrorCode = gitCommitLookup(
            commit:     &headCommitPointer,
            repo:       repository.pointer,
            id:         headOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        
        
        let repoHEADResult: GitErrorCode = gitRepositoryHEAD(
            out:    &branchPointer,
            repo:   repository.pointer
        )
        
        XCTAssertOK(repoHEADResult)
        
        guard let branchPointer: OpaquePointer = branchPointer
        else
        {
            throw NSError.makeError("The branch pointer was nil.")
        }
        
        guard let referenceName: String = gitReferenceName(ref: branchPointer)
        else
        {
            throw NSError.makeError("The branch name was nil.")
        }
        
        
        
        let repoSetHEADResult: GitErrorCode = gitRepositorySetHEAD(
            repo:       repository.pointer,
            refName:    referenceName
        )
        
        XCTAssertOK(repoSetHEADResult)
        
        
        
        return (mainCommitOID, featureCommitOID)
    }
}
