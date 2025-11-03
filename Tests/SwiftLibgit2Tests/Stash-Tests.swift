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



final class StashTests: XCTestCaseStopOnFail
{
    func testGitStashApply() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let modifiedContent: String = "Modified content"
            
            try repository.modifyFile(
                at:         Repository.readmeFileName,
                with:       modifiedContent,
                appending:  false
            )
            
            
            
            var stashOptions = GitStashSaveOptions()
            
            stashOptions.stasher    = repository.signature
            stashOptions.message    = "Test stash"
            
            var stashOID = GitOID()
            
            let stashSaveWithOptsResult: GitErrorCode = gitStashSaveWithOpts(
                out:    &stashOID,
                repo:   repository.pointer,
                opts:   stashOptions
            )
            
            XCTAssertOK(stashSaveWithOptsResult)
            XCTAssertNotZeroOID(stashOID)
            
            
            
            let readmeFileURL: URL = repository.url.appending(
                path:           Repository.readmeFileName,
                directoryHint:  .notDirectory
            )
            
            let contentAfterStash = try String(contentsOf: readmeFileURL)
            
            XCTAssertEqual(contentAfterStash, Repository.readmeFileContent)
            
            
            
            let stashApplyResult: GitErrorCode = gitStashApply(
                repo:       repository.pointer,
                index:      0,
                options:    nil
            )
            
            XCTAssertOK(stashApplyResult)
            
            
            
            let contentAfterApply = try String(contentsOf: readmeFileURL)
            
