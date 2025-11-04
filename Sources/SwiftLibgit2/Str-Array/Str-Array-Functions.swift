//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the memory allocated for the strings of a `git_strarray` instance.
///
/// This function does not free the `git_strarray` instance itself, since
/// libgit2 will never allocate that object directly.
///
/// - Parameter array: The array containing the strings to free.
///
/// ## C Equivalent
///
/// [`git_strarray_dispose()`](https://libgit2.org/docs/reference/main/strarray/git_strarray_dispose.html)
public func gitStrArrayDispose(
    array: UnsafeMutablePointer<git_strarray>?
)
{
    guard let array
    else
    {
        return
    }
    
    git_strarray_dispose(array)
}
