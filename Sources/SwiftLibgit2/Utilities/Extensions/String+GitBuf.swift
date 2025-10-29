//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



internal extension Optional where Wrapped == String
{
    /// Calls the given closure with a mutable pointer to a `git_buf` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    mutating func withOptionalMutatingGitBuf<T>(
        _ body: (UnsafeMutablePointer<git_buf>) throws -> T
    ) throws -> T
    {
        var buffer = git_buf()
        
        defer
        {
            gitBufDispose(buffer: &buffer)
        }
        
        
        
        let result: T = try body(&buffer)
        
        if isSuccess(result)
        {
            self = String(optionalCString: buffer.ptr)
        }
        
        return result
    }
}
