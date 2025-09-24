//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The separator used in path list strings, like the `PATH` environment variable.
///
/// ## Discussion
///
/// A colon is used for Apple platforms and all systems other than Windows and AmigaOS,
/// which use a semi-colon.
///
/// ## C Equivalent
///
/// [`GIT_PATH_LIST_SEPARATOR`](https://libgit2.org/docs/reference/main/common/GIT_PATH_LIST_SEPARATOR.html)
public let GitPathListSeparator: String = ":"



/// The maximum length of a valid Git path.
///
/// ## C Equivalent
///
/// [`GIT_PATH_MAX`](https://libgit2.org/docs/reference/main/common/GIT_PATH_MAX.html)
public let GitPathMax: Int32 = GIT_PATH_MAX
