//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The type of rebase operation.
///
/// ## C Equivalent
///
/// [`git_rebase_operation_t`](https://libgit2.org/docs/reference/main/rebase/git_rebase_operation_t.html)
public enum GitRebaseOperationT: UInt32, CEnum
{
    /// The commit will be cherry-picked, and the client should commit the
    /// changes and continue if there are no conflicts.
    case gitRebaseOperationPick     = 0
    
    /// The commit will be cherry-picked, but the client should prompt the
    /// user to provide an updated commit message.
    case gitRebaseOperationReword   = 1
    
    /// The commit will be cherry-picked, but the client should stop to allow
    /// the user to edit the changes before committing them.
    case gitRebaseOperationEdit     = 2
    
    /// The commit will be squashed into the previous commit, and the commit
    /// message will be merged with the previous message.
    case gitRebaseOperationSquash   = 3
    
    /// The commit will be squashed into the previous commit, and the commit
    /// message will be discarded.
    case gitRebaseOperationFixup    = 4
    
    /// No commit will be cherry-picked, and the client should run the given
    /// command and continue if successful.
    case gitRebaseOperationExec     = 5
    
    
    
    /// Initializes a ``GitRebaseOperationT`` instance from the given
    /// `git_rebase_operation_t` instance.
    /// - Parameter rebaseOperation: The `git_rebase_operation_t` instance to
    /// use.
    internal init?(
        cValue rebaseOperation: git_rebase_operation_t
    )
    {
        switch rebaseOperation
        {
            case GIT_REBASE_OPERATION_PICK      : self = .gitRebaseOperationPick
            case GIT_REBASE_OPERATION_REWORD    : self = .gitRebaseOperationReword
            case GIT_REBASE_OPERATION_EDIT      : self = .gitRebaseOperationEdit
            case GIT_REBASE_OPERATION_SQUASH    : self = .gitRebaseOperationSquash
            case GIT_REBASE_OPERATION_FIXUP     : self = .gitRebaseOperationFixup
            case GIT_REBASE_OPERATION_EXEC      : self = .gitRebaseOperationExec
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitRebaseOperationT`` instance into a
    /// `git_rebase_operation_t` instance.
    /// - Returns: The `git_rebase_operation_t` instance.
    internal func cValue() -> git_rebase_operation_t
    {
        switch self
        {
            case .gitRebaseOperationPick    : return GIT_REBASE_OPERATION_PICK
            case .gitRebaseOperationReword  : return GIT_REBASE_OPERATION_REWORD
            case .gitRebaseOperationEdit    : return GIT_REBASE_OPERATION_EDIT
            case .gitRebaseOperationSquash  : return GIT_REBASE_OPERATION_SQUASH
            case .gitRebaseOperationFixup   : return GIT_REBASE_OPERATION_FIXUP
            case .gitRebaseOperationExec    : return GIT_REBASE_OPERATION_EXEC
        }
    }
}
