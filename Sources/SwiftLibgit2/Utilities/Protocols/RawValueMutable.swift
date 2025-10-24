//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

// MARK: - RawValueMutable

/// A type that can be converted to and from a fixed-size integer raw value,
/// and can be mutated.
internal protocol RawValueMutable: RawRepresentable, Sendable
    where RawValue: FixedWidthInteger { }



// MARK: - Extensions

internal extension RawValueMutable
{
    /// Calls the given closure with a mutable pointer to a `RawValue`,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `RawValue *`.
    mutating func withMutatingRawValue<T>(
        _ body: (UnsafeMutablePointer<RawValue>) throws -> T
    ) rethrows -> T
    {
        var value: RawValue = rawValue
        
        return try withUnsafeMutablePointer(to: &value)
        {
            rawValuePointer in
            
            let result: T = try body(rawValuePointer)
            
            if
                isSuccess(result),
                let mutated = Self.init(rawValue: rawValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `RawValue`, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `RawValue **`.
    mutating func withBorrowingRawValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<RawValue>?>) throws -> T
    ) rethrows -> T
    {
        var value: RawValue = rawValue
        
        return try withUnsafeMutablePointer(to: &value)
        {
            rawValuePointer in
            
            var optionalRawValuePointer: UnsafeMutablePointer<RawValue>?
                = rawValuePointer
            
            let result: T = try body(&optionalRawValuePointer)
            
            if
                isSuccess(result),
                let finalRawValuePointer: UnsafeMutablePointer<RawValue>
                    = optionalRawValuePointer,
                let mutated = Self.init(rawValue: finalRawValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `RawValue`, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const RawValue **`.
    mutating func withMutatingRawValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<RawValue>?>) throws -> T
    ) rethrows -> T
    {
        var optionalRawValuePointer: UnsafePointer<RawValue>? = nil
        
        let result: T = try body(&optionalRawValuePointer)
        
        if
            isSuccess(result),
            let finalRawValuePointer: UnsafePointer<RawValue>
                = optionalRawValuePointer,
            let mutated = Self.init(rawValue: finalRawValuePointer.pointee)
        {
            self = mutated
        }
        
        return result
    }
}
