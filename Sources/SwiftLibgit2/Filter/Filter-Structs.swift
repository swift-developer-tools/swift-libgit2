//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The filtering options.
///
/// ## C Equivalent
///
/// [`git_filter_options`](https://libgit2.org/docs/reference/main/filter/git_filter_options.html)
public struct GitFilterOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitFilterOptionsVersion``.
    public var version      : UInt32
    
    /// The flags controlling the filtering process.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags        : GitFilterFlagT
    
    /// The commit ID.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var commitID     : GitOID?
    
    /// The commit to load attributes from when
    /// ``GitFilterFlagT/gitFilterAttributesFromCommit`` is specified.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitOID`` instance.
    public var attrCommitID : GitOID
    
    
    
    /// Initializes a ``GitFilterOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32            = gitFilterOptionsVersion,
        flags           : GitFilterFlagT    = [],
        commitID        : GitOID?           = nil,
        attrCommitID    : GitOID            = GitOID()
    )
    {
        self.version        = version
        self.flags          = flags
        self.commitID       = commitID
        self.attrCommitID   = attrCommitID
    }
    
    
    
    /// Initializes a ``GitFilterOptions`` instance from the given
    /// `git_filter_options` instance.
    /// - Parameter filterOptions: The `git_filter_options` instance
    /// to use.
    internal init(
        cValue filterOptions: git_filter_options
    )
    {
        self.version        = filterOptions.version
        self.flags          = GitFilterFlagT(rawValue: filterOptions.flags)
        self.commitID       = GitOID(cValue: filterOptions.commit_id.pointee)
        self.attrCommitID   = GitOID(cValue: filterOptions.attr_commit_id)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_filter_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_filter_options>) throws -> T
    ) rethrows -> T
    {
        var filterOptions = git_filter_options()
        
        filterOptions.version           = version
        filterOptions.flags             = flags.rawValue
        filterOptions.attr_commit_id    = attrCommitID.cValue()
        
        if let commitID: GitOID = commitID
        {
            var cCommitID: git_oid = commitID.cValue()
            
            return try withUnsafeMutablePointer(to: &cCommitID)
            {
                commitIDPointer in
                
                filterOptions.commit_id = commitIDPointer
                
                return try body(&filterOptions)
            }
        }
        else
        {
            filterOptions.commit_id = nil
            
            return try body(&filterOptions)
        }
    }
}
