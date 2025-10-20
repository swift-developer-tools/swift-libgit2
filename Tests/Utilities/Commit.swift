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



/// Commit-related test utilities.
enum Commit
{
    /// Calls the given closure with a pointer to the HEAD commit.
    /// - Parameters:
    ///   - repository: The repository containing the commit.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withHEADCommit<T>(
        in  repository  : Repository,
        _   body        : (OpaquePointer) throws -> T
    ) throws -> T
    {
        let headOID: GitOID = OID.getHEADCommitOID(in: repository)
        
        
        
        var commitPointer: OpaquePointer? = nil
        
        defer
        {
            gitCommitFree(commit: commitPointer)
        }
        
        
        
        let commitLookupResult: GitErrorCode = gitCommitLookup(
            commit:     &commitPointer,
            repo:       repository.pointer,
            id:         headOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        guard let commitPointer: OpaquePointer = commitPointer
        else
        {
            throw NSError.makeError("The commit pointer was nil.")
        }
        
        return try body(commitPointer)
    }
}
