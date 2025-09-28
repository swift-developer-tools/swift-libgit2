//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Foundation



internal extension NSError
{
    /// Creates an `NSError` from the given information.
    /// - Parameters:
    ///   - code: The error code.
    ///   - message: The localized description.
    /// - Returns: The created `NSError`.
    static func makeError(
        code    : Int,
        message : String
    ) -> NSError
    {
        return NSError(
            domain:     Bundle.main.bundleIdentifier ?? "swift-libgit2",
            code:       code,
            userInfo:   [NSLocalizedDescriptionKey: message]
        )
    }
}
