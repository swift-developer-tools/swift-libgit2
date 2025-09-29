//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The current version for ``GitApplyOptions``.
///
/// ## C Equivalent
/// 
/// [`GIT_APPLY_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/apply/GIT_APPLY_OPTIONS_VERSION.html)
public let gitApplyOptionsVersion: UInt32 = UInt32(GIT_APPLY_OPTIONS_VERSION)
