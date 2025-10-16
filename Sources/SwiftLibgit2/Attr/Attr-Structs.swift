//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for querying attributes.
///
/// ## C Equivalent
///
/// [`git_attr_options`](https://libgit2.org/docs/reference/main/attr/git_attr_options.html)
public struct GitAttrOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitAttrOptionsVersion``.
    public var version      : UInt32
    
    /// The flags to use when querying the attributes.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags        : GitAttrCheckFlagsT
    
    /// The commit ID.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var commitID     : GitOID?
    
    /// The commit to load attributes from when
    /// ``GitAttrCheckFlagsT/gitAttrCheckIncludeCommit`` is specified.
    ///
    /// ## Discussion
    ///
    /// The default value is a zero-initialized ``GitOID`` instance.
    public var attrCommitID : GitOID                
    
    
    
    /// Initializes a ``GitAttrOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                = gitAttrOptionsVersion,
        flags           : GitAttrCheckFlagsT    = [],
        commitID        : GitOID?               = nil,
        attrCommitID    : GitOID                = GitOID()
    )
    {
        self.version        = version
        self.flags          = flags
        self.commitID       = commitID
        self.attrCommitID   = attrCommitID
    }
    
    
    
    /// Initializes a ``GitAttrOptions`` instance from the given
    /// `git_attr_options` instance.
    /// - Parameter attrOptions: The `git_attr_options` instance to use.
    internal init(
        cValue attrOptions: git_attr_options
    )
    {
        self.version        = attrOptions.version
        self.flags          = GitAttrCheckFlagsT(rawValue: attrOptions.flags)
        self.commitID       = GitOID(cValue: attrOptions.commit_id.pointee)
        self.attrCommitID   = GitOID(cValue: attrOptions.attr_commit_id)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_attr_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_attr_options>) throws -> T
    ) rethrows -> T
    {
        var attrOptions = git_attr_options()
        
        attrOptions.version         = version
        attrOptions.flags           = flags.rawValue
        attrOptions.attr_commit_id  = attrCommitID.cValue()
        
        if let commitID: GitOID = commitID
        {
            var cCommitID: git_oid = commitID.cValue()
            
            return try withUnsafeMutablePointer(to: &cCommitID)
            {
                commitIDPointer in
                
                attrOptions.commit_id = commitIDPointer
                
                return try body(&attrOptions)
            }
        }
        else
        {
            attrOptions.commit_id = nil
            
            return try body(&attrOptions)
        }
    }
}
