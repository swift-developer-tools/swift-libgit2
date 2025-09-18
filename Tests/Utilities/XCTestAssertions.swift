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



/// Asserts that the given libgit2 operation result code is `GIT_OK`.
/// - Parameter result: The libgit2 operation result code.
func XCTAssertOK(
    _ result: Int32
)
{
    guard result != GIT_OK.rawValue
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
