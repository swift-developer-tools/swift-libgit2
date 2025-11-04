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



final class SubmoduleTests: XCTestCaseStopOnFail
{
    func testGitSubmoduleAddSetup() throws
    {
        try withSubmodule
        {
            _, _ in
        }
    }
    
    
    
    func testGitSubmoduleAddToIndexAndFinalize() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var submodulePointer    : OpaquePointer?    = nil
            var subRepoPointer      : OpaquePointer?    = nil
            
            defer
            {
                gitSubmoduleFree(submodule: submodulePointer)
                gitRepositoryFree(repo: subRepoPointer)
            }
            
            
            
            let submoduleAddSetupResult: GitErrorCode = gitSubmoduleAddSetup(
                out:            &submodulePointer,
                repo:           repository.pointer,
                url:            Self.submoduleURL,
                path:           Self.submodulePath,
                useGitlink:     true
            )
            
            XCTAssertOK(submoduleAddSetupResult)
            
            guard let submodulePointer
            else
            {
                XCTFail("The submodule pointer was nil.")
                return
            }
            
            
            
            let submoduleOpenResult: GitErrorCode = gitSubmoduleOpen(
                repo:       &subRepoPointer,
                submodule:  submodulePointer
            )
            
            XCTAssertOK(submoduleOpenResult)
            
            guard let subRepoPointer
            else
            {
                XCTFail("The subrepository pointer was nil.")
                return
            }
            
            
            
            let subRepoURL: URL = repository.url.appending(
                path:           Self.submodulePath,
                directoryHint:  .isDirectory
            )
            
            let subRepository = Repository(
                url:        subRepoURL,
                pointer:    subRepoPointer
            )
            
            /// Establish HEAD, otherwise the following operations will fail.
            try subRepository.commit(
                "Submodule content",
                toFile:     "submodule.txt",
                message:    "Submodule commit"
            )
            
            
            
            let submoduleAddToIndexResult: GitErrorCode
                = gitSubmoduleAddToIndex(
                    submodule:      submodulePointer,
                    writeIndex:     true
                )
            
            XCTAssertOK(submoduleAddToIndexResult)
            
            
            
            let submoduleAddFinalizeResult: GitErrorCode
                = gitSubmoduleAddFinalize(submodule: submodulePointer)
            
            XCTAssertOK(submoduleAddFinalizeResult)
            
            
            
            let submoduleUpdateResult: GitErrorCode = gitSubmoduleUpdate(
                submodule:  submodulePointer,
                init:       true,
                options:    nil
            )
            
