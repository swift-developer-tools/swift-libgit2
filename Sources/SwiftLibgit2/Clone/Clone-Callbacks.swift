//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callback to add a remote with the default fetch refspec to the repository's configuration.
/// - Parameters:
///   - out: The pointer in which to store the resulting remote. The underlying type should be
///   `git_remote`.
///   - repo: The repository in which to create the remote. The underlying type should be
///   `git_repository`.
///   - name: The remote name.
///   - url: The remote URL.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// Callers of ``gitClone(out:url:localPath:options:)`` may provide a function matching
/// this signature to override the remote creation and customization process during a clone operation.
///
/// ## C Equivalent
///
/// [`git_remote_create_cb()`](https://libgit2.org/docs/reference/main/clone/git_remote_create_cb.html)
public typealias GitRemoteCreateCB = @convention(c)
(
    UnsafeMutablePointer<OpaquePointer?>?,
    OpaquePointer?,
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback to create a new Git repository in the given folder.
/// - Parameters:
///   - out: The pointer in which to store the resulting repository. The underlying type should be
///   `git_repository`.
///   - path: The path to the repository.
///   - isBare: Whether a Git repository without a working directory should be created at the
///   given path. If `false`, the provided path will be considered the working directory in which
///   the `.git` directory will be created.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// Callers of ``gitClone(out:url:localPath:options:)`` may provide a function matching
/// this signature to override the repository creation and customization process during a clone operation.
///
/// ## C Equivalent
///
/// [`git_repository_create_cb()`](https://libgit2.org/docs/reference/main/clone/git_repository_create_cb.html)
public typealias GitRepositoryCreateCB = @convention(c)
(
    UnsafeMutablePointer<OpaquePointer?>?,
    UnsafePointer<CChar>?,
    Int32,
    UnsafeMutableRawPointer?
) -> Int32
