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



final class WorktreeTests: XCTestCaseStopOnFail
{
    func testGitWorktreeAdd() throws
    {
        try withWorktree
        {
            _, _ in
        }
    }
    
    
    
    func testGitWorktreeAddWithOptions() throws
    {
        var worktreeAddOptions = GitWorktreeAddOptions()
        
        worktreeAddOptions.lock = true
        
        
        
        try withWorktree(options: worktreeAddOptions)
        {
            _, worktreePointer in
            
            var lockReason: String? = nil
            
            let isLocked: Bool? = gitWorktreeIsLocked(
                reason:     &lockReason,
                wt:         worktreePointer
            )
            
            XCTAssertNotNil(isLocked)
            XCTAssertTrue(isLocked ?? false)
            XCTAssertNotNil(lockReason)
        }
    }
    
    
    
    func testGitWorktreeAddOptions() throws
    {
        let worktreeAddOptions = GitWorktreeAddOptions()
        
        XCTAssertEqual(worktreeAddOptions.version, gitWorktreeAddOptionsVersion)
        XCTAssertFalse(worktreeAddOptions.lock)
        XCTAssertFalse(worktreeAddOptions.checkoutExisting)
        XCTAssertNil(worktreeAddOptions.ref)
        XCTAssertNotNil(worktreeAddOptions.checkoutOpts)
        
        try worktreeAddOptions.withCValue
        {
            cWorktreeAddOptions in
            
            XCTAssertEqual(cWorktreeAddOptions.pointee.version, gitWorktreeAddOptionsVersion)
            XCTAssertFalse(Bool(cWorktreeAddOptions.pointee.lock))
            XCTAssertFalse(Bool(cWorktreeAddOptions.pointee.checkout_existing))
            XCTAssertNil(cWorktreeAddOptions.pointee.ref)
            XCTAssertNotNil(cWorktreeAddOptions.pointee.checkout_options)
        }
    }
    
    
    
    func testGitWorktreeAddOptionsInit() throws
    {
        var worktreeAddOptions = git_worktree_add_options()
        
        let worktreeAddOptionsInitResult: GitErrorCode
            = gitWorktreeAddOptionsInit(
                opts:       &worktreeAddOptions,
                version:    gitWorktreeAddOptionsVersion
            )
        
        XCTAssertOK(worktreeAddOptionsInitResult)
    }
    
    
    
