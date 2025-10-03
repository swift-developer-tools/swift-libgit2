//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The current version for ``GitBlobFilterOptions``.
///
/// ## C Equivalent
///
/// [`GIT_BLOB_FILTER_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/blob/GIT_BLOB_FILTER_OPTIONS_VERSION.html)
public let gitBlobFilterOptionsVersion: UInt32 = UInt32(GIT_BLOB_FILTER_OPTIONS_VERSION)
