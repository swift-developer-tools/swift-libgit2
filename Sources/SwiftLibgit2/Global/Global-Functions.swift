//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the global state.
/// - Returns: The number of times the initialization has been called (including this one) that have not
/// subsequently been shutdown.
///
/// ## Discussion
///
/// This function must be called before any other libgit2 function in order to set up global state and threading.
///
/// This function may be called multiple times.
///
/// ## C Equivalent
///
/// [`git_libgit2_init()`](https://libgit2.org/docs/reference/main/global/git_libgit2_init.html)
public func gitLibgit2Init() -> Int32
{
    return git_libgit2_init()
}



/// Shuts down the global state.
/// - Returns: The number of remainining initializations that have not been shutdown (after this one).
///
/// ## Discussion
///
/// This function may be used to clean up the global state and threading context by calling it as many times
/// as ``gitLibgit2Init()`` was called.
///
/// ## C Equivalent
///
/// [`git_libgit2_shutdown()`](https://libgit2.org/docs/reference/main/global/git_libgit2_shutdown.html)
public func gitLibgit2Shutdown() -> Int32
{
    return git_libgit2_shutdown()
}
