//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The types of Git-specific files.
///
/// ## C Equivalent
///
/// [`git_path_gitfile`](https://libgit2.org/docs/reference/main/sys/path/git_path_gitfile.html)
public enum GitPathGitFile: UInt32, CEnum
{
    /// Check for the `.gitignore` file.
    case gitPathGitFileGitignore        = 0
    
    /// Check for the `.gitmodules` file.
    case gitPathGitFileGitmodules       = 1
    
    /// Check for the `.gitattributes` file.
    case gitPathGitFileGitattributes    = 2
    
    
    
    /// Initializes a ``GitPathGitFile`` instance from the given
    /// `git_path_gitfile` instance.
    /// - Parameter pathGitFile: The `git_path_gitfile` instance to use.
    internal init?(
        cValue pathGitFile: git_path_gitfile
    )
    {
        switch pathGitFile
        {
            case GIT_PATH_GITFILE_GITIGNORE     : self = .gitPathGitFileGitignore
            case GIT_PATH_GITFILE_GITMODULES    : self = .gitPathGitFileGitmodules
            case GIT_PATH_GITFILE_GITATTRIBUTES : self = .gitPathGitFileGitattributes
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitPathGitFile`` instance into a `git_path_gitfile`
    /// instance.
    /// - Returns: The `git_path_gitfile` instance.
    internal func cValue() -> git_path_gitfile
    {
        switch self
        {
            case .gitPathGitFileGitignore       : return GIT_PATH_GITFILE_GITIGNORE
            case .gitPathGitFileGitmodules      : return GIT_PATH_GITFILE_GITMODULES
            case .gitPathGitFileGitattributes   : return GIT_PATH_GITFILE_GITATTRIBUTES
        }
    }
}



/// The types of file system checks to perform.
///
/// ## C Equivalent
///
/// [`git_path_fs`](https://libgit2.org/docs/reference/main/sys/path/git_path_fs.html)
public enum GitPathFS: UInt32, CEnum
{
    /// Perform both NTFS-specific and HFS-specific checks.
    case gitPathFSGeneric   = 0
    
    /// Perform only NTFS-specific checks.
    case gitPathFSNTFS      = 1
    
    /// Perform only HFS-specific checks.
    case gitPathFSHFS       = 2
    
    
    
    /// Initializes a ``GitPathFS`` instance from the given `git_path_fs`
    /// instance.
    /// - Parameter pathFS: The `git_path_fs` instance to use.
    internal init?(
        cValue pathFS: git_path_fs
    )
    {
        switch pathFS
        {
            case GIT_PATH_FS_GENERIC    : self = .gitPathFSGeneric
            case GIT_PATH_FS_NTFS       : self = .gitPathFSNTFS
            case GIT_PATH_FS_HFS        : self = .gitPathFSHFS
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitPathFS`` instance into a `git_path_fs` instance.
    /// - Returns: The `git_path_fs` instance.
    internal func cValue() -> git_path_fs
    {
        switch self
        {
            case .gitPathFSGeneric  : return GIT_PATH_FS_GENERIC
            case .gitPathFSNTFS     : return GIT_PATH_FS_NTFS
            case .gitPathFSHFS      : return GIT_PATH_FS_HFS
        }
    }
}
