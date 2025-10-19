//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked for each reference.
/// - Parameters:
///   - reference: The reference. The underlying type must be `git_reference`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// - Important: This callback must free each reference passed to it.
///
/// ## C Equivalent
///
/// [`git_reference_foreach_cb()`](https://libgit2.org/docs/reference/main/refs/git_reference_foreach_cb.html)
public typealias GitReferenceForEachCB = @convention(c)
(
    OpaquePointer?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each reference name.
/// - Parameters:
///   - name: The reference name.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_reference_foreach_name_cb()`](https://libgit2.org/docs/reference/main/refs/git_reference_foreach_name_cb.html)
public typealias GitReferenceForEachNameCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
