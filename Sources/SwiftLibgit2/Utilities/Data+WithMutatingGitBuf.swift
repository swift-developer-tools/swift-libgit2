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



internal extension Data
{
    /// Calls the given closure with a mutable pointer to a `git_buf` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This method will only mutate the receiver if the operation was
    /// successful and `git_buf->ptr` is not `nil`. The pointer should
    /// generally not be `nil` after a successful operation.
    mutating func withMutatingGitBuf<T>(
        _ body: (UnsafeMutablePointer<git_buf>) throws -> T
    ) throws -> T
    {
        var buffer = git_buf()
        
        defer
        {
            gitBufDispose(buffer: &buffer)
        }
        
        
        
        let result: T = try body(&buffer)
        
        if
            isSuccess(result),
            let ptr: UnsafeMutablePointer<CChar> = buffer.ptr
        {
            self = Data(
                bytes:  ptr,
                count:  buffer.size
            )
        }
        
        return result
    }
}
