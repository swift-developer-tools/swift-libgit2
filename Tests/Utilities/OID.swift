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



/// OID-related testing utilities.
enum OID
{
    /// Gets the HEAD commit OID.
    /// - Parameter repository: The repository to use.
    /// - Returns: The HEAD commit OID.
    static func getHEADCommitOID(
        in repository: Repository
    ) -> GitOID
    {
        var headOID = GitOID()
        
        let referenceNameToIDResult: GitErrorCode = gitReferenceNameToID(
            out:    &headOID,
            repo:   repository.pointer,
            name:   "HEAD"
        )
        
        XCTAssertOK(referenceNameToIDResult)
        XCTAssertNotZeroOID(headOID)
        
        return headOID
    }
}
