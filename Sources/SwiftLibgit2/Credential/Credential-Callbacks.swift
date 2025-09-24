//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callback for credential acquisition.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - url: The resource for which a credential is being demanded.
///   - usernameFromURL: The username that is embedded in a `user@host` remote URL.
///   - allowedTypes: The credential types that may be returned. See ``GitCredentialT``.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if an error occurred, a positive value if no credential was acquired,
/// or `0` on success.
///
/// ## Discussion
///
/// This callback is usually involved any time another system might need authentication. A valid
/// `git_credential` object must be provided, depending on `allowedTypes`.
///
/// Most authentication details are the caller's responsibility. This callback will be called repeatedly until
/// the authentication succeeds or an error is reported. Take care to stop providing the same incorrect
/// credentials, otherwise it is easy to fall into an infinite loop.
///
/// ## C Equivalent
///
/// [`git_credential_acquire_cb()`](https://libgit2.org/docs/reference/main/credential/git_credential_acquire_cb.html)
public typealias GitCredentialAcquireCB = @convention(c)
(
    UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>?,
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UInt32,
    UnsafeMutableRawPointer?
) -> Int32
