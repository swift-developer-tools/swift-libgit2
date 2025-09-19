//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation
import XCTest
@testable import SwiftLibgit2



/// Diff-related testing utilities.
enum Diff
{
    /// Calls the given closure with a pointer to a diff between HEAD and the working directory.
    /// - Parameters:
    ///   - repository: The repository on which the diff should be created.
    ///   - body: The closure to call.
    /// - Throws: An `Error` thrown by the closure or if the write operation failed,
    /// or an `NSError` if the diff could not be created.
    static func withDiffPointer(
        in  repository  : Repository,
        _   body        : (OpaquePointer) throws -> Void
    ) throws
    {
        try repository.modifyFile(
            path:       Repository.readmeFileName,
            content:    "\(Repository.readmeFileContent) Goodbye World!"
        )
        
        
        
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
        XCTAssertNotNil(treePointer)
        
        
        
        var diffPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeDiff(diffPointer)
        }
        
        let diffTreeToWorkdirResult: Int32 = git_diff_tree_to_workdir(
            &diffPointer,
            repository.pointer,
            treePointer,
            nil
        )
        
        XCTAssertOK(diffTreeToWorkdirResult)
        
        guard let diffPointer: OpaquePointer = diffPointer
        else
        {
            throw NSError.create(
                code:       Int(GIT_EUSER.rawValue),
                message:    "The diff pointer was nil."
            )
        }
        
        
        
        return try body(diffPointer)
    }
}
