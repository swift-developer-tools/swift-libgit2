//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked for each tag.
/// - Parameters:
///   - name: The name of the tag.
///   - oid: The ID of the tag.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_tag_foreach_cb()`](https://libgit2.org/docs/reference/main/tag/git_tag_foreach_cb.html)
public typealias GitTagForEachCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafeMutablePointer<git_oid>?,
    UnsafeMutableRawPointer?
) -> Int32
