//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A data buffer for exporting data from libgit2.
///
/// ## Discussion
///
/// Sometimes libgit2 wants to return an allocated data buffer to the caller and have the caller take
/// responsibility for freeing that memory. To make ownership clear in these cases, libgit2 uses ``GitBuf``
/// to return this data. Callers must use ``gitBufDispose(buffer:)`` to free the memory.
///
/// A ``GitBuf`` contains a pointer to a null-terminated C string and the length of the string, in bytes.
/// The length of the string does not include the null terminator.
///
/// ## C Equivalent
///
/// [`git_buf`](https://libgit2.org/docs/reference/main/buffer/git_buf.html)
public struct GitBuf: GitStructInternalMutable, WithCConvertible
{
    /// The buffer contents.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// ``ptr`` points to the start of the buffer being returned. The buffer's length, in bytes, is specified
    /// by the ``size`` property. The buffer contains a null terminator at position `size + 1`.
    ///
    /// In libgit2, `git_buf->ptr` has the following lifecycle:
    ///
    /// - Initial state: `NULL`.
    /// - After population: points to allocated, zero-terminated memory.
    /// - After disposal: points to a static single-character array sentinel value.
    ///
    /// In swift-libgit2, ``ptr`` uses Swift's optional type, where `nil` represents both the initial state
    /// and the disposed state for more idiomatic Swift.
    public internal(set) var ptr        : UnsafeMutablePointer<CChar>?  = nil
    
    /// This property is unused, but is reserved for API compatibility.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public internal(set) var reserved   : Int                           = 0
    
    /// The length, in bytes, of the buffer pointed to by ``ptr``, not including the null terminator.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public internal(set) var size       : Int                           = 0
    
    
    
    /// Creates a ``GitBuf`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitBuf`` instance from a `git_buf` instance.
    /// - Parameter buf: The `git_buf` instance to use.
    internal init(
        cValue buf: git_buf
    )
    {
        self.ptr        = buf.ptr
        self.reserved   = buf.reserved
        self.size       = buf.size
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_buf` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_buf>) throws -> T
    ) rethrows -> T
    {
        var buffer = git_buf()
        
        buffer.ptr          = ptr
        buffer.reserved     = reserved
        buffer.size         = size
        
        return try body(&buffer)
    }
}
