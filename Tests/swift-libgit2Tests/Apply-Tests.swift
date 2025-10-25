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



final class ApplyTests: XCTestCaseStopOnFail
{
    func testGitApplyFlagsT() throws
    {
        XCTAssertEqual(GitApplyFlagsT.gitApplyCheck.rawValue, GIT_APPLY_CHECK.rawValue)
        
        XCTAssertEqual(GitApplyFlagsT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitApplyFlagsT.gitApplyCheck.cValue(), GIT_APPLY_CHECK)
        
        XCTAssertEqual(GitApplyFlagsT(cValue: GIT_APPLY_CHECK), .gitApplyCheck)
        
        
        
        let flags: GitApplyFlagsT =
        [
            .gitApplyCheck,
            GitApplyFlagsT(rawValue: 10)
        ]
        
        XCTAssertTrue(flags.contains(.gitApplyCheck))
        XCTAssertTrue(flags.contains(GitApplyFlagsT(rawValue: 10)))
        XCTAssertFalse(flags.contains(GitApplyFlagsT(rawValue: 123)))
    }
    
    
    
    func testGitApplyLocationT() throws
    {
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationWorkdir.rawValue, GIT_APPLY_LOCATION_WORKDIR.rawValue)
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationIndex.rawValue, GIT_APPLY_LOCATION_INDEX.rawValue)
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationBoth.rawValue, GIT_APPLY_LOCATION_BOTH.rawValue)
        
        XCTAssertEqual(GitApplyLocationT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationWorkdir.cValue(), GIT_APPLY_LOCATION_WORKDIR)
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationIndex.cValue(), GIT_APPLY_LOCATION_INDEX)
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationBoth.cValue(), GIT_APPLY_LOCATION_BOTH)
        
        XCTAssertEqual(GitApplyLocationT(cValue: GIT_APPLY_LOCATION_WORKDIR), .gitApplyLocationWorkdir)
        XCTAssertEqual(GitApplyLocationT(cValue: GIT_APPLY_LOCATION_INDEX), .gitApplyLocationIndex)
        XCTAssertEqual(GitApplyLocationT(cValue: GIT_APPLY_LOCATION_BOTH), .gitApplyLocationBoth)
        
        
        
        let flags: GitApplyLocationT =
        [
            .gitApplyLocationWorkdir,
            .gitApplyLocationIndex
        ]
        
        XCTAssertTrue(flags.contains(.gitApplyLocationWorkdir))
        XCTAssertTrue(flags.contains(.gitApplyLocationIndex))
        XCTAssertFalse(flags.contains(.gitApplyLocationBoth))
    }
    
    
    
    func testGitApplyOptions() throws
    {
        let applyOptions = GitApplyOptions()
        
        XCTAssertEqual(applyOptions.version, gitApplyOptionsVersion)
        XCTAssertNil(applyOptions.deltaCB)
        XCTAssertNil(applyOptions.hunkCB)
        XCTAssertNil(applyOptions.payload)
        XCTAssertEqual(applyOptions.flags, [])
        
        try applyOptions.withCValue
        {
            cApplyOptions in
            
            XCTAssertEqual(cApplyOptions.pointee.version, gitApplyOptionsVersion)
            XCTAssertNil(cApplyOptions.pointee.delta_cb)
            XCTAssertNil(cApplyOptions.pointee.hunk_cb)
            XCTAssertNil(cApplyOptions.pointee.payload)
            XCTAssertEqual(GitApplyFlagsT(rawValue: cApplyOptions.pointee.flags), [])
        }
    }
    
    
    
    func testGitApplyOptionsInit() throws
    {
        var applyOptions = git_apply_options()
        
        let applyOptionsInitResult: GitErrorCode = gitApplyOptionsInit(
            opts:       &applyOptions,
            version:    gitApplyOptionsVersion
        )
        
        XCTAssertOK(applyOptionsInitResult)
    }
    
    
    
    func testGitApplyOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitApplyOptionsVersion), GIT_APPLY_OPTIONS_VERSION)
    }
    
    
    
    func testGitApplyToTree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var treePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(treePointer)
            }
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
            }
            
            guard let treePointer: OpaquePointer = treePointer
            else
            {
                XCTFail("The tree pointer was nil.")
                return
            }
            
            
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let applyOptions = GitApplyOptions()
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository)
            {
                diffPointer in
                
                let applyToTreeResult: GitErrorCode = gitApplyToTree(
                    out:        &indexPointer,
                    repo:       repository.pointer,
                    preimage:   treePointer,
                    diff:       diffPointer,
                    options:    applyOptions
                )
                
                XCTAssertOK(applyToTreeResult)
                XCTAssertNotNil(indexPointer)
            }
        }
    }
    
    
    
    func testGitApplyToBoth() throws
    {
        try testGitApplyFlow(
            location:       .gitApplyLocationBoth,
            flags:          nil,
            checkIndex:     true,
            endContent:     "\(Repository.readmeFileContent) Goodbye World!"
        )
    }
    
    
    
    func testGitApplyToIndex() throws
    {
        try testGitApplyFlow(
            location:       .gitApplyLocationIndex,
            flags:          nil,
            checkIndex:     true,
            endContent:     Repository.readmeFileContent
        )
    }
    
    
    
    func testGitApplyToWorkdir() throws
    {
        try testGitApplyFlow(
            location:       .gitApplyLocationWorkdir,
            flags:          nil,
            checkIndex:     false,
            endContent:     "\(Repository.readmeFileContent) Goodbye World!"
        )
    }
    
    
    
    func testGitApplyWithCheckFlag() throws
    {
        try testGitApplyFlow(
            location:       .gitApplyLocationWorkdir,
            flags:          .gitApplyCheck,
            checkIndex:     false,
            endContent:     Repository.readmeFileContent
        )
    }
}



