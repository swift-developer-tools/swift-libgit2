//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Checks whether the given path component corresponds to a `.git$SUFFIX` file.
/// - Parameters:
///   - path: The path component to check.
///   - pathLen: The length `path`.
///   - gitFile: The Git-specific file type.
///   - fs: The type of file system check to perform.
/// - Returns: Whether the given path component corresponds to a `.git$SUFFIX`
/// file, or `nil` if there was an error.
///
/// ## Discussion
///
/// Since some file systems have special behavior when writing files to the
/// disk, a plain string comparison is not always possible to verify whether
/// a file name matches an expected path. This function performs a more
/// in-depth check to verify the given path component.
///
/// ## C Equivalent
///
/// [`git_path_is_gitfile()`](https://libgit2.org/docs/reference/main/sys/path/git_path_is_gitfile.html)
public func gitPathIsGitFile(
    path    : String,
    pathLen : Int,
    gitFile : GitPathGitFile,
    fs      : GitPathFS
) -> Bool?
{
    let isPathGitFile: Int32 = git_path_is_gitfile(
        path,
        path.count,
        gitFile.cValue(),
        fs.cValue()
    )
    
    if
        isPathGitFile != 0,
        isPathGitFile != 1
    {
        return nil
    }
    
    return Bool(isPathGitFile)
}