    func testGitWorktreeAddOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitWorktreePruneOptionsVersion), GIT_WORKTREE_ADD_OPTIONS_VERSION)
    }
    
    
    
    func testGitWorktreeFree() throws
    {
        gitWorktreeFree(wt: nil)
    }
    
    
    
    func testGitWorktreeIsPrunable() throws
    {
        try withWorktree
        {
            _, worktreePointer in
            
            var worktreePruneOptions = GitWorktreePruneOptions()
            
            var isPruneable: Bool? = gitWorktreeIsPrunable(
                wt:     worktreePointer,
                opts:   worktreePruneOptions
            )
            
            XCTAssertNotNil(isPruneable)
            XCTAssertFalse(isPruneable ?? true)
            
            
            
            worktreePruneOptions.flags =
            [
                .gitWorktreePruneValid,
                .gitWorktreePruneLocked,
                .gitWorktreePruneWorkingTree
            ]
            
            isPruneable = gitWorktreeIsPrunable(
                wt:     worktreePointer,
                opts:   worktreePruneOptions
            )
            
            XCTAssertNotNil(isPruneable)
            XCTAssertTrue(isPruneable ?? false)
        }
    }
    
    
    
    func testGitWorktreeList() throws
    {
        try withWorktree
        {
            repository, _ in
            
            var worktreeNames: [String] = []
            
            let worktreeListResult: GitErrorCode = gitWorktreeList(
                out:    &worktreeNames,
                repo:   repository.pointer
            )
            
            XCTAssertOK(worktreeListResult)
            XCTAssertEqual(worktreeNames.count, 1)
            XCTAssertTrue(worktreeNames.contains(Self.worktreeName))
        }
    }
    
    
    
    func testGitWorktreeLockAndUnlock() throws
    {
        try withWorktree
        {
            _, worktreePointer in
            
            let lockReason: String = "Something"
            
            let worktreeLockResult: GitErrorCode = gitWorktreeLock(
                wt:         worktreePointer,
                reason:     lockReason
            )
            
            XCTAssertOK(worktreeLockResult)
            
            
            
            var retrievedLockReason: String? = nil
            
            var isLocked: Bool? = gitWorktreeIsLocked(
                reason:     &retrievedLockReason,
                wt:         worktreePointer
            )
            
            XCTAssertNotNil(isLocked)
            XCTAssertTrue(isLocked ?? false)
            XCTAssertNotNil(retrievedLockReason)
            XCTAssertEqual(retrievedLockReason, lockReason)
            
            
            
            let worktreeUnlockResult: GitErrorCode
                = gitWorktreeUnlock(wt: worktreePointer)
            
            XCTAssertOK(worktreeUnlockResult)
            
            
            
            retrievedLockReason = nil
            
            isLocked = gitWorktreeIsLocked(
                reason:     &retrievedLockReason,
                wt:         worktreePointer
            )
            
            XCTAssertNotNil(isLocked)
            XCTAssertFalse(isLocked ?? true)
            XCTAssertNotNil(retrievedLockReason)
            XCTAssertEqual(retrievedLockReason, "")
        }
    }
    
    
    
    func testGitWorktreeLockWithoutReason() throws
    {
        try withWorktree
        {
            _, worktreePointer in
            
            let worktreeLockResult: GitErrorCode = gitWorktreeLock(
                wt:         worktreePointer,
                reason:     nil
            )
            
            XCTAssertOK(worktreeLockResult)
            
            
            
            var lockReason: String? = nil
            
            let isLocked: Bool? = gitWorktreeIsLocked(
                reason:     &lockReason,
                wt:         worktreePointer
            )
            
            XCTAssertNotNil(isLocked)
            XCTAssertTrue(isLocked ?? false)
            XCTAssertNotNil(lockReason)
            XCTAssertEqual(lockReason, "")
        }
    }
    
    
    
    func testGitWorktreeLookup() throws
    {
        try withWorktree
        {
            repository, _ in
            
            var worktreePointer: OpaquePointer? = nil
            
            defer
            {
                gitWorktreeFree(wt: worktreePointer)
            }
            
            
            
            let worktreeLookupResult: GitErrorCode = gitWorktreeLookup(
                out:    &worktreePointer,
                repo:   repository.pointer,
                name:   Self.worktreeName
            )
            
            XCTAssertOK(worktreeLookupResult)
            
            guard let worktreePointer: OpaquePointer = worktreePointer
            else
            {
                XCTFail("The worktree pointer was nil.")
                return
            }
            
            
            
            let worktreeName: String? = gitWorktreeName(wt: worktreePointer)
            
            XCTAssertNotNil(worktreeName)
            XCTAssertEqual(worktreeName, Self.worktreeName)
        }
    }
    
    
    
    func testGitWorktreeName() throws
    {
        try withWorktree
        {
            _, worktreePointer in
            
            let worktreeName: String? = gitWorktreeName(wt: worktreePointer)
            
            XCTAssertNotNil(worktreeName)
            XCTAssertEqual(worktreeName, Self.worktreeName)
        }
    }
    
    
    
    func testGitWorktreeOpenFromRepository() throws
    {
        try withWorktree
        {
            repository, _ in
            
            var repoPointer     : OpaquePointer?    = nil
            var worktreePointer : OpaquePointer?    = nil
            
            defer
            {
                gitRepositoryFree(repo: repoPointer)
                gitWorktreeFree(wt: worktreePointer)
            }
            
            
            
            let repoOpenResult: GitErrorCode = gitRepositoryOpen(
                out:    &repoPointer,
                path:   Self.worktreePath
            )
            
            XCTAssertOK(repoOpenResult)
            
            guard let repoPointer: OpaquePointer = repoPointer
            else
            {
                XCTFail("The repository pointer was nil.")
                return
            }
            
            
            
            let worktreeOpenFromRepoResult: GitErrorCode
                = gitWorktreeOpenFromRepository(
                    out:    &worktreePointer,
                    repo:   repoPointer
                )
            
            XCTAssertOK(worktreeOpenFromRepoResult)
            
            guard let worktreePointer: OpaquePointer = worktreePointer
            else
            {
                XCTFail("The worktree pointer was nil.")
                return
            }
            
            
            
            let worktreeName: String? = gitWorktreeName(wt: worktreePointer)
            
            XCTAssertNotNil(worktreeName)
            XCTAssertEqual(worktreeName, Self.worktreeName)
        }
    }
    
    
    
    func testGitWorktreePath() throws
    {
        try withWorktree
        {
            _, worktreePointer in
            
            let worktreePath: String? = gitWorktreePath(wt: worktreePointer)
            
            XCTAssertNotNil(worktreePath)
            XCTAssertTrue(worktreePath?.contains(Self.worktreeName) ?? false)
        }
    }
    
    
    
    func testGitWorktreePrune() throws
    {
        try withWorktree
        {
            repository, worktreePointer in
            
            var worktreePruneOptions = GitWorktreePruneOptions()
            
            worktreePruneOptions.flags =
            [
                .gitWorktreePruneValid,
                .gitWorktreePruneLocked,
                .gitWorktreePruneWorkingTree
            ]
            
            let worktreePruneResult: GitErrorCode = gitWorktreePrune(
                wt:     worktreePointer,
                opts:   worktreePruneOptions
            )
            
            XCTAssertOK(worktreePruneResult)
            
            
            
            let worktreeExists: Bool
                = FileManager.default.fileExists(atPath: Self.worktreePath)
            
            XCTAssertFalse(worktreeExists)
        }
    }
    
    
    
    func testGitWorktreePruneOptions() throws
    {
        let worktreePruneOptions = GitWorktreePruneOptions()
        
        XCTAssertEqual(worktreePruneOptions.version, gitWorktreePruneOptionsVersion)
        XCTAssertEqual(worktreePruneOptions.flags, [])
        
        try worktreePruneOptions.withCValue
        {
            cWorktreePruneOptions in
            
            XCTAssertEqual(cWorktreePruneOptions.pointee.version, gitWorktreePruneOptionsVersion)
            XCTAssertEqual(GitWorktreePruneT(rawValue: cWorktreePruneOptions.pointee.flags), [])
        }
    }
    
    
    
    func testGitWorktreePruneOptionsInit() throws
    {
        var worktreePruneOptions = git_worktree_prune_options()
        
        let worktreePruneOptionsInitResult: GitErrorCode
            = gitWorktreePruneOptionsInit(
                opts:       &worktreePruneOptions,
                version:    gitWorktreePruneOptionsVersion
            )
        
        XCTAssertOK(worktreePruneOptionsInitResult)
    }
    
    
    
    func testGitWorktreePruneT() throws
    {
        XCTAssertEqual(GitWorktreePruneT.gitWorktreePruneValid.rawValue, GIT_WORKTREE_PRUNE_VALID.rawValue)
        XCTAssertEqual(GitWorktreePruneT.gitWorktreePruneLocked.rawValue, GIT_WORKTREE_PRUNE_LOCKED.rawValue)
        XCTAssertEqual(GitWorktreePruneT.gitWorktreePruneWorkingTree.rawValue, GIT_WORKTREE_PRUNE_WORKING_TREE.rawValue)
        
        XCTAssertEqual(GitWorktreePruneT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitWorktreePruneT.gitWorktreePruneValid.cValue(), GIT_WORKTREE_PRUNE_VALID)
        XCTAssertEqual(GitWorktreePruneT.gitWorktreePruneLocked.cValue(), GIT_WORKTREE_PRUNE_LOCKED)
        XCTAssertEqual(GitWorktreePruneT.gitWorktreePruneWorkingTree.cValue(), GIT_WORKTREE_PRUNE_WORKING_TREE)
        
        XCTAssertEqual(GitWorktreePruneT(cValue: GIT_WORKTREE_PRUNE_VALID), .gitWorktreePruneValid)
        XCTAssertEqual(GitWorktreePruneT(cValue: GIT_WORKTREE_PRUNE_LOCKED), .gitWorktreePruneLocked)
        XCTAssertEqual(GitWorktreePruneT(cValue: GIT_WORKTREE_PRUNE_WORKING_TREE), .gitWorktreePruneWorkingTree)
        
        
        
        let flags: GitWorktreePruneT =
        [
            .gitWorktreePruneValid,
            .gitWorktreePruneLocked
        ]
        
        XCTAssertTrue(flags.contains(.gitWorktreePruneValid))
        XCTAssertTrue(flags.contains(.gitWorktreePruneLocked))
        XCTAssertFalse(flags.contains(.gitWorktreePruneWorkingTree))
    }
    
    
    
    func testGitWorktreePruneOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitWorktreePruneOptionsVersion), GIT_WORKTREE_PRUNE_OPTIONS_VERSION)
    }
    
    
    
    func testGitWorktreeValidate() throws
    {
        try withWorktree
        {
            _, worktreePointer in
            
            let worktreeValidateResult: GitErrorCode
                = gitWorktreeValidate(wt: worktreePointer)
            
            XCTAssertOK(worktreeValidateResult)
        }
    }
}



