//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling revision history sorting.
///
/// ## C Equivalent
///
/// [`git_sort_t`](https://libgit2.org/docs/reference/main/revwalk/git_sort_t.html)
public struct GitSortT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitSortT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitSortT`` instance from the given `git_sort_t`
    /// instance.
    /// - Parameter sort: The `git_sort_t` instance to use.
    internal init(
        cValue sort: git_sort_t
    )
    {
        self.rawValue = sort.rawValue
    }
    
    
    
    /// Sort in reverse chronological order, the default Git sort order.
    public static let gitSortNone           = GitSortT(rawValue: GIT_SORT_NONE.rawValue)
    
    /// Sort in topological order, showing no parent commit until all of its
    /// child commits are shown.
    ///
    /// This flag may be combined with chronological sorting.
    public static let gitSortTopological    = GitSortT(rawValue: GIT_SORT_TOPOLOGICAL.rawValue)
    
    /// Sort in chronological order.
    ///
    /// This flag may be combined with topological sorting.
    public static let gitSortTime           = GitSortT(rawValue: GIT_SORT_TIME.rawValue)
    
    /// Sort in reverse order.
    ///
    /// This flag may be combined with any other flag.
    public static let gitSortReverse        = GitSortT(rawValue: GIT_SORT_REVERSE.rawValue)
    
    
    
    /// Converts the ``GitSortT`` instance into a `git_sort_t` instance.
    /// - Returns: The `git_sort_t` instance.
    internal func cValue() -> git_sort_t
    {
        return git_sort_t(rawValue)
    }
}
