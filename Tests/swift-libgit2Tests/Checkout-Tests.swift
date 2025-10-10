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



final class CheckoutTests: XCTestCaseStopOnFail
{
    func testGitCheckoutCallbacks() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   "Modified content 1"
            )
            
            try repository.modifyFile(
                at:     "file2.txt",
                with:   "New file content 2"
            )
            
            try repository.modifyFile(
                at:     "file3.txt",
                with:   "New file content 3"
            )
            
            
            
            var callbackData = CheckoutCallbackData()
            
            let notifyCB: GitCheckoutNotifyCB =
            {
                why, path, baseline, target, workdir, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GitErrorCode.gitOK.rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CheckoutCallbackData>
                    = payload.assumingMemoryBound(to: CheckoutCallbackData.self)
                
                payloadPointer.pointee.notifyCallCount      += 1
                payloadPointer.pointee.lastNotifyReason     = GitCheckoutNotifyT(rawValue: why.rawValue)
                
                if let path = String(optionalCString: path)
                {
                    payloadPointer.pointee.lastNotifyPath = path
                }
                
                return GitErrorCode.gitOK.rawValue
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
                
                if let path = String(optionalCString: path)
                {
                    payloadPointer.pointee.lastPath = path
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
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var checkoutOptions = GitCheckoutOptions()
                
                checkoutOptions.checkoutStrategy    = .gitCheckoutForce
                checkoutOptions.notifyFlags         = .gitCheckoutNotifyUpdated
                checkoutOptions.notifyCB            = notifyCB
                checkoutOptions.notifyPayload       = UnsafeMutableRawPointer(callbackDataPointer)
                checkoutOptions.progressCB          = progressCB
                checkoutOptions.progressPayload     = UnsafeMutableRawPointer(callbackDataPointer)
                checkoutOptions.perfDataCB          = perfDataCB
                checkoutOptions.perfDataPayload     = UnsafeMutableRawPointer(callbackDataPointer)
                
                let checkoutResult: GitErrorCode = gitCheckoutHEAD(
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
    
    
    
    func testGitCheckoutHEAD() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let content: String = "Modified content for HEAD checkout."
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   content
            )
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     content
            )
            
            
            
            var checkoutOptions = GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var checkoutHEADResult: GitErrorCode = gitCheckoutHEAD(
                repo:   repository.pointer,
                opts:   checkoutOptions
            )
            
            XCTAssertOK(checkoutHEADResult)
            
            
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     Repository.readmeFileContent
            )
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   content
            )
            
            
            
            /// Checking out without options will default to using safe
            /// checkout.
            checkoutHEADResult = gitCheckoutHEAD(
                repo:   repository.pointer,
                opts:   nil
            )
            
            XCTAssertOK(checkoutHEADResult)
            
            
            
            /// The safe checkout will not overwrite uncommitted changes.
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     content
            )
        }
    }
    
    
    
    func testGitCheckoutIndex() throws
    {
        try Repository.withRepositoryAndIndexPointer
        {
            repository, indexPointer in
            
            
            let content: String = "Modified content for index checkout."
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   content
            )
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     content
            )
            
            
            
            var checkoutOptions = GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var checkoutIndexResult: GitErrorCode = gitCheckoutIndex(
                repo:   repository.pointer,
                index:  indexPointer,
                opts:   checkoutOptions
            )
            
            XCTAssertOK(checkoutIndexResult)
            
            
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     Repository.readmeFileContent
            )
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   content
            )
            
            
            
            /// Checking out without options will default to using safe
            /// checkout. This will also default to using the repository index.
            checkoutIndexResult = gitCheckoutIndex(
                repo:   repository.pointer,
                index:  nil,
                opts:   nil
            )
            
            XCTAssertOK(checkoutIndexResult)
            
            
            
            /// The safe checkout will not overwrite uncommitted changes.
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     content
            )
        }
    }
    
    
    
    func testGitCheckoutNotifyT() throws
    {
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyNone.rawValue, GIT_CHECKOUT_NOTIFY_NONE.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyConflict.rawValue, GIT_CHECKOUT_NOTIFY_CONFLICT.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyDirty.rawValue, GIT_CHECKOUT_NOTIFY_DIRTY.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyUpdated.rawValue, GIT_CHECKOUT_NOTIFY_UPDATED.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyUntracked.rawValue, GIT_CHECKOUT_NOTIFY_UNTRACKED.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyIgnored.rawValue, GIT_CHECKOUT_NOTIFY_IGNORED.rawValue)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyAll.rawValue, GIT_CHECKOUT_NOTIFY_ALL.rawValue)
        
        XCTAssertEqual(GitCheckoutNotifyT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyNone.cValue(), GIT_CHECKOUT_NOTIFY_NONE)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyConflict.cValue(), GIT_CHECKOUT_NOTIFY_CONFLICT)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyDirty.cValue(), GIT_CHECKOUT_NOTIFY_DIRTY)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyUpdated.cValue(), GIT_CHECKOUT_NOTIFY_UPDATED)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyUntracked.cValue(), GIT_CHECKOUT_NOTIFY_UNTRACKED)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyIgnored.cValue(), GIT_CHECKOUT_NOTIFY_IGNORED)
        XCTAssertEqual(GitCheckoutNotifyT.gitCheckoutNotifyAll.cValue(), GIT_CHECKOUT_NOTIFY_ALL)
        
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_NONE).cValue(), GIT_CHECKOUT_NOTIFY_NONE)
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_CONFLICT).cValue(), GIT_CHECKOUT_NOTIFY_CONFLICT)
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_DIRTY).cValue(), GIT_CHECKOUT_NOTIFY_DIRTY)
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_UPDATED).cValue(), GIT_CHECKOUT_NOTIFY_UPDATED)
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_UNTRACKED).cValue(), GIT_CHECKOUT_NOTIFY_UNTRACKED)
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_IGNORED).cValue(), GIT_CHECKOUT_NOTIFY_IGNORED)
        XCTAssertEqual(GitCheckoutNotifyT(cValue: GIT_CHECKOUT_NOTIFY_ALL).cValue(), GIT_CHECKOUT_NOTIFY_ALL)
        
        
        
        let flags: GitCheckoutNotifyT =
        [
            .gitCheckoutNotifyDirty,
            .gitCheckoutNotifyConflict
        ]
        
        XCTAssertTrue(flags.contains(.gitCheckoutNotifyDirty))
        XCTAssertTrue(flags.contains(.gitCheckoutNotifyConflict))
        XCTAssertFalse(flags.contains(.gitCheckoutNotifyIgnored))
    }
    
    
    
    func testGitCheckoutOptions() throws
    {
        let checkoutOptions = GitCheckoutOptions()
        
        /// `dirMode`, `fileMode`, and `fileOpenFlags` are zero-initialized.
        /// The documentation defaults refer to runtime defaults set in
        /// `checkout_data_init()` and `blob_content_to_file()`.
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
        
        try checkoutOptions.withCValue
        {
            cCheckoutOptions in
            
            XCTAssertEqual(cCheckoutOptions.pointee.version, gitCheckoutOptionsVersion)
            XCTAssertEqual(GitCheckoutStrategyT(rawValue: cCheckoutOptions.pointee.checkout_strategy), .gitCheckoutSafe)
            XCTAssertFalse(Bool(cCheckoutOptions.pointee.disable_filters))
            XCTAssertEqual(cCheckoutOptions.pointee.dir_mode, 0)
            XCTAssertEqual(cCheckoutOptions.pointee.file_mode, 0)
            XCTAssertEqual(cCheckoutOptions.pointee.file_open_flags, 0)
            XCTAssertEqual(GitCheckoutNotifyT(rawValue: cCheckoutOptions.pointee.notify_flags), .gitCheckoutNotifyNone)
            XCTAssertNil(cCheckoutOptions.pointee.notify_cb)
            XCTAssertNil(cCheckoutOptions.pointee.notify_payload)
            XCTAssertNil(cCheckoutOptions.pointee.progress_cb)
            XCTAssertNil(cCheckoutOptions.pointee.progress_payload)
            XCTAssertNotNil(Array(cCheckoutOptions.pointee.paths))
            XCTAssertNil(cCheckoutOptions.pointee.baseline)
            XCTAssertNil(cCheckoutOptions.pointee.baseline_index)
            XCTAssertNil(cCheckoutOptions.pointee.target_directory)
            XCTAssertNil(cCheckoutOptions.pointee.ancestor_label)
            XCTAssertNil(cCheckoutOptions.pointee.our_label)
            XCTAssertNil(cCheckoutOptions.pointee.their_label)
            XCTAssertNil(cCheckoutOptions.pointee.perfdata_cb)
            XCTAssertNil(cCheckoutOptions.pointee.perfdata_payload)
        }
    }
    
    
    
    func testGitCheckoutOptionsInit() throws
    {
        var checkoutOptions = git_checkout_options()
        
        let checkoutOptionsInitResult: GitErrorCode = gitCheckoutOptionsInit(
            opts:       &checkoutOptions,
            version:    gitCheckoutOptionsVersion
        )
        
        XCTAssertOK(checkoutOptionsInitResult)
    }
    
    
    
    func testGitCheckoutOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitCheckoutOptionsVersion), GIT_CHECKOUT_OPTIONS_VERSION)
    }
    
    
    
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
        
        XCTAssertEqual(perfData.cValue().mkdir_calls, 1)
        XCTAssertEqual(perfData.cValue().stat_calls, 2)
        XCTAssertEqual(perfData.cValue().chmod_calls, 3)
    }
    
    
    
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
        
        XCTAssertEqual(GitCheckoutStrategyT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutSafe.cValue(), GIT_CHECKOUT_SAFE)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutForce.cValue(), GIT_CHECKOUT_FORCE)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutRecreateMissing.cValue(), GIT_CHECKOUT_RECREATE_MISSING)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutAllowConflicts.cValue(), GIT_CHECKOUT_ALLOW_CONFLICTS)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutRemoveUntracked.cValue(), GIT_CHECKOUT_REMOVE_UNTRACKED)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutRemoveIgnored.cValue(), GIT_CHECKOUT_REMOVE_IGNORED)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUpdateOnly.cValue(), GIT_CHECKOUT_UPDATE_ONLY)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontUpdateIndex.cValue(), GIT_CHECKOUT_DONT_UPDATE_INDEX)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutNoRefresh.cValue(), GIT_CHECKOUT_NO_REFRESH)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutSkipUnmerged.cValue(), GIT_CHECKOUT_SKIP_UNMERGED)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUseOurs.cValue(), GIT_CHECKOUT_USE_OURS)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUseTheirs.cValue(), GIT_CHECKOUT_USE_THEIRS)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDisablePathspecMatch.cValue(), GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutSkipLockedDirectories.cValue(), GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontOverwriteIgnored.cValue(), GIT_CHECKOUT_DONT_OVERWRITE_IGNORED)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutConflictStyleMerge.cValue(), GIT_CHECKOUT_CONFLICT_STYLE_MERGE)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutConflictStyleDiff3.cValue(), GIT_CHECKOUT_CONFLICT_STYLE_DIFF3)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontRemoveExisting.cValue(), GIT_CHECKOUT_DONT_REMOVE_EXISTING)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDontWriteIndex.cValue(), GIT_CHECKOUT_DONT_WRITE_INDEX)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutDryRun.cValue(), GIT_CHECKOUT_DRY_RUN)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutConflictStyleZDiff3.cValue(), GIT_CHECKOUT_CONFLICT_STYLE_ZDIFF3)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutNone.cValue(), GIT_CHECKOUT_NONE)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUpdateSubmodules.cValue(), GIT_CHECKOUT_UPDATE_SUBMODULES)
        XCTAssertEqual(GitCheckoutStrategyT.gitCheckoutUpdateSubmodulesIfChanged.cValue(), GIT_CHECKOUT_UPDATE_SUBMODULES_IF_CHANGED)
        
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_SAFE).cValue(), GIT_CHECKOUT_SAFE)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_FORCE).cValue(), GIT_CHECKOUT_FORCE)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_RECREATE_MISSING).cValue(), GIT_CHECKOUT_RECREATE_MISSING)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_ALLOW_CONFLICTS).cValue(), GIT_CHECKOUT_ALLOW_CONFLICTS)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_REMOVE_UNTRACKED).cValue(), GIT_CHECKOUT_REMOVE_UNTRACKED)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_REMOVE_IGNORED).cValue(), GIT_CHECKOUT_REMOVE_IGNORED)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_UPDATE_ONLY).cValue(), GIT_CHECKOUT_UPDATE_ONLY)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_DONT_UPDATE_INDEX).cValue(), GIT_CHECKOUT_DONT_UPDATE_INDEX)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_NO_REFRESH).cValue(), GIT_CHECKOUT_NO_REFRESH)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_SKIP_UNMERGED).cValue(), GIT_CHECKOUT_SKIP_UNMERGED)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_USE_OURS).cValue(), GIT_CHECKOUT_USE_OURS)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_USE_THEIRS).cValue(), GIT_CHECKOUT_USE_THEIRS)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH).cValue(), GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES).cValue(), GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_DONT_OVERWRITE_IGNORED).cValue(), GIT_CHECKOUT_DONT_OVERWRITE_IGNORED)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_CONFLICT_STYLE_MERGE).cValue(), GIT_CHECKOUT_CONFLICT_STYLE_MERGE)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_CONFLICT_STYLE_DIFF3).cValue(), GIT_CHECKOUT_CONFLICT_STYLE_DIFF3)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_DONT_REMOVE_EXISTING).cValue(), GIT_CHECKOUT_DONT_REMOVE_EXISTING)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_DONT_WRITE_INDEX).cValue(), GIT_CHECKOUT_DONT_WRITE_INDEX)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_DRY_RUN).cValue(), GIT_CHECKOUT_DRY_RUN)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_CONFLICT_STYLE_ZDIFF3).cValue(), GIT_CHECKOUT_CONFLICT_STYLE_ZDIFF3)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_NONE).cValue(), GIT_CHECKOUT_NONE)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_UPDATE_SUBMODULES).cValue(), GIT_CHECKOUT_UPDATE_SUBMODULES)
        XCTAssertEqual(GitCheckoutStrategyT(cValue: GIT_CHECKOUT_UPDATE_SUBMODULES_IF_CHANGED).cValue(), GIT_CHECKOUT_UPDATE_SUBMODULES_IF_CHANGED)
        
        
        
        let flags: GitCheckoutStrategyT =
        [
            .gitCheckoutSafe,
            .gitCheckoutRecreateMissing
        ]
        
        XCTAssertTrue(flags.contains(.gitCheckoutSafe))
        XCTAssertTrue(flags.contains(.gitCheckoutRecreateMissing))
        XCTAssertFalse(flags.contains(.gitCheckoutSkipLockedDirectories))
    }
    
    
    
    func testGitCheckoutTree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var treePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(treePointer)
            }
            
            
            
            let commitTreeResult: GitErrorCode
                = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
            }
            
            XCTAssertOK(commitTreeResult)
            
            
            
            let content: String = "Modified content for tree checkout."
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   content
            )
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     content
            )
            
            
            
            var checkoutOptions = GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy = .gitCheckoutForce
            
            
            
            var checkoutTreeResult: GitErrorCode = gitCheckoutTree(
                repo:       repository.pointer,
                treeish:    treePointer,
                opts:       checkoutOptions
            )
            
            XCTAssertOK(checkoutTreeResult)
            
            
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     Repository.readmeFileContent
            )
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   content
            )
            
            
            
            /// Checking out without options will default to using safe
            /// checkout. This will also default to using HEAD.
            checkoutTreeResult = gitCheckoutTree(
                repo:       repository.pointer,
                treeish:    nil,
                opts:       nil
            )
            
            XCTAssertOK(checkoutTreeResult)
            
            
            
            /// The safe checkout will not overwrite uncommitted changes.
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     content
            )
        }
    }
}



// MARK: - Extensions

extension CheckoutTests
{
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
