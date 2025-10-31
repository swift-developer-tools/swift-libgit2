//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The callback invoked for each packed object.
/// - Parameters:
///   - buf: The object's data.
///   - size: The size of the underlying object.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_packbuilder_foreach_cb()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_foreach_cb.html)
public typealias GitPackbuilderForEachCB = @convention(c)
(
    UnsafeMutableRawPointer?,
    Int,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked to report packfile iteration progress.
/// - Parameters:
///   - stage: The stage of the packbuilder.
///   - current: The current object.
///   - total: The number of objects.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_packbuilder_progress()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_progress.html)
public typealias GitPackbuilderProgressCB = @convention(c)
(
    Int32,
    UInt32,
    UInt32,
    UnsafeMutableRawPointer?
) -> Int32
