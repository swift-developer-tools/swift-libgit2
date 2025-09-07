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



/// Miscellaneous or general assertions which do not fit in a more specific namespace.
/// These are global rather than namespaced to match the general use of `XCTest`.



/// Asserts that a libgit2 operation result code is `GIT_OK`.
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
    
    if let errorMessage: String = error?.pointee.message.map({ String(cString: $0) })
    {
        message += " \(errorMessage)"
    }
    
    XCTAssertEqual(result, GIT_OK.rawValue, message)
}
