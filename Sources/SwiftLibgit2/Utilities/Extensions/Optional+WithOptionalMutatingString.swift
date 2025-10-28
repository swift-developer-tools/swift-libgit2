//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

internal extension Optional where Wrapped == String
{
    /// Calls the given closure with a mutable pointer to the contents of the
    /// receiver, and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// - Important: This method does not free any memory. Only use this method
    /// with libgit2 functions that return pointers to memory owned by other
    /// objects. Do not use this method with libgit2 functions that allocate
    /// memory that must be freed by the caller.
    mutating func withOptionalMutatingString<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<CChar>?>) throws -> T
    ) rethrows -> T
    {
        switch self
        {
            case .none:
                
                var cString: UnsafePointer<CChar>? = nil
                
                let result: T = try body(&cString)
                
                if isSuccess(result)
                {
                    self = String(optionalCString: cString)
                }
                
                return result
                
            case .some(let wrapped):
                
                return try wrapped.withCString
                {
                    cString in
                    
                    var optionalCString: UnsafePointer<CChar>? = cString
                    
                    let result: T = try body(&optionalCString)
                    
                    if isSuccess(result)
                    {
                        self = String(optionalCString: optionalCString)
                    }
                    
                    return result
                }
        }
    }
}
