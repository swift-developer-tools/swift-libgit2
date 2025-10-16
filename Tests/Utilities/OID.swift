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
    /// - Parameter repository: The repository on which the HEAD commit exists.
    /// - Returns: The HEAD commit OID.
    static func getHEADCommitOID(
        in repository: Repository
    ) -> GitOID
    {
        var cHeadOID = git_oid()
        
        let referenceNameToIDResult: Int32 = git_reference_name_to_id(
            &cHeadOID,
            repository.pointer,
            "HEAD"
        )
        
        XCTAssertOK(GitErrorCode(rawValue: referenceNameToIDResult))
        
        
        
        let headOID = GitOID(cValue: cHeadOID)
        
        XCTAssertNotZeroOID(headOID)
        
        return headOID
    }
}
