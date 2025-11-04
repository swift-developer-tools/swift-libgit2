//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for configuring an object database.
///
/// ## C Equivalent
///
/// [`git_odb_options`](https://libgit2.org/docs/reference/main/odb/git_odb_options.html)
public struct GitODBOptions: CStructMutable, CConvertible, Sendable
{
    /// The struct version.
    ///
    /// The default value is ``gitODBOptionsVersion``.
    public var version  : UInt32
    
    /// The type of ID to use for the object database.
    ///
    /// The default value is ``GitOIDT/gitOIDSHA1``.
    public var oidType  : GitOIDT
    
    
    
    /// Initializes a ``GitODBOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version : UInt32    = gitODBOptionsVersion,
        oidType : GitOIDT   = .gitOIDSHA1
    )
    {
        self.version    = version
        self.oidType    = oidType
    }
    
    
    
    /// Initializes a ``GitODBOptions`` instance from the given
    /// `git_odb_options` instance.
    /// - Parameter odbOptions: The `git_odb_options`
    /// instance to use.
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
public struct GitODBExpandID: CStructMutable, CConvertible, Sendable
{
    /// The ID to expand.
    ///
    /// The default value is a default-initialized ``GitOID`` instance.
    public var id       : GitOID
    
    /// The length of the object ID.
    ///
    /// The default value is `0`.
    public var length   : UInt16
    
    /// The type of object for which to search.
    ///
    /// The default value is ``GitObjectT/gitObjectAny``.
    public var type    : GitObjectT
    
    
    
    /// Initializes a ``GitODBExpandID`` instance, optionally specifying
    /// values for its properties.
    public init(
        id      : GitOID        = GitOID(),
        length  : UInt16        = 0,
        type    : GitObjectT    = .gitObjectAny
    )
    {
        self.id         = id
        self.length     = length
        self.type       = type
    }
    
    
    
    /// Initializes a ``GitODBExpandID`` instance from the given
    /// `git_odb_expand_id` instance.
    /// - Parameter odbExpandID: The `git_odb_expand_id` instance to use.
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
