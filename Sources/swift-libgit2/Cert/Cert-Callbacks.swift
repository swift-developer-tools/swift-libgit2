//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callback for the user's custom certificate checks.
/// - Parameters:
///   - cert: The host certificate.
///   - valid: Whether OpenSSL thinks this certificate is valid.
///   - host: The host name of the host to which libgit2 is connected.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if the connection should be failed, a positive value if the callback
/// refused to act and the existing validity determination should be honored, or `0` to proceed with
/// the connection.
///
/// ## C Equivalent
///
/// [`git_transport_certificate_check_cb()`](https://libgit2.org/docs/reference/main/cert/git_transport_certificate_check_cb.html)
public typealias GitTransportCertificateCheckCallback = @convention(c)
(
    UnsafeMutablePointer<git_cert>?,
    Int32,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
