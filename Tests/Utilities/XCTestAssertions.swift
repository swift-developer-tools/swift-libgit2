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



// MARK: - Utilities

/// Checks whether the given libgit2 operation result is ``GitErrorCode/gitOK``,
/// and clears the last libgit2 error otherwise.
/// - Parameter errorCode: The libgit2 operation result to check.
/// - Returns: Whether the given libgit2 operation result is
/// ``GitErrorCode/gitOK``.
func isOK(
    _ errorCode: GitErrorCode
) -> Bool
{
    let isOK: Bool = errorCode == .gitOK
    
    if !isOK
    {
        // TODO: Replace when `git_error_clear()` has a binding, and remove CLibgit2 import.
        git_error_clear()
    }
    
    return isOK
}



// MARK: - Result Codes

/// Asserts that the given libgit2 operation result code is
/// ``GitErrorCode/gitOK``.
/// - Parameter result: The libgit2 operation result code to use.
func XCTAssertOK(
    _ result: GitErrorCode
)
{
    guard result != .gitOK
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
    
    XCTAssertEqual(result, GitErrorCode.gitOK, message)
}



/// Asserts that the given libgit2 operation result code is not
/// ``GitErrorCode/gitOK``.
/// - Parameter result: The libgit2 operation result code to use.
func XCTAssertNotOK(
    _ result: GitErrorCode
)
{
    guard result != .gitOK
    else
    {
        XCTFail("The result was gitOK.")
        return
    }
    
    git_error_last()
}



// MARK: - Data

/// Asserts that the UTF-8 content of the given data is equal to the given
/// string.
/// - Parameters:
///   - data: The data to compare.
///   - content: The content to compare against the given data.
func XCTAssertEqual(
    _   data:       Data,
    _   content:    String
)
{
    guard let dataString = String(
        data:       data,
        encoding:   .utf8
    )
    else
    {
        XCTFail("The data string was nil.")
        return
    }
    
    XCTAssertEqual(dataString, content)
}



/// Asserts that the UTF-8 content of the given data is not equal to the
/// given string.
/// - Parameters:
///   - data: The data to compare.
///   - content: The content to compare against the given data.
func XCTAssertNotEqual(
    _   data:       Data,
    _   content:    String
)
{
    guard let dataString = String(
        data:       data,
        encoding:   .utf8
    )
    else
    {
        XCTFail("The data string was nil.")
        return
    }
    
    XCTAssertNotEqual(dataString, content)
}



// MARK: - OIDs

/// Asserts that the given OIDs are equal.
/// - Parameters:
///   - oid1: The first OID to compare.
///   - oid2: The second OID to compare.
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
///   - oid1: The first OID to compare.
///   - oid2: The second OID to compare.
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



/// Asserts that the given OID is not `nil` and all zeros.
/// - Parameter oid: The OID to evaluate.
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
    
    let isZeroOID: Bool = gitOIDIsZero(id: oid)
    
    XCTAssertTrue(isZeroOID)
}



/// Asserts that the given OID is not `nil` and is not all zeros.
/// - Parameter oid: The OID to evaluate.
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
    
    let isZeroOID: Bool = gitOIDIsZero(id: oid)
    
    XCTAssertFalse(isZeroOID)
}
