//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// An array of strings.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All bindings use `[String]` instead.
///
/// ## C Equivalent
///
/// [`git_strarray`](https://libgit2.org/docs/reference/main/strarray/git_strarray.html)
public struct GitStrArray: CStruct, Sendable
{
    /// The strings.
    public let strings  : [String]
    
    /// The length of ``strings``.
    public var count    : Int
    {
        return strings.count
    }
    
    
    
    /// Initializes a ``GitStrArray`` instance from the given `git_strarray`
    /// instance.
    /// - Parameter strArray: The `git_strarray` instance to use.
    internal init(
        cValue strArray: git_strarray
    )
    {
        self.strings = Array(strArray)
    }
}
