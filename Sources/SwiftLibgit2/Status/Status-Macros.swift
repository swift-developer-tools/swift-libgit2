//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The default ``GitStatusOptT`` values.
///
/// ## C Equivalent
///
/// [`GIT_STATUS_OPT_DEFAULTS`](https://libgit2.org/docs/reference/main/status/GIT_STATUS_OPT_DEFAULTS.html)
public let gitStatusOptDefaults: GitStatusOptT =
[
    .gitStatusOptIncludeIgnored,
    .gitStatusOptIncludeUntracked,
    .gitStatusOptRecurseUntrackedDirs
]



/// The current version for ``GitStatusOptions``.
///
/// ## C Equivalent
///
/// [`GIT_STATUS_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/status/GIT_STATUS_OPTIONS_VERSION.html)
public let gitStatusOptionsVersion: UInt32 = 1