            /// The update requires a remote.
            XCTAssertNotOK(submoduleUpdateResult)
        }
    }
    
    
    
    func testGitSubmoduleBranch() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            var submoduleBranch: String?
                = gitSubmoduleBranch(submodule: submodulePointer)
            
            XCTAssertNil(submoduleBranch)
            
            
            
            let branchName: String = "feature"
            
            let submoduleSetBranchResult: GitErrorCode
                = gitSubmoduleSetBranch(
                    repo:       repository.pointer,
                    name:       Self.submoduleName,
                    branch:     branchName
                )
            
            XCTAssertOK(submoduleSetBranchResult)
            
            
            
            let submoduleReloadResult: GitErrorCode = gitSubmoduleReload(
                submodule:  submodulePointer,
                force:      true
            )
            
            XCTAssertOK(submoduleReloadResult)
            
            
            
            submoduleBranch = gitSubmoduleBranch(submodule: submodulePointer)
            
            XCTAssertNotNil(submoduleBranch)
            XCTAssertEqual(submoduleBranch, branchName)
        }
    }
    
    
    
    func testGitSubmoduleClone() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            var clonedPointer: OpaquePointer? = nil
            
            defer
            {
                gitSubmoduleFree(submodule: clonedPointer)
            }
            
            
            
            let submoduleCloneResult: GitErrorCode = gitSubmoduleClone(
                out:        &clonedPointer,
                submodule:  submodulePointer,
                opts:       nil
            )
            
            XCTAssertEqual(submoduleCloneResult, .gitECertificate)
            XCTAssertNil(clonedPointer)
        }
    }
    
    
    
    func testGitSubmoduleDup() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            var duplicatedPointer: OpaquePointer? = nil
            
            defer
            {
                gitSubmoduleFree(submodule: duplicatedPointer)
            }
            
            
            
            let submoduleDupResult: GitErrorCode = gitSubmoduleDup(
                out:        &duplicatedPointer,
                source:     submodulePointer
            )
            
            XCTAssertOK(submoduleDupResult)
            XCTAssertNotNil(duplicatedPointer)
            XCTAssertEqual(duplicatedPointer, submodulePointer)
        }
    }
    
    
    
    func testGitSubmoduleFetchRecurseSubmodules() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let recursionRule: GitSubmoduleRecurseT?
                = gitSubmoduleFetchRecurseSubmodules(
                    submodule: submodulePointer
                )
            
            XCTAssertNotNil(recursionRule)
            XCTAssertEqual(recursionRule, .gitSubmoduleRecurseNo)
        }
    }
    
    
    
    func testGitSubmoduleForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var submodulePointers: [OpaquePointer] = []
            
            defer
            {
                for submodulePointer in submodulePointers
                {
                    gitSubmoduleFree(submodule: submodulePointer)
                }
            }
            
            
            
            let submoduleNames: [String] =
            [
                "submodules/submodule1",
                "submodules/submodule2",
                "submodules/submodule3"
            ]
            
            for submoduleName in submoduleNames
            {
                var submodulePointer: OpaquePointer? = nil
                
                let submoduleAddSetupResult: GitErrorCode
                    = gitSubmoduleAddSetup(
                        out:            &submodulePointer,
                        repo:           repository.pointer,
                        url:            "https://example.com/repo/submodule.git",
                        path:           submoduleName,
                        useGitlink:     true
                    )
                
                XCTAssertOK(submoduleAddSetupResult)
                
                guard let submodulePointer
                else
                {
                    XCTFail("The submodule pointer was nil.")
                    return
                }
                
                submodulePointers.append(submodulePointer)
            }
            
            
            
            var callbackData = CallbackData()
            
            let submoduleCB: GitSubmoduleCB =
            {
                _, name, payload in
                
                guard
                    let payload,
                    let name = String(optionalCString: name)
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                payloadPointer.pointee.names.append(name)
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let submoduleForEachResult: GitErrorCode = gitSubmoduleForEach(
                    repo:       repository.pointer,
                    callback:   submoduleCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(submoduleForEachResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            XCTAssertEqual(Set(callbackData.names), Set(submoduleNames))
        }
    }
    
    
    
    func testGitSubmoduleFree() throws
    {
        gitSubmoduleFree(submodule: nil)
    }
    
    
    
    func testGitSubmoduleHEADID() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let headOID: GitOID?
                = gitSubmoduleHEADID(submodule: submodulePointer)
            
            /// The newly-created submodule has not been cloned yet.
            XCTAssertNil(headOID)
        }
    }
    
    
    
    func testGitSubmoduleIgnore() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let ignoreRule: GitSubmoduleIgnoreT?
                = gitSubmoduleIgnore(submodule: submodulePointer)
            
            XCTAssertNotNil(ignoreRule)
            XCTAssertEqual(ignoreRule, .gitSubmoduleIgnoreNone)
        }
    }
    
    
    
    func testGitSubmoduleIgnoreT() throws
    {
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreUnspecified.rawValue, GIT_SUBMODULE_IGNORE_UNSPECIFIED.rawValue)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreNone.rawValue, GIT_SUBMODULE_IGNORE_NONE.rawValue)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreUntracked.rawValue, GIT_SUBMODULE_IGNORE_UNTRACKED.rawValue)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreDirty.rawValue, GIT_SUBMODULE_IGNORE_DIRTY.rawValue)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreAll.rawValue, GIT_SUBMODULE_IGNORE_ALL.rawValue)
        
        XCTAssertNil(GitSubmoduleIgnoreT(rawValue: 123))
        
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreUnspecified.cValue(), GIT_SUBMODULE_IGNORE_UNSPECIFIED)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreNone.cValue(), GIT_SUBMODULE_IGNORE_NONE)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreUntracked.cValue(), GIT_SUBMODULE_IGNORE_UNTRACKED)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreDirty.cValue(), GIT_SUBMODULE_IGNORE_DIRTY)
        XCTAssertEqual(GitSubmoduleIgnoreT.gitSubmoduleIgnoreAll.cValue(), GIT_SUBMODULE_IGNORE_ALL)
        
        XCTAssertEqual(GitSubmoduleIgnoreT(cValue: GIT_SUBMODULE_IGNORE_UNSPECIFIED), .gitSubmoduleIgnoreUnspecified)
        XCTAssertEqual(GitSubmoduleIgnoreT(cValue: GIT_SUBMODULE_IGNORE_NONE), .gitSubmoduleIgnoreNone)
        XCTAssertEqual(GitSubmoduleIgnoreT(cValue: GIT_SUBMODULE_IGNORE_UNTRACKED), .gitSubmoduleIgnoreUntracked)
        XCTAssertEqual(GitSubmoduleIgnoreT(cValue: GIT_SUBMODULE_IGNORE_DIRTY), .gitSubmoduleIgnoreDirty)
        XCTAssertEqual(GitSubmoduleIgnoreT(cValue: GIT_SUBMODULE_IGNORE_ALL), .gitSubmoduleIgnoreAll)
    }
    
    
    
    func testGitSubmoduleIndexID() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let indexOID: GitOID?
                = gitSubmoduleIndexID(submodule: submodulePointer)
            
            /// The newly-created submodule has not been cloned yet.
            XCTAssertNil(indexOID)
        }
    }
    
    
    
    func testGitSubmoduleInit() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            var submoduleInitResult: GitErrorCode = gitSubmoduleInit(
                submodule:  submodulePointer,
                overwrite:  false
            )
            
            XCTAssertOK(submoduleInitResult)
            
            
            
            submoduleInitResult = gitSubmoduleInit(
                submodule:  submodulePointer,
                overwrite:  true
            )
            
            XCTAssertOK(submoduleInitResult)
        }
    }
    
    
    
    func testGitSubmoduleLocation() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            var status: GitSubmoduleStatusT = []
            
            let submoduleLocationResult: GitErrorCode = gitSubmoduleLocation(
                locationStatus:     &status,
                submodule:          submodulePointer
            )
            
            XCTAssertOK(submoduleLocationResult)
            XCTAssertTrue(status.contains(.gitSubmoduleStatusInConfig))
        }
    }
    
    
    
    func testGitSubmoduleLookup() throws
    {
        try withSubmodule
        {
            repository, _ in
            
            var lookupPointer: OpaquePointer? = nil
            
            defer
            {
                gitSubmoduleFree(submodule: lookupPointer)
            }
            
            
            
            let submoduleLookupResult: GitErrorCode = gitSubmoduleLookup(
                out:    &lookupPointer,
                repo:   repository.pointer,
                name:   Self.submoduleName
            )
            
            XCTAssertOK(submoduleLookupResult)
            XCTAssertNotNil(lookupPointer)
        }
    }
    
    
    
    func testGitSubmoduleName() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let name: String? = gitSubmoduleName(submodule: submodulePointer)
            
            XCTAssertNotNil(name)
            XCTAssertEqual(name, Self.submoduleName)
        }
    }
    
    
    
    func testGitSubmoduleOpen() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            var firstRepoPointer    : OpaquePointer?    = nil
            var secondRepoPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitRepositoryFree(repo: firstRepoPointer)
                gitRepositoryFree(repo: secondRepoPointer)
            }
            
            
            
            var submoduleOpenResult: GitErrorCode = gitSubmoduleOpen(
                repo:       &firstRepoPointer,
                submodule:  submodulePointer
            )
            
            XCTAssertOK(submoduleOpenResult)
            XCTAssertNotNil(firstRepoPointer)
            
            
            
            submoduleOpenResult = gitSubmoduleOpen(
                repo:       &secondRepoPointer,
                submodule:  submodulePointer
            )
            
            XCTAssertOK(submoduleOpenResult)
            XCTAssertNotNil(secondRepoPointer)
            XCTAssertNotEqual(firstRepoPointer, secondRepoPointer)
        }
    }
    
    
    
    func testGitSubmoduleOwner() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            let ownerPointer: OpaquePointer
                = gitSubmoduleOwner(submodule: submodulePointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
        }
    }
    
    
    
    func testGitSubmodulePath() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let path: String? = gitSubmodulePath(submodule: submodulePointer)
            
            XCTAssertNotNil(path)
            XCTAssertEqual(path, Self.submodulePath)
        }
    }
    
    
    
    func testGitSubmoduleRecurseT() throws
    {
        XCTAssertEqual(GitSubmoduleRecurseT.gitSubmoduleRecurseNo.rawValue, GIT_SUBMODULE_RECURSE_NO.rawValue)
        XCTAssertEqual(GitSubmoduleRecurseT.gitSubmoduleRecurseYes.rawValue, GIT_SUBMODULE_RECURSE_YES.rawValue)
        XCTAssertEqual(GitSubmoduleRecurseT.gitSubmoduleRecurseOnDemand.rawValue, GIT_SUBMODULE_RECURSE_ONDEMAND.rawValue)
        
        XCTAssertNil(GitSubmoduleRecurseT(rawValue: 123))
        
        XCTAssertEqual(GitSubmoduleRecurseT.gitSubmoduleRecurseNo.cValue(), GIT_SUBMODULE_RECURSE_NO)
        XCTAssertEqual(GitSubmoduleRecurseT.gitSubmoduleRecurseYes.cValue(), GIT_SUBMODULE_RECURSE_YES)
        XCTAssertEqual(GitSubmoduleRecurseT.gitSubmoduleRecurseOnDemand.cValue(), GIT_SUBMODULE_RECURSE_ONDEMAND)
        
        XCTAssertEqual(GitSubmoduleRecurseT(cValue: GIT_SUBMODULE_RECURSE_NO), .gitSubmoduleRecurseNo)
        XCTAssertEqual(GitSubmoduleRecurseT(cValue: GIT_SUBMODULE_RECURSE_YES), .gitSubmoduleRecurseYes)
        XCTAssertEqual(GitSubmoduleRecurseT(cValue: GIT_SUBMODULE_RECURSE_ONDEMAND), .gitSubmoduleRecurseOnDemand)
    }
    
    
    
    func testGitSubmoduleReload() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let submoduleReloadResult: GitErrorCode = gitSubmoduleReload(
                submodule:  submodulePointer,
                force:      true
            )
            
            XCTAssertOK(submoduleReloadResult)
        }
    }
    
    
    
    func testGitSubmoduleRepoInit() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            var repoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: repoPointer)
            }
            
            
            
            var submoduleRepoInitResult: GitErrorCode = gitSubmoduleRepoInit(
                out:            &repoPointer,
                sm:             submodulePointer,
                useGitlink:     true
            )
            
            XCTAssertEqual(submoduleRepoInitResult, .gitEExists)
            XCTAssertNil(repoPointer)
            
            
            
            submoduleRepoInitResult = gitSubmoduleRepoInit(
                out:            &repoPointer,
                sm:             submodulePointer,
                useGitlink:     false
            )
            
            XCTAssertEqual(submoduleRepoInitResult, .gitEExists)
            XCTAssertNil(repoPointer)
        }
    }
    
    
    
    func testGitSubmoduleResolveURL() throws
    {
        try withSubmodule
        {
            repository, _ in
            
            var resolvedURL: String? = nil
            
            let submoduleResolveURLResult: GitErrorCode
                = gitSubmoduleResolveURL(
                    out:    &resolvedURL,
                    repo:   repository.pointer,
                    url:    Self.submoduleURL
                )
            
            XCTAssertOK(submoduleResolveURLResult)
            XCTAssertNotNil(resolvedURL)
            XCTAssertEqual(resolvedURL, Self.submoduleURL)
        }
    }
    
    
    
    func testGitSubmoduleSetFetchRecurseSubmodules() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            var recursionRule: GitSubmoduleRecurseT?
                = gitSubmoduleFetchRecurseSubmodules(
                    submodule: submodulePointer
                )
            
            XCTAssertNotNil(recursionRule)
            XCTAssertEqual(recursionRule, .gitSubmoduleRecurseNo)
            
            
            
            let expectedRecursionRule: GitSubmoduleRecurseT
                = .gitSubmoduleRecurseYes
            
            let submoduleSetRecursionResult: GitErrorCode
                = gitSubmoduleSetFetchRecurseSubmodules(
                    repo:                   repository.pointer,
                    name:                   Self.submoduleName,
                    fetchRecurseSubmodules: expectedRecursionRule
                )
            
            XCTAssertOK(submoduleSetRecursionResult)
            
            
            
            let submoduleReloadResult: GitErrorCode = gitSubmoduleReload(
                submodule:  submodulePointer,
                force:      true
            )
            
            XCTAssertOK(submoduleReloadResult)
            
            
            
            recursionRule
                = gitSubmoduleFetchRecurseSubmodules(submodule: submodulePointer)
            
            XCTAssertNotNil(recursionRule)
            XCTAssertEqual(recursionRule, expectedRecursionRule)
        }
    }
    
    
    
    func testGitSubmoduleSetIgnore() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            var ignoreRule: GitSubmoduleIgnoreT?
                = gitSubmoduleIgnore(submodule: submodulePointer)
            
            XCTAssertNotNil(ignoreRule)
            XCTAssertEqual(ignoreRule, .gitSubmoduleIgnoreNone)
            
            
            
            let expectedIgnoreRule: GitSubmoduleIgnoreT
                = .gitSubmoduleIgnoreUntracked
            
            let submoduleSetIgnoreResult: GitErrorCode
                = gitSubmoduleSetIgnore(
                    repo:       repository.pointer,
                    name:       Self.submoduleName,
                    ignore:     expectedIgnoreRule
                )
            
            XCTAssertOK(submoduleSetIgnoreResult)
            
            
            
            let submoduleReloadResult: GitErrorCode = gitSubmoduleReload(
                submodule:  submodulePointer,
                force:      true
            )
            
            XCTAssertOK(submoduleReloadResult)
            
            
            
            ignoreRule = gitSubmoduleIgnore(submodule: submodulePointer)
            
            XCTAssertNotNil(ignoreRule)
            XCTAssertEqual(ignoreRule, expectedIgnoreRule)
        }
    }
    
    
    
    func testGitSubmoduleSetUpdate() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            var updateRule: GitSubmoduleUpdateT?
                = gitSubmoduleUpdateStrategy(submodule: submodulePointer)
            
            XCTAssertNotNil(updateRule)
            XCTAssertEqual(updateRule, .gitSubmoduleUpdateCheckout)
            
            
            
            let expectedUpdateRule: GitSubmoduleUpdateT
                = .gitSubmoduleUpdateRebase
            
            let submoduleSetUpdateResult: GitErrorCode
                = gitSubmoduleSetUpdate(
                    repo:       repository.pointer,
                    name:       Self.submoduleName,
                    ignore:     expectedUpdateRule
                )
            
            XCTAssertOK(submoduleSetUpdateResult)
            
            
            
            let submoduleReloadResult: GitErrorCode = gitSubmoduleReload(
                submodule:  submodulePointer,
                force:      true
            )
            
            XCTAssertOK(submoduleReloadResult)
            
            
            
            updateRule = gitSubmoduleUpdateStrategy(submodule: submodulePointer)
            
            XCTAssertNotNil(updateRule)
            XCTAssertEqual(updateRule, expectedUpdateRule)
        }
    }
    
    
    
    func testGitSubmoduleSetURL() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            let newURL: String = "https://example.com/repo/new.git"
            
            let submoduleSetURLResult: GitErrorCode = gitSubmoduleSetURL(
                repo:   repository.pointer,
                name:   Self.submoduleName,
                url:    newURL
            )
            
            XCTAssertOK(submoduleSetURLResult)
            
            
            
            let submoduleReloadResult: GitErrorCode = gitSubmoduleReload(
                submodule:  submodulePointer,
                force:      true
            )
            
            XCTAssertOK(submoduleReloadResult)
            
            
            
            let retrievedURL: String?
                = gitSubmoduleURL(submodule: submodulePointer)
            
            XCTAssertNotNil(retrievedURL)
            XCTAssertEqual(retrievedURL, newURL)
        }
    }
    
    
    
    func testGitSubmoduleStatus() throws
    {
        try withSubmodule
        {
            repository, submodulePointer in
            
            var status: GitSubmoduleStatusT = []
            
            let submoduleStatusResult: GitErrorCode = gitSubmoduleStatus(
                status:     &status,
                repo:       repository.pointer,
                name:       Self.submoduleName,
                ignore:     .gitSubmoduleIgnoreUnspecified
            )
            
            XCTAssertOK(submoduleStatusResult)
            XCTAssertTrue(status.contains(.gitSubmoduleStatusInConfig))
        }
    }
    
    
    
    func testGitSubmoduleStatusIsIndexUnmodified() throws
    {
        var status: GitSubmoduleStatusT = .gitSubmoduleStatusInConfig
        
        var isIndexUnmodified: Bool
            = gitSubmoduleStatusIsIndexUnmodified(status: status)
        
        XCTAssertTrue(isIndexUnmodified)
        
        
        
        status = status.union(.gitSubmoduleStatusIndexModified)
        
        isIndexUnmodified = gitSubmoduleStatusIsIndexUnmodified(status: status)
        
        XCTAssertFalse(isIndexUnmodified)
    }
    
    
    
    func testGitSubmoduleStatusIsWDDirty() throws
    {
        var status: GitSubmoduleStatusT = .gitSubmoduleStatusInConfig
        
        var isWDDirty: Bool
            = gitSubmoduleStatusIsWDDirty(status: status)
        
        XCTAssertFalse(isWDDirty)
        
        
        status = status.union(.gitSubmoduleStatusWDIndexModified)
        
        isWDDirty = gitSubmoduleStatusIsWDDirty(status: status)
        
        XCTAssertTrue(isWDDirty)
    }
    
    
    
    func testGitSubmoduleStatusIsWDUnmodified() throws
    {
        var status: GitSubmoduleStatusT = .gitSubmoduleStatusInConfig
        
        var isWDUnmodified: Bool
            = gitSubmoduleStatusIsWDUnmodified(status: status)
        
        XCTAssertTrue(isWDUnmodified)
        
        
        
        status = status.union(.gitSubmoduleStatusWDIndexModified)
        
        isWDUnmodified = gitSubmoduleStatusIsWDUnmodified(status: status)
        
        XCTAssertFalse(isWDUnmodified)
    }
    
    
    
    func testGitSubmoduleStatusIsUnmodified() throws
    {
        var status: GitSubmoduleStatusT = .gitSubmoduleStatusInConfig
        
        var isUnmodified: Bool
            = gitSubmoduleStatusIsUnmodified(status: status)
        
        XCTAssertTrue(isUnmodified)
        
        
        
        status = status.union(.gitSubmoduleStatusIndexModified)
        
        isUnmodified = gitSubmoduleStatusIsUnmodified(status: status)
        
        XCTAssertFalse(isUnmodified)
    }
    
    
    
    func testGitSubmoduleStatusInFlags() throws
    {
        XCTAssertEqual(gitSubmoduleStatusInFlags, GIT_SUBMODULE_STATUS__IN_FLAGS)
    }
    
    
    
    func testGitSubmoduleStatusIndexFlags() throws
    {
        XCTAssertEqual(gitSubmoduleStatusIndexFlags, GIT_SUBMODULE_STATUS__INDEX_FLAGS)
    }

    
    
    func testGitSubmoduleStatusT() throws
    {
        func testGitSubmoduleStatusT() throws
        {
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInHEAD.rawValue, GIT_SUBMODULE_STATUS_IN_HEAD.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInIndex.rawValue, GIT_SUBMODULE_STATUS_IN_INDEX.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInConfig.rawValue, GIT_SUBMODULE_STATUS_IN_CONFIG.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInWD.rawValue, GIT_SUBMODULE_STATUS_IN_WD.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusIndexAdded.rawValue, GIT_SUBMODULE_STATUS_INDEX_ADDED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusIndexDeleted.rawValue, GIT_SUBMODULE_STATUS_INDEX_DELETED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusIndexModified.rawValue, GIT_SUBMODULE_STATUS_INDEX_MODIFIED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDUninitialized.rawValue, GIT_SUBMODULE_STATUS_WD_UNINITIALIZED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDAdded.rawValue, GIT_SUBMODULE_STATUS_WD_ADDED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDDeleted.rawValue, GIT_SUBMODULE_STATUS_WD_DELETED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDModified.rawValue, GIT_SUBMODULE_STATUS_WD_MODIFIED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDIndexModified.rawValue, GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDWDModified.rawValue, GIT_SUBMODULE_STATUS_WD_WD_MODIFIED.rawValue)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDUntracked.rawValue, GIT_SUBMODULE_STATUS_WD_UNTRACKED.rawValue)
            
            XCTAssertEqual(GitSubmoduleStatusT(rawValue: 123).cValue().rawValue, 123)
            
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInHEAD.cValue(), GIT_SUBMODULE_STATUS_IN_HEAD)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInIndex.cValue(), GIT_SUBMODULE_STATUS_IN_INDEX)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInConfig.cValue(), GIT_SUBMODULE_STATUS_IN_CONFIG)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusInWD.cValue(), GIT_SUBMODULE_STATUS_IN_WD)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusIndexAdded.cValue(), GIT_SUBMODULE_STATUS_INDEX_ADDED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusIndexDeleted.cValue(), GIT_SUBMODULE_STATUS_INDEX_DELETED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusIndexModified.cValue(), GIT_SUBMODULE_STATUS_INDEX_MODIFIED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDUninitialized.cValue(), GIT_SUBMODULE_STATUS_WD_UNINITIALIZED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDAdded.cValue(), GIT_SUBMODULE_STATUS_WD_ADDED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDDeleted.cValue(), GIT_SUBMODULE_STATUS_WD_DELETED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDModified.cValue(), GIT_SUBMODULE_STATUS_WD_MODIFIED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDIndexModified.cValue(), GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDWDModified.cValue(), GIT_SUBMODULE_STATUS_WD_WD_MODIFIED)
            XCTAssertEqual(GitSubmoduleStatusT.gitSubmoduleStatusWDUntracked.cValue(), GIT_SUBMODULE_STATUS_WD_UNTRACKED)
            
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_IN_HEAD), .gitSubmoduleStatusInHEAD)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_IN_INDEX), .gitSubmoduleStatusInIndex)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_IN_CONFIG), .gitSubmoduleStatusInConfig)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_IN_WD), .gitSubmoduleStatusInWD)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_INDEX_ADDED), .gitSubmoduleStatusIndexAdded)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_INDEX_DELETED), .gitSubmoduleStatusIndexDeleted)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_INDEX_MODIFIED), .gitSubmoduleStatusIndexModified)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_UNINITIALIZED), .gitSubmoduleStatusWDUninitialized)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_ADDED), .gitSubmoduleStatusWDAdded)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_DELETED), .gitSubmoduleStatusWDDeleted)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_MODIFIED), .gitSubmoduleStatusWDModified)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED), .gitSubmoduleStatusWDIndexModified)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_WD_MODIFIED), .gitSubmoduleStatusWDWDModified)
            XCTAssertEqual(GitSubmoduleStatusT(cValue: GIT_SUBMODULE_STATUS_WD_UNTRACKED), .gitSubmoduleStatusWDUntracked)
            
            
            
            let flags: GitSubmoduleStatusT =
            [
                .gitSubmoduleStatusIndexAdded,
                .gitSubmoduleStatusIndexModified
            ]
            
            XCTAssertTrue(flags.contains(.gitSubmoduleStatusIndexAdded))
            XCTAssertTrue(flags.contains(.gitSubmoduleStatusIndexModified))
            XCTAssertFalse(flags.contains(.gitSubmoduleStatusWDWDModified))
        }
    }
    
    
    
    func testGitSubmoduleStatusWDFlags() throws
    {
        XCTAssertEqual(gitSubmoduleStatusWDFlags, GIT_SUBMODULE_STATUS__WD_FLAGS)
    }
    
    
    
    func testGitSubmoduleSync() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let submoduleSyncResult: GitErrorCode
                = gitSubmoduleSync(submodule: submodulePointer)
            
            XCTAssertOK(submoduleSyncResult)
        }
    }
    
    
    
    func testGitSubmoduleUpdateOptionsInit() throws
    {
        var submoduleUpdateOptions = git_submodule_update_options()
        
        let submoduleUpdateOptionsInitResult: GitErrorCode
            = gitSubmoduleUpdateOptionsInit(
                opts:       &submoduleUpdateOptions,
                version:    gitSubmoduleUpdateOptionsVersion
            )
        
        XCTAssertOK(submoduleUpdateOptionsInitResult)
    }
    
    
    
    func testGitSubmoduleUpdateOptions() throws
    {
        let submoduleUpdateOptions = GitSubmoduleUpdateOptions()
        
        XCTAssertEqual(submoduleUpdateOptions.version, gitSubmoduleUpdateOptionsVersion)
        XCTAssertNotNil(submoduleUpdateOptions.checkoutOpts)
        XCTAssertNotNil(submoduleUpdateOptions.fetchOpts)
        XCTAssertTrue(submoduleUpdateOptions.allowFetch)
        
        try submoduleUpdateOptions.withCValue
        {
            cSubmoduleUpdateOptions in
            
            XCTAssertEqual(cSubmoduleUpdateOptions.pointee.version, gitSubmoduleUpdateOptionsVersion)
            XCTAssertNotNil(cSubmoduleUpdateOptions.pointee.checkout_opts)
            XCTAssertNotNil(cSubmoduleUpdateOptions.pointee.fetch_opts)
            XCTAssertTrue(Bool(cSubmoduleUpdateOptions.pointee.allow_fetch))
        }
    }
    
    
    
    func testGitSubmoduleUpdateT() throws
    {
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateCheckout.rawValue, GIT_SUBMODULE_UPDATE_CHECKOUT.rawValue)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateRebase.rawValue, GIT_SUBMODULE_UPDATE_REBASE.rawValue)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateMerge.rawValue, GIT_SUBMODULE_UPDATE_MERGE.rawValue)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateNone.rawValue, GIT_SUBMODULE_UPDATE_NONE.rawValue)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateDefault.rawValue, GIT_SUBMODULE_UPDATE_DEFAULT.rawValue)
        
        XCTAssertNil(GitSubmoduleUpdateT(rawValue: 123))
        
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateCheckout.cValue(), GIT_SUBMODULE_UPDATE_CHECKOUT)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateRebase.cValue(), GIT_SUBMODULE_UPDATE_REBASE)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateMerge.cValue(), GIT_SUBMODULE_UPDATE_MERGE)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateNone.cValue(), GIT_SUBMODULE_UPDATE_NONE)
        XCTAssertEqual(GitSubmoduleUpdateT.gitSubmoduleUpdateDefault.cValue(), GIT_SUBMODULE_UPDATE_DEFAULT)
        
        XCTAssertEqual(GitSubmoduleUpdateT(cValue: GIT_SUBMODULE_UPDATE_CHECKOUT), .gitSubmoduleUpdateCheckout)
        XCTAssertEqual(GitSubmoduleUpdateT(cValue: GIT_SUBMODULE_UPDATE_REBASE), .gitSubmoduleUpdateRebase)
        XCTAssertEqual(GitSubmoduleUpdateT(cValue: GIT_SUBMODULE_UPDATE_MERGE), .gitSubmoduleUpdateMerge)
        XCTAssertEqual(GitSubmoduleUpdateT(cValue: GIT_SUBMODULE_UPDATE_NONE), .gitSubmoduleUpdateNone)
        XCTAssertEqual(GitSubmoduleUpdateT(cValue: GIT_SUBMODULE_UPDATE_DEFAULT), .gitSubmoduleUpdateDefault)
    }
    
    
    
    func testGitSubmoduleUpdateOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitSubmoduleUpdateOptionsVersion), GIT_SUBMODULE_UPDATE_OPTIONS_VERSION)
    }
    
    
    
    func testGitSubmoduleUpdateStrategy() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let updateRule: GitSubmoduleUpdateT?
                = gitSubmoduleUpdateStrategy(submodule: submodulePointer)
            
            XCTAssertNotNil(updateRule)
            XCTAssertEqual(updateRule, .gitSubmoduleUpdateCheckout)
        }
    }
    
    
    
    func testGitSubmoduleURL() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let url: String? = gitSubmoduleURL(submodule: submodulePointer)
            
            XCTAssertNotNil(url)
            XCTAssertEqual(url, Self.submoduleURL)
        }
    }
    
    
    
    func testGitSubmoduleWDID() throws
    {
        try withSubmodule
        {
            _, submodulePointer in
            
            let workingDirectoryOID: GitOID?
                = gitSubmoduleWDID(submodule: submodulePointer)
            
            /// The newly-created submodule has not been cloned yet.
            XCTAssertNil(workingDirectoryOID)
        }
    }
}



