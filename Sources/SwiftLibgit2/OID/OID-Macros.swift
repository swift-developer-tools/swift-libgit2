//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The current libgit2 default ID type.
///
/// ## C Equivalent
///
/// [`GIT_OID_DEFAULT`](https://libgit2.org/docs/reference/main/oid/GIT_OID_DEFAULT.html)
public let gitOIDDefault: GitOIDT = .gitOIDSHA1



/// The size, in bytes, of a raw SHA-1 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA1_SIZE`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA1_SIZE.html)
public let gitOIDSHA1Size: Int = 20



/// The size, in bytes, of a hex formatted SHA-1 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA1_HEXSIZE`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA1_HEXSIZE.html)
public let gitOIDSHA1HexSize: Int = gitOIDSHA1Size * 2



/// The binary representation of the null SHA-1 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA1_ZERO`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA1_ZERO.html)
public let gitOIDSHA1Zero: GitOID = GitOID()



/// The string representation of the null SHA-1 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA1_HEXZERO`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA1_HEXZERO.html)
public let gitOIDSHA1HexZero = String(
    repeating:  "0",
    count:      Int(gitOIDSHA1HexSize)
)



/// The size, in bytes, of a raw SHA-256 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA256_SIZE`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA256_SIZE.html)
public let gitOIDSHA256Size: Int = 32



/// The size, in bytes, of a hex formatted SHA-256 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA256_HEXSIZE`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA256_HEXSIZE.html)
public let gitOIDSHA256HexSize: Int = gitOIDSHA256Size * 2



/// The string representation of the null SHA-256 ID.
///
/// ## C Equivalent
///
/// [`GIT_OID_SHA256_HEXZERO`](https://libgit2.org/docs/reference/main/oid/GIT_OID_SHA256_HEXZERO.html)
public let gitOIDSHA256HexZero = String(
    repeating:  "0",
    count:      Int(gitOIDSHA256HexSize)
)



/// The maximum possible raw format ID size.
///
/// ## C Equivalent
///
/// [`GIT_OID_MAX_SIZE`](https://libgit2.org/docs/reference/main/oid/GIT_OID_MAX_SIZE.html)
public let gitOIDMaxSize: Int = gitOIDSHA1Size



/// The maximum possible hex format ID size.
///
/// ## C Equivalent
///
/// [`GIT_OID_MAX_HEXSIZE`](https://libgit2.org/docs/reference/main/oid/GIT_OID_MAX_HEXSIZE.html)
public let gitOIDMaxHexSize: Int = gitOIDSHA1HexSize



/// The minimum length, in number of hex characters, of an ID prefix.
///
/// ## C Equivalent
///
/// [`GIT_OID_MINPREFIXLEN`](https://libgit2.org/docs/reference/main/oid/GIT_OID_MINPREFIXLEN.html)
public let gitOIDMinPrefixLen: Int = 4
