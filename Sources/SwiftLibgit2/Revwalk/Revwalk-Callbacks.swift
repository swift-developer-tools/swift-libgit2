//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to hide the specified commit and its parents.
/// - Parameters:
///   - commitID: The ID of the commit to hide.
///   - payload: The payload provided by the caller.
/// - Returns: A non-zero value to hide the specified commit and its parents,
/// or `0` otherwise.
///
/// ## C Equivalent
///
/// [`git_revwalk_hide_cb()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_hide_cb.html)
public typealias GitRevwalkHideCB = @convention(c)
(
    UnsafePointer<git_oid>?,
    UnsafeMutableRawPointer?
) -> Int32
