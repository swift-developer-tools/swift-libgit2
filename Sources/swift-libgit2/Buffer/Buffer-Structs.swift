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
/// A ``GitBuf`` contains a pointer to a `NULL`-terminated C string and the length of the string, in bytes.
/// The length of the string does not include the `NULL` terminator.
///
/// ## C Equivalent
///
/// [`git_buf`](https://libgit2.org/docs/reference/main/buffer/git_buf.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public struct GitBuf
{
    /// The buffer contents.
    ///
    /// ## Discussion
    ///
    /// ``GitBuf/ptr`` points to the start of the buffer being returned. The buffer's length, in bytes,
    /// is specified by the ``GitBuf/size`` property. The buffer contains a `NULL` terminator at
    /// position `size + 1`.
    public var ptr      : UnsafeMutablePointer<CChar>?
    
    /// This property is unused, but is reserved for API compatibility.
    public var reserved : Int
    
    /// The length, in bytes, of the buffer pointed to by ``GitBuf/ptr``, not including the `NULL`
    /// terminator.
    public var size     : Int
    
    
    
    /// Creates a ``GitBuf`` instance.
    public init()
    {
        /// libgit2 doesn't provide an initialization function for `git_buf`.
        /// The C macro `GIT_BUF_INIT` would zero-initialize all fields, so that approach
        /// is mirrored here.
        self.ptr        = nil
        self.reserved   = 0
        self.size       = 0
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_buf` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCStruct<T>(
        _ body: (UnsafeMutablePointer<git_buf>) -> T
    ) -> T
    {
        var buffer = git_buf()
        
        buffer.ptr          = ptr
        buffer.reserved     = reserved
        buffer.size         = size
        
        return body(&buffer)
    }
    
    
    
    /// Frees the memory pointed to by ``GitBuf/ptr``.
    ///
    /// ## Discussion
    ///
    /// This function does not free the ``GitBuf`` instance itself, only the memory pointed to by
    /// ``GitBuf/ptr``.
    internal mutating func dispose()
    {
        withCStruct
        {
            cBuffer in
            
            git_buf_dispose(cBuffer)
            
            ptr        = cBuffer.pointee.ptr
            reserved   = cBuffer.pointee.reserved
            size       = cBuffer.pointee.size
        }
    }
}