            XCTAssertEqual(contentAfterApply, modifiedContent)
        }
    }
    
    
    
    func testGitStashApplyFlags() throws
    {
        XCTAssertEqual(GitStashApplyFlags.gitStashApplyDefault.rawValue, GIT_STASH_APPLY_DEFAULT.rawValue)
        XCTAssertEqual(GitStashApplyFlags.gitStashApplyReinstateIndex.rawValue, GIT_STASH_APPLY_REINSTATE_INDEX.rawValue)
        
        XCTAssertNil(GitStashApplyFlags(rawValue: 123))
        
        XCTAssertEqual(GitStashApplyFlags.gitStashApplyDefault.cValue(), GIT_STASH_APPLY_DEFAULT)
        XCTAssertEqual(GitStashApplyFlags.gitStashApplyReinstateIndex.cValue(), GIT_STASH_APPLY_REINSTATE_INDEX)
        
        XCTAssertEqual(GitStashApplyFlags(cValue: GIT_STASH_APPLY_DEFAULT), .gitStashApplyDefault)
        XCTAssertEqual(GitStashApplyFlags(cValue: GIT_STASH_APPLY_REINSTATE_INDEX), .gitStashApplyReinstateIndex)
    }
    
    
    
    func testGitStashApplyOptionsInit() throws
    {
        var stashApplyOptions = git_stash_apply_options()
        
        let stashApplyOptionsInitResult: GitErrorCode
            = gitStashApplyOptionsInit(
                opts:       &stashApplyOptions,
                version:    gitStashApplyOptionsVersion
            )
        
        XCTAssertOK(stashApplyOptionsInitResult)
    }
    
    
    
    func testGitStashApplyOptions() throws
    {
        let stashApplyOptions = GitStashApplyOptions()
        
        XCTAssertEqual(stashApplyOptions.version, gitStashApplyOptionsVersion)
        XCTAssertEqual(stashApplyOptions.flags, .gitStashApplyDefault)
        XCTAssertNotNil(stashApplyOptions.checkoutOptions)
        XCTAssertNil(stashApplyOptions.progressCB)
        XCTAssertNil(stashApplyOptions.progressPayload)
        
        try stashApplyOptions.withCValue
        {
            cStashApplyOptions in
            
            XCTAssertEqual(cStashApplyOptions.pointee.version, gitStashApplyOptionsVersion)
            XCTAssertEqual(GitStashApplyFlags(rawValue: cStashApplyOptions.pointee.flags), .gitStashApplyDefault)
            XCTAssertNotNil(cStashApplyOptions.pointee.checkout_options)
            XCTAssertNil(cStashApplyOptions.pointee.progress_cb)
            XCTAssertNil(cStashApplyOptions.pointee.progress_payload)
        }
    }
    
    
    
    func testGitStashApplyOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitStashApplyOptionsVersion), GIT_STASH_APPLY_OPTIONS_VERSION)
    }
    
    
    
    func testGitStashApplyProgressCB() throws
    {
        let stashApplyProgressCB: GitStashApplyProgressCB =
        {
            _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let stashApplyProgressCBResult: Int32 = stashApplyProgressCB(
            GitStashApplyProgressT.gitStashApplyProgressDone.cValue(),
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: stashApplyProgressCBResult))
    }
    
    
    
    func testGitStashApplyProgressT() throws
    {
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressNone.rawValue, GIT_STASH_APPLY_PROGRESS_NONE.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressLoadingStash.rawValue, GIT_STASH_APPLY_PROGRESS_LOADING_STASH.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressAnalyzeIndex.rawValue, GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressAnalyzeModified.rawValue, GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressAnalyzeUntracked.rawValue, GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressCheckoutUntracked.rawValue, GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressCheckoutModified.rawValue, GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED.rawValue)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressDone.rawValue, GIT_STASH_APPLY_PROGRESS_DONE.rawValue)
        
        XCTAssertNil(GitStashApplyProgressT(rawValue: 123))
        
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressNone.cValue(), GIT_STASH_APPLY_PROGRESS_NONE)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressLoadingStash.cValue(), GIT_STASH_APPLY_PROGRESS_LOADING_STASH)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressAnalyzeIndex.cValue(), GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressAnalyzeModified.cValue(), GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressAnalyzeUntracked.cValue(), GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressCheckoutUntracked.cValue(), GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressCheckoutModified.cValue(), GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED)
        XCTAssertEqual(GitStashApplyProgressT.gitStashApplyProgressDone.cValue(), GIT_STASH_APPLY_PROGRESS_DONE)
        
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_NONE), .gitStashApplyProgressNone)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_LOADING_STASH), .gitStashApplyProgressLoadingStash)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX), .gitStashApplyProgressAnalyzeIndex)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED), .gitStashApplyProgressAnalyzeModified)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED), .gitStashApplyProgressAnalyzeUntracked)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED), .gitStashApplyProgressCheckoutUntracked)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED), .gitStashApplyProgressCheckoutModified)
        XCTAssertEqual(GitStashApplyProgressT(cValue: GIT_STASH_APPLY_PROGRESS_DONE), .gitStashApplyProgressDone)
    }
    
    
    
    func testGitStashDrop() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let stashCount: Int = 3
            
            for index in 0..<stashCount
            {
                try repository.modifyFile(
                    at:         Repository.readmeFileName,
                    with:       "Stash \(index) content",
                    appending:  true
                )
                
                var stashOptions = GitStashSaveOptions()
                
                stashOptions.stasher    = repository.signature
                stashOptions.message    = "Test stash"
                
                var stashOID = GitOID()
                
                let stashSaveWithOptsResult: GitErrorCode
                    = gitStashSaveWithOpts(
                        out:    &stashOID,
                        repo:   repository.pointer,
                        opts:   stashOptions
                    )
                
                XCTAssertOK(stashSaveWithOptsResult)
                XCTAssertNotZeroOID(stashOID)
            }
            
            
            
            var callbackData = CallbackData()
            
            iterateStashes(
                in:     repository,
                with:   &callbackData
            )
            
            XCTAssertEqual(callbackData.callCount, stashCount)
            
            
            
            let stashDropResult: GitErrorCode = gitStashDrop(
                repo:   repository.pointer,
                index:  0
            )
            
            XCTAssertOK(stashDropResult)
            
            
            
            callbackData = CallbackData()
            
            iterateStashes(
                in:     repository,
                with:   &callbackData
            )
            
            XCTAssertEqual(callbackData.callCount, stashCount - 1)
        }
    }
    
    
    
    func testGitStashFlags() throws
    {
        XCTAssertEqual(GitStashFlags.gitStashDefault.rawValue, GIT_STASH_DEFAULT.rawValue)
        XCTAssertEqual(GitStashFlags.gitStashKeepIndex.rawValue, GIT_STASH_KEEP_INDEX.rawValue)
        XCTAssertEqual(GitStashFlags.gitStashIncludeUntracked.rawValue, GIT_STASH_INCLUDE_UNTRACKED.rawValue)
        XCTAssertEqual(GitStashFlags.gitStashIncludeIgnored.rawValue, GIT_STASH_INCLUDE_IGNORED.rawValue)
        XCTAssertEqual(GitStashFlags.gitStashKeepAll.rawValue, GIT_STASH_KEEP_ALL.rawValue)
        
        XCTAssertEqual(GitStashFlags(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitStashFlags.gitStashDefault.cValue(), GIT_STASH_DEFAULT)
        XCTAssertEqual(GitStashFlags.gitStashKeepIndex.cValue(), GIT_STASH_KEEP_INDEX)
        XCTAssertEqual(GitStashFlags.gitStashIncludeUntracked.cValue(), GIT_STASH_INCLUDE_UNTRACKED)
        XCTAssertEqual(GitStashFlags.gitStashIncludeIgnored.cValue(), GIT_STASH_INCLUDE_IGNORED)
        XCTAssertEqual(GitStashFlags.gitStashKeepAll.cValue(), GIT_STASH_KEEP_ALL)
        
        XCTAssertEqual(GitStashFlags(cValue: GIT_STASH_DEFAULT), .gitStashDefault)
        XCTAssertEqual(GitStashFlags(cValue: GIT_STASH_KEEP_INDEX), .gitStashKeepIndex)
        XCTAssertEqual(GitStashFlags(cValue: GIT_STASH_INCLUDE_UNTRACKED), .gitStashIncludeUntracked)
        XCTAssertEqual(GitStashFlags(cValue: GIT_STASH_INCLUDE_IGNORED), .gitStashIncludeIgnored)
        XCTAssertEqual(GitStashFlags(cValue: GIT_STASH_KEEP_ALL), .gitStashKeepAll)
        
        
        
        let flags: GitStashFlags =
        [
            .gitStashKeepIndex,
            .gitStashIncludeUntracked
        ]
        
        XCTAssertTrue(flags.contains(.gitStashKeepIndex))
        XCTAssertTrue(flags.contains(.gitStashIncludeUntracked))
        XCTAssertFalse(flags.contains(.gitStashIncludeIgnored))
    }
    
    
    
    func testGitStashForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var expectedStashOIDs: [GitOID] = []
            
            let stashMessages: [String] =
            [
                "First stash",
                "Second stash",
                "Third stash"
            ]
            
            for stashMessage in stashMessages
            {
                try repository.modifyFile(
                    at:         Repository.readmeFileName,
                    with:       "\(stashMessage) content",
                    appending:  true
                )
                
                
                
                var stashOID = GitOID()
                
                let stashSaveResult: GitErrorCode = gitStashSave(
                    out:        &stashOID,
                    repo:       repository.pointer,
                    stasher:    repository.signature,
                    message:    stashMessage,
                    flags:      []
                )
                
                XCTAssertOK(stashSaveResult)
                XCTAssertNotZeroOID(stashOID)
                
                expectedStashOIDs.append(stashOID)
            }
            
            
            
            var callbackData = CallbackData()
            
            iterateStashes(
                in:     repository,
                with:   &callbackData
            )
            
            XCTAssertEqual(callbackData.callCount, stashMessages.count)
            XCTAssertEqual(callbackData.stashMessages.count, stashMessages.count)
            
            for (index, stashMessage) in stashMessages.reversed().enumerated()
            {
                /// The messages have the format `On <branch>: <message>`.
                let hasMessageSuffix: Bool
                    = callbackData.stashMessages[index].hasSuffix(stashMessage)
                
                XCTAssertTrue(hasMessageSuffix)
            }
        }
    }
    
    
    
    func testGitStashPop() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let modifiedContent: String = "Modified content"
            
            try repository.modifyFile(
                at:         Repository.readmeFileName,
                with:       modifiedContent,
                appending:  false
            )
            
            
            
            var stashOptions = GitStashSaveOptions()
            
            stashOptions.stasher    = repository.signature
            stashOptions.message    = "Test stash"
            
            var stashOID = GitOID()
            
            let stashSaveWithOptsResult: GitErrorCode = gitStashSaveWithOpts(
                out:    &stashOID,
                repo:   repository.pointer,
                opts:   stashOptions
            )
            
            XCTAssertOK(stashSaveWithOptsResult)
            XCTAssertNotZeroOID(stashOID)
            
            
            
            var callbackData = CallbackData()
            
            iterateStashes(
                in:     repository,
                with:   &callbackData
            )
            
            XCTAssertEqual(callbackData.callCount, 1)
            
            
            
            let stashPopResult: GitErrorCode = gitStashPop(
                repo:       repository.pointer,
                index:      0,
                options:    nil
            )
            
            XCTAssertOK(stashPopResult)
            
            
            
            callbackData = CallbackData()
            
            iterateStashes(
                in:     repository,
                with:   &callbackData
            )
            
            XCTAssertEqual(callbackData.callCount, 0)
            
            
            
            let readmeFileURL: URL = repository.url.appending(
                path:           Repository.readmeFileName,
                directoryHint:  .notDirectory
            )
            
            let contentAfterPop = try String(contentsOf: readmeFileURL)
            
            XCTAssertEqual(contentAfterPop, modifiedContent)
        }
    }
    
    
    
    func testGitStashSave() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let untrackedFileName   : String    = "untracked.txt"
            let untrackedContent    : String    = "Untracked content"
            
            try repository.modifyFile(
                at:     untrackedFileName,
                with:   untrackedContent
            )
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   "Modified content"
            )
            
            
            
            var stashOID = GitOID()
            
            let stashSaveResult: GitErrorCode = gitStashSave(
                out:        &stashOID,
                repo:       repository.pointer,
                stasher:    repository.signature,
                message:    "Test stash",
                flags:      .gitStashIncludeUntracked
            )
            
            XCTAssertOK(stashSaveResult)
            XCTAssertNotZeroOID(stashOID)
        }
    }
    
    
    
    func testGitStashSaveOptions() throws
    {
        let stashSaveOptions = GitStashSaveOptions()
        
        XCTAssertEqual(stashSaveOptions.version, gitStashSaveOptionsVersion)
        XCTAssertEqual(stashSaveOptions.flags, [])
        XCTAssertNotNil(stashSaveOptions.stasher)
        XCTAssertNil(stashSaveOptions.message)
        XCTAssertEqual(stashSaveOptions.paths, [])
        
        try stashSaveOptions.withCValue
        {
            cStashSaveOptions in
            
            XCTAssertEqual(cStashSaveOptions.pointee.version, gitStashSaveOptionsVersion)
            XCTAssertEqual(GitStashFlags(rawValue: cStashSaveOptions.pointee.flags), [])
            XCTAssertNotNil(cStashSaveOptions.pointee.stasher)
            XCTAssertNil(cStashSaveOptions.pointee.message)
            XCTAssertEqual(Array(cStashSaveOptions.pointee.paths), [])
        }
    }
    
    
    
    func testGitStashSaveOptionsInit() throws
    {
        var stashSaveOptions = git_stash_save_options()
        
        let stashSaveOptionsInitResult: GitErrorCode
            = gitStashSaveOptionsInit(
                opts:       &stashSaveOptions,
                version:    gitStashSaveOptionsVersion
            )
        
        XCTAssertOK(stashSaveOptionsInitResult)
    }
    
    
    
    func testGitStashSaveOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitStashSaveOptionsVersion), GIT_STASH_SAVE_OPTIONS_VERSION)
    }
    
    
    
    func testGitStashSaveWithOpts() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let untrackedFileName   : String    = "untracked.txt"
            let untrackedContent    : String    = "Untracked content"
            
            try repository.modifyFile(
                at:     untrackedFileName,
                with:   untrackedContent
            )
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   "Modified content"
            )
            
            
            
            var stashOptions = GitStashSaveOptions()
            
            stashOptions.stasher    = repository.signature
            stashOptions.message    = "Test stash"
            stashOptions.flags      = .gitStashIncludeUntracked
            
            var stashOID = GitOID()
            
            let stashSaveWithOptsResult: GitErrorCode = gitStashSaveWithOpts(
                out:    &stashOID,
                repo:   repository.pointer,
                opts:   stashOptions
            )
            
            XCTAssertOK(stashSaveWithOptsResult)
            XCTAssertNotZeroOID(stashOID)
        }
    }
}




