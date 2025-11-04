//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked with trace data.
/// - Parameters:
///   - level: The trace level.
///   - msg: The trace message.
///
/// ## C Equivalent
///
/// [`git_trace_cb()`](https://libgit2.org/docs/reference/main/trace/git_trace_cb.html)
public typealias GitTraceCB = @convention(c)
(
    git_trace_level_t,
    UnsafePointer<CChar>?
) -> Void
