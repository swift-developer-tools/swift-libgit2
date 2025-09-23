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
    /// Calls the given closure with an optional pointer to the contents of the string.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withOptionalCString<T>(
        _ body: (UnsafePointer<CChar>?) -> T
    ) -> T
    {
        switch self
        {
            case .none:
                
                return body(nil)
                
            case .some(let wrapped):
                
                return wrapped.withCString
                {
                    cString in
                    
                    return body(cString)
                }
        }
    }
}
