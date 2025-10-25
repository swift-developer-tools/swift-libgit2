//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The type of reset operation.
///
/// ## C Equivalent
///
/// [`git_reset_t`](https://libgit2.org/docs/reference/main/reset/git_reset_t.html)
public enum GitResetT: UInt32, CEnum
{
    /// Move HEAD to the given commit.
    case gitResetSoft   = 1
    
    /// Perform a soft reset, and replace the index with the content of the
    /// given commit tree.
    case gitResetMixed  = 2
    
    /// Perform a mixed reset, and replace the working directory with the
    /// content of the index, leaving untracked and ignored files unchanged.
    case gitResetHard   = 3
    
    
    
    /// Initializes a ``GitResetT`` instance from the given `git_reset_t`
    /// instance.
    /// - Parameter reset: The `git_reset_t` instance to use.
    internal init?(
        cValue reset: git_reset_t
    )
    {
        switch reset
        {
            case GIT_RESET_SOFT     : self = .gitResetSoft
            case GIT_RESET_MIXED    : self = .gitResetMixed
            case GIT_RESET_HARD     : self = .gitResetHard
            default                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitResetT`` instance into a `git_reset_t` instance.
    /// - Returns: The `git_reset_t` instance.
    internal func cValue() -> git_reset_t
    {
        switch self
        {
            case .gitResetSoft  : return GIT_RESET_SOFT
            case .gitResetMixed : return GIT_RESET_MIXED
            case .gitResetHard  : return GIT_RESET_HARD
        }
    }
}
