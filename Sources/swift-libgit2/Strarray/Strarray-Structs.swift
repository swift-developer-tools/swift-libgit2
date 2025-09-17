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
/// Bindings for libgit2 functions that accept `git_strarray` use `[String]` instead.
///
/// ## C Equivalent
///
/// [`git_strarray`](https://libgit2.org/docs/reference/main/strarray/git_strarray.html)
public struct GitStrarray
{
    /// The array of strings.
    public let strings  : [String]
    
    /// The number of elements in the array of strings.
    public let count    : Int
}
