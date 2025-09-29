//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The current version for ``GitCheckoutOptions``.
///
/// ## C Equivalent
///
/// [`GIT_CHECKOUT_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/checkout/GIT_CHECKOUT_OPTIONS_VERSION.html)
public let gitCheckoutOptionsVersion: UInt32 = UInt32(GIT_CHECKOUT_OPTIONS_VERSION)
