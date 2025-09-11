//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



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
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBufDispose(
    buffer: inout GitBuf
)
{
    buffer.withCStruct
    {
        cBuffer in
        
        git_buf_dispose(cBuffer)
    }
}
