//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the OIDs contained in a `git_oidarray`.
/// - Parameter array: The array containing the OIDs to free.
///
/// ## Discussion
///
/// This function does not free the `git_oidarray` itself, since libgit2 will
/// never allocate that object directly.
///
/// - Note: This function is only needed when working directly with
/// `git_oidarray` instances allocated by libgit2. ``GitOIDArray`` instances
/// do not need to be freed.
///
/// ## C Equivalent
///
/// [`git_oidarray_dispose()`](https://libgit2.org/docs/reference/main/oidarray/git_oidarray_dispose.html)
public func gitOIDArrayDispose(
    array: UnsafeMutablePointer<git_oidarray>?
)
{
    guard let array: UnsafeMutablePointer<git_oidarray> = array
    else
    {
        return
    }
    
    git_oidarray_dispose(array)
}
