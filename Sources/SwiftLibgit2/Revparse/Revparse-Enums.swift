//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling revision parsing.
///
/// ## C Equivalent
///
/// [`git_revspec_t`](https://libgit2.org/docs/reference/main/revparse/git_revspec_t.html)
public struct GitRevspecT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitRevspecT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitRevspecT`` instance from the given `git_revspec_t`
    /// instance.
    /// - Parameter revspec: The `git_revspec_t` instance to use.
    internal init(
        cValue revspec: git_revspec_t
    )
    {
        self.rawValue = revspec.rawValue
    }
    
    
    
    /// Target a single object.
    public static let gitRevspecSingle      = GitRevspecT(rawValue: GIT_REVSPEC_SINGLE.rawValue)
    
    /// Target a range of commits.
    public static let gitRevspecRange       = GitRevspecT(rawValue: GIT_REVSPEC_RANGE.rawValue)
    
    /// Use the three-dot (`...`) operator to invoke special semantics.
    public static let gitRevspecMergeBase   = GitRevspecT(rawValue: GIT_REVSPEC_MERGE_BASE.rawValue)
    
    
    
    /// Converts the ``GitRevspecT`` instance into a `git_revspec_t` instance.
    /// - Returns: The `git_revspec_t` instance.
    internal func cValue() -> git_revspec_t
    {
        return git_revspec_t(rawValue)
    }
}
