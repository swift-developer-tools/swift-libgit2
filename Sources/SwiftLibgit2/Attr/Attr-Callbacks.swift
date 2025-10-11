//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback to invoke for each attribute name and value during attribute
/// iteration.
/// - Parameters:
///   - name: The attribute name.
///   - value: The attribute value. This may be `nil` if the attribute is
///   explicitly set to unspecified using the exclamation mark (`!`) operator.
///   - payload: The payload provided by the caller.
/// - Returns: `0` to continue looping, or a non-zero value to stop looping.
///
/// ## Discussion
///
/// This callback will be invoked only once per attribute name, even if there
/// are multiple rules for a given file. The highest priority rule will be used.
///
/// ## C Equivalent
///
/// [`git_attr_foreach_cb()`](https://libgit2.org/docs/reference/main/attr/git_attr_foreach_cb.html)
public typealias GitAttrForEachCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
