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



// MARK: - Result Codes

/// Checks whether a libgit2 result code is `GIT_OK`, or is one of the given codes.
/// - Parameters:
///   - resultCode: The libgit2 result code.
///   - includedCodes: The libgit2 result codes other than `GIT_OK` to consider successful.
/// - Returns: Whether the libgit2 result code was `GIT_OK`, or was one of the given result codes.
func isOK(
    _           resultCode      : Int32,
    including   includedCodes   : Set<Int32>    = []
) -> Bool
{
    return resultCode == GIT_OK.rawValue
           || includedCodes.contains(resultCode)
}



/// Asserts that the given libgit2 operation result code is `GIT_OK`.
/// - Parameter result: The libgit2 operation result code.
func XCTAssertOK(
    _ result: Int32
)
{
    guard !isOK(result)
    else
    {
        return
    }
    
    
    
    let error   : UnsafePointer<git_error>?     = git_error_last()
    var message : String                        = "Code: \(result)."
    
    if let errorMessage = String(optionalCString: error?.pointee.message)
    {
        message += " \(errorMessage)"
    }
    
    XCTAssertEqual(result, GIT_OK.rawValue, message)
}



/// Asserts that the given libgit2 operation result code is not `GIT_OK`.
/// - Parameter result: The libgit2 operation result code.
func XCTAssertNotOK(
    _ result: Int32
)
{
    guard !isOK(result)
    else
    {
        XCTFail("The result was GIT_OK.")
        return
    }
    
    
    
    /// Clear the error before returning.
    git_error_last()
}



// MARK: - OIDs

/// Asserts that the given OIDs are equal.
/// - Parameters:
///   - oid1: The first OID.
///   - oid2: The second OID.
func XCTAssertEqual(
    _ oid1  : GitOID?,
    _ oid2  : GitOID?
)
{
    switch (oid1, oid2)
    {
        case (nil, nil):
            
            return
            
        case (nil, _), (_, nil):
            
            XCTFail("One OID is nil while the other is not.")
            return
        
        case let (oid1?, oid2?):
            
            let oidEqualResult: Bool = gitOIDEqual(
                a:  oid1,
                b:  oid2
            )
            
            XCTAssertTrue(oidEqualResult)
    }
}



/// Asserts that the given OIDs are not equal.
/// - Parameters:
///   - oid1: The first OID.
///   - oid2: The second OID.
func XCTAssertNotEqual(
    _ oid1  : GitOID?,
    _ oid2  : GitOID?
)
{
    switch (oid1, oid2)
    {
        case (nil, nil):
            
            XCTFail("Both OIDs are nil.")
            return
            
        case (nil, _), (_, nil):
            
            return
        
        case let (oid1?, oid2?):
            
            let oidEqualResult: Bool = gitOIDEqual(
                a:  oid1,
                b:  oid2
            )
            
            XCTAssertFalse(oidEqualResult)
    }
}



/// Asserts that the given OID is non-`nil` and zero-initialized.
/// - Parameter oid: The OID.
func XCTAssertZeroOID(
    _ oid : GitOID?
)
{
    guard let oid: GitOID = oid
    else
    {
        XCTFail("The OID is nil.")
        return
    }
    
    XCTAssertEqual(oid, GitOID())
}



/// Asserts that the given OID is non-`nil` and not zero-initialized.
/// - Parameter oid: The OID.
func XCTAssertNotZeroOID(
    _ oid : GitOID?
)
{
    guard let oid: GitOID = oid
    else
    {
        XCTFail("The OID is nil.")
        return
    }
    
    XCTAssertNotEqual(oid, GitOID())
}
