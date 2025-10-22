//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
@testable import SwiftLibgit2



/// Functions to free memory.
enum Free
{
    /// Frees the memory allocated for the given `git_revwalk` instance.
    /// - Parameter revwalk: The revwalk to free. The underlying type must
    /// be `git_revwalk`.
    static func freeRevwalk(
        _ revwalk: OpaquePointer?
    )
    {
        guard let revwalk: OpaquePointer = revwalk
        else
        {
            return
        }
        
        git_revwalk_free(revwalk)
    }
    
    
    
    /// Frees the memory allocated for the given `git_repository` instance.
    /// - Parameter repository: The repository to free. The underlying type
    /// must be `git_repository`.
    static func freeRepository(
        _ repository: OpaquePointer?
    )
    {
        guard let repository: OpaquePointer = repository
        else
        {
            return
        }
        
        git_repository_free(repository)
    }
    
    
    
    /// Frees the memory allocated for the given `git_transaction` instance.
    /// - Parameter transaction: The transaction to free. The underlying type
    /// must be `git_transaction`.
    static func freeTransaction(
        _ transaction: OpaquePointer?
    )
    {
        guard let transaction: OpaquePointer = transaction
        else
        {
            return
        }
        
        git_transaction_free(transaction)
    }
    
    
    
    /// Frees the memory allocated for the given `git_tree` instance.
    /// - Parameter tree: The tree to free. The underlying type must be
    /// `git_tree`.
    static func freeTree(
        _ tree: OpaquePointer?
    )
    {
        guard let tree: OpaquePointer = tree
        else
        {
            return
        }
        
        git_tree_free(tree)
    }
    
    
    
    /// Frees the memory allocated for the given `git_worktree` instance.
    /// - Parameter worktree: The worktree to free. The underlying type must
    /// be `git_worktree`.
    static func freeWorktree(
        _ worktree: OpaquePointer?
    )
    {
        guard let worktree: OpaquePointer = worktree
        else
        {
            return
        }
        
        git_worktree_free(worktree)
    }
}
