//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

extension Bool
{
    /// Calls the given closure with a mutable pointer to a signed 32-bit
    /// integer, and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    mutating func withMutatingBool<T>(
        _ body: (UnsafeMutablePointer<Int32>) throws -> T
    ) rethrows -> T
    {
        var intValue: Int32 = self.int32Value
        
        let result: T = try body(&intValue)
        
        if isSuccess(result)
        {
            self = Bool(intValue)
        }
        
        return result
    }
}
