//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The valid modes for index and tree entries.
///
/// ## C Equivalent
///
/// [`git_filemode_t`](https://libgit2.org/docs/reference/main/tree/git_filemode_t.html)
public enum GitFileModeT: UInt16, GitEnum
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

    
    
    
    /// Creates a ``GitFileModeT`` instance from a `git_filemode_t` instance.
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
    
    
    
    /// The equivalent C value.
    internal var cValue: git_filemode_t
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
