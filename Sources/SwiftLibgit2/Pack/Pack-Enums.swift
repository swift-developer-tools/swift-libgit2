//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The stages reporting by the packbuilder progress callback.
///
/// ## C Equivalent
///
/// [`git_packbuilder_stage_t`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_stage_t.html)
public enum GitPackbuilderStageT: UInt32, CEnum
{
    /// The packbuilder is adding objects to the pack.
    case gitPackbuilderAddingObjects    = 0
    
    /// The packbuilder is compressing objects by computing deltas.
    case gitPackbuilderDeltafication    = 1
    
    
    
    /// Initializes a ``GitPackbuilderStageT`` instance from the given
    /// `git_packbuilder_stage_t` instance.
    /// - Parameter packbuilderStage: The `git_packbuilder_stage_t` instance
    /// to use.
    internal init?(
        cValue packbuilderStage: git_packbuilder_stage_t
    )
    {
        switch packbuilderStage
        {
            case GIT_PACKBUILDER_ADDING_OBJECTS : self = .gitPackbuilderAddingObjects
            case GIT_PACKBUILDER_DELTAFICATION  : self = .gitPackbuilderDeltafication
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitPackbuilderStageT`` instance into a
    /// `git_packbuilder_stage_t` instance.
    /// - Returns: The `git_packbuilder_stage_t` instance.
    internal func cValue() -> git_packbuilder_stage_t
    {
        switch self
        {
            case .gitPackbuilderAddingObjects   : return GIT_PACKBUILDER_ADDING_OBJECTS
            case .gitPackbuilderDeltafication   : return GIT_PACKBUILDER_DELTAFICATION
        }
    }
}
