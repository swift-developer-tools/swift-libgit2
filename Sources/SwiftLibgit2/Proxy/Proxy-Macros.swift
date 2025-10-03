//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The current version for ``GitProxyOptions``.
///
/// ## C Equivalent
///
/// [`GIT_PROXY_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/proxy/GIT_PROXY_OPTIONS_VERSION.html)
public let gitProxyOptionsVersion: UInt32 = UInt32(GIT_PROXY_OPTIONS_VERSION)
