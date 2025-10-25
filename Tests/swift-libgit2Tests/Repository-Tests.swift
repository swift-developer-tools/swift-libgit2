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



final class RepositoryTests: XCTestCaseStopOnFail
{
    func testGitRepositoryCommitParents() throws
    {
        try Repository.withRepository
        {
            repository in
            
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
            
            repository.reset(to: firstCommitOID)
            
            try repository.commit(
                "Branch content",
                toFile:     "branch.txt",
                message:    "Branch commit"
            )
            
            
            
            var commits: [OpaquePointer] = []
            
            defer
            {
                for commit in commits
                {
                    gitCommitFree(commit: commit)
                }
            }
            
            
            
            let repoCommitParentsResult: GitErrorCode
                = gitRepositoryCommitParents(
                    commits:    &commits,
                    repo:       repository.pointer
                )
            
            XCTAssertOK(repoCommitParentsResult)
            XCTAssertGreaterThan(commits.count, 0)
        }
    }
    
    
    
    func testGitRepositoryCommonDir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commonDirectoryPath: String?
                = gitRepositoryCommonDir(repo: repository.pointer)
            
            XCTAssertNotNil(commonDirectoryPath)
            XCTAssertTrue(commonDirectoryPath?.hasSuffix(".git/") ?? false)
        }
    }
    
    
    
    func testGitRepositoryConfig() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var configPointer: OpaquePointer? = nil
            
            defer
            {
                gitConfigFree(cfg: configPointer)
            }
            
            
            
            let repoConfigResult: GitErrorCode = gitRepositoryConfig(
                out:    &configPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoConfigResult)
            XCTAssertNotNil(configPointer)
        }
    }
    
    
    
    func testGitRepositoryConfigSnapshot() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var snapshotPointer: OpaquePointer? = nil
            
            defer
            {
                gitConfigFree(cfg: snapshotPointer)
            }
            
            
            
            let repoConfigSnapshotResult: GitErrorCode
                = gitRepositoryConfigSnapshot(
                    out:    &snapshotPointer,
                    repo:   repository.pointer
                )
            
            XCTAssertOK(repoConfigSnapshotResult)
            XCTAssertNotNil(snapshotPointer)
        }
    }
    
    
    
    func testGitRepositoryDetachHEAD() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoDetachHEADResult: GitErrorCode
                = gitRepositoryDetachHEAD(repo: repository.pointer)
            
            XCTAssertOK(repoDetachHEADResult)
            
            
            
            let isDetached: Bool?
                = gitRepositoryHEADDetached(repo: repository.pointer)
            
            XCTAssertNotNil(isDetached)
            XCTAssertTrue(isDetached ?? false)
        }
    }
    
    
    
    func testGitRepositoryDiscover() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repositoryPath  : String    = repository.url.path()
            var discoveredData  : Data      = Data()
            
            let repoDiscoverResult: GitErrorCode = gitRepositoryDiscover(
                out:            &discoveredData,
                startPath:      repositoryPath,
                acrossFS:       false,
                ceilingDirs:    nil
            )
            
            XCTAssertOK(repoDiscoverResult)
            
            guard let discoveredPath = String(
                data:       discoveredData,
                encoding:   .utf8
            )
            else
            {
                XCTFail("The discovered path was nil.")
                return
            }
            
            XCTAssertTrue(discoveredPath.contains(repositoryPath))
        }
    }
    
    
    
    func testGitRepositoryFETCHHEADForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            guard let headOIDString: String
                    = gitOIDToStrS(oid: repository.headOID)
            else
            {
                XCTFail("The HEAD OID string was nil.")
                return
            }
            
            
            
            let fetchheadURL: URL = repository.url.appending(
                path:           ".git/FETCH_HEAD",
                directoryHint:  .notDirectory
            )
            
            let fetchheadContent: String
                = "\(headOIDString)\t\tbranch 'main' of https://example.com/repo\n"
            
            try fetchheadContent.atomicWrite(to: fetchheadURL)
            
            
            
            var callbackData = CallbackData()
            
            let fetchheadForEachCB: GitRepositoryFETCHHEADForEachCB =
            {
                refNane, remoteURL, oid, isMerge, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount    += 1
                payloadPointer.pointee.lastURL      = String(optionalCString: remoteURL)
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let fetchheadForEachResult: GitErrorCode
                    = gitRepositoryFETCHHEADForEach(
                        repo:       repository.pointer,
                        callback:   fetchheadForEachCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(fetchheadForEachResult)
            }
            
            XCTAssertEqual(callbackData.callCount, 1)
            XCTAssertNotNil(callbackData.lastURL)
            XCTAssertTrue(callbackData.lastURL?.contains("example.com") ?? false)
        }
    }
    
    
    
    func testGitRepositoryFree() throws
    {
        gitRepositoryFree(repo: nil)
    }
    
    
    
    func testGitRepositoryHashFile() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let fileContent : String    = "Hello World!"
            let fileName    : String    = "hash.txt"
            
            try repository.commit(
                fileContent,
                toFile:     fileName,
                message:    "Add test file"
            )
            
            
            
            var hashedOID = GitOID()
            
            let repoHashFileResult: GitErrorCode = gitRepositoryHashFile(
                out:        &hashedOID,
                repo:       repository.pointer,
                path:       fileName,
                type:       .gitObjectBlob,
                asPath:     fileName
            )
            
            XCTAssertOK(repoHashFileResult)
            XCTAssertNotZeroOID(hashedOID)
        }
    }
    
    
    
    func testGitRepositoryHEAD() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var headPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: headPointer)
            }
            
            
            
            let repoHEADResult: GitErrorCode = gitRepositoryHEAD(
                out:    &headPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoHEADResult)
            XCTAssertNotNil(headPointer)
        }
    }
    
    
    
    func testGitRepositoryHEADDetachedForWorktree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let worktreeName: String = "test-worktree"
            
            let worktreeURL: URL
                = FileManager.default.temporaryDirectory
                    .appending(path: "worktree", directoryHint: .isDirectory)
                    .appendingPathExtension(UUID().uuidString)
            
            
            
            var worktreePointer: OpaquePointer? = nil
            
            defer
            {
                try? FileManager.default.removeItem(at: worktreeURL)
                Free.freeWorktree(worktreePointer)
            }
            
            
            
            let worktreeAddResult: Int32 = git_worktree_add(
                &worktreePointer,
                repository.pointer,
                worktreeName,
                worktreeURL.path(),
                nil
            )
            
            XCTAssertOK(GitErrorCode(rawValue: worktreeAddResult))
            XCTAssertNotNil(worktreePointer)
            
            
            
            let isHEADDetached: Bool? = gitRepositoryHEADDetachedForWorktree(
                repo:   repository.pointer,
                name:   worktreeName
            )
            
            XCTAssertNotNil(isHEADDetached)
            XCTAssertTrue(isHEADDetached ?? false)
        }
    }
    
    
    
    func testGitRepositoryHEADForWorktree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let worktreeName: String = "test-worktree"
            
            let worktreeURL: URL
                = FileManager.default.temporaryDirectory
                    .appending(path: "worktree", directoryHint: .isDirectory)
                    .appendingPathExtension(UUID().uuidString)
            
            
            
            var worktreePointer : OpaquePointer?    = nil
            var headPointer     : OpaquePointer?    = nil
            
            defer
            {
                try? FileManager.default.removeItem(at: worktreeURL)
                Free.freeWorktree(worktreePointer)
                gitReferenceFree(ref: headPointer)
            }
            
            
            
            let worktreeAddResult: Int32 = git_worktree_add(
                &worktreePointer,
                repository.pointer,
                worktreeName,
                worktreeURL.path(),
                nil
            )
            
            XCTAssertOK(GitErrorCode(rawValue: worktreeAddResult))
            XCTAssertNotNil(worktreePointer)
            
            
            
            let headForWorktreeResult: GitErrorCode
                = gitRepositoryHEADForWorktree(
                    out:    &headPointer,
                    repo:   repository.pointer,
                    name:   worktreeName
                )
            
            XCTAssertOK(headForWorktreeResult)
            XCTAssertNotNil(headPointer)
        }
    }
    
    
    
    func testGitRepositoryHEADUnborn() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let isHEADUnborn: Bool?
                = gitRepositoryHEADUnborn(repo: repository.pointer)
            
            XCTAssertNotNil(isHEADUnborn)
            XCTAssertFalse(isHEADUnborn ?? true)
        }
    }
    
    
    
    func testGitRepositoryIdent() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var repoSetIdentResult: GitErrorCode = gitRepositorySetIdent(
                repo:   repository.pointer,
                name:   Repository.commitAuthorName,
                email:  Repository.commitAuthorEmail
            )
            
            XCTAssertOK(repoSetIdentResult)
            
            
            
            var name    : String?   = nil
            var email   : String?   = nil
            
            var repoIdentResult: GitErrorCode = gitRepositoryIdent(
                name:   &name,
                email:  &email,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoIdentResult)
            XCTAssertNotNil(name)
            XCTAssertNotNil(email)
            XCTAssertEqual(name, Repository.commitAuthorName)
            XCTAssertEqual(email, Repository.commitAuthorEmail)
            
            
            
            repoSetIdentResult = gitRepositorySetIdent(
                repo:   repository.pointer,
                name:   nil,
                email:  nil
            )
            
            XCTAssertOK(repoSetIdentResult)
            
            
            
            repoIdentResult = gitRepositoryIdent(
                name:   &name,
                email:  &email,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoIdentResult)
            XCTAssertNil(name)
            XCTAssertNil(email)
        }
    }
    
    
    
    func testGitRepositoryIndex() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let repoIndexResult: GitErrorCode = gitRepositoryIndex(
                out:    &indexPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoIndexResult)
            XCTAssertNotNil(indexPointer)
        }
    }
    
    
    
    func testGitRepositoryInit() throws
    {
        try Repository.withRepository
        {
            _ in
        }
    }
    
    
    
    func testGitRepositoryInitBare() throws
    {
        try Repository.withRepository(isBare: true)
        {
            repository in
            
            let isBare: Bool = gitRepositoryIsBare(repo: repository.pointer)
            
            XCTAssertTrue(isBare)
        }
    }
    
    
    
    func testGitRepositoryInitExt() throws
    {
        var repoInitOptions = GitRepositoryInitOptions()
        
        repoInitOptions.flags   = .gitRepositoryInitMkdir
        repoInitOptions.mode    = .gitRepositoryInitSharedUmask
        
        try Repository.withRepository(options: repoInitOptions)
        {
            repository in
            
            let isBare: Bool = gitRepositoryIsBare(repo: repository.pointer)
            
            XCTAssertFalse(isBare)
        }
    }
    
    
    
    func testGitRepositoryInitFlagT() throws
    {
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitBare.rawValue, GIT_REPOSITORY_INIT_BARE.rawValue)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitNoReinit.rawValue, GIT_REPOSITORY_INIT_NO_REINIT.rawValue)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitMkdir.rawValue, GIT_REPOSITORY_INIT_MKDIR.rawValue)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitMkpath.rawValue, GIT_REPOSITORY_INIT_MKPATH.rawValue)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitExternalTemplate.rawValue, GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE.rawValue)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitRelativeGitlink.rawValue, GIT_REPOSITORY_INIT_RELATIVE_GITLINK.rawValue)
        
        XCTAssertEqual(GitRepositoryInitFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitBare.cValue(), GIT_REPOSITORY_INIT_BARE)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitNoReinit.cValue(), GIT_REPOSITORY_INIT_NO_REINIT)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitMkdir.cValue(), GIT_REPOSITORY_INIT_MKDIR)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitMkpath.cValue(), GIT_REPOSITORY_INIT_MKPATH)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitExternalTemplate.cValue(), GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE)
        XCTAssertEqual(GitRepositoryInitFlagT.gitRepositoryInitRelativeGitlink.cValue(), GIT_REPOSITORY_INIT_RELATIVE_GITLINK)
        
        XCTAssertEqual(GitRepositoryInitFlagT(cValue: GIT_REPOSITORY_INIT_BARE), .gitRepositoryInitBare)
        XCTAssertEqual(GitRepositoryInitFlagT(cValue: GIT_REPOSITORY_INIT_NO_REINIT), .gitRepositoryInitNoReinit)
        XCTAssertEqual(GitRepositoryInitFlagT(cValue: GIT_REPOSITORY_INIT_MKDIR), .gitRepositoryInitMkdir)
        XCTAssertEqual(GitRepositoryInitFlagT(cValue: GIT_REPOSITORY_INIT_MKPATH), .gitRepositoryInitMkpath)
        XCTAssertEqual(GitRepositoryInitFlagT(cValue: GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE), .gitRepositoryInitExternalTemplate)
        XCTAssertEqual(GitRepositoryInitFlagT(cValue: GIT_REPOSITORY_INIT_RELATIVE_GITLINK), .gitRepositoryInitRelativeGitlink)
        
        
        
        let flags: GitRepositoryInitFlagT =
        [
            .gitRepositoryInitNoReinit,
            .gitRepositoryInitMkdir
        ]
        
        XCTAssertTrue(flags.contains(.gitRepositoryInitNoReinit))
        XCTAssertTrue(flags.contains(.gitRepositoryInitMkdir))
        XCTAssertFalse(flags.contains(.gitRepositoryInitMkpath))
    }
    
    
    
    func testGitRepositoryInitModeT() throws
    {
        XCTAssertEqual(GitRepositoryInitModeT.gitRepositoryInitSharedUmask.rawValue, GIT_REPOSITORY_INIT_SHARED_UMASK.rawValue)
        XCTAssertEqual(GitRepositoryInitModeT.gitRepositoryInitSharedGroup.rawValue, GIT_REPOSITORY_INIT_SHARED_GROUP.rawValue)
        XCTAssertEqual(GitRepositoryInitModeT.gitRepositoryInitSharedAll.rawValue, GIT_REPOSITORY_INIT_SHARED_ALL.rawValue)
        
        XCTAssertNil(GitRepositoryInitModeT(rawValue: 123))
        
        XCTAssertEqual(GitRepositoryInitModeT.gitRepositoryInitSharedUmask.cValue(), GIT_REPOSITORY_INIT_SHARED_UMASK)
        XCTAssertEqual(GitRepositoryInitModeT.gitRepositoryInitSharedGroup.cValue(), GIT_REPOSITORY_INIT_SHARED_GROUP)
        XCTAssertEqual(GitRepositoryInitModeT.gitRepositoryInitSharedAll.cValue(), GIT_REPOSITORY_INIT_SHARED_ALL)
        
        XCTAssertEqual(GitRepositoryInitModeT(cValue: GIT_REPOSITORY_INIT_SHARED_UMASK), .gitRepositoryInitSharedUmask)
        XCTAssertEqual(GitRepositoryInitModeT(cValue: GIT_REPOSITORY_INIT_SHARED_GROUP), .gitRepositoryInitSharedGroup)
        XCTAssertEqual(GitRepositoryInitModeT(cValue: GIT_REPOSITORY_INIT_SHARED_ALL), .gitRepositoryInitSharedAll)
    }
    
    
    
    func testGitRepositoryInitOptions() throws
    {
        let repositoryInitOptions = GitRepositoryInitOptions()
        
        XCTAssertEqual(repositoryInitOptions.version, gitRepositoryInitOptionsVersion)
        XCTAssertEqual(repositoryInitOptions.flags, [])
        XCTAssertEqual(repositoryInitOptions.mode, .gitRepositoryInitSharedUmask)
        XCTAssertNil(repositoryInitOptions.workdirPath)
        XCTAssertNil(repositoryInitOptions.description)
        XCTAssertNil(repositoryInitOptions.templatePath)
        XCTAssertNil(repositoryInitOptions.initialHEAD)
        XCTAssertNil(repositoryInitOptions.originURL)
        
        try repositoryInitOptions.withCValue
        {
            cRepositoryInitOptions in
            
            XCTAssertEqual(cRepositoryInitOptions.pointee.version, gitRepositoryInitOptionsVersion)
            XCTAssertEqual(GitRepositoryInitFlagT(rawValue: cRepositoryInitOptions.pointee.flags), [])
            XCTAssertEqual(GitRepositoryInitModeT(rawValue: cRepositoryInitOptions.pointee.mode), .gitRepositoryInitSharedUmask)
            XCTAssertNil(cRepositoryInitOptions.pointee.workdir_path)
            XCTAssertNil(cRepositoryInitOptions.pointee.description)
            XCTAssertNil(cRepositoryInitOptions.pointee.template_path)
            XCTAssertNil(cRepositoryInitOptions.pointee.initial_head)
            XCTAssertNil(cRepositoryInitOptions.pointee.origin_url)
        }
    }
    
    
    
    func testGitRepositoryInitOptionsInit() throws
    {
        var repoInitOptions = git_repository_init_options()
        
        let repoInitOptionsInitResult: GitErrorCode
            = gitRepositoryInitOptionsInit(
                opts:       &repoInitOptions,
                version:    gitRepositoryInitOptionsVersion
            )
        
        XCTAssertOK(repoInitOptionsInitResult)
    }
    
    
    
    func testGitRepositoryInitOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRepositoryInitOptionsVersion), GIT_REPOSITORY_INIT_OPTIONS_VERSION)
    }
    
    
    
    func testGitRepositoryIsBare() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let isBare: Bool = gitRepositoryIsBare(repo: repository.pointer)
            
            XCTAssertFalse(isBare)
        }
    }
    
    
    
    func testGitRepositoryIsEmpty() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let isEmpty: Bool? = gitRepositoryIsEmpty(repo: repository.pointer)
            
            XCTAssertNotNil(isEmpty)
            XCTAssertFalse(isEmpty ?? true)
        }
    }
    
    
    
    func testGitRepositoryIsShallow() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let isShallow: Bool?
                = gitRepositoryIsShallow(repo: repository.pointer)
            
            XCTAssertNotNil(isShallow)
            XCTAssertFalse(isShallow ?? true)
        }
    }
    
    
    func testGitRepositoryIsWorktree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let isWorktree: Bool
                = gitRepositoryIsWorktree(repo: repository.pointer)
            
            XCTAssertFalse(isWorktree)
        }
    }
    
    
    
    func testGitRepositoryItemPath() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var itemPathData = Data()
            
            var repoItemPathResult: GitErrorCode = gitRepositoryItemPath(
                out:    &itemPathData,
                repo:   repository.pointer,
                item:   .gitRepositoryItemIndex
            )
            
            XCTAssertOK(repoItemPathResult)
            
            guard let indexPathString = String(
                bytes:      itemPathData,
                encoding:   .utf8
            )
            else
            {
                XCTFail("The index path string was nil.")
                return
            }
            
            XCTAssertTrue(indexPathString.contains("index"))
            
            
            
            itemPathData = Data()
            
            repoItemPathResult = gitRepositoryItemPath(
                out:    &itemPathData,
                repo:   repository.pointer,
                item:   .gitRepositoryItemGitDir
            )
            
            XCTAssertOK(repoItemPathResult)
            
            guard let gitDirPathString = String(
                bytes:      itemPathData,
                encoding:   .utf8
            )
            else
            {
                XCTFail("The Git directory path string was nil.")
                return
            }
            
            XCTAssertTrue(gitDirPathString.contains(".git"))
        }
    }
    
    
    
    func testGitRepositoryItemT() throws
    {
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemGitDir.rawValue, GIT_REPOSITORY_ITEM_GITDIR.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemWorkdir.rawValue, GIT_REPOSITORY_ITEM_WORKDIR.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemCommonDir.rawValue, GIT_REPOSITORY_ITEM_COMMONDIR.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemIndex.rawValue, GIT_REPOSITORY_ITEM_INDEX.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemObjects.rawValue, GIT_REPOSITORY_ITEM_OBJECTS.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemRefs.rawValue, GIT_REPOSITORY_ITEM_REFS.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemPackedRefs.rawValue, GIT_REPOSITORY_ITEM_PACKED_REFS.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemRemotes.rawValue, GIT_REPOSITORY_ITEM_REMOTES.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemConfig.rawValue, GIT_REPOSITORY_ITEM_CONFIG.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemInfo.rawValue, GIT_REPOSITORY_ITEM_INFO.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemHooks.rawValue, GIT_REPOSITORY_ITEM_HOOKS.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemLogs.rawValue, GIT_REPOSITORY_ITEM_LOGS.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemModules.rawValue, GIT_REPOSITORY_ITEM_MODULES.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemWorktrees.rawValue, GIT_REPOSITORY_ITEM_WORKTREES.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemWorktreeConfig.rawValue, GIT_REPOSITORY_ITEM_WORKTREE_CONFIG.rawValue)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemLast.rawValue, GIT_REPOSITORY_ITEM__LAST.rawValue)
        
        XCTAssertNil(GitRepositoryItemT(rawValue: 123))
        
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemGitDir.cValue(), GIT_REPOSITORY_ITEM_GITDIR)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemWorkdir.cValue(), GIT_REPOSITORY_ITEM_WORKDIR)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemCommonDir.cValue(), GIT_REPOSITORY_ITEM_COMMONDIR)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemIndex.cValue(), GIT_REPOSITORY_ITEM_INDEX)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemObjects.cValue(), GIT_REPOSITORY_ITEM_OBJECTS)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemRefs.cValue(), GIT_REPOSITORY_ITEM_REFS)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemPackedRefs.cValue(), GIT_REPOSITORY_ITEM_PACKED_REFS)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemRemotes.cValue(), GIT_REPOSITORY_ITEM_REMOTES)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemConfig.cValue(), GIT_REPOSITORY_ITEM_CONFIG)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemInfo.cValue(), GIT_REPOSITORY_ITEM_INFO)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemHooks.cValue(), GIT_REPOSITORY_ITEM_HOOKS)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemLogs.cValue(), GIT_REPOSITORY_ITEM_LOGS)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemModules.cValue(), GIT_REPOSITORY_ITEM_MODULES)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemWorktrees.cValue(), GIT_REPOSITORY_ITEM_WORKTREES)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemWorktreeConfig.cValue(), GIT_REPOSITORY_ITEM_WORKTREE_CONFIG)
        XCTAssertEqual(GitRepositoryItemT.gitRepositoryItemLast.cValue(), GIT_REPOSITORY_ITEM__LAST)
        
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_GITDIR), .gitRepositoryItemGitDir)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_WORKDIR), .gitRepositoryItemWorkdir)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_COMMONDIR), .gitRepositoryItemCommonDir)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_INDEX), .gitRepositoryItemIndex)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_OBJECTS), .gitRepositoryItemObjects)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_REFS), .gitRepositoryItemRefs)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_PACKED_REFS), .gitRepositoryItemPackedRefs)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_REMOTES), .gitRepositoryItemRemotes)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_CONFIG), .gitRepositoryItemConfig)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_INFO), .gitRepositoryItemInfo)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_HOOKS), .gitRepositoryItemHooks)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_LOGS), .gitRepositoryItemLogs)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_MODULES), .gitRepositoryItemModules)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_WORKTREES), .gitRepositoryItemWorktrees)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM_WORKTREE_CONFIG), .gitRepositoryItemWorktreeConfig)
        XCTAssertEqual(GitRepositoryItemT(cValue: GIT_REPOSITORY_ITEM__LAST), .gitRepositoryItemLast)
    }
    
    
    
    func testGitRepositoryMERGEHEADForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = repository.headOID
            
            guard let headOIDString: String = gitOIDToStrS(oid: headOID)
            else
            {
                XCTFail("The HEAD OID string was nil.")
                return
            }
            
            
            
            let mergeheadURL: URL = repository.url.appending(
                path:           ".git/MERGE_HEAD",
                directoryHint:  .notDirectory
            )
            
            let mergeheadContent: String = "\(headOIDString)\n"
            
            try mergeheadContent.atomicWrite(to: mergeheadURL)
            
            
            
            var callbackData = CallbackData()
            
            let mergeheadForEachCB: GitRepositoryMERGEHEADForEachCB =
            {
                oid, payload in
                
                guard
                    let oid     : UnsafePointer<git_oid>    = oid,
                    let payload : UnsafeMutableRawPointer   = payload
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount    += 1
                payloadPointer.pointee.lastOID      = GitOID(cValue: oid.pointee)
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let mergeheadForEachResult: GitErrorCode
                    = gitRepositoryMERGEHEADForEach(
                        repo:       repository.pointer,
                        callback:   mergeheadForEachCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(mergeheadForEachResult)
            }
            
            XCTAssertEqual(callbackData.callCount, 1)
            XCTAssertEqual(callbackData.lastOID, headOID)
        }
    }
    
    
    
    func testGitRepositoryMessageAndRemove() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let mergeMessageURL: URL = repository.url.appending(
                path:           ".git/MERGE_MSG",
                directoryHint:  .notDirectory
            )
            
            let mergeMessage: String = "Merge branch 'feature' into main"
            
            try mergeMessage.atomicWrite(to: mergeMessageURL)
            
            
            
            var messageData = Data()
            
            let repoMessageResult: GitErrorCode = gitRepositoryMessage(
                out:    &messageData,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoMessageResult)
            XCTAssertEqual(messageData, mergeMessage)
            
            
            
            let repoMessageRemoveResult: GitErrorCode
                = gitRepositoryMessageRemove(repo: repository.pointer)
            
            XCTAssertOK(repoMessageRemoveResult)
            
            
            
            let mergeMessageURLExists: Bool
                = FileManager.default.fileExists(
                    atPath: mergeMessageURL.path()
                )
            
            XCTAssertFalse(mergeMessageURLExists)
        }
    }
    
    
    
    func testGitRepositoryODB() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var odbPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
            }
            
            
            
            let repoODBResult: GitErrorCode = gitRepositoryODB(
                out:    &odbPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoODBResult)
            XCTAssertNotNil(odbPointer)
        }
    }
    
    
    
    func testGitRepositoryOIDType() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let oidType: GitOIDT?
                = gitRepositoryOIDType(repo: repository.pointer)
            
            XCTAssertNotNil(oidType)
            XCTAssertEqual(oidType, .gitOIDSHA1)
        }
    }
    
    
    
    func testGitRepositoryOpen() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var repoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: repoPointer)
            }
            
            
            
            let repoOpenResult: GitErrorCode = gitRepositoryOpen(
                out:    &repoPointer,
                path:   repository.url.path()
            )
            
            XCTAssertOK(repoOpenResult)
            
            guard let repoPointer: OpaquePointer = repoPointer
            else
            {
                XCTFail("The repository pointer was nil.")
                return
            }
            
            
            
            let isBare: Bool = gitRepositoryIsBare(repo: repoPointer)
            
            XCTAssertFalse(isBare)
        }
    }
    
    
    
    func testGitRepositoryOpenBare() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var repoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: repoPointer)
            }
            
            
            
            let gitDirURL: URL = repository.url.appending(
                component:      ".git",
                directoryHint:  .isDirectory
            )
            
            let repoOpenBareResult: GitErrorCode = gitRepositoryOpenBare(
                out:        &repoPointer,
                barePath:   gitDirURL.path()
            )
            
            XCTAssertOK(repoOpenBareResult)
            
            guard let repoPointer: OpaquePointer = repoPointer
            else
            {
                XCTFail("The repository pointer was nil.")
                return
            }
            
            
            
            let isBare: Bool = gitRepositoryIsBare(repo: repoPointer)
            
            XCTAssertTrue(isBare)
        }
    }
    
    
    
    func testGitRepositoryOpenExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var repoPointer: OpaquePointer? = nil
            
            defer
            {
                gitRepositoryFree(repo: repoPointer)
            }
            
            
            
            let repoOpenExtResult: GitErrorCode = gitRepositoryOpenExt(
                out:            &repoPointer,
                path:           repository.url.path(),
                flags:          .gitRepositoryOpenNoSearch,
                ceilingDirs:    nil
            )
            
            XCTAssertOK(repoOpenExtResult)
            XCTAssertNotNil(repoPointer)
        }
    }
    
    
    
    func testGitRepositoryOpenFlagT() throws
    {
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenNoSearch.rawValue, GIT_REPOSITORY_OPEN_NO_SEARCH.rawValue)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenCrossFS.rawValue, GIT_REPOSITORY_OPEN_CROSS_FS.rawValue)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenBare.rawValue, GIT_REPOSITORY_OPEN_BARE.rawValue)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenNoDotGit.rawValue, GIT_REPOSITORY_OPEN_NO_DOTGIT.rawValue)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenFromEnv.rawValue, GIT_REPOSITORY_OPEN_FROM_ENV.rawValue)
        
        XCTAssertEqual(GitRepositoryOpenFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenNoSearch.cValue(), GIT_REPOSITORY_OPEN_NO_SEARCH)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenCrossFS.cValue(), GIT_REPOSITORY_OPEN_CROSS_FS)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenBare.cValue(), GIT_REPOSITORY_OPEN_BARE)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenNoDotGit.cValue(), GIT_REPOSITORY_OPEN_NO_DOTGIT)
        XCTAssertEqual(GitRepositoryOpenFlagT.gitRepositoryOpenFromEnv.cValue(), GIT_REPOSITORY_OPEN_FROM_ENV)
        
        XCTAssertEqual(GitRepositoryOpenFlagT(cValue: GIT_REPOSITORY_OPEN_NO_SEARCH), .gitRepositoryOpenNoSearch)
        XCTAssertEqual(GitRepositoryOpenFlagT(cValue: GIT_REPOSITORY_OPEN_CROSS_FS), .gitRepositoryOpenCrossFS)
        XCTAssertEqual(GitRepositoryOpenFlagT(cValue: GIT_REPOSITORY_OPEN_BARE), .gitRepositoryOpenBare)
        XCTAssertEqual(GitRepositoryOpenFlagT(cValue: GIT_REPOSITORY_OPEN_NO_DOTGIT), .gitRepositoryOpenNoDotGit)
        XCTAssertEqual(GitRepositoryOpenFlagT(cValue: GIT_REPOSITORY_OPEN_FROM_ENV), .gitRepositoryOpenFromEnv)
        
        
        
        let flags: GitRepositoryOpenFlagT =
        [
            .gitRepositoryOpenCrossFS,
            .gitRepositoryOpenBare
        ]
        
        XCTAssertTrue(flags.contains(.gitRepositoryOpenCrossFS))
        XCTAssertTrue(flags.contains(.gitRepositoryOpenBare))
        XCTAssertFalse(flags.contains(.gitRepositoryOpenNoDotGit))
    }
    
    
    
    func testGitRepositoryOpenFromWorktree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let worktreeName: String = "test-worktree"
            
            let worktreeURL: URL
                = FileManager.default.temporaryDirectory
                    .appending(path: "worktree", directoryHint: .isDirectory)
                    .appendingPathExtension(UUID().uuidString)
            
            
            
            var worktreePointer : OpaquePointer?    = nil
            var repoPointer     : OpaquePointer?    = nil
            
            defer
            {
                try? FileManager.default.removeItem(at: worktreeURL)
                Free.freeWorktree(worktreePointer)
                gitRepositoryFree(repo: repoPointer)
            }
            
            
            
            let worktreeAddResult: Int32 = git_worktree_add(
                &worktreePointer,
                repository.pointer,
                worktreeName,
                worktreeURL.path(),
                nil
            )
            
            XCTAssertOK(GitErrorCode(rawValue: worktreeAddResult))
            
            guard let worktreePointer: OpaquePointer = worktreePointer
            else
            {
                XCTFail("The worktree pointer was nil.")
                return
            }
            
            
            
            let repoOpenFromWorktreeResult: GitErrorCode
                = gitRepositoryOpenFromWorktree(
                    out:    &repoPointer,
                    wt:     worktreePointer
                )
            
            XCTAssertOK(repoOpenFromWorktreeResult)
            
            guard let repoPointer: OpaquePointer = repoPointer
            else
            {
                XCTFail("The repository pointer was nil.")
                return
            }
            
            
            
            let isWorktree: Bool = gitRepositoryIsWorktree(repo: repoPointer)
            
            XCTAssertTrue(isWorktree)
        }
    }
    
    
    
    func testGitRepositoryPath() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoPath: String? = gitRepositoryPath(repo: repository.pointer)
            
            XCTAssertNotNil(repoPath)
            XCTAssertTrue(repoPath?.hasSuffix(".git/") ?? false)
        }
    }
    
    
    
    func testGitRepositoryRefDB() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var refDBPointer: OpaquePointer? = nil
            
            defer
            {
                gitRefDBFree(refDB: refDBPointer)
            }
            
            
            
            let repoRefDBResult: GitErrorCode = gitRepositoryRefDB(
                out:    &refDBPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoRefDBResult)
            XCTAssertNotNil(refDBPointer)
        }
    }
    
    
    
    func testGitRepositorySetAndGetNamespace() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let namespace: String = "test-namespace"
            
            let repoSetNamespaceResult: GitErrorCode
                = gitRepositorySetNamespace(
                    repo:       repository.pointer,
                    nmspace:    namespace
                )
            
            XCTAssertOK(repoSetNamespaceResult)
            
            
            
            let retrievedNamespace: String?
                = gitRepositoryGetNamespace(repo: repository.pointer)
            
            XCTAssertNotNil(retrievedNamespace)
            XCTAssertEqual(retrievedNamespace, namespace)
        }
    }
    
    
    
    func testGitRepositorySetHEAD() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let branchName      : String    = "feature"
            let branchFullName  : String    = "refs/heads/\(branchName)"
            
            try Branch.createLocalBranch(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let repoSetHEADResult: GitErrorCode = gitRepositorySetHEAD(
                repo:       repository.pointer,
                refName:    branchFullName
            )
            
            XCTAssertOK(repoSetHEADResult)
            
            
            
            var headPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: headPointer)
            }
            
            
            
            let refLookupResult: GitErrorCode = gitReferenceLookup(
                out:    &headPointer,
                repo:   repository.pointer,
                name:   "HEAD"
            )
            
            XCTAssertOK(refLookupResult)
            
            guard let headPointer: OpaquePointer = headPointer
            else
            {
                XCTFail("The HEAD pointer was nil.")
                return
            }
            
            
            
            let refType: GitReferenceT? = gitReferenceType(ref: headPointer)
            
            XCTAssertNotNil(refType)
            XCTAssertEqual(refType, .gitReferenceSymbolic)
            
            
            let refSymbolicTarget: String?
                = gitReferenceSymbolicTarget(ref: headPointer)
            
            XCTAssertNotNil(refSymbolicTarget)
            XCTAssertEqual(refSymbolicTarget, branchFullName)
        }
    }
    
    
    
    func testGitRepositorySetHEADDetached() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoSetHEADDetachedResult: GitErrorCode
                = gitRepositorySetHEADDetached(
                    repo:           repository.pointer,
                    committish:     repository.headOID
                )
            
            XCTAssertOK(repoSetHEADDetachedResult)
            
            
            
            let isDetached: Bool?
                = gitRepositoryHEADDetached(repo: repository.pointer)
            
            XCTAssertNotNil(isDetached)
            XCTAssertTrue(isDetached ?? false)
        }
    }
    
    
    
    func testGitRepositorySetHEADDetachedFromAnnotated() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            }
            
            
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     repository.headOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let repoSetHEADDetachedFromAnnotatedResult: GitErrorCode
                = gitRepositorySetHEADDetachedFromAnnotated(
                    repo:           repository.pointer,
                    committish:     annotatedCommitPointer
                )
            
            XCTAssertOK(repoSetHEADDetachedFromAnnotatedResult)
            
            
            
            let isDetached: Bool?
                = gitRepositoryHEADDetached(repo: repository.pointer)
            
            XCTAssertNotNil(isDetached)
            XCTAssertTrue(isDetached ?? false)
        }
    }
    
    
    
    func testGitRepositorySetWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let newWorkdirURL: URL
                = try Repository.createTemporaryDirectory(named: "NewWorkdir")
            
            defer
            {
                try? FileManager.default.removeItem(at: newWorkdirURL)
            }
            
            
            
            let repoSetWorkdirResult: GitErrorCode = gitRepositorySetWorkdir(
                repo:           repository.pointer,
                workdir:        newWorkdirURL.path(),
                updateGitlink:  true
            )
            
            XCTAssertOK(repoSetWorkdirResult)
            
            
            
            let updatedWorkdirPath: String?
                = gitRepositoryWorkdir(repo: repository.pointer)
            
            XCTAssertNotNil(updatedWorkdirPath)
            XCTAssertTrue(updatedWorkdirPath?.contains(newWorkdirURL.lastPathComponent) ?? false)
        }
    }
    
    
    
    func testGitRepositoryState() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoState: GitRepositoryStateT?
                = gitRepositoryState(repo: repository.pointer)
            
            XCTAssertNotNil(repoState)
            XCTAssertEqual(repoState, .gitRepositoryStateNone)
        }
    }
    
    
    
    func testGitRepositoryStateCleanup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoStateCleanupResult: GitErrorCode
                = gitRepositoryStateCleanup(repo: repository.pointer)
            
            XCTAssertOK(repoStateCleanupResult)
        }
    }
    
    
    
    func testGitRepositoryStateT() throws
    {
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateNone.rawValue, GIT_REPOSITORY_STATE_NONE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateMerge.rawValue, GIT_REPOSITORY_STATE_MERGE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRevert.rawValue, GIT_REPOSITORY_STATE_REVERT.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRevertSequence.rawValue, GIT_REPOSITORY_STATE_REVERT_SEQUENCE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateCherrypick.rawValue, GIT_REPOSITORY_STATE_CHERRYPICK.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateCherrypickSequence.rawValue, GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateBisect.rawValue, GIT_REPOSITORY_STATE_BISECT.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRebase.rawValue, GIT_REPOSITORY_STATE_REBASE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRebaseInteractive.rawValue, GIT_REPOSITORY_STATE_REBASE_INTERACTIVE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRebaseMerge.rawValue, GIT_REPOSITORY_STATE_REBASE_MERGE.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateApplyMailbox.rawValue, GIT_REPOSITORY_STATE_APPLY_MAILBOX.rawValue)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateApplyMailboxOrRebase.rawValue, GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE.rawValue)
        
        XCTAssertNil(GitRepositoryStateT(rawValue: 123))
        
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateNone.cValue(), GIT_REPOSITORY_STATE_NONE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateMerge.cValue(), GIT_REPOSITORY_STATE_MERGE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRevert.cValue(), GIT_REPOSITORY_STATE_REVERT)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRevertSequence.cValue(), GIT_REPOSITORY_STATE_REVERT_SEQUENCE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateCherrypick.cValue(), GIT_REPOSITORY_STATE_CHERRYPICK)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateCherrypickSequence.cValue(), GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateBisect.cValue(), GIT_REPOSITORY_STATE_BISECT)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRebase.cValue(), GIT_REPOSITORY_STATE_REBASE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRebaseInteractive.cValue(), GIT_REPOSITORY_STATE_REBASE_INTERACTIVE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateRebaseMerge.cValue(), GIT_REPOSITORY_STATE_REBASE_MERGE)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateApplyMailbox.cValue(), GIT_REPOSITORY_STATE_APPLY_MAILBOX)
        XCTAssertEqual(GitRepositoryStateT.gitRepositoryStateApplyMailboxOrRebase.cValue(), GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE)
        
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_NONE), .gitRepositoryStateNone)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_MERGE), .gitRepositoryStateMerge)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_REVERT), .gitRepositoryStateRevert)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_REVERT_SEQUENCE), .gitRepositoryStateRevertSequence)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_CHERRYPICK), .gitRepositoryStateCherrypick)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE), .gitRepositoryStateCherrypickSequence)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_BISECT), .gitRepositoryStateBisect)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_REBASE), .gitRepositoryStateRebase)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_REBASE_INTERACTIVE), .gitRepositoryStateRebaseInteractive)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_REBASE_MERGE), .gitRepositoryStateRebaseMerge)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_APPLY_MAILBOX), .gitRepositoryStateApplyMailbox)
        XCTAssertEqual(GitRepositoryStateT(cValue: GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE), .gitRepositoryStateApplyMailboxOrRebase)
    }
    
    
    
    func testGitRepositoryWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let workdirPath: String?
                = gitRepositoryWorkdir(repo: repository.pointer)
            
            XCTAssertNotNil(workdirPath)
            XCTAssertTrue(workdirPath?.contains(repository.url.lastPathComponent) ?? false)
        }
    }
    
    
    
    func testGitRepositoryWrapODB() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var odbPointer  : OpaquePointer?    = nil
            var repoPointer : OpaquePointer?    = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
                gitRepositoryFree(repo: repoPointer)
            }
            
            
            
            let repoODBResult: GitErrorCode = gitRepositoryODB(
                out:    &odbPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoODBResult)
            
            guard let odbPointer: OpaquePointer = odbPointer
            else
            {
                XCTFail("The ODB pointer was nil.")
                return
            }
            
            
            
            let repoWrapODBResult: GitErrorCode = gitRepositoryWrapODB(
                out:    &repoPointer,
                odb:    odbPointer
            )
            
            XCTAssertOK(repoWrapODBResult)
            
            guard let repoPointer: OpaquePointer = repoPointer
            else
            {
                XCTFail("The repository pointer was nil.")
                return
            }
            
            
            
            let repoPath: String? = gitRepositoryPath(repo: repoPointer)
            
            XCTAssertNil(repoPath)
        }
    }
}



// MARK: - Extensions

private extension RepositoryTests
{
    struct CallbackData
    {
        var callCount   : Int       = 0
        var lastURL     : String?   = nil
        var lastOID     : GitOID    = GitOID()
    }
}
