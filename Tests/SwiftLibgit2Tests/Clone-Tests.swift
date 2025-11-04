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



final class CloneTests: XCTestCaseStopOnFail
{
    func testGitClone() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let clonedRepoURL: URL = try Repository.createTemporaryDirectory(
                named: "SwiftLibgit2CloneTests"
            )
            
            var clonedRepoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: clonedRepoPointer)
                
                try? FileManager.default.removeItem(at: clonedRepoURL)
            }
            
            
            
            let cloneResult: GitErrorCode = gitClone(
                out:        &clonedRepoPointer,
                url:        repository.url.path,
                localPath:  clonedRepoURL.path,
                options:    nil
            )
            
            XCTAssertOK(cloneResult)
            XCTAssertNotNil(clonedRepoPointer)
            
            
            
            let readmeFileURL: URL = clonedRepoURL.appending(
                path:           Repository.readmeFileName,
                directoryHint:  .notDirectory
            )
            
            let fileExists: Bool = FileManager.default
                .fileExists(atPath: readmeFileURL.path)
            
            XCTAssertTrue(fileExists)
            
            
            
            let readmeFileContent = try String(contentsOf: readmeFileURL)
            
            XCTAssertEqual(readmeFileContent, Repository.readmeFileContent)
        }
    }
    
    
    
    func testGitCloneLocalT() throws
    {
        XCTAssertEqual(GitCloneLocalT.gitCloneLocalAuto.rawValue, GIT_CLONE_LOCAL_AUTO.rawValue)
        XCTAssertEqual(GitCloneLocalT.gitCloneLocal.rawValue, GIT_CLONE_LOCAL.rawValue)
        XCTAssertEqual(GitCloneLocalT.gitCloneNoLocal.rawValue, GIT_CLONE_NO_LOCAL.rawValue)
        XCTAssertEqual(GitCloneLocalT.gitCLoneLocalNoLinks.rawValue, GIT_CLONE_LOCAL_NO_LINKS.rawValue)
        
        XCTAssertNil(GitCloneLocalT(rawValue: 123))
        
        XCTAssertEqual(GitCloneLocalT.gitCloneLocalAuto.cValue(), GIT_CLONE_LOCAL_AUTO)
        XCTAssertEqual(GitCloneLocalT.gitCloneLocal.cValue(), GIT_CLONE_LOCAL)
        XCTAssertEqual(GitCloneLocalT.gitCloneNoLocal.cValue(), GIT_CLONE_NO_LOCAL)
        XCTAssertEqual(GitCloneLocalT.gitCLoneLocalNoLinks.cValue(), GIT_CLONE_LOCAL_NO_LINKS)
        
        XCTAssertEqual(GitCloneLocalT(cValue: GIT_CLONE_LOCAL_AUTO), .gitCloneLocalAuto)
        XCTAssertEqual(GitCloneLocalT(cValue: GIT_CLONE_LOCAL), .gitCloneLocal)
        XCTAssertEqual(GitCloneLocalT(cValue: GIT_CLONE_NO_LOCAL), .gitCloneNoLocal)
        XCTAssertEqual(GitCloneLocalT(cValue: GIT_CLONE_LOCAL_NO_LINKS), .gitCLoneLocalNoLinks)
    }
    
    
    
    func testGitCloneOptions() throws
    {
        let cloneOptions = GitCloneOptions()
        
        XCTAssertEqual(cloneOptions.version, gitCloneOptionsVersion)
        XCTAssertNotNil(cloneOptions.checkoutOpts)
        XCTAssertNotNil(cloneOptions.fetchOpts)
        XCTAssertFalse(cloneOptions.bare)
        XCTAssertEqual(cloneOptions.local, .gitCloneLocalAuto)
        XCTAssertNil(cloneOptions.checkoutBranch)
        XCTAssertNil(cloneOptions.repositoryCB)
        XCTAssertNil(cloneOptions.repositoryCBPayload)
        XCTAssertNil(cloneOptions.remoteCB)
        XCTAssertNil(cloneOptions.remoteCBPayload)
        
        try cloneOptions.withCValue
        {
            cCloneOptions in
            
            XCTAssertEqual(cCloneOptions.pointee.version, gitCloneOptionsVersion)
            XCTAssertNotNil(cCloneOptions.pointee.checkout_opts)
            XCTAssertNotNil(cCloneOptions.pointee.fetch_opts)
            XCTAssertFalse(Bool(cCloneOptions.pointee.bare))
            XCTAssertEqual(GitCloneLocalT(cValue: cCloneOptions.pointee.local), .gitCloneLocalAuto)
            XCTAssertNil(cCloneOptions.pointee.checkout_branch)
            XCTAssertNil(cCloneOptions.pointee.repository_cb)
            XCTAssertNil(cCloneOptions.pointee.repository_cb_payload)
            XCTAssertNil(cCloneOptions.pointee.remote_cb)
            XCTAssertNil(cCloneOptions.pointee.remote_cb_payload)
        }
    }
    
    
    
    func testGitCloneOptionsInit() throws
    {
        var cloneOptions = git_clone_options()
        
        let cloneOptionsInitResult: GitErrorCode = gitCloneOptionsInit(
            opts:       &cloneOptions,
            version:    gitCloneOptionsVersion
        )
        
        XCTAssertOK(cloneOptionsInitResult)
    }
    
    
    
    func testGitCloneOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitCloneOptionsVersion), GIT_CLONE_OPTIONS_VERSION)
    }
    
    
    
    func testGitCloneWithCallbacks() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let clonedRepoURL: URL = try Repository.createTemporaryDirectory(
                named: "SwiftLibgit2CloneTests"
            )
            
            var clonedRepoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: clonedRepoPointer)
                
                try? FileManager.default.removeItem(at: clonedRepoURL)
            }
            
            
            
            var callbackData = CallbackData()
            
            let repositoryCreateCallback: GitRepositoryCreateCB =
            {
                out, path, isBare, payload in
                
                guard let payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.isRepositoryCreated = true
                
                return git_repository_init(
                    out,
                    path,
                    UInt32(isBare)
                )
            }
            
            
            
            let remoteCreateCallback: GitRemoteCreateCB =
            {
                out, repo, name, url, payload in
                
                guard let payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.isRemoteCreated = true
                
                return git_remote_create(
                    out,
                    repo,
                    name,
                    url
                )
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var cloneOptions = GitCloneOptions()
                
                cloneOptions.repositoryCB           = repositoryCreateCallback
                cloneOptions.repositoryCBPayload    = UnsafeMutableRawPointer(callbackDataPointer)
                cloneOptions.remoteCB               = remoteCreateCallback
                cloneOptions.remoteCBPayload        = UnsafeMutableRawPointer(callbackDataPointer)
                
                
                
                let cloneResult: GitErrorCode = gitClone(
                    out:        &clonedRepoPointer,
                    url:        repository.url.path,
                    localPath:  clonedRepoURL.path,
                    options:    cloneOptions
                )
                
                XCTAssertOK(cloneResult)
                XCTAssertNotNil(clonedRepoPointer)
            }
            
            XCTAssertTrue(callbackData.isRepositoryCreated)
            XCTAssertTrue(callbackData.isRemoteCreated)
        }
    }
    
    
    
    func testGitCloneWithCheckoutBranch() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let testBranchName: String = "test-branch"
            
            try Branch.createLocalBranch(
                named:      testBranchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let clonedRepoURL: URL = try Repository.createTemporaryDirectory(
                named: "SwiftLibgit2CloneTests"
            )
            
            var clonedRepoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: clonedRepoPointer)
                
                try? FileManager.default.removeItem(at: clonedRepoURL)
            }
            
            
            
            var cloneOptions = GitCloneOptions()
            
            cloneOptions.checkoutBranch = testBranchName
            
            
            
            let cloneResult: GitErrorCode = gitClone(
                out:        &clonedRepoPointer,
                url:        repository.url.path,
                localPath:  clonedRepoURL.path,
                options:    cloneOptions
            )
            
            XCTAssertOK(cloneResult)
            
            guard let clonedRepoPointer
            else
            {
                XCTFail("The repository pointer was nil.")
                return
            }
            
            
            
            var headReferencePointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: headReferencePointer)
            }
            
            
            
            let repositoryHEADResult: GitErrorCode = gitRepositoryHEAD(
                out:    &headReferencePointer,
                repo:   clonedRepoPointer
            )
            
            XCTAssertOK(repositoryHEADResult)
            
            guard let headReferencePointer
            else
            {
                XCTFail("The HEAD reference pointer was nil.")
                return
            }
            
            
            
            guard let branchName: String
                    = gitReferenceShorthand(ref: headReferencePointer)
            else
            {
                XCTFail("The branch name was nil.")
                return
            }
            
            XCTAssertEqual(branchName, testBranchName)
        }
    }
    
    
    
    func testGitCloneWithInvalidOptions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let clonedRepoURL: URL = try Repository.createTemporaryDirectory(
                named: "SwiftLibgit2CloneTests"
            )
            
            var clonedRepoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: clonedRepoPointer)
                
                try? FileManager.default.removeItem(at: clonedRepoURL)
            }
            
            
            
            var cloneOptions = GitCloneOptions()
            
            cloneOptions.version = 123
            
            
            
            let cloneResult: GitErrorCode = gitClone(
                out:        &clonedRepoPointer,
                url:        repository.url.path,
                localPath:  clonedRepoURL.path,
                options:    cloneOptions
            )
            
            XCTAssertEqual(cloneResult, .gitEUser)
            XCTAssertNil(clonedRepoPointer)
        }
    }
    
    
    
    func testGitCloneWithOptions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let clonedRepoURL: URL = try Repository.createTemporaryDirectory(
                named: "SwiftLibgit2CloneTests"
            )
            
            var clonedRepoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: clonedRepoPointer)
                
                try? FileManager.default.removeItem(at: clonedRepoURL)
            }
            
            
            
            var cloneOptions = GitCloneOptions()
            
            cloneOptions.bare   = true
            cloneOptions.local  = .gitCloneLocal
            
            
            
            let cloneResult: GitErrorCode = gitClone(
                out:        &clonedRepoPointer,
                url:        repository.url.path,
                localPath:  clonedRepoURL.path,
                options:    cloneOptions
            )
            
            XCTAssertOK(cloneResult)
            XCTAssertNotNil(clonedRepoPointer)
            
            
            
            let readmeFileURL: URL = clonedRepoURL.appending(
                path:           Repository.readmeFileName,
                directoryHint:  .notDirectory
            )
            
            /// A bare repository should have no working directory files.
            let readmeFileExists: Bool = FileManager.default
                .fileExists(atPath: readmeFileURL.path)
            
            XCTAssertFalse(readmeFileExists)
            
            
            
            let objectsDirectoryURL: URL = clonedRepoURL.appending(
                path:           "objects",
                directoryHint:  .isDirectory
            )
            
            /// A bare repository should still have a `.git/objects` directory.
            let objectsDirectoryExists: Bool = FileManager.default
                .fileExists(atPath: objectsDirectoryURL.path)
            
            XCTAssertTrue(objectsDirectoryExists)
        }
    }
}



// MARK: - Extensions

private extension CloneTests
{
    struct CallbackData
    {
        var isRepositoryCreated : Bool  = false
        var isRemoteCreated     : Bool  = false
    }
}
