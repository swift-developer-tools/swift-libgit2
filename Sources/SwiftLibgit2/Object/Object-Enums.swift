//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The basic type (loose or packed) of any Git object.
///
/// ## C Equivalent
///
/// [`git_object_t`](https://libgit2.org/docs/reference/main/object/git_object_t.html)
public enum GitObjectT: Int32, GitEnum
{
    /// Any object.
    case gitObjectAny       = -2
    
    /// An invalid object.
    case gitObjectInvalid   = -1
    
    /// A commit object.
    case gitObjectCommit    = 1
    
    /// A tree (directory listing) object.
    case gitObjectTree      = 2
    
    /// A file revision object.
    case gitObjectBlob      = 3
    
    /// An annotated tag object.
    case gitObjectTag       = 4
    
    
    
    /// Creates a ``GitObjectT`` instance from a `git_object_t` instance.
    /// - Parameter configLevel: The `git_object_t` instance to use.
    internal init?(
        cValue object: git_object_t
    )
    {
        switch object
        {
            case GIT_OBJECT_ANY     : self = .gitObjectAny
            case GIT_OBJECT_INVALID : self = .gitObjectInvalid
            case GIT_OBJECT_COMMIT  : self = .gitObjectCommit
            case GIT_OBJECT_TREE    : self = .gitObjectTree
            case GIT_OBJECT_BLOB    : self = .gitObjectBlob
            case GIT_OBJECT_TAG     : self = .gitObjectTag
            default                 : return nil
                
        }
    }
    
    
    
    /// Converts the ``GitObjectT`` instance into a `git_object_t` instance.
    /// - Returns: The `git_object_t` instance.
    internal func cValue() -> git_object_t
    {
        switch self
        {
            case .gitObjectAny      : return GIT_OBJECT_ANY
            case .gitObjectInvalid  : return GIT_OBJECT_INVALID
            case .gitObjectCommit   : return GIT_OBJECT_COMMIT
            case .gitObjectTree     : return GIT_OBJECT_TREE
            case .gitObjectBlob     : return GIT_OBJECT_BLOB
            case .gitObjectTag      : return GIT_OBJECT_TAG
        }
    }
}
