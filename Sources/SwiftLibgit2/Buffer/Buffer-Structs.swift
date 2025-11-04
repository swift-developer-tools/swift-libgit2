//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A data buffer for exporting data.
///
/// - Note: This struct is provided for documentation purposes, but is not used
/// by other bindings. All bindings use `Data` instead.
///
/// ## C Equivalent
///
/// [`git_buf`](https://libgit2.org/docs/reference/main/buffer/git_buf.html)
public struct GitBuf: CStruct
{
    /// The buffer contents.
    ///
    /// The default value is `nil`.
    ///
    /// This points to the start of the buffer being returned. The buffer's
    /// length, in bytes, is specified by the ``size`` property. The buffer
    /// contains a null terminator at position `size + 1`.
    public let ptr      : UnsafeMutablePointer<CChar>?
    
    /// A reserved property.
    ///
    /// - Note: This property is unused in libgit2, but is reserved for API
    /// compatibility.
    ///
    /// The default value is `0`.
    public let reserved : Int
    
    /// The length, in bytes, of the buffer pointed to by ``ptr``, not
    /// including the null terminator.
    ///
    /// The default value is `0`.
    public let size     : Int
    
    
    
    /// Initializes a ``GitBuf`` instance from the given `git_buf` instance.
    /// - Parameter buf: The `git_buf` instance to use.
    internal init(
        cValue buf: git_buf
    )
    {
        self.ptr        = buf.ptr
        self.reserved   = buf.reserved
        self.size       = buf.size
    }
}
