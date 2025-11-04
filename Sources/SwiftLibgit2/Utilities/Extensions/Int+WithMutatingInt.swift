//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

internal extension Int
{
    /// Calls the given closure with a mutable pointer to an integer, and
    /// updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    mutating func withMutatingInt<T>(
        _ body: (UnsafeMutablePointer<Int>) throws -> T
    ) rethrows -> T
    {
        var intValue: Int = self
        
        let result: T = try body(&intValue)
        
        if isSuccess(result)
        {
            self = intValue
        }
        
        return result
    }
}
