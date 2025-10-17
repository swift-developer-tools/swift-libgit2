//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The callback invoked to add, remove, or update files.
/// - Parameters:
///   - path: The matching path.
///   - matchedPathspec: The given path to match.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if an error occurred, a positive value to skip
/// this file for the index operation, or `0` on success.
///
/// ## C Equivalent
///
/// [`git_index_matched_path_cb()`](https://libgit2.org/docs/reference/main/index/git_index_matched_path_cb.html)
public typealias GitIndexMatchedPathCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
