//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// An array of strings.
///
/// ## Discussion
///
/// This struct is provided for documentation purposes, but is not used by other bindings.
///
/// All bindings use `[String]` instead of `git_strarray`.
///
/// ## C Equivalent
///
/// [`git_strarray`](https://libgit2.org/docs/reference/main/strarray/git_strarray.html)
public struct GitStrArray: GitStruct
{
    /// The array of strings.
    public let strings  : [String]
    
    /// The number of strings in the array.
    public let count    : Int
    
    
    
    /// Creates a ``GitStrArray`` instance from a `git_strarray` instance.
    /// - Parameter strArray: The `git_strarray` instance to use.
    internal init(
        cValue strArray: git_strarray
    )
    {
        self.strings    = Array(strArray)
        self.count      = strArray.count
    }
}
