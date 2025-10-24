//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

// MARK: - CMutable

/// A type that can be converted to and from the equivalent C value, and can
/// be mutated.
internal protocol CMutable
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Creates an instance from the equivalent C value.
    /// - Parameter cValue: The C value to use.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    init?(
        cValue: C
    )
}



// MARK: - Extensions

internal extension CMutable where Self: CConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            if
                isSuccess(result),
                let mutated = Self.init(cValue: cValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    mutating func withBorrowingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>?
                = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if
                isSuccess(result),
                let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer,
                let mutated = Self.init(cValue: finalCValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `C` instance, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if
            isSuccess(result),
            let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer,
            let mutated = Self.init(cValue: finalCValuePointer.pointee)
        {
            self = mutated
        }
        
        return result
    }
}



internal extension CMutable where Self: ThrowingCConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        var cValue: C = try cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            if
                isSuccess(result),
                let mutated = Self.init(cValue: cValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    mutating func withBorrowingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T
    {
        var cValue: C = try cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if
                isSuccess(result),
                let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer,
                let mutated = Self.init(cValue: finalCValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `C` instance, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if
            isSuccess(result),
            let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer,
            let mutated = Self.init(cValue: finalCValuePointer.pointee)
        {
            self = mutated
        }
        
        return result
    }
}



internal extension CMutable where Self: WithCConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            if
                isSuccess(result),
                let mutated = Self.init(cValue: cValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    mutating func withBorrowingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if
                isSuccess(result),
                let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer,
                let mutated = Self.init(cValue: finalCValuePointer.pointee)
            {
                self = mutated
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `C` instance, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if
            isSuccess(result),
            let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer,
            let mutated = Self.init(cValue: finalCValuePointer.pointee)
        {
            self = mutated
        }
        
        return result
    }
}



internal extension CMutable where Self: CConvertible & CFreeable
{
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    ///
    /// - Important: If libgit2 allocates new memory, this method will
    /// automatically free that memory by calling the receiver's
    /// ``freeCValue(_:)`` method after copying the data.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) rethrows -> T where P == UnsafeMutablePointer<C>?
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>?
                = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            guard let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            else
            {
                return result
            }
            
            
            
            if
                isSuccess(result),
                let mutated = Self.init(cValue: finalCValuePointer.pointee)
            {
                self = mutated
            }
            
            if finalCValuePointer != cValuePointer
            {
                Self.freeCValue(finalCValuePointer)
            }
            
            return result
        }
    }
}



internal extension CMutable where Self: ThrowingCConvertible & CFreeable
{
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    ///
    /// - Important: If libgit2 allocates new memory, this method will
    /// automatically free that memory by calling the receiver's
    /// ``freeCValue(_:)`` method after copying the data.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T where P == UnsafeMutablePointer<C>?
    {
        var cValue: C = try cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            guard let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            else
            {
                return result
            }
            
            
            
            if
                isSuccess(result),
                let mutated = Self.init(cValue: finalCValuePointer.pointee)
            {
                self = mutated
            }
            
            if finalCValuePointer != cValuePointer
            {
                Self.freeCValue(finalCValuePointer)
            }
            
            return result
        }
    }
}



internal extension CMutable where Self: WithCConvertible & CFreeable
{
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    ///
    /// - Important: If libgit2 allocates new memory, this method will
    /// automatically free that memory by calling the receiver's
    /// ``freeCValue(_:)`` method after copying the data.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T where P == UnsafeMutablePointer<C>?
    {
        return try withCValue
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            guard let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            else
            {
                return result
            }
            
            
            
            if
                isSuccess(result),
                let mutated = Self.init(cValue: finalCValuePointer.pointee)
            {
                self = mutated
            }
            
            if finalCValuePointer != cValuePointer
            {
                Self.freeCValue(finalCValuePointer)
            }
            
            return result
        }
    }
}