// MARK: - Extensions

private extension WorktreeTests
{
    static let worktreeName: String    = "worktree"
    static let worktreePath: String    = worktreeURL.path()
    
    static let worktreeURL: URL
        = FileManager.default.temporaryDirectory
            .appending(
                path:           worktreeName,
                directoryHint:  .isDirectory
            )
            .appendingPathExtension(UUID().uuidString)
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a worktree.
    /// - Parameters:
    ///   - options: The worktree adding options to use.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withWorktree(
        options : GitWorktreeAddOptions? = nil,
        _ body  : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var worktreePointer: OpaquePointer? = nil
            
            defer
            {
                gitWorktreeFree(wt: worktreePointer)
                
                try? FileManager.default.removeItem(at: Self.worktreeURL)
            }
            
            
            
            try? FileManager.default.removeItem(at: Self.worktreeURL)
            
            let worktreeAddResult: GitErrorCode = gitWorktreeAdd(
                out:    &worktreePointer,
                repo:   repository.pointer,
                name:   Self.worktreeName,
                path:   Self.worktreePath,
                opts:   options
            )
            
            XCTAssertOK(worktreeAddResult)
            
            guard let worktreePointer: OpaquePointer = worktreePointer
            else
            {
                XCTFail("The worktree pointer was nil.")
                return
            }
            
            
            
            try body(
                repository,
                worktreePointer
            )
        }
    }
}
