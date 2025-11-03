//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for submodule updates.
///
/// ## C Equivalent
///
/// [`git_tree_update`](https://libgit2.org/docs/reference/main/tree/git_tree_update.html)
public struct GitTreeUpdate: CStructMutable, WithCConvertible, Sendable
{
    /// The type of tree update.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitTreeUpdateT/gitTreeUpdateUpsert``.
    ///
    /// If this is ``GitTreeUpdateT/gitTreeUpdateRemove``, only ``path`` will
    /// be considered.
    public var action   : GitTreeUpdateT
    
    /// The ID of the entry.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitOID`` instance.
    public var id       : GitOID
    
    /// The file mode.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitFileModeT/gitFileModeUnreadable``.
    public var fileMode : GitFileModeT
    
    /// The full path from the root tree.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If this is `nil`, the tree update will be ignored.
    public var path     : String?
    
    
    
    /// Initializes a ``GitTreeUpdate`` instance with the given path,
    /// optionally specifying values for its other properties.
    public init(
        action      : GitTreeUpdateT    = .gitTreeUpdateUpsert,
        id          : GitOID            = GitOID(),
        fileMode    : GitFileModeT      = .gitFileModeUnreadable,
        path        : String?           = nil
    )
    {
        self.action     = action
        self.id         = id
        self.fileMode   = fileMode
        self.path       = path
    }
    
    
    
    /// Initializes a ``GitTreeUpdate`` instance from the given
    /// `git_tree_update` instance.
    /// - Parameter treeUpdate: The `git_tree_update` instance to use.
    internal init(
        cValue treeUpdate: git_tree_update
    )
    {
        self.action     = GitTreeUpdateT(cValue: treeUpdate.action) ?? .gitTreeUpdateUpsert
        self.id         = GitOID(cValue: treeUpdate.id)
        self.fileMode   = GitFileModeT(cValue: treeUpdate.filemode) ?? .gitFileModeUnreadable
        self.path       = String(optionalCString: treeUpdate.path)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_tree_update`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_tree_update>) throws -> T
    ) rethrows -> T
    {
        var treeUpdate = git_tree_update()
        
        treeUpdate.action       = action.cValue()
        treeUpdate.id           = id.cValue()
        treeUpdate.filemode     = fileMode.cValue()
        
        return try path.withOptionalCString
        {
            cPath in
            
            treeUpdate.path = cPath
            
            return try body(&treeUpdate)
        }
    }
}
