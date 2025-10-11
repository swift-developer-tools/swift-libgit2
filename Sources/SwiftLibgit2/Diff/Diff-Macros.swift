//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The current version for ``GitDiffOptions``.
///
/// ## C Equivalent
///
/// [`GIT_DIFF_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/diff/GIT_DIFF_OPTIONS_VERSION.html)
public let gitDiffOptionsVersion: UInt32 = 1



/// The default maximum size of the diff hunk header.
///
/// ## C Equivalent
///
/// [`GIT_DIFF_HUNK_HEADER_SIZE`](https://libgit2.org/docs/reference/main/diff/GIT_DIFF_HUNK_HEADER_SIZE.html)
public let gitDiffHunkHeaderSize: UInt32 = 128



/// The current version for ``GitDiffFindOptions``.
///
/// ## C Equivalent
///
/// [`GIT_DIFF_FIND_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/diff/GIT_DIFF_FIND_OPTIONS_VERSION.html)
public let gitDiffFindOptionsVersion: UInt32 = 1



/// The current version for ``GitDiffParseOptions``.
///
/// ## C Equivalent
///
/// [`GIT_DIFF_PARSE_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/diff/GIT_DIFF_PARSE_OPTIONS_VERSION.html)
public let gitDiffParseOptionsVersion: UInt32 = 1



/// The current version for ``GitDiffPatchIDOptions``.
///
/// ## C Equivalent
///
/// [`GIT_DIFF_PATCHID_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/diff/GIT_DIFF_PATCHID_OPTIONS_VERSION.html)
public let gitDiffPatchIDOptionsVersion: UInt32 = 1
