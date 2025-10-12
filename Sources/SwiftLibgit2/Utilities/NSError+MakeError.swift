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
        code    : Int32,
        message : String
    ) -> NSError
    {
        /// `code` can be safely cast from `Int32` to `Int` since this is
        /// a widening conversion.
        return NSError(
            domain:     Bundle.main.bundleIdentifier ?? "swift-libgit2",
            code:       Int(code),
            userInfo:   [NSLocalizedDescriptionKey: message]
        )
    }
    
    
    
    /// Creates an `NSError` related to a Swift-to-C conversion failure.
    /// - Returns: The created `NSError`.
    static func makeCConversionError() -> NSError
    {
        return makeError(
            code:       GitErrorCode.gitEUser.rawValue,
            message:    "Failed to convert a Swift value to its C equivalent."
        )
    }
}
