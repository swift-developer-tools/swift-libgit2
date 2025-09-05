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



/// Diff-related testing utilities.
enum Diff
{
    /// Calls the given closure with a pointer to a diff between HEAD and the working directory.
    /// - Parameters:
    ///   - repository: The repository on which the diff should be created.
    ///   - body: The closure to call.
    /// - Throws: An `Error` thrown by the closure, or an `NSError` if the write operation failed
    /// or the diff pointer could not be created.
    static func withDiffPointer(
        on  repository  : Repository,
        _   body        : (OpaquePointer) throws -> Void
    ) throws
    {
        let documentURL: URL = repository.url.appending(
            path:           Repository.originalDocumentName,
            directoryHint:  .notDirectory
        )
        
        let modifiedDocumentContent: String = "\(Repository.originalDocumentContent) Goodbye World!"
        
        do
        {
            try modifiedDocumentContent.write(
                to:             documentURL,
                atomically:     true,
                encoding:       .utf8
            )
        }
        catch
        {
            XCTFail("The modified content was not written to the document: \(error)")
            
            throw NSError(
                domain:     #function,
                code:       Int(GIT_EUSER.rawValue),
                userInfo:   nil
            )
        }
        
        
        
        var headOID         : git_oid           = OID.getHEADCommitOID(on: repository)
        var commitPointer   : OpaquePointer?    = nil
        
        defer
        {
            Free.freeCommitPointer(&commitPointer)
        }
        
        
        
        let commitLookupResult: Int32 = git_commit_lookup(
            &commitPointer,
            repository.pointer,
            &headOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        XCTAssertNotNil(
            commitPointer,
            "The commit pointer was nil."
        )
        
        
        
        var treePointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeTreePointer(&treePointer)
        }
        
        
        
        let commitTreeResult: Int32 = git_commit_tree(
            &treePointer,
            commitPointer
        )
        
        XCTAssertOK(commitTreeResult)
        
        XCTAssertNotNil(
            treePointer,
            "The tree pointer was nil."
        )
        
        
        
        var diffPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeDiffPointer(&diffPointer)
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
            throw NSError(
                domain:     #function,
                code:       Int(GIT_EUSER.rawValue),
                userInfo:   nil
            )
        }
        
        
        
        return try body(diffPointer)
    }
}
