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



final class ApplyTests: XCTestCaseStopOnFail
{
    // MARK: - testGitApplyFlagsT()
    
    func testGitApplyFlagsT() throws
    {
        XCTAssertEqual(GitApplyFlagsT.gitApplyCheck.rawValue, GIT_APPLY_CHECK.rawValue)
        XCTAssertEqual(GitApplyFlagsT(rawValue: 123).rawValue, 123)
        
        
        
        let flags: GitApplyFlagsT =
        [
            .gitApplyCheck,
            GitApplyFlagsT(rawValue: 10)
        ]
        
        XCTAssertTrue(flags.contains(.gitApplyCheck))
        XCTAssertTrue(flags.contains(GitApplyFlagsT(rawValue: 10)))
        XCTAssertFalse(flags.contains(GitApplyFlagsT(rawValue: 123)))
    }
    
    
    
    // MARK: - testGitApplyLocationT()
    
    func testGitApplyLocationT() throws
    {
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationWorkdir.rawValue, GIT_APPLY_LOCATION_WORKDIR.rawValue)
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationIndex.rawValue, GIT_APPLY_LOCATION_INDEX.rawValue)
        XCTAssertEqual(GitApplyLocationT.gitApplyLocationBoth.rawValue, GIT_APPLY_LOCATION_BOTH.rawValue)
        XCTAssertEqual(GitApplyLocationT(rawValue: 123).rawValue, 123)
    }
    
    
    
    // MARK: - testGitApplyOptions()
    
    func testGitApplyOptions() throws
    {
        guard var applyOptions = GitApplyOptions()
        else
        {
            XCTFail("The apply options were nil.")
            return
        }
        
        XCTAssertEqual(applyOptions.version, gitApplyOptionsVersion)
        XCTAssertNil(applyOptions.deltaCB)
        XCTAssertNil(applyOptions.hunkCB)
        XCTAssertNil(applyOptions.payload)
        XCTAssertEqual(applyOptions.flags.rawValue, 0)
        
        XCTAssertEqual(gitApplyOptionsVersion, UInt32(GIT_APPLY_OPTIONS_VERSION))
        
        
        
        applyOptions.flags = GitApplyFlagsT(rawValue: 123)
        
        XCTAssertEqual(applyOptions.flags, GitApplyFlagsT(rawValue: 123))
        
        
        
        applyOptions.flags =
        [
            .gitApplyCheck,
            GitApplyFlagsT(rawValue: 123)
        ]
        
        XCTAssertTrue(applyOptions.flags.contains(.gitApplyCheck))
        XCTAssertTrue(applyOptions.flags.contains(GitApplyFlagsT(rawValue: 123)))
        XCTAssertFalse(applyOptions.flags.contains(GitApplyFlagsT(rawValue: 456)))
    }
    
    
    
    // MARK: - testGitApplyToTree()
    
    func testGitApplyToTree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID         : GitOID            = OID.getHEADCommitOID(in: repository)
            var commitPointer   : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
            }
            
            
            
            var cHeadOID: git_oid = headOID.cValue
            
            let commitLookupResult: Int32 = git_commit_lookup(
                &commitPointer,
                repository.pointer,
                &cHeadOID
            )
            
            XCTAssertOK(commitLookupResult)
            XCTAssertNotNil(commitPointer)
            
            
            
            var treePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(treePointer)
            }
            
            
            
            let commitTreeResult: Int32 = git_commit_tree(
                &treePointer,
                commitPointer
            )
            
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
            
            
            
            guard let applyOptions = GitApplyOptions()
            else
            {
                XCTFail("The apply options were nil.")
                return
            }
            
            try Diff.withDiffPointer(in: repository)
            {
                diffPointer in
                
                let applyToTreeResult: Int32 = gitApplyToTree(
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
    
    
    
    // MARK: - testGitApplyToBoth()
    
    func testGitApplyToBoth() throws
    {
        try gitApplyFlow(
            location:       .gitApplyLocationBoth,
            flags:          nil,
            checkIndex:     true,
            endContent:     "\(Repository.readmeFileContent) Goodbye World!"
        )
    }
    
    
    
    // MARK: - testGitApplyToIndex()
    
    func testGitApplyToIndex() throws
    {
        try gitApplyFlow(
            location:       .gitApplyLocationIndex,
            flags:          nil,
            checkIndex:     true,
            endContent:     Repository.readmeFileContent
        )
    }
    
    
    
    // MARK: - testGitApplyToWorkdir()
    
    func testGitApplyToWorkdir() throws
    {
        try gitApplyFlow(
            location:       .gitApplyLocationWorkdir,
            flags:          nil,
            checkIndex:     false,
            endContent:     "\(Repository.readmeFileContent) Goodbye World!"
        )
    }
    
    
    
    // MARK: - testGitApplyWithCheckFlag()
    
    func testGitApplyWithCheckFlag() throws
    {
        try gitApplyFlow(
            location:       .gitApplyLocationWorkdir,
            flags:          .gitApplyCheck,
            checkIndex:     false,
            endContent:     Repository.readmeFileContent
        )
    }
}



extension ApplyTests
{
    // MARK: - gitApplyFlow()

    /// The callback count for `GitApplyOptions`.
    private struct CallbackCounts
    {
        /// The number of times the delta callback was invoked.
        var deltaCount  : Int   = 0
        
        /// The number of times the hunk callback was invoked.
        var hunkCount   : Int   = 0
    }



    /// Tests `git apply` functionality by creating a diff and applying it with the given options.
    ///
    /// 1. Create a modified version of the repository's `README.md` file.
    /// 2. Stage the modification to create a new tree state.
    /// 3. Generate a diff between the original tree and the modified tree.
    /// 4. Reset the working directory back to the original state.
    /// 5. Apply the diff using the given options.
    /// 6. Check that both the delta and hunk callbacks were invoked.
    /// 7. Check that the final file content is correct.
    /// 8. Optionally check that the index contains staged changes.
    ///
    /// - Parameters:
    ///   - location: The target location for applying the diff (the working directory, the index, or both).
    ///   - flags: The flags to control the apply behavior.
    ///   - checkIndex: Whether to check that the index contains staged changes after applying.
    ///   - endContent: The expected file content after applying.
    /// - Throws: An `Error` if a Git operation, write operation fails, or `GitApplyOptions`
    /// initialization fails.
    private func gitApplyFlow(
        location        : GitApplyLocationT,
        flags           : GitApplyFlagsT?,
        checkIndex      : Bool,
        endContent      : String
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var commitPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
            }
            
            
            
            var cHeadOID: git_oid = headOID.cValue
            
            let commitLookupResult: Int32 = git_commit_lookup(
                &commitPointer,
                repository.pointer,
                &cHeadOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            
            
            var oldTreePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(oldTreePointer)
            }
            
            
            
            let commitTreeResult: Int32 = git_commit_tree(
                &oldTreePointer,
                commitPointer
            )
            
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
            
            XCTAssertOK(repositoryIndexResult)
            
            
            
            let indexAddBypathResult: Int32 = git_index_add_bypath(
                indexPointer,
                Repository.readmeFileName
            )
            
            XCTAssertOK(indexAddBypathResult)
            
            
            
            var newTreeOID = git_oid()
            
            let indexWriteTreeResult: Int32 = git_index_write_tree(
                &newTreeOID,
                indexPointer
            )
            
            XCTAssertOK(indexWriteTreeResult)
            
            
            
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
            
            XCTAssertOK(treeLookupResult)
            
            
            
            var diffPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeDiff(diffPointer)
            }
            
            
            
            let diffTreeToTreeResult: Int32 = git_diff_tree_to_tree(
                &diffPointer,
                repository.pointer,
                oldTreePointer,
                newTreePointer,
                nil
            )
            
            XCTAssertOK(diffTreeToTreeResult)
            
            guard let diffPointer: OpaquePointer = diffPointer
            else
            {
                XCTFail("The diff pointer was nil.")
                return
            }
            
            
            
            let resetResult: Int32 = git_reset(
                repository.pointer,
                commitPointer,
                GIT_RESET_HARD,
                nil
            )
            
            XCTAssertOK(resetResult)
            
            
            
            var callbackCounts = CallbackCounts()
            
            let deltaCB: GitApplyDeltaCB =
            {
                _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GIT_OK.rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackCounts>
                    = payload.assumingMemoryBound(to: CallbackCounts.self)
                
                payloadPointer.pointee.deltaCount += 1
                
                return GIT_OK.rawValue
            }
            
            
            
            let hunkCB: GitApplyHunkCB =
            {
                _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GIT_OK.rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackCounts>
                    = payload.assumingMemoryBound(to: CallbackCounts.self)
                
                payloadPointer.pointee.hunkCount += 1
                
                return GIT_OK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackCounts)
            {
                callbackCountsPointer in
                
                guard var applyOptions = GitApplyOptions()
                else
                {
                    XCTFail("The apply options were nil.")
                    return
                }
                
                applyOptions.deltaCB    = deltaCB
                applyOptions.hunkCB     = hunkCB
                applyOptions.payload    = UnsafeMutableRawPointer(callbackCountsPointer)
                
                if let flags: GitApplyFlagsT = flags
                {
                    applyOptions.flags = flags
                }
                
                let applyResult: Int32 = gitApply(
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
                
                XCTAssertOK(statusFileResult)
                
                /// The file should have staged changes in the index.
                XCTAssertTrue((statusFlags & GIT_STATUS_INDEX_MODIFIED.rawValue) != 0)
            }
        }
    }
}
