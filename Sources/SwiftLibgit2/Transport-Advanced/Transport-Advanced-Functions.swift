//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_transport` instance.
/// - Parameters:
///   - transport: The `git_transport` instance to initialize.
///   - version: The version to use. Pass ``gitTransportVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_init()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_init.html)
public func gitTransportInit(
    transport   : UnsafeMutablePointer<git_transport>,
    version     : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_init(
            transport,
            version
        )
    }
}



/// Creates a transport from the given URL.
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The remote to own the transport. The underlying type must be
///   `git_remote`.
///   - url: The URL to which to connect.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_new()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_new.html)
public func gitTransportNew(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?>,
    owner   : OpaquePointer,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_new(
            out,
            owner,
            url
        )
    }
}



/// Creates an SSH transport with the given command paths.
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The remote to own the transport. The underlying type must be
///   `git_remote`.
///   - payload: The command paths to use. This must contain paths for
///   `git-upload-pack` and `git-receive-pack` as the first and second elements,
///   respectively.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_ssh_with_paths()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_ssh_with_paths.html)
public func gitTransportSSHWithPaths(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?>,
    owner   : OpaquePointer,
    payload : [String]
) -> GitErrorCode
{
    return withCConversion
    {
        return try payload.withGitStrArray
        {
            cPayload in
            
            return git_transport_ssh_with_paths(
                out,
                owner,
                cPayload
            )
        }
    }
}



/// Adds the specified custom transport definition to the built-in set of
/// libgit2 transports.
///
/// - Note: The caller is repsonsible for synchronizing calls to this function
/// and ``gitTransportUnregister(prefix:)`` with other calls that instantiate
/// transports.
///
/// - Parameters:
///   - prefix: The scheme to match. This must end with a scheme delimiter
///   (`://`).
///   - cb: The ``GitTransportCB`` callback to invoke to create the transport.
///   - param: The payload to pass to `cb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_register()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_register.html)
public func gitTransportRegister(
    prefix  : String,
    cb      : GitTransportCB,
    param   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_register(
            prefix,
            cb,
            param
        )
    }
}



/// Unregisters the specified custom transport.
///
/// - Note: The caller is repsonsible for synchronizing calls to this function
/// and ``gitTransportRegister(prefix:cb:param:)`` with other calls that
/// instantiate transports.
///
/// - Parameter prefix: The scheme to match. This must end with a scheme
/// delimiter (`://`).
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_unregister()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_unregister.html)
public func gitTransportUnregister(
    prefix: String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_unregister(prefix)
    }
}



/// Creates an instance of the local transport.
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The remote to own the transport. The underlying type must be
///   `git_remote`.
///   - payload: The payload to use. This must be `nil`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_local()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_local.html)
public func gitTransportLocal(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?>,
    owner   : OpaquePointer,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_local(
            out,
            owner,
            payload
        )
    }
}



/// Creates an instance of the smart transport.
///
/// - Important: If the operation succeeds, ownership of the given transport
/// will be transferred to the remote. The caller must not free the transport.
///
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The remote to own the transport. The underlying type must be
///   `git_remote`.
///   - payload: The subtransport definition to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_smart()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_smart.html)
public func gitTransportSmart(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?>,
    owner   : OpaquePointer,
    payload : GitSmartSubtransportDefinition
) -> GitErrorCode
{
    return withCConversion
    {
        return payload.withCValue
        {
            cPayload in
            
            return git_transport_smart(
                out,
                owner,
                cPayload
            )
        }
    }
}



/// Invokes the certificate check of the given smart transport.
/// - Parameters:
///   - transport: The smart transport to use.
///   - cert: The certificate to pass to the caller.
///   - valid: Whether the certificate is believed to be valid.
///   - hostName: The host name to which the tranport connected.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_smart_certificate_check()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_smart_certificate_check.html)
public func gitTransportSmartCertificateCheck(
    transport   : UnsafeMutablePointer<git_transport>,
    cert        : UnsafeMutablePointer<git_cert>,
    valid       : Bool,
    hostName    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_smart_certificate_check(
            transport,
            cert,
            valid.int32Value,
            hostName
        )
    }
}



/// Invokes the credentials callback of the given smart transport.
/// - Parameters:
///   - out: The pointer in which to store the credentials.
///   - transport: The smart transport to use.
///   - user: The user included in the URL.
///   - methods: The available authentication methods.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_smart_credentials()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_smart_credentials.html)
public func gitTransportSmartCredentials(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    transport   : UnsafeMutablePointer<git_transport>,
    user        : String?,
    methods     : Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transport_smart_credentials(
            out,
            transport,
            user,
            methods
        )
    }
}



/// Gets the remote connect options of the given transport.
/// - Parameters:
///   - out: The ``GitRemoteConnectOptions`` instance in which to store the
///   remote connect options of the given transport.
///   - transport: The transport to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transport_remote_connect_options()`](https://libgit2.org/docs/reference/main/sys/transport/git_transport_remote_connect_options.html)
public func gitTransportRemoteConnectOptions(
    out         : inout GitRemoteConnectOptions,
    transport   : UnsafeMutablePointer<git_transport>
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_transport_remote_connect_options(
                cOut,
                transport
            )
        }
    }
}



/// Creates an instance of the HTTP/HTTPS transport.
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The smart transport to own the subtransport.
///   - param: The custom subtransport parameters to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport_http()`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport_http.html)
public func gitSmartSubtransportHTTP(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_smart_subtransport>?>,
    owner   : UnsafeMutablePointer<git_transport>,
    param   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_smart_subtransport_http(
            out,
            owner,
            param
        )
    }
}



/// Creates an instance of the Git transport.
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The smart transport to own the subtransport.
///   - param: The custom subtransport parameters to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport_git()`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport_git.html)
public func gitSmartSubtransportGit(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_smart_subtransport>?>,
    owner   : UnsafeMutablePointer<git_transport>,
    param   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_smart_subtransport_git(
            out,
            owner,
            param
        )
    }
}



/// Creates an instance of the SSH transport.
/// - Parameters:
///   - out: The pointer in which to store the transport.
///   - owner: The smart transport to own the subtransport.
///   - param: The custom subtransport parameters to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport_ssh()`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport_ssh.html)
public func gitSmartSubtransportSSH(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_smart_subtransport>?>,
    owner   : UnsafeMutablePointer<git_transport>,
    param   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_smart_subtransport_ssh(
            out,
            owner,
            param
        )
    }
}
