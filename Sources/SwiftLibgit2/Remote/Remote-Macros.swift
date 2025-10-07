//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



// TODO: Replace `git_remote_create_options` in documentation.
/// The current version for `git_remote_create_options`.
///
/// ## C Equivalent
///
/// [`GIT_REMOTE_CREATE_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/remote/GIT_REMOTE_CREATE_OPTIONS_VERSION.html)
public let gitRemoteCreateOptionsVersion: UInt32 = 1



/// The current version for ``GitRemoteCallbacks``.
///
/// ## C Equivalent
///
/// [`GIT_REMOTE_CALLBACKS_VERSION`](https://libgit2.org/docs/reference/main/remote/GIT_REMOTE_CALLBACKS_VERSION.html)
public let gitRemoteCallbacksVersion: UInt32 = 1



/// The current version for ``GitFetchOptions``.
///
/// ## C Equivalent
///
/// [`GIT_FETCH_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/remote/GIT_FETCH_OPTIONS_VERSION.html)
public let gitFetchOptionsVersion: UInt32 = 1



// TODO: Replace `git_push_options` in documentation.
/// The current version for `git_push_options`.
///
/// ## C Equivalent
///
/// [`GIT_PUSH_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/remote/GIT_PUSH_OPTIONS_VERSION.html)
public let gitPushOptionsVersion: UInt32 = 1



// TODO: Replace `git_remote_connect_options` in documentation.
/// The current version for `git_remote_connect_options`.
///
/// ## C Equivalent
///
/// [`GIT_REMOTE_CONNECT_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/remote/GIT_REMOTE_CONNECT_OPTIONS_VERSION.html)
public let gitRemoteConnectOptionsVersion: UInt32 = 1
