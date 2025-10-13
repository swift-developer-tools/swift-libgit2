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
    ///
    /// ## Discussion
    ///
    /// libgit2 result codes use a type of `Int32`, but `NSError` expects
    /// `Int`. ``code`` can be safely cast from `Int32` to `Int`, since this
    /// is a widening conversion.
    static func makeError(
        code    : Int32,
        message : String
    ) -> NSError
    {
        return NSError(
            domain:     Bundle.main.bundleIdentifier ?? "swift-libgit2",
            code:       Int(code),
            userInfo:   [NSLocalizedDescriptionKey: message]
        )
    }
    
    
    
    /// Creates an `NSError` with the given message and an error code of
    /// ``GitErrorCode/gitEUser``.
    /// - Parameter message: The localized description.
    /// - Returns: The created `NSError`.
    static func makeError(
        _ message : String
    ) -> NSError
    {
        return makeError(
            code:       GitErrorCode.gitEUser.rawValue,
            message:    message
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
