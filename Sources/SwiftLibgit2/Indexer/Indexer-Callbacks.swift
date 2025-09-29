//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback to report progress during the indexing process.
/// - Parameters:
///   - stats: The state of the transfer.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_indexer_progress_cb()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_progress_cb.html)
public typealias GitIndexerProgressCB = @convention(c)
(
    UnsafePointer<git_indexer_progress>?,
    UnsafeMutableRawPointer?
) -> Int32
