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



final class CheckoutTests: XCTestCaseStopOnFail
{
    // MARK: - testGitCheckoutCallbacks()
    
    func testGitCheckoutCallbacks() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    "Modified content 1"
            )
            
            try repository.modifyFile(
                path:       "file2.txt",
                content:    "New file content 2"
            )
            
            try repository.modifyFile(
                path:       "file3.txt",
                content:    "New file content 3"
            )
            
            
            
            var callbackData = CheckoutCallbackData()
            
            let notifyCB: GitCheckoutNotifyCB =
            {
                why, path, baseline, target, workdir, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GIT_OK.rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CheckoutCallbackData>
                    = payload.assumingMemoryBound(to: CheckoutCallbackData.self)
                
                payloadPointer.pointee.notifyCallCount      += 1
                payloadPointer.pointee.lastNotifyReason     = GitCheckoutNotifyT(rawValue: why.rawValue)
                
                if let path: UnsafePointer<CChar> = path
                {
                    payloadPointer.pointee.lastNotifyPath = String(cString: path)
                }
                
                return GIT_OK.rawValue
            }
            
            
            
            let progressCB: GitCheckoutProgressCB =
            {
                path, completedSteps, totalSteps, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return
                }
                
                let payloadPointer: UnsafeMutablePointer<CheckoutCallbackData>
                    = payload.assumingMemoryBound(to: CheckoutCallbackData.self)
                
                payloadPointer.pointee.progressCallCount    += 1
                payloadPointer.pointee.lastCompletedSteps   = completedSteps
                payloadPointer.pointee.lastTotalSteps       = totalSteps
                
                if let path: UnsafePointer<CChar> = path
                {
                    payloadPointer.pointee.lastPath = String(cString: path)
                }
            }
            
            
            
            let perfDataCB: GitCheckoutPerfDataCB =
            {
                perfData, payload in
                
                guard
                    let perfData    : UnsafePointer<git_checkout_perfdata>  = perfData,
                    let payload     : UnsafeMutableRawPointer               = payload
                else
                {
                    return
                }
                
                let payloadPointer: UnsafeMutablePointer<CheckoutCallbackData>
                    = payload.assumingMemoryBound(to: CheckoutCallbackData.self)
                
                payloadPointer.pointee.perfDataCallCount    += 1
                payloadPointer.pointee.lastPerfData         = GitCheckoutPerfData(cValue: perfData.pointee)
            }
            
            
            
            try withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var checkoutOptions = try GitCheckoutOptions()
                
                checkoutOptions.checkoutStrategy    = .gitCheckoutForce
                checkoutOptions.notifyFlags         = .gitCheckoutNotifyUpdated
                checkoutOptions.notifyCB            = notifyCB
                checkoutOptions.notifyPayload       = UnsafeMutableRawPointer(callbackDataPointer)
                checkoutOptions.progressCB          = progressCB
                checkoutOptions.progressPayload     = UnsafeMutableRawPointer(callbackDataPointer)
                checkoutOptions.perfDataCB          = perfDataCB
                checkoutOptions.perfDataPayload     = UnsafeMutableRawPointer(callbackDataPointer)
                
                let checkoutResult: Int32 = gitCheckoutHEAD(
                    repo:   repository.pointer,
                    opts:   checkoutOptions
                )
                
                XCTAssertOK(checkoutResult)
            }
            
            
            
            XCTAssertGreaterThan(callbackData.notifyCallCount, 0)
            XCTAssertNotNil(callbackData.lastNotifyPath)
            XCTAssertEqual(callbackData.lastNotifyReason, .gitCheckoutNotifyUpdated)
            
            XCTAssertGreaterThan(callbackData.progressCallCount, 0)
            XCTAssertGreaterThanOrEqual(callbackData.lastCompletedSteps, 0)
            XCTAssertGreaterThan(callbackData.lastTotalSteps, 0)
            XCTAssertNotNil(callbackData.lastPath)
            
            XCTAssertGreaterThan(callbackData.perfDataCallCount, 0)
            
            guard let perfData: GitCheckoutPerfData = callbackData.lastPerfData
            else
            {
                XCTFail("The checkout performance data was nil.")
                return
            }
            
            XCTAssertGreaterThanOrEqual(perfData.statCalls, 0)
        }
    }
    
    
    
    // MARK: - testGitCheckoutHEAD()
    
    func testGitCheckoutHEAD() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let content: String = "Modified content for HEAD checkout."
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            
            
            var checkoutOptions = try GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var checkoutHEADResult: Int32 = gitCheckoutHEAD(
                repo:   repository.pointer,
                opts:   checkoutOptions
            )
            
            XCTAssertOK(checkoutHEADResult)
            
            
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    Repository.readmeFileContent
            )
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            
            
            /// Checking out without options will default to using safe checkout.
            checkoutHEADResult = gitCheckoutHEAD(
                repo:   repository.pointer,
                opts:   nil
            )
            
            XCTAssertOK(checkoutHEADResult)
            
            
            
            /// The safe checkout will not overwrite uncommitted changes.
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    content
            )
        }
    }
    
    
    
    // MARK: - testGitCheckoutIndex()
    
    func testGitCheckoutIndex() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeIndex(indexPointer)
            }
            
            
            
            let repositoryIndexResult: Int32 = git_repository_index(
                &indexPointer,
                repository.pointer
            )
            
            XCTAssertOK(repositoryIndexResult)
            
            
            
            let content: String = "Modified content for index checkout."
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            
            
            var checkoutOptions = try GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var checkoutIndexResult: Int32 = gitCheckoutIndex(
                repo:   repository.pointer,
                index:  indexPointer,
                opts:   checkoutOptions
            )
            
            XCTAssertOK(checkoutIndexResult)
            
            
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    Repository.readmeFileContent
            )
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            
            
            /// Checking out without options will default to using safe checkout.
            /// This will also default to using the repository index.
            checkoutIndexResult = gitCheckoutIndex(
                repo:   repository.pointer,
                index:  nil,
                opts:   nil
            )
            
            XCTAssertOK(checkoutIndexResult)
            
            
            
            /// The safe checkout will not overwrite uncommitted changes.
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    content
            )
        }
    }
    
    
    
    // MARK: - testGitCheckoutNotifyT()
    
    func testGitCheckoutNotifyT() throws
    {
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyNone.rawValue, GIT_CHECKOUT_NOTIFY_NONE.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyConflict.rawValue, GIT_CHECKOUT_NOTIFY_CONFLICT.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyDirty.rawValue, GIT_CHECKOUT_NOTIFY_DIRTY.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyUpdated.rawValue, GIT_CHECKOUT_NOTIFY_UPDATED.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyUntracked.rawValue, GIT_CHECKOUT_NOTIFY_UNTRACKED.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyIgnored.rawValue, GIT_CHECKOUT_NOTIFY_IGNORED.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyAll.rawValue, GIT_CHECKOUT_NOTIFY_ALL.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT(rawValue: 123).rawValue, 123)
        
        
        
        let flags: GitCheckoutNotifyT =
        [
            .gitCheckoutNotifyDirty,
            .gitCheckoutNotifyConflict
        ]
        
        XCTAssertTrue(flags.contains(.gitCheckoutNotifyDirty))
        XCTAssertTrue(flags.contains(.gitCheckoutNotifyConflict))
        XCTAssertFalse(flags.contains(.gitCheckoutNotifyIgnored))
    }
    
    
    
    // MARK: - testGitCheckoutOptions()
    
    func testGitCheckoutOptions() throws
    {
        var checkoutOptions = try GitCheckoutOptions()
        
        /// `dirMode`, `fileMode`, and `fileOpenFlags` are zero-initialized.
        /// The documentation defaults refer to runtime defaults set in `checkout_data_init()`
        /// and `blob_content_to_file()`.
        XCTAssertEqual(checkoutOptions.version, gitCheckoutOptionsVersion)
        XCTAssertEqual(checkoutOptions.checkoutStrategy, .gitCheckoutSafe)
        XCTAssertFalse(checkoutOptions.disableFilters)
        XCTAssertEqual(checkoutOptions.dirMode, 0)
        XCTAssertEqual(checkoutOptions.fileMode, 0)
        XCTAssertEqual(checkoutOptions.fileOpenFlags, 0)
        XCTAssertEqual(checkoutOptions.notifyFlags, .gitCheckoutNotifyNone)
        XCTAssertNil(checkoutOptions.notifyCB)
        XCTAssertNil(checkoutOptions.notifyPayload)
        XCTAssertNil(checkoutOptions.progressCB)
        XCTAssertNil(checkoutOptions.progressPayload)
        XCTAssertNotNil(checkoutOptions.paths)
        XCTAssertNil(checkoutOptions.baseline)
        XCTAssertNil(checkoutOptions.baselineIndex)
        XCTAssertNil(checkoutOptions.targetDirectory)
        XCTAssertNil(checkoutOptions.ancestorLabel)
        XCTAssertNil(checkoutOptions.ourLabel)
        XCTAssertNil(checkoutOptions.theirLabel)
        XCTAssertNil(checkoutOptions.perfDataCB)
        XCTAssertNil(checkoutOptions.perfDataPayload)
        
        XCTAssertEqual(gitCheckoutOptionsVersion, UInt32(GIT_CHECKOUT_OPTIONS_VERSION))
        
        
        
        checkoutOptions.checkoutStrategy = GitCheckoutStrategyT(rawValue: 123)
        
        XCTAssertEqual(checkoutOptions.checkoutStrategy, GitCheckoutStrategyT(rawValue: 123))
        
        
        
        checkoutOptions.checkoutStrategy = .gitCheckoutForce
        
        XCTAssertEqual(checkoutOptions.checkoutStrategy, .gitCheckoutForce)
        
        
        
        checkoutOptions.checkoutStrategy =
        [
            .gitCheckoutSafe,
            .gitCheckoutRecreateMissing
        ]
        
        XCTAssertTrue(checkoutOptions.checkoutStrategy.contains(.gitCheckoutSafe))
        XCTAssertTrue(checkoutOptions.checkoutStrategy.contains(.gitCheckoutRecreateMissing))
        XCTAssertFalse(checkoutOptions.checkoutStrategy.contains(.gitCheckoutRemoveIgnored))
        
        
        
        checkoutOptions.notifyFlags = GitCheckoutNotifyT(rawValue: 123)
        
        XCTAssertEqual(checkoutOptions.notifyFlags, GitCheckoutNotifyT(rawValue: 123))
        
        
        
        checkoutOptions.notifyFlags = .gitCheckoutNotifyConflict
        
        XCTAssertEqual(checkoutOptions.notifyFlags, .gitCheckoutNotifyConflict)
        
        
        
        checkoutOptions.notifyFlags =
        [
            .gitCheckoutNotifyUntracked,
            .gitCheckoutNotifyIgnored
        ]
        
        XCTAssertTrue(checkoutOptions.notifyFlags.contains(.gitCheckoutNotifyUntracked))
        XCTAssertTrue(checkoutOptions.notifyFlags.contains(.gitCheckoutNotifyIgnored))
        XCTAssertFalse(checkoutOptions.notifyFlags.contains(.gitCheckoutNotifyConflict))
        
        
        
        checkoutOptions.disableFilters = true
        
        XCTAssertTrue(checkoutOptions.disableFilters)
        
        
        
        checkoutOptions.dirMode = 0o644
        
        XCTAssertEqual(checkoutOptions.dirMode, 0o644)
    }
    
    
    
    // MARK: - testGitCheckoutPerfData()
    
    func testGitCheckoutPerfData() throws
    {
        var cPerfData = git_checkout_perfdata()
        
        cPerfData.mkdir_calls   = 1
        cPerfData.stat_calls    = 2
        cPerfData.chmod_calls   = 3
        
        
        
        let perfData = GitCheckoutPerfData(cValue: cPerfData)
        
        XCTAssertEqual(perfData.mkdirCalls, 1)
        XCTAssertEqual(perfData.statCalls, 2)
        XCTAssertEqual(perfData.chmodCalls, 3)
    }
    
    
    
    // MARK: - testGitCheckoutStrategyT()
    
    func testGitCheckoutStrategyT() throws
    {
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutSafe.rawValue, GIT_CHECKOUT_SAFE.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutForce.rawValue, GIT_CHECKOUT_FORCE.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutRecreateMissing.rawValue, GIT_CHECKOUT_RECREATE_MISSING.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutAllowConflicts.rawValue, GIT_CHECKOUT_ALLOW_CONFLICTS.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutRemoveUntracked.rawValue, GIT_CHECKOUT_REMOVE_UNTRACKED.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutRemoveIgnored.rawValue, GIT_CHECKOUT_REMOVE_IGNORED.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUpdateOnly.rawValue, GIT_CHECKOUT_UPDATE_ONLY.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontUpdateIndex.rawValue, GIT_CHECKOUT_DONT_UPDATE_INDEX.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutNoRefresh.rawValue, GIT_CHECKOUT_NO_REFRESH.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutSkipUnmerged.rawValue, GIT_CHECKOUT_SKIP_UNMERGED.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUseOurs.rawValue, GIT_CHECKOUT_USE_OURS.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUseTheirs.rawValue, GIT_CHECKOUT_USE_THEIRS.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDisablePathspecMatch.rawValue, GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutSkipLockedDirectories.rawValue, GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontOverwriteIgnored.rawValue, GIT_CHECKOUT_DONT_OVERWRITE_IGNORED.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutConflictStyleMerge.rawValue, GIT_CHECKOUT_CONFLICT_STYLE_MERGE.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutConflictStyleDiff3.rawValue, GIT_CHECKOUT_CONFLICT_STYLE_DIFF3.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontRemoveExisting.rawValue, GIT_CHECKOUT_DONT_REMOVE_EXISTING.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontWriteIndex.rawValue, GIT_CHECKOUT_DONT_WRITE_INDEX.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDryRun.rawValue, GIT_CHECKOUT_DRY_RUN.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutConflictStyleZDiff3.rawValue, GIT_CHECKOUT_CONFLICT_STYLE_ZDIFF3.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutNone.rawValue, GIT_CHECKOUT_NONE.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUpdateSubmodules.rawValue, GIT_CHECKOUT_UPDATE_SUBMODULES.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUpdateSubmodulesIfChanged.rawValue, GIT_CHECKOUT_UPDATE_SUBMODULES_IF_CHANGED.rawValue)
        XCTAssertEqual(GitCheckoutStrategyT(rawValue: 123).rawValue, 123)
        
        
        
        let flags: GitCheckoutStrategyT =
        [
            .gitCheckoutSafe,
            .gitCheckoutRecreateMissing
        ]
        
        XCTAssertTrue(flags.contains(.gitCheckoutSafe))
        XCTAssertTrue(flags.contains(.gitCheckoutRecreateMissing))
        XCTAssertFalse(flags.contains(.gitCheckoutSkipLockedDirectories))
    }
    
    
    
    // MARK: - testGitCheckoutTree()
    
    func testGitCheckoutTree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID         : GitOID            = OID.getHEADCommitOID(in: repository)
            var commitPointer   : OpaquePointer?    = nil
            var treePointer     : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
                Free.freeTree(treePointer)
            }
            
            
            
            var cHeadOID: git_oid = headOID.cValue
            
            let commitLookupResult: Int32 = git_commit_lookup(
                &commitPointer,
                repository.pointer,
                &cHeadOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            
            
            let commitTreeResult: Int32 = git_commit_tree(
                &treePointer,
                commitPointer
            )
            
            XCTAssertOK(commitTreeResult)
            
            
            
            let content: String = "Modified content for tree checkout."
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            
            
            var checkoutOptions = try GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var checkoutTreeResult: Int32 = gitCheckoutTree(
                repo:       repository.pointer,
                treeish:    treePointer,
                opts:       checkoutOptions
            )
            
            XCTAssertOK(checkoutTreeResult)
            
            
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    Repository.readmeFileContent
            )
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    content
            )
            
            
            
            /// Checking out without options will default to using safe checkout.
            /// This will also default to using HEAD.
            checkoutTreeResult = gitCheckoutTree(
                repo:       repository.pointer,
                treeish:    nil,
                opts:       nil
            )
            
            XCTAssertOK(checkoutTreeResult)
            
            
            
            /// The safe checkout will not overwrite uncommitted changes.
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    content
            )
        }
    }
}



extension CheckoutTests
{
    // MARK: - CheckoutCallbackData
    
    private struct CheckoutCallbackData
    {
        var notifyCallCount     : Int                   = 0
        var lastNotifyReason    : GitCheckoutNotifyT?   = nil
        var lastNotifyPath      : String?               = nil
        
        var progressCallCount   : Int                   = 0
        var lastCompletedSteps  : Int                   = 0
        var lastTotalSteps      : Int                   = 0
        var lastPath            : String?               = nil
        
        var perfDataCallCount   : Int                   = 0
        var lastPerfData        : GitCheckoutPerfData?  = nil
    }
}
