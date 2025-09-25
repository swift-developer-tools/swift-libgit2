//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// A data buffer for exporting data from libgit2.
///
/// ## Discussion
///
/// Sometimes libgit2 wants to return an allocated data buffer to the caller and have the caller take
/// responsibility for freeing that memory. To make ownership clear in these cases, libgit2 uses ``GitBuf``
/// to return this data. Callers should use ``gitBufDispose(buffer:)`` to free the memory.
///
/// A ``GitBuf`` contains a pointer to a null-terminated C string and the length of the string, in bytes.
/// The length of the string does not include the null terminator.
///
/// ## C Equivalent
///
/// [`git_buf`](https://libgit2.org/docs/reference/main/buffer/git_buf.html)
public struct GitBuf
{
    /// The buffer contents.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// ``GitBuf/ptr`` points to the start of the buffer being returned. The buffer's length, in bytes,
    /// is specified by the ``GitBuf/size`` property. The buffer contains a null terminator at
    /// position `size + 1`.
    ///
    /// In libgit2, `git_buf->ptr` has the following lifecycle:
    ///
    /// - Initial state: `NULL`.
    /// - After population: points to allocated, zero-terminated memory.
    /// - After disposal: points to a static single-character array sentinel value.
    ///
    /// In swift-libgit2, ``GitBuf/ptr`` uses Swift's optional type, where `nil` represents both
    /// the initial state and the disposed state for more idiomatic Swift.
    public var ptr      : UnsafeMutablePointer<CChar>?
    
    /// This property is unused, but is reserved for API compatibility.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var reserved : Int
    
    /// The length, in bytes, of the buffer pointed to by ``GitBuf/ptr``, not including the null
    /// terminator.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var size     : Int
    
    
    
    /// Creates a ``GitBuf`` instance.
    public init()
    {
        /// libgit2 does not provide an initialization function for `git_buf`.
        /// The C macro `GIT_BUF_INIT` would initialize all fields to `0` or `NULL`,
        /// so that approach is mirrored here.
        self.ptr        = nil
        self.reserved   = 0
        self.size       = 0
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_buf` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<git_buf>) -> T
    ) -> T
    {
        var buffer = git_buf()
        
        buffer.ptr          = ptr
        buffer.reserved     = reserved
        buffer.size         = size
        
        let result: T = body(&buffer)
        
        ptr        = buffer.ptr
        reserved   = buffer.reserved
        size       = buffer.size
        
        return result
    }
}
