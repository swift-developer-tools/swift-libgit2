//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of object database lookups.
///
/// ## C Equivalent
///
/// [`git_odb_lookup_flags_t`](https://libgit2.org/docs/reference/main/odb/git_odb_lookup_flags_t.html)
public struct GitODBLookupFlagsT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitODBLookupFlagsT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitODBLookupFlagsT`` instance from a
    /// `git_odb_lookup_flags_t` instance.
    /// - Parameter odbLookupFlags: The `git_odb_lookup_flags_t` instance to
    /// use.
    internal init(
        cValue odbLookupFlags: git_odb_lookup_flags_t
    )
    {
        self.rawValue = odbLookupFlags.rawValue
    }
    
    
    
    /// Do not refresh the object database if the lookup fails.
    ///
    /// ## Discussion
    ///
    /// This is useful when batching lookup operations for objects that may
    /// legitimately not exist. If this flag is used, the caller may
    /// manually call ``gitODBRefresh(db:)`` before processing a batch of
    /// objects.
    public static let gitODBLookupNoRefresh = GitODBLookupFlagsT(rawValue: GIT_ODB_LOOKUP_NO_REFRESH.rawValue)
    
    
    
    /// Converts the ``GitODBLookupFlagsT`` instance into a
    /// `git_odb_lookup_flags_t` instance.
    /// - Returns: The `git_odb_lookup_flags_t` instance.
    internal func cValue() -> git_odb_lookup_flags_t
    {
        return git_odb_lookup_flags_t(rawValue)
    }
}
