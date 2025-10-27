//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given allocator to use the `stdalloc` pointer.
/// - Parameter allocator: The allocator to initialize.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_stdalloc_init_allocator()`](https://libgit2.org/docs/reference/main/sys/alloc/git_stdalloc_init_allocator.html)
public func gitStdAllocInitAllocator(
    allocator: UnsafeMutablePointer<git_allocator>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stdalloc_init_allocator(allocator)
    }
}



/// Initializes the given allocator to use the `crtdbg` pointer.
/// - Parameter allocator: The allocator to initialize.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is provided for documentation purposes, but is not
/// available on the supported platforms.
///
/// ## C Equivalent
///
/// [`git_win32_crtdbg_init_allocator()`](https://libgit2.org/docs/reference/main/sys/alloc/git_win32_crtdbg_init_allocator.html)
public func gitWin32CrtdbgInitAllocator(
    allocator: UnsafeMutablePointer<git_allocator>
) -> GitErrorCode
{
    return withCConversion
    {
        /// This function is only available on Windows, and if libgit2 was
        /// built with the `-DMSVC_CRTDBG` flag.
        //return git_win32_crtdbg_init_allocator(allocator)
        
        return GitErrorCode.gitEUser.rawValue
    }
}
