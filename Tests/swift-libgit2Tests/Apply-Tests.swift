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
    }
    
    
    
    func testGitApplyOptions() throws
    {
        let applyOptions = GitApplyOptions()
        
        XCTAssertEqual(applyOptions.version, gitApplyOptionsVersion)
        XCTAssertNil(applyOptions.deltaCB)
        XCTAssertNil(applyOptions.hunkCB)
        XCTAssertNil(applyOptions.payload)
        XCTAssertEqual(applyOptions.flags, [])
        
        XCTAssertEqual(gitApplyOptionsVersion, UInt32(GIT_APPLY_OPTIONS_VERSION))
        
        try applyOptions.withCValue
        {
            cApplyOptions in
            
            XCTAssertEqual(cApplyOptions.pointee.version, gitApplyOptionsVersion)
            XCTAssertNil(cApplyOptions.pointee.delta_cb)
            XCTAssertNil(cApplyOptions.pointee.hunk_cb)
            XCTAssertNil(cApplyOptions.pointee.payload)
            XCTAssertEqual(cApplyOptions.pointee.flags, 0)
        }
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
            
            
            
            let commitTreeResult: GitErrorCode = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
            }
            
            XCTAssertOK(commitTreeResult)
            
            guard let treePointer: OpaquePointer = treePointer
            else
            {
                XCTFail("The tree pointer was nil.")
                return
            }
            
            
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeIndex(indexPointer)
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

extension ApplyTests
{
    private struct CallbackCounts
    {
        var deltaCount  : Int   = 0
        var hunkCount   : Int   = 0
    }
    
    
    
    /// Tests `git apply` functionality by creating a diff and applying it with the given options.
    ///
    /// - Parameters:
    ///   - location: The target location for applying the diff (the working directory, the index, or both).
    ///   - flags: The flags to control the apply behavior.
    ///   - checkIndex: Whether to check that the index contains staged changes after applying.
    ///   - endContent: The expected file content after applying.
    /// - Throws: An error if a Git operation, write operation fails, or `GitApplyOptions`
    /// initialization fails.
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
    private func testGitApplyFlow(
        location        : GitApplyLocationT,
        flags           : GitApplyFlagsT?,
        checkIndex      : Bool,
        endContent      : String
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var oldTreePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(oldTreePointer)
            }
            
            
            
            let commitTreeResult: GitErrorCode = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTree(
                    out:        &oldTreePointer,
                    commit:     commitPointer
                )
            }
            
            XCTAssertOK(commitTreeResult)
            
            
            
            let modifiedContent: String = "\(Repository.readmeFileContent) Goodbye World!"
            
            try repository.modifyFile(
                path:       Repository.readmeFileName,
                content:    modifiedContent
            )
            
            
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeIndex(indexPointer)
            }
            
            
            
            let repositoryIndexResult: Int32 = git_repository_index(
                &indexPointer,
                repository.pointer
            )
            
            XCTAssertOK(GitErrorCode(rawValue: repositoryIndexResult))
            
            
            
            let indexAddBypathResult: Int32 = git_index_add_bypath(
                indexPointer,
                Repository.readmeFileName
            )
            
            XCTAssertOK(GitErrorCode(rawValue: indexAddBypathResult))
            
            
            
            var newTreeOID = git_oid()
            
            let indexWriteTreeResult: Int32 = git_index_write_tree(
                &newTreeOID,
                indexPointer
            )
            
            XCTAssertOK(GitErrorCode(rawValue: indexWriteTreeResult))
            
            
            
            var newTreePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(newTreePointer)
            }
            
            
            
            let treeLookupResult: Int32 = git_tree_lookup(
                &newTreePointer,
                repository.pointer,
                &newTreeOID
            )
            
            XCTAssertOK(GitErrorCode(rawValue: treeLookupResult))
            
            
            
            var diffPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeDiff(diffPointer)
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
            
            
            
            let resetResult: Int32 = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return git_reset(
                    repository.pointer,
                    commitPointer,
                    GIT_RESET_HARD,
                    nil
                )
            }
            
            XCTAssertOK(GitErrorCode(rawValue: resetResult))
            
            
            
            var callbackCounts = CallbackCounts()
            
            let deltaCB: GitApplyDeltaCB =
            {
                _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GitErrorCode.gitOK.rawValue
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
                    return GitErrorCode.gitOK.rawValue
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
            
            
            
            try repository.verifyFileContent(
                path:       Repository.readmeFileName,
                content:    endContent
            )
            
            
            
            if checkIndex
            {
                var statusFlags: UInt32 = 0
                
                let statusFileResult: Int32 = git_status_file(
                    &statusFlags,
                    repository.pointer,
                    Repository.readmeFileName
                )
                
                XCTAssertOK(GitErrorCode(rawValue: statusFileResult))
                
                /// The file should have staged changes in the index.
                XCTAssertTrue((statusFlags & GIT_STATUS_INDEX_MODIFIED.rawValue) != 0)
            }
        }
    }
}
