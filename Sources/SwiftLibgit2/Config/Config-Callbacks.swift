//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callback for configuration enumeration.
/// - Parameters:
///   - entry: The entry currently being enumerated.
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
