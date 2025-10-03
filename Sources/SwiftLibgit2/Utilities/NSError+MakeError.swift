//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
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
    
    
    
    /// Creates an `NSError` related to a Swift-to-C conversion failure.
    /// - Returns: The created `NSError`.
    static func makeCConversionError() -> NSError
    {
        return makeError(
            code:       Int(GIT_EUSER.rawValue),
            message:    "Failed to convert Swift binding to C equivalent."
        )
    }
}
