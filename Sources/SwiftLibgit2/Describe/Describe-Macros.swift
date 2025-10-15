//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The default maximum number of candidate tags.
///
/// ## C Equivalent
///
/// [`GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS`](https://libgit2.org/docs/reference/main/describe/GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS.html)
public let gitDescribeDefaultMaxCandidatesTags: UInt32 = 10



/// The default size of the abbreviated commit ID.
///
/// ## C Equivalent
///
/// [`GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE`](https://libgit2.org/docs/reference/main/describe/GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE.html)
public let gitDescribeDefaultAbbreviatedSize: UInt32 = 7



/// The current version for ``GitDescribeOptions``.
///
/// ## C Equivalent
///
/// [`GIT_DESCRIBE_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/describe/GIT_DESCRIBE_OPTIONS_VERSION.html)
public let gitDescribeOptionsVersion: UInt32 = 1



/// The current version for ``GitDescribeFormatOptions``.
///
/// ## C Equivalent
///
/// [`GIT_DESCRIBE_FORMAT_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/describe/GIT_DESCRIBE_FORMAT_OPTIONS_VERSION.html)
public let gitDescribeFormatOptionsVersion: UInt32 = 1
