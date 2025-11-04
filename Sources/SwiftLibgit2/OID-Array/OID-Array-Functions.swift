//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the memory allocated for the IDs of a `git_oidarray` instance.
///
/// This function does not free the `git_oidarray` instance itself, since
/// libgit2 will never allocate that object directly.
///
/// - Parameter array: The array containing the IDs to free.
///
/// ## C Equivalent
///
/// [`git_oidarray_dispose()`](https://libgit2.org/docs/reference/main/oidarray/git_oidarray_dispose.html)
public func gitOIDArrayDispose(
    array: UnsafeMutablePointer<git_oidarray>?
)
{
    guard let array
    else
    {
        return
    }
    
    git_oidarray_dispose(array)
}
