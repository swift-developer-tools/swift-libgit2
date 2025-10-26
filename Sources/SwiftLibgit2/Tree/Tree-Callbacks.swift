//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked for each tree entry.
/// - Parameters:
///   - entry: The tree entry.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_treebuilder_filter_cb()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_filter_cb.html)
public typealias GitTreebuilderFilterCB = @convention(c)
(
    OpaquePointer?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each tree entry.
/// - Parameters:
///   - root: The current (relative) tree entry root.
///   - entry: The tree entry.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_treewalk_cb()`](https://libgit2.org/docs/reference/main/tree/git_treewalk_cb.html)
public typealias GitTreewalkCB = @convention(c)
(
    UnsafePointer<CChar>?,
    OpaquePointer?,
    UnsafeMutableRawPointer?
) -> Int32
