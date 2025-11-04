//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The `text` merge driver.
///
/// ## C Equivalent
///
/// [`GIT_MERGE_DRIVER_TEXT`](https://libgit2.org/docs/reference/main/sys/merge/GIT_MERGE_DRIVER_TEXT.html)
public let gitMergeDriverText: String = "text"



/// The `binary` merge driver.
///
/// ## C Equivalent
///
/// [`GIT_MERGE_DRIVER_BINARY`](https://libgit2.org/docs/reference/main/sys/merge/GIT_MERGE_DRIVER_BINARY.html)
public let gitMergeDriverBinary: String = "binary"



/// The `union` merge driver.
///
/// ## C Equivalent
///
/// [`GIT_MERGE_DRIVER_UNION`](https://libgit2.org/docs/reference/main/sys/merge/GIT_MERGE_DRIVER_UNION.html)
public let gitMergeDriverUnion: String = "union"



/// The current version for ``GitMergeDriver``.
///
/// ## C Equivalent
///
/// [`GIT_MERGE_DRIVER_VERSION`](https://libgit2.org/docs/reference/main/sys/merge/GIT_MERGE_DRIVER_VERSION.html)
public let gitMergeDriverVersion: UInt32 = 1
