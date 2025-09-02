//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Init the global state.
/// - Returns: The number of times the initialization has been called (including this one) that have not
/// subsequently been shutdown.
/// https://libgit2.org/docs/reference/main/global/git_libgit2_init.html
public func gitLibgit2Init() -> Int32
{
    return git_libgit2_init()
}



/// Shutdown the global state.
/// - Returns: The number of remainining initializations that have not been shutdown (after this one).
/// https://libgit2.org/docs/reference/main/global/git_libgit2_shutdown.html
public func gitLibgit2Shutdown() -> Int32
{
    return git_libgit2_shutdown()
}
