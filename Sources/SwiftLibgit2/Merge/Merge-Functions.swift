//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_merge_options` instance.
/// - Parameters:
///   - opts: The `git_merge_options` instance to initialize.
///   - version: The version to use. Pass ``gitMergeOptionsVersion``.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_merge_options` instances.
/// ``GitMergeOptions`` instances do not need to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_merge_options_init()`](https://libgit2.org/docs/reference/main/merge/git_merge_options_init.html)
public func gitMergeOptionsInit(
    opts    : UnsafeMutablePointer<git_merge_options>,
    version : UInt32
) -> Int32
{
    return git_merge_options_init(
        opts,
        version
    )
}
