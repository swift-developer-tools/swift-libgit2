//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
// Parts of this file are adapted from the Swift.org open source project.
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors.
// Licensed under the Apache License, Version 2.0, with Runtime Library
// Exception.
//
// See https://swift.org/LICENSE.txt for license information.
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors.
//
//===----------------------------------------------------------------------===//

/// Parts of the function below are adapted from the Swift.org open source project. Original source code:
/// https://github.com/swiftlang/swift/blob/c3b7709a7c4789f1ad7249d357f69509fb8be731/stdlib/private/SwiftPrivate/SwiftPrivate.swift

import Foundation



internal extension String
{
    /// Calls the given closure with a mutable C string.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the closure.
    ///
    /// ## Discussion
    ///
    /// Use this function over ``String.withCString(_:)`` when working with C APIs
    /// that expect mutable strings.
    ///
    /// This could be done more simply by as follows:
    ///
    /// ```swift
    /// guard let mutableCString: UnsafeMutablePointer<CChar> = strdup(self)
    /// else
    /// {
    ///     return
    /// }
    ///
    /// defer
    /// {
    ///     free(mutableCString)
    /// }
    /// ```
    ///
    /// However, the current approach using a single buffer avoids heap allocation via `malloc()` and
    /// `free()` in `strdup()`. This approach is similar to the one used by the Swift standard library
    /// in ``withArrayOfCStrings(args:body:)``.
    func withMutableCString<T>(
        _ body: (UnsafeMutablePointer<CChar>) -> T
    ) -> T
    {
        let utf8Count   : Int       = self.utf8.count
        var buffer      : [UInt8]   = []
        
        buffer.reserveCapacity(utf8Count + 1)
        
        if !self.isEmpty
        {
            buffer.append(contentsOf: self.utf8)
        }
        
        buffer.append(0)
        
        return buffer.withUnsafeMutableBufferPointer
        {
            buffer in
            
            /// `baseAddress` should never be `nil` since the buffer will not be empty at this point.
            let mutableCString = UnsafeMutableRawPointer(buffer.baseAddress!)
                .bindMemory(to: CChar.self, capacity: buffer.count)
            
            return body(mutableCString)
        }
    }
}
