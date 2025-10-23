//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The revision spec.
///
/// ## C Equivalent
///
/// [`git_revspec`](https://libgit2.org/docs/reference/main/revparse/git_revspec.html)
public struct GitRevspec: CStructMutable, CConvertible
{
    /// The left element of the revspec.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var from     : OpaquePointer?
    
    /// The right element of the revspec.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var to       : OpaquePointer?
    
    /// The flags controlling revision parsing.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags    : GitRevspecT
    
    
    
    /// Initializes a ``GitRevspec`` instance, optionally specifying values
    /// for its properties.
    public init(
        from    : OpaquePointer?    = nil,
        to      : OpaquePointer?    = nil,
        flags   : GitRevspecT       = []
    )
    {
        self.from   = from
        self.to     = to
        self.flags  = flags
    }
    
    
    
    /// Initializes a ``GitRevspec`` instance from the given `git_revspec`
    /// instance.
    /// - Parameter revspec: The `git_revspec` instance to use.
    internal init(
        cValue revspec: git_revspec
    )
    {
        self.from   = revspec.from
        self.to     = revspec.to
        self.flags  = GitRevspecT(rawValue: revspec.flags)
    }
    
    
    
    /// Converts the ``GitRevspec`` instance into a `git_revspec` instance.
    /// - Returns: The `git_revspec` instance.
    internal func cValue() -> git_revspec
    {
        var revspec = git_revspec()
        
        revspec.from    = from
        revspec.to      = to
        revspec.flags   = flags.rawValue
        
        return revspec
    }
}
