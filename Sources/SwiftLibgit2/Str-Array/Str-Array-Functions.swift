//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the strings contained in a `git_strarray`.
/// - Parameter array: The array containing the strings to free.
///
/// ## Discussion
///
/// This function does not free the `git_strarray` itself, since libgit2 will
/// never allocate that object directly.
///
/// - Note: This function is only needed when working directly with
/// `git_strarray` instances allocated by libgit2. ``GitStrArray`` instances
/// do not need to be freed.
///
/// ## C Equivalent
///
/// [`git_strarray_dispose()`](https://libgit2.org/docs/reference/main/strarray/git_strarray_dispose.html)
public func gitStrArrayDispose(
    array: UnsafeMutablePointer<git_strarray>?
)
{
    guard let array: UnsafeMutablePointer<git_strarray> = array
    else
    {
        return
    }
    
    git_strarray_dispose(array)
}
