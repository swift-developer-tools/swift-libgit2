//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked for each configuration entry.
/// - Parameters:
///   - entry: The entry being iterated.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_config_foreach_cb()`](https://libgit2.org/docs/reference/main/config/git_config_foreach_cb.html)
public typealias GitConfigForEachCB = @convention(c)
(
    UnsafePointer<git_config_entry>?,
    UnsafeMutableRawPointer?
) -> Int32