// MARK: - Extensions

private extension StashTests
{
    struct CallbackData
    {
        var callCount       : Int       = 0
        var stashMessages   : [String]  = []
        var stashOIDs       : [GitOID]  = []
    }
    
    
    
    /// Loops over all the stashed states in the given repository.
    /// - Parameters:
    ///   - repository: The repository containing the stash.
    ///   - callbackData: The ``CallbackData`` instance in which to store the
    ///   callback data.
    func iterateStashes(
        in      repository      : Repository,
        with    callbackData    : inout CallbackData
    )
    {
        let stashCB: GitStashCB =
        {
            _, message, stashOID, payload in
            
            guard
                let payload     : UnsafeMutableRawPointer   = payload,
                let stashOID    : UnsafePointer<git_oid>    = stashOID,
                let message = String(optionalCString: message)
            else
            {
                XCTFail("All or some callback parameters were nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            let payloadPointer: UnsafeMutablePointer<CallbackData>
                = payload.assumingMemoryBound(to: CallbackData.self)
            
            payloadPointer.pointee.callCount += 1
            payloadPointer.pointee.stashMessages.append(message)
            
            payloadPointer.pointee.stashOIDs.append(
                GitOID(cValue: stashOID.pointee)
            )
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        withUnsafeMutablePointer(to: &callbackData)
        {
            callbackDataPointer in
            
            let stashForEachResult: GitErrorCode = gitStashForEach(
                repo:       repository.pointer,
                callback:   stashCB,
                payload:    UnsafeMutableRawPointer(callbackDataPointer)
            )
            
            XCTAssertOK(stashForEachResult)
        }
    }
}
