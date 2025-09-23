//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The current version for ``GitMergeOptions``.
///
/// ## C Equivalent
///
/// [`GIT_MERGE_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/merge/GIT_MERGE_OPTIONS_VERSION.html)
public let gitMergeOptionsVersion: UInt32 = UInt32(GIT_MERGE_OPTIONS_VERSION)
