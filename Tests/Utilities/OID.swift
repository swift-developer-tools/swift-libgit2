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



/// OID-related testing utilities.
enum OID
{
    /// Asserts that two OIDs are equal.
    /// - Parameters:
    ///   - oid1: The first OID.
    ///   - oid2: The second OID.
    static func assertOIDsEqual(
        _ oid1  : UnsafePointer<git_oid>,
        _ oid2  : UnsafePointer<git_oid>
    )
    {
        guard let oid1StringPointer: UnsafeMutablePointer<CChar> = git_oid_tostr_s(oid1)
        else
        {
            XCTFail("The first OID string pointer was nil.")
            return
        }
        
        guard let oid2StringPointer: UnsafeMutablePointer<CChar> = git_oid_tostr_s(oid2)
        else
        {
            XCTFail("The second OID string pointer was nil.")
            return
        }
        
        let oid1String  = String(cString: oid1StringPointer)
        let oid2String  = String(cString: oid2StringPointer)
        
        XCTAssertEqual(oid1String, oid2String)
    }
    
    
    
    /// Gets the HEAD commit OID.
    /// - Parameter repository: The repository on which the HEAD commit exists.
    /// - Returns: The HEAD commit OID.
    static func getHEADCommitOID(
        in repository: Repository
    ) -> git_oid
    {
        var headOID = git_oid()
        
        let referenceNameToIDResult: Int32 = git_reference_name_to_id(
            &headOID,
            repository.pointer,
            "HEAD"
        )
        
        XCTAssertOK(referenceNameToIDResult)
        
        return headOID
    }
}
