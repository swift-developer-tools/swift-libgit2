//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The current version for ``GitRebaseOptions``.
///
/// ## C Equivalent
///
/// [`GIT_REBASE_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/rebase/GIT_REBASE_OPTIONS_VERSION.html)
public let gitRebaseOptionsVersion: UInt32 = 1



/// Indicates that a rebase operation is not in progress.
///
/// ## C Equivalent
///
/// [`GIT_REBASE_NO_OPERATION`](https://libgit2.org/docs/reference/main/rebase/GIT_REBASE_NO_OPERATION.html)
public let gitRebaseNoOperation: UInt = UInt.max
