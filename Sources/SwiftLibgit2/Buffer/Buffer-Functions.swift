//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the memory allocated for the given `git_buf` instance.
/// - Parameter buffer: The buffer to free.
///
/// ## Discussion
///
/// This function does not free the `git_buf` instance itself, since libgit2
/// will never allocate that object directly.
///
/// ## C Equivalent
///
/// [`git_buf_dispose()`](https://libgit2.org/docs/reference/main/buffer/git_buf_dispose.html)
public func gitBufDispose(
    buffer: UnsafeMutablePointer<git_buf>?
)
{
    guard let buffer
    else
    {
        return
    }
    
    git_buf_dispose(buffer)
}
