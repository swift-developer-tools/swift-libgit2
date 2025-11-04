//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The callback invoked for each submodule.
/// - Parameters:
///   - sm: The submodule. The underlying type must be `git_submodule`.
///   - name: The name of the submodule.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_submodule_cb()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_cb.html)
public typealias GitSubmoduleCB = @convention(c)
(
    OpaquePointer?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