// MARK: - Extensions

private extension ApplyTests
{
    struct CallbackCounts
    {
        var deltaCount  : Int   = 0
        var hunkCount   : Int   = 0
    }
    
    
    
    /// Tests `git apply` functionality by creating a diff and applying it
    /// with the given options.
    ///
    /// - Parameters:
    ///   - location: The target location for applying the diff (the working
    ///   directory, the index, or both).
    ///   - flags: The flags to control the apply behavior.
    ///   - checkIndex: Whether to check that the index contains staged changes
    ///   after applying.
    ///   - endContent: The expected file content after applying.
    /// - Throws: An error if an operation fails.
    ///
    /// ## Discussion
    ///
    /// The test is performed by following these steps:
    ///
    /// 1. Create a modified version of the repository's `README.md` file.
    /// 2. Stage the modification to create a new tree state.
    /// 3. Generate a diff between the original tree and the modified tree.
    /// 4. Reset the working directory back to the original state.
    /// 5. Apply the diff using the given options.
    /// 6. Check that both the delta and hunk callbacks were invoked.
    /// 7. Check that the final file content is correct.
    /// 8. Optionally check that the index contains staged changes.
    func testGitApplyFlow(
        location        : GitApplyLocationT,
        flags           : GitApplyFlagsT?,
        checkIndex      : Bool,
        endContent      : String
    ) throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            var oldTreePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(oldTreePointer)
            }
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &oldTreePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
            }
            
            
            
            let modifiedContent: String
                = "\(Repository.readmeFileContent) Goodbye World!"
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   modifiedContent
            )
            
            
            
            let indexAddBypathResult: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   Repository.readmeFileName
            )
            
            XCTAssertOK(indexAddBypathResult)
            
            
            
            var newTreeOID = GitOID()
            
            let indexWriteTreeResult: GitErrorCode = gitIndexWriteTree(
                out:    &newTreeOID,
                index:  indexPointer
            )
            
            XCTAssertOK(indexWriteTreeResult)
            
            
            
            var newTreePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(newTreePointer)
            }
            
            
            
            // TODO: Replace once `git_tree_lookup()` has a binding.
            var cNewTreeOID: git_oid = newTreeOID.cValue()
            
            let treeLookupResult: Int32 = git_tree_lookup(
                &newTreePointer,
                repository.pointer,
                &cNewTreeOID
            )
            
            XCTAssertOK(GitErrorCode(rawValue: treeLookupResult))
            
            
            
            var diffPointer: OpaquePointer? = nil
            
            defer
            {
                gitDiffFree(diff: diffPointer)
            }
            
            
            
            let diffTreeToTreeResult: GitErrorCode = gitDiffTreeToTree(
                diff:       &diffPointer,
                repo:       repository.pointer,
                oldTree:    oldTreePointer,
                newTree:    newTreePointer,
                opts:       nil
            )
            
            XCTAssertOK(diffTreeToTreeResult)
            
            guard let diffPointer: OpaquePointer = diffPointer
            else
            {
                XCTFail("The diff pointer was nil.")
                return
            }
            
            
            
            repository.reset(to: repository.headOID)
            
            
            
            var callbackCounts = CallbackCounts()
            
            let deltaCB: GitApplyDeltaCB =
            {
                _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackCounts>
                    = payload.assumingMemoryBound(to: CallbackCounts.self)
                
                payloadPointer.pointee.deltaCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            let hunkCB: GitApplyHunkCB =
            {
                _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackCounts>
                    = payload.assumingMemoryBound(to: CallbackCounts.self)
                
                payloadPointer.pointee.hunkCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackCounts)
            {
                callbackCountsPointer in
                
                var applyOptions = GitApplyOptions()
                
                applyOptions.deltaCB    = deltaCB
                applyOptions.hunkCB     = hunkCB
                applyOptions.payload    = UnsafeMutableRawPointer(callbackCountsPointer)
                
                if let flags: GitApplyFlagsT = flags
                {
                    applyOptions.flags = flags
                }
                
                let applyResult: GitErrorCode = gitApply(
                    repo:       repository.pointer,
                    diff:       diffPointer,
                    location:   location,
                    options:    applyOptions
                )
                
                XCTAssertOK(applyResult)
            }
            
            XCTAssertGreaterThan(callbackCounts.deltaCount, 0)
            XCTAssertGreaterThan(callbackCounts.hunkCount, 0)
            
            
            
            try repository.assertFileContent(
                at:         Repository.readmeFileName,
                equals:     endContent
            )
            
            
            
            if checkIndex
            {
                var status = GitStatusT()
                
                let statusFileResult: GitErrorCode = gitStatusFile(
                    statusFlags:    &status,
                    repo:           repository.pointer,
                    path:           Repository.readmeFileName
                )
                
                XCTAssertOK(statusFileResult)
                XCTAssertTrue(status.contains(.gitStatusIndexModified))
            }
        }
    }
}
