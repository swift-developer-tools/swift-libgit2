//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callback that will be used with
/// ``gitAttrForEach(repo:flags:path:callback:payload:)``.
/// - Parameters:
///   - name: The attribute name.
///   - value: The attribute value. May be `nil` if the attribute is explicitly set to unspecified using the
///   `!` operator.
///   - payload: The user-specified payload.
/// - Returns: `0` to continue looping or a non-zero value to stop looping. This value will be returned
/// from ``gitAttrForEach(repo:flags:path:callback:payload:)``.
///
/// ## Discussion
///
/// This callback will be invoked only once per attribute name, even if there are multiple rules for a given file.
/// The highest priority rule will be used.
///
/// ## C Equivalent
///
/// [`git_attr_foreach_cb()`](https://libgit2.org/docs/reference/main/attr/git_attr_foreach_cb.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public typealias GitAttrForEachCB = @convention(c) (
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
