//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The direction of the remote connection.
///
/// ## C Equivalent
///
/// [`git_direction`](https://libgit2.org/docs/reference/main/net/git_direction.html)
public enum GitDirection: UInt32, CEnum
{
    /// The remote connection is for fetching.
    case gitDirectionFetch  = 0
    
    /// The remote connection is for pushing.
    case gitDirectionPush   = 1
    
    
    
    /// Initializes a ``GitDirection`` instance from the given `git_direction`
    /// instance.
    /// - Parameter direction: The `git_direction` instance to use.
    internal init?(
        cValue direction: git_direction
    )
    {
        switch direction
        {
            case GIT_DIRECTION_FETCH    : self = .gitDirectionFetch
            case GIT_DIRECTION_PUSH     : self = .gitDirectionPush
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitDirection`` instance into a `git_direction` instance.
    /// - Returns: The `git_direction` instance.
    internal func cValue() -> git_direction
    {
        switch self
        {
            case .gitDirectionFetch : return GIT_DIRECTION_FETCH
            case .gitDirectionPush  : return GIT_DIRECTION_PUSH
        }
    }
}
