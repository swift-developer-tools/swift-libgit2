//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the OpenSSL locks.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// OpenSSL requires the application to determine how it performs locking.
/// This is a last-resort convenience function that libgit2 provides for
/// allocating and initializing the locks, as well as setting the locking
/// function to use the system's native locking functions.
///
/// The locking function will be cleared and the memory will be freed when
/// ``gitLibgit2Shutdown()`` is called.
///
/// - Important: Swift OpenSSL bindings and packages already handle locking.
/// Strongly consider using those instead of this last-resort function.
///
/// ## C Equivalent
///
/// [`git_openssl_set_locking()`](https://libgit2.org/docs/reference/main/sys/openssl/git_openssl_set_locking.html)
public func gitOpenSSLSetLocking() -> GitErrorCode
{
    return withCConversion
    {
        return git_openssl_set_locking()
    }
}
