//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Tree traversal modes.
///
/// ## C Equivalent
///
/// [`git_treewalk_mode`](https://libgit2.org/docs/reference/main/tree/git_treewalk_mode.html)
public enum GitTreewalkMode: UInt32, CEnum
{
    /// Pre-order.
    case gitTreewalkPre     = 0
    
    /// Post-order.
    case gitTreewalkPost    = 1

    
    
    /// Initializes a ``GitTreewalkMode`` instance from the given
    /// `git_treewalk_mode` instance.
    /// - Parameter treewalkMode: The `git_treewalk_mode` instance to use.
    internal init?(
        cValue treewalkMode: git_treewalk_mode
    )
    {
        switch treewalkMode
        {
            case GIT_TREEWALK_PRE   : self = .gitTreewalkPre
            case GIT_TREEWALK_POST  : self = .gitTreewalkPost
            default                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitTreewalkMode`` instance into a `git_treewalk_mode`
    /// instance.
    /// - Returns: The `git_treewalk_mode` instance.
    internal func cValue() -> git_treewalk_mode
    {
        switch self
        {
            case .gitTreewalkPre    : return GIT_TREEWALK_PRE
            case .gitTreewalkPost   : return GIT_TREEWALK_POST
        }
    }
}



/// Tree update types.
///
/// ## C Equivalent
///
/// [`git_tree_update_t`](https://libgit2.org/docs/reference/main/tree/git_tree_update_t.html)
public enum GitTreeUpdateT: UInt32, CEnum
{
    /// Update or insert an entry.
    case gitTreeUpdateUpsert    = 0
    
    /// Remove an entry.
    case gitTreeUpdateRemove    = 1

    
    
    /// Initializes a ``GitTreeUpdateT`` instance from the given
    /// `git_tree_update_t` instance.
    /// - Parameter treeUpdate: The `git_tree_update_t` instance to use.
    internal init?(
        cValue treeUpdate: git_tree_update_t
    )
    {
        switch treeUpdate
        {
            case GIT_TREE_UPDATE_UPSERT : self = .gitTreeUpdateUpsert
            case GIT_TREE_UPDATE_REMOVE : self = .gitTreeUpdateRemove
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitTreeUpdateT`` instance into a `git_tree_update_t`
    /// instance.
    /// - Returns: The `git_tree_update_t` instance.
    internal func cValue() -> git_tree_update_t
    {
        switch self
        {
            case .gitTreeUpdateUpsert   : return GIT_TREE_UPDATE_UPSERT
            case .gitTreeUpdateRemove   : return GIT_TREE_UPDATE_REMOVE
        }
    }
}



/// The valid UNIX file attributes for index and tree entries.
///
/// ## C Equivalent
///
/// [`git_filemode_t`](https://libgit2.org/docs/reference/main/tree/git_filemode_t.html)
public enum GitFileModeT: UInt16, CEnum
{
    /// The unreadable file mode.
    case gitFileModeUnreadable      = 0
    
    /// The tree file mode.
    case gitFileModeTree            = 0o40000
    
    /// The blob file mode.
    case gitFileModeBlob            = 0o100644
    
    /// The executable blob file mode.
    case gitFileModeBlobExecutable  = 0o100755
    
    /// The link file mode.
    case gitFileModeLink            = 0o120000
    
    /// The commit file mode.
    case gitFileModeCommit          = 0o160000

    
    
    /// Initializes a ``GitFileModeT`` instance from the given `git_filemode_t`
    /// instance.
    /// - Parameter fileMode: The `git_filemode_t` instance to use.
    internal init?(
        cValue fileMode: git_filemode_t
    )
    {
        switch fileMode
        {
            case GIT_FILEMODE_UNREADABLE        : self = .gitFileModeUnreadable
            case GIT_FILEMODE_TREE              : self = .gitFileModeTree
            case GIT_FILEMODE_BLOB              : self = .gitFileModeBlob
            case GIT_FILEMODE_BLOB_EXECUTABLE   : self = .gitFileModeBlobExecutable
            case GIT_FILEMODE_LINK              : self = .gitFileModeLink
            case GIT_FILEMODE_COMMIT            : self = .gitFileModeCommit
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitFileModeT`` instance into a `git_filemode_t` instance.
    /// - Returns: The `git_filemode_t` instance.
    internal func cValue() -> git_filemode_t
    {
        switch self
        {
            case .gitFileModeUnreadable     : return GIT_FILEMODE_UNREADABLE
            case .gitFileModeTree           : return GIT_FILEMODE_TREE
            case .gitFileModeBlob           : return GIT_FILEMODE_BLOB
            case .gitFileModeBlobExecutable : return GIT_FILEMODE_BLOB_EXECUTABLE
            case .gitFileModeLink           : return GIT_FILEMODE_LINK
            case .gitFileModeCommit         : return GIT_FILEMODE_COMMIT
        }
    }
}
