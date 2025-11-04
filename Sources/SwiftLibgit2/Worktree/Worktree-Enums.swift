//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling worktree pruning.
///
/// ## C Equivalent
///
/// [`git_worktree_prune_t`](https://libgit2.org/docs/reference/main/worktree/git_worktree_prune_t.html)
public struct GitWorktreePruneT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitWorktreePruneT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitWorktreePruneT`` instance from the given
    /// `git_worktree_prune_t` instance.
    /// - Parameter worktreePrune: The `git_worktree_prune_t` instance to use.
    internal init(
        cValue worktreePrune: git_worktree_prune_t
    )
    {
        self.rawValue = worktreePrune.rawValue
    }
    
    
    
    /// Prune valid worktrees.
    public static let gitWorktreePruneValid         = GitWorktreePruneT(rawValue: GIT_WORKTREE_PRUNE_VALID.rawValue)
    
    /// Prune locked worktrees.
    public static let gitWorktreePruneLocked        = GitWorktreePruneT(rawValue: GIT_WORKTREE_PRUNE_LOCKED.rawValue)
    
    /// Remove the worktree directory from the file system.
    public static let gitWorktreePruneWorkingTree   = GitWorktreePruneT(rawValue: GIT_WORKTREE_PRUNE_WORKING_TREE.rawValue)
    
    
    
    /// Converts the ``GitWorktreePruneT`` instance into a
    /// `git_worktree_prune_t` instance.
    /// - Returns: The `git_worktree_prune_t` instance.
    internal func cValue() -> git_worktree_prune_t
    {
        return git_worktree_prune_t(rawValue)
    }
}
