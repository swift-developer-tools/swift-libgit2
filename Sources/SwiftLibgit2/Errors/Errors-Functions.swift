//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Gets the last error that was generated.
/// - Returns: The last error that was generated.
///
/// ## Discussion
///
/// The returned ``GitError`` instance may contain stale information if this
/// function is called after a different function that succeeded.
///
/// - Important: Do not rely on this to determine whether an error has occurred.
/// Instead, examine the ``GitErrorCode`` instances returned by functions.
///
/// ## C Equivalent
///
/// [`git_error_last()`](https://libgit2.org/docs/reference/main/errors/git_error_last.html)
public func gitErrorLast() -> GitError?
{
    guard let error: UnsafePointer<git_error> = git_error_last()
    else
    {
        return nil
    }
    
    return GitError(cValue: error.pointee)
}
