//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation
import XCTest
@testable import SwiftLibgit2



/// Diff-related test utilities.
enum Diff
{
    /// Asserts that the given diff meets certain expectations.
    /// - Parameters:
    ///   - diffPointer: The diff to evaluate.
    ///   - type: The type to evaluate.
    ///
    /// ## Discussion
    ///
    /// The following conditions are checked:
    ///
    /// - The diff is not `nil`.
    /// - The diff has a non-zero number of deltas.
    /// - The diff has a non-zero number of deltas of the given type, if a
    /// type was specified.
    static func assertDiffChanges(
        diffPointer : OpaquePointer?,
        type        : GitDeltaT?        = nil
    )
    {
        guard let diffPointer: OpaquePointer = diffPointer
        else
        {
            XCTFail("The diff pointer was nil.")
            return
        }
        
        
        
        let deltas: Int = gitDiffNumDeltas(diff: diffPointer)
        
        XCTAssertGreaterThan(deltas, 0)
        
        
        
         _ = gitDiffIsSortedICase(diff: diffPointer)
        
        
        
        guard let type: GitDeltaT = type
        else
        {
            return
        }
        
        
        
        let deltasOfType: Int = gitDiffNumDeltasOfType(
            diff:   diffPointer,
            type:   type
        )
        
        XCTAssertGreaterThan(deltasOfType, 0)
        
        
        
        guard let delta: GitDiffDelta
                = gitDiffGetDelta(
                    diff:   diffPointer,
                    idx:    0
                )
        else
        {
            XCTFail("The delta was nil.")
            return
        }
        
        XCTAssertEqual(delta.status, type)
        XCTAssertNotNil(delta.oldFile.path)
        XCTAssertNotNil(delta.newFile.path)
    }
    
    
    
    /// Calls the given closure with a pointer to a diff between two trees.
    /// - Parameters:
    ///   - repository: The repository in which to create the diff.
    ///   - oldCommitOID: The old commit ID.
    ///   - newCommitOID: The new commit ID.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withTreeToTreeDiffPointer<T>(
        in  repository  : Repository,
        oldCommitOID    : GitOID,
        newCommitOID    : GitOID,
        _   body        : (OpaquePointer) throws -> T
    ) throws -> T
    {
        var oldCommitPointer    : OpaquePointer?    = nil
        var newCommitPointer    : OpaquePointer?    = nil
        var oldTreePointer      : OpaquePointer?    = nil
        var newTreePointer      : OpaquePointer?    = nil
        var diffPointer         : OpaquePointer?    = nil
        
        defer
        {
            gitCommitFree(commit: oldCommitPointer)
            gitCommitFree(commit: newCommitPointer)
            Free.freeTree(oldTreePointer)
            Free.freeTree(newTreePointer)
            gitDiffFree(diff: diffPointer)
        }
        
        
        
        let oldCommitLookupResult: GitErrorCode = gitCommitLookup(
            commit:     &oldCommitPointer,
            repo:       repository.pointer,
            id:         oldCommitOID
        )
        
        XCTAssertOK(oldCommitLookupResult)
        
        guard let oldCommitPointer: OpaquePointer = oldCommitPointer
        else
        {
            throw NSError.makeError("The old commit pointer was nil.")
        }
        
        
        
        let newCommitLookupResult: GitErrorCode = gitCommitLookup(
            commit:     &newCommitPointer,
            repo:       repository.pointer,
            id:         newCommitOID
        )
        
        XCTAssertOK(newCommitLookupResult)
        
        guard let newCommitPointer: OpaquePointer = newCommitPointer
        else
        {
            throw NSError.makeError("The new commit pointer was nil.")
        }
        
        
        
        let oldCommitTreeResult: GitErrorCode = gitCommitTree(
            out:        &oldTreePointer,
            commit:     oldCommitPointer
        )
        
        XCTAssertOK(oldCommitTreeResult)
        XCTAssertNotNil(oldTreePointer)
        
        
        
        let newCommitTreeResult: GitErrorCode = gitCommitTree(
            out:        &newTreePointer,
            commit:     newCommitPointer
        )
        
        XCTAssertOK(newCommitTreeResult)
        XCTAssertNotNil(newCommitPointer)
        
        
        
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
            throw NSError.makeError("The diff pointer was nil.")
        }
        
        
        
        assertDiffChanges(diffPointer: diffPointer)
        
        return try body(diffPointer)
    }
    
    
    
    /// Calls the given closure with a pointer to a diff between HEAD and the
    /// working directory.
    /// - Parameters:
    ///   - repository: The repository in which to create the diff.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withTreeToWorkdirDiffPointer<T>(
        in  repository  : Repository,
        _   body        : (OpaquePointer) throws -> T
    ) throws -> T
    {
        try repository.modifyFile(
            at:     Repository.readmeFileName,
            with:   "\(Repository.readmeFileContent) Goodbye World!"
        )
        
        
        
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
            XCTAssertNotNil(treePointer)
        }
        
        
        
        var diffPointer: OpaquePointer? = nil
        
        defer
        {
            gitDiffFree(diff: diffPointer)
        }
        
        
        
        let diffTreeToWorkdirResult: GitErrorCode = gitDiffTreeToWorkdir(
            diff:       &diffPointer,
            repo:       repository.pointer,
            oldTree:    treePointer,
            opts:       nil
        )
        
        XCTAssertOK(diffTreeToWorkdirResult)
        
        guard let diffPointer: OpaquePointer = diffPointer
        else
        {
            throw NSError.makeError("The diff pointer was nil.")
        }
        
        assertDiffChanges(diffPointer: diffPointer)
        
        
        
        return try body(diffPointer)
    }
}
