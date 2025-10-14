//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for configuring a loose object backend.
///
/// ## C Equivalent
///
/// [`git_odb_options`](https://libgit2.org/docs/reference/main/odb/git_odb_options.html)
public struct GitODBOptions: CStructMutable, CConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitODBOptionsVersion``.
    public var version  : UInt32    = gitODBOptionsVersion
    
    /// The type of ID to use for the object database.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitOIDT/gitOIDSHA1``.
    public var oidType  : GitOIDT   = .gitOIDSHA1
    
    
    
    /// Creates a ``GitODBOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitODBOptions`` instance from a `git_odb_options` instance.
    /// - Parameter odbOptions: The `git_odb_options`
    /// instance to use.
    ///
    /// ## Discussion
    ///
    /// ``oidType`` defaults to ``GitOIDT/gitOIDSHA1`` if an unexpected value
    /// is encountered, although this should never occur.
    internal init(
        cValue odbOptions: git_odb_options
    )
    {
        self.version    = odbOptions.version
        self.oidType    = GitOIDT(cValue: odbOptions.oid_type) ?? .gitOIDSHA1
    }
    
    
    
    /// Converts the ``GitODBOptions`` instance into a `git_odb_options`
    /// instance.
    /// - Returns: The `git_odb_options` instance.
    internal func cValue() -> git_odb_options
    {
        var odbOptions = git_odb_options()
        
        odbOptions.version      = version
        odbOptions.oid_type     = oidType.cValue()
        
        return odbOptions
    }
}



/// Information about object IDs.
///
/// ## C Equivalent
///
/// [`git_odb_expand_id`](https://libgit2.org/docs/reference/main/odb/git_odb_expand_id.html)
public struct GitODBExpandID: CStructMutable, CConvertible
{
    /// The ID to expand.
    ///
    /// ## Discussion
    ///
    /// The default value is a zero-initialized ``GitOID`` instance.
    public var id       : GitOID        = GitOID()
    
    /// The length of the object ID.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var length   : UInt16        = 0
    
    /// The type of object for which to search.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitObjectT/gitObjectAny``.
    public var type    : GitObjectT     = .gitObjectAny
    
    
    
    /// Creates a ``GitODBExpandID`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitODBExpandID`` instance from a `git_odb_expand_id`
    /// instance.
    /// - Parameter odbExpandID: The `git_odb_expand_id` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``type`` defaults to ``GitObjectT/gitObjectAny`` if an unexpected
    /// value is encountered, although this should never occur.
    internal init(
        cValue odbExpandID: git_odb_expand_id
    )
    {
        self.id         = GitOID(cValue: odbExpandID.id)
        self.length     = odbExpandID.length
        self.type       = GitObjectT(cValue: odbExpandID.type) ?? .gitObjectAny
    }
    
    
    
    /// Converts the ``GitODBExpandID`` instance into a `git_odb_expand_id`
    /// instance.
    /// - Returns: The `git_odb_expand_id` instance.
    internal func cValue() -> git_odb_expand_id
    {
        var odbExpandID = git_odb_expand_id()
        
        odbExpandID.id      = id.cValue()
        odbExpandID.length  = length
        odbExpandID.type    = type.cValue()
        
        return odbExpandID
    }
}
