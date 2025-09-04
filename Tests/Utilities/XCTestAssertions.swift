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



/// Assert that a libgit2 operation result code is `GIT_OK`.
/// - Parameters:
///   - result: The libgit2 operation result code.
///   - description: The libgit2 operation description.
func XCTAssertOK(
    _   result      : Int32,
    _   description : String
)
{
    XCTAssertEqual(
        result,
        GIT_OK.rawValue,
        "\(description) was not GIT_OK."
    )
}
