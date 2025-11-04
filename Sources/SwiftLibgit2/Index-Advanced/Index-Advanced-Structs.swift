//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A file name conflict entry in the index.
///
/// ## C Equivalent
///
/// [`git_index_name_entry`](https://libgit2.org/docs/reference/main/sys/index/git_index_name_entry.html)
public struct GitIndexNameEntry: CStructInternalMutable, WithCConvertible, Sendable
{
    /// The name of the common ancestor.
    ///
    /// The default value is `nil`.
    public private(set) var ancestor    : String?   = nil
    
    /// The name of "our" side.
    ///
    /// The default value is `nil`.
    public private(set) var ours        : String?   = nil
    
    /// The name of "their" side.
    ///
    /// The default value is `nil`.
    public private(set) var theirs      : String?   = nil
    
    
    
    /// Initializes a default ``GitIndexNameEntry`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitIndexNameEntry`` instance from the given
    /// `git_index_name_entry` instance.
    /// - Parameter indexNameEntry: The `git_index_name_entry` instance to use.
    internal init(
        cValue indexNameEntry: git_index_name_entry
    )
    {
        self.ancestor   = String(optionalCString: indexNameEntry.ancestor)
        self.ours       = String(optionalCString: indexNameEntry.ours)
        self.theirs     = String(optionalCString: indexNameEntry.theirs)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_index_name_entry` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_index_name_entry>) throws -> T
    ) throws -> T
    {
        var indexNameEntry = git_index_name_entry()
        
        return try ancestor.withOptionalMutableCString
        {
            cAncestor in
            
            indexNameEntry.ancestor = cAncestor
            
            return try ours.withOptionalMutableCString
            {
                cOurs in
                
                indexNameEntry.ours = cOurs
                
                return try theirs.withOptionalMutableCString
                {
                    cTheirs in
                    
                    indexNameEntry.theirs = cTheirs
                    
                    return try body(&indexNameEntry)
                }
            }
        }
    }
}



/// A resolve-undo (REUC) entry in the index.
///
/// ## C Equivalent
///
/// [`git_index_reuc_entry`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_entry.html)
public struct GitIndexREUCEntry: CStructInternalMutable, WithCConvertible, Sendable
{
    /// The file mode for each stage.
    ///
    /// The default value is a 3-element tuple in which all elements are `0`.
    public private(set) var mode    : REUCStages<UInt32>    = (0, 0, 0)
    
    /// The IDs of each stage.
    ///
    /// The default value is a 3-element tuple in which all elements are a
    /// default-initialized ``GitOID`` instance.
    public private(set) var oid     : REUCStages<GitOID>    = (GitOID(), GitOID(), GitOID())
    
    /// The path to the file.
    ///
    /// The default value is `nil`.
    public private(set) var path    : String?               = nil
    
    
    
    /// Initializes a default ``GitIndexREUCEntry`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitIndexREUCEntry`` instance from the given
    /// `git_index_reuc_entry` instance.
    /// - Parameter indexREUCEntry: The `git_index_reuc_entry` instance to use.
    internal init(
        cValue indexREUCEntry: git_index_reuc_entry
    )
    {
        self.mode   = indexREUCEntry.mode
        self.path   = String(optionalCString: indexREUCEntry.path)
        
        let cOID: REUCStages<git_oid> = indexREUCEntry.oid
        
        self.oid = (
            GitOID(cValue: cOID.0),
            GitOID(cValue: cOID.1),
            GitOID(cValue: cOID.2)
        )
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_index_reuc_entry` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_index_reuc_entry>) throws -> T
    ) throws -> T
    {
        var indexREUCEntry = git_index_reuc_entry()
        
        indexREUCEntry.mode = mode
        
        indexREUCEntry.oid = (
            oid.0.cValue(),
            oid.1.cValue(),
            oid.2.cValue()
        )
        
        return try path.withOptionalMutableCString
        {
            cPath in
            
            indexREUCEntry.path = cPath
            
            return try body(&indexREUCEntry)
        }
    }
    
    
    
    /// The three stages of a resolve-undo (REUC) entry.
    ///
    /// The three elements of the tuple are the ancestor, "our" side, and
    /// "their" side, in order.
    public typealias REUCStages<T> = (T, T, T)
}
