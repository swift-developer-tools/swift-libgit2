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
public struct GitAttrOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitAttrOptionsVersion``.
    public var version      : UInt32
    
    /// The flags to use when querying the attributes.
    public var flags        : GitAttrCheckFlagsT
    
    /// The commit ID.
    public var commitID     : GitOID?
    
    /// The commit to load attributes from when
    /// ``GitAttrCheckFlagsT/gitAttrCheckIncludeCommit`` is specified.
    public var attrCommitID : GitOID?
    
    
    
    /// Creates a ``GitAttrOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to ``gitAttrOptionsVersion``.
    public init(
        version: UInt32 = gitAttrOptionsVersion
    )
    {
        /// libgit2 doesn't provide an initialization function for `git_attr_options`.
        /// The C macro `GIT_ATTR_OPTIONS_INIT` would initialize all fields other than
        /// `version` to `0` or `NULL`, so that approach is mirrored here.
        self.version        = version
        self.flags          = []
        self.commitID       = nil
        self.attrCommitID   = nil
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
