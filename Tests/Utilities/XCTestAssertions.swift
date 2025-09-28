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



/// Miscellaneous or general assertions which do not fit in a more specific namespace.
/// These are global rather than namespaced to match the general use of `XCTest`.



/// Checks if a libgit2 result code is `GIT_OK`, or is one of the given codes.
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
