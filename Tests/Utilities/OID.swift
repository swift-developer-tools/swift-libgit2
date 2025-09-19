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



/// OID-related testing utilities.
enum OID
{
    /// Asserts that two OIDs are equal.
    /// - Parameters:
    ///   - oid1: The first OID.
    ///   - oid2: The second OID.
    static func assertOIDsEqual(
        _ oid1  : GitOID,
        _ oid2  : GitOID
    )
    {
        let oidEqualResult: Bool = gitOIDEqual(
            a:  oid1,
            b:  oid2
        )
        
        XCTAssertTrue(oidEqualResult)
    }
    
    
    
    /// Gets the HEAD commit OID.
    /// - Parameter repository: The repository on which the HEAD commit exists.
    /// - Returns: The HEAD commit OID.
    static func getHEADCommitOID(
        in repository: Repository
    ) -> GitOID
    {
        var headOID = git_oid()
        
        let referenceNameToIDResult: Int32 = git_reference_name_to_id(
            &headOID,
            repository.pointer,
            "HEAD"
        )
        
        XCTAssertOK(referenceNameToIDResult)
        
        return GitOID(cValue: headOID)
    }
}
