//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Registers the specified stream constructor.
/// - Parameters:
///   - type: The type of stream to register.
///   - registration: The stream registration information to use. Pass `nil`
///   to unregister the stream and use the system defaults.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the specified stream constructor has already been registered, it will
/// be overwritten.
///
/// ## C Equivalent
///
/// [`git_stream_register()`](https://libgit2.org/docs/reference/main/sys/stream/git_stream_register.html)
public func gitStreamRegister(
    type            : GitStreamT,
    registration    : UnsafeMutablePointer<git_stream_registration>?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stream_register(
            type.cValue(),
            registration
        )
    }
}



/// Registers a TLS stream constructor.
/// - Parameter ctor: The ``GitStreamCB`` callback to invoke to create a new
/// connection. Pass `nil` to unregister the stream and use the system defaults.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function does not support HTTP CONNECT proxies.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``GitStreamRegistration/Initialize`` instead.
///
/// ## C Equivalent
///
/// [`git_stream_register_tls()`](https://libgit2.org/docs/reference/main/sys/stream/git_stream_register_tls.html)
public func gitStreamRegisterTLS(
    ctor: GitStreamCB?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_stream_register_tls(ctor)
    }
}
