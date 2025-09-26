//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for querying attributes.
///
/// ## C Equivalent
///
/// [`git_attr_options`](https://libgit2.org/docs/reference/main/attr/git_attr_options.html)
public struct GitAttrOptions: GitStructReadWrite
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitAttrOptionsVersion``.
    public var version      : UInt32                = gitAttrOptionsVersion
    
    /// The flags to use when querying the attributes.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags        : GitAttrCheckFlagsT    = []
    
    /// The commit ID.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var commitID     : GitOID?               = nil
    
    /// The commit to load attributes from when
    /// ``GitAttrCheckFlagsT/gitAttrCheckIncludeCommit`` is specified.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using `git_oid()`.
    public var attrCommitID : GitOID?               = nil
    
    
    
    /// Creates a ``GitAttrOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitAttrOptions`` instance from a `git_attr_options` instance.
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
    
    
    
    /// Calls the given closure with a pointer to a `git_attr_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_attr_options>) -> T
    ) -> T
    {
        var attrOptions = git_attr_options()
        
        attrOptions.version         = version
        attrOptions.flags           = flags.rawValue
        attrOptions.attr_commit_id  = attrCommitID?.cValue ?? git_oid()
        
        if let commitID: GitOID = commitID
        {
            var cCommitID: git_oid = commitID.cValue
            
            return withUnsafeMutablePointer(to: &cCommitID)
            {
                commitIDPointer in
                
                attrOptions.commit_id = commitIDPointer
                
                return body(&attrOptions)
            }
        }
        else
        {
            attrOptions.commit_id = nil
            
            return body(&attrOptions)
        }
    }
}
