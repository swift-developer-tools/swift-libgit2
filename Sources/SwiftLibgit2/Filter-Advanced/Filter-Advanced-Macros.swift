//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The CRLF filter.
///
/// ## C Equivalent
///
/// [`GIT_FILTER_CRLF`](https://libgit2.org/docs/reference/main/sys/filter/GIT_FILTER_CRLF.html)
public let gitFilterCRLF: String = "crlf"



/// The `ident` filter.
///
/// ## C Equivalent
///
/// [`GIT_FILTER_IDENT`](https://libgit2.org/docs/reference/main/sys/filter/GIT_FILTER_IDENT.html)
public let gitFilterIdent: String = "ident"



/// The priority with which the internal CRLF filter will be registered.
///
/// ## C Equivalent
///
/// [`GIT_FILTER_CRLF_PRIORITY`](https://libgit2.org/docs/reference/main/sys/filter/GIT_FILTER_CRLF_PRIORITY.html)
public let gitFilterCRLFPriority: Int32 = 0



/// The priority with which the internal `ident` filter will be registered.
///
/// ## C Equivalent
///
/// [`GIT_FILTER_IDENT_PRIORITY`](https://libgit2.org/docs/reference/main/sys/filter/GIT_FILTER_IDENT_PRIORITY.html)
public let gitFilterIdentPriority: Int32 = 100



/// The priority with which custom filters imitating core Git filter drivers
/// will be registered.
///
/// ## Discussion
///
/// The custom filters will be run last on checkout and first on checkin. This
/// does not need to be used, but it improves compatibility.
///
/// ## C Equivalent
///
/// [`GIT_FILTER_DRIVER_PRIORITY`](https://libgit2.org/docs/reference/main/sys/filter/GIT_FILTER_DRIVER_PRIORITY.html)
public let gitFilterDriverPriority: Int32 = 200



/// The current version for ``GitFilter``.
///
/// ## C Equivalent
///
/// [`GIT_FILTER_VERSION`](https://libgit2.org/docs/reference/main/sys/filter/GIT_FILTER_VERSION.html)
public let gitFilterVersion: UInt32 = 1
