//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The basic type of any branch.
///
/// ## C Equivalent
///
/// [`git_branch_t`](https://libgit2.org/docs/reference/main/branch/git_branch_t.html)
public enum GitBranchT: UInt32, GitEnum
{
    /// A local branch.
    case gitBranchLocal     = 1
    
    /// A remote branch.
    case gitBranchRemote    = 2
    
    /// Both local and remote branches.
    case gitBranchAll       = 3
    
    
    
    /// Creates a ``GitBranchT`` instance from a `git_branch_t` instance.
    /// - Parameter branch: The `git_branch_t` instance to use.
    internal init?(
        cValue branch: git_branch_t
    )
    {
        switch branch
        {
            case GIT_BRANCH_LOCAL   : self = .gitBranchLocal
            case GIT_BRANCH_REMOTE  : self = .gitBranchRemote
            case GIT_BRANCH_ALL     : self = .gitBranchAll
            default                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitBranchT`` instance into a `git_branch_t` instance.
    /// - Returns: The `git_branch_t` instance.
    internal func cValue() -> git_branch_t
    {
        switch self
        {
            case .gitBranchLocal    : return GIT_BRANCH_LOCAL
            case .gitBranchRemote   : return GIT_BRANCH_REMOTE
            case .gitBranchAll      : return GIT_BRANCH_ALL
        }
    }
}
