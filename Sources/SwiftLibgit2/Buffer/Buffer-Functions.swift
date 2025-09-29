//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the memory pointed to by ``GitBuf/ptr``.
/// - Parameter buffer: The buffer to free.
///
/// ## Discussion
///
/// This function does not free the ``GitBuf`` instance itself, only the memory pointed to by
/// ``GitBuf/ptr``.
///
/// ## C Equivalent
///
/// [`git_buf_dispose()`](https://libgit2.org/docs/reference/main/buffer/git_buf_dispose.html)
public func gitBufDispose(
    buffer: inout GitBuf
)
{
    buffer.withMutatingCValue
    {
        cBuffer in
        
        git_buf_dispose(cBuffer)
    }
    
    /// `git_buf_dispose()` sets `cBuffer->ptr` to a static sentinel value, not `NULL`.
    ///
    /// After freeing the allocated memory, `git_buf_dispose()` sets `cBuffer->ptr`
    /// to a static single-character array, `git_str__initstr`, which ensures that
    /// `cBuffer->ptr` remains non-`NULL` and zero-terminated even after disposal.
    ///
    /// The Swift binding sets `buffer.ptr` to `nil` after disposal for more idiomatic Swift.
    /// See ``GitBuf/ptr`` for more information.
    buffer.ptr          = nil
    buffer.reserved     = 0
    buffer.size         = 0
}
