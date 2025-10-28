//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Sets the system tracing configuration to the given level with the given
/// callback.
/// - Parameters:
///   - level: The trace level to set.
///   - cb: The ``GitTraceCB`` callback to invoke with trace data.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_trace_set()`](https://libgit2.org/docs/reference/main/trace/git_trace_set.html)
public func gitTraceSet(
    level   : GitTraceLevelT,
    cb      : GitTraceCB
) -> GitErrorCode
{
    return withCConversion
    {
        return git_trace_set(
            level.cValue(),
            cb
        )
    }
}
