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