// MARK: - Extensions

private extension SubmoduleTests
{
    struct CallbackData
    {
        var callCount   : Int       = 0
        var names       : [String]  = []
    }
    
    
    
    static let submoduleName    : String    = "submodules/test-submodule"
    static let submoduleURL     : String    = "https://example.com/repo/sub.git"
    static let submodulePath    : String    = "submodules/test-submodule"
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a submodule.
    /// - Parameters:
    ///   - name: The name of the submodule to create.
    ///   - url: The URL of the submodule to create.
    ///   - path: The path of the submodule to create.
    ///   - useGitlink: Whether the working directory should contain a Gitlink
    ///   to the repository in `.git/modules`, as opposed to initializing an
    ///   empty repository at the specified location in the working directory.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    ///
    /// ## Discussion
    ///
    /// The name, URL, and path of the submodule default to ``submoduleName``,
    /// ``submoduleURL``, and ``submodulePath``, respectively.
    func withSubmodule(
        name        : String    = "submodules/test-submodule",
        url         : String    = "https://example.com/repo/sub.git",
        path        : String    = "submodules/test-submodule",
        useGitlink  : Bool      = true,
        _ body      : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var submodulePointer: OpaquePointer? = nil
            
            defer
            {
                gitSubmoduleFree(submodule: submodulePointer)
            }
            
            
            
            let submoduleAddSetupResult: GitErrorCode = gitSubmoduleAddSetup(
                out:            &submodulePointer,
                repo:           repository.pointer,
                url:            url,
                path:           path,
                useGitlink:     useGitlink
            )
            
            XCTAssertOK(submoduleAddSetupResult)
            
            guard let submodulePointer
            else
            {
                XCTFail("The submodule pointer was nil.")
                return
            }
            
            
            
            let retrievedName: String?
                = gitSubmoduleName(submodule: submodulePointer)
            
            XCTAssertNotNil(retrievedName)
            XCTAssertEqual(retrievedName, name)
            
            
            
            let retrievedPath: String?
                = gitSubmodulePath(submodule: submodulePointer)
            
            XCTAssertNotNil(retrievedPath)
            XCTAssertEqual(retrievedPath, path)
            
            
            
            let retrievedURL: String?
                = gitSubmoduleURL(submodule: submodulePointer)
            
            XCTAssertNotNil(retrievedURL)
            XCTAssertEqual(retrievedURL, url)
            
            
            
            try body(
                repository,
                submodulePointer
            )
        }
    }
}
