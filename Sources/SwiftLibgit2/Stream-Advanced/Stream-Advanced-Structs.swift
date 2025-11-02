//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The base for all stream types.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_stream` instead.
///
/// ## C Equivalent
///
/// [`git_stream`](https://libgit2.org/docs/reference/main/sys/stream/git_stream.html)
public struct GitStream: CStruct, Sendable
{
    /// The struct version.
    public let version          : Int32
    
    /// Whether the stream is encrypted.
    public let encrypted        : Bool
    
    /// Whether the stream supports proxies.
    public let proxySupport     : Bool
    
    /// The timeout for read and write operations.
    ///
    /// ## Discussion
    ///
    /// If this is `0`, all read and write operations will be blocked
    /// indefinitely.
    public let timeout          : Int32
    
    /// The timeout for connecting to the remote server.
    ///
    /// ## Discussion
    ///
    /// If this is `0`, the system defaults will be used. This may be shorter
    /// than the system default, which is usually 75 seconds, but it must not
    /// be longer.
    public let connectTimeout   : Int32
    
    /// Connects the given stream.
    public let connect          : GitStream.Connect?
    
    /// Validates the given certificate.
    public let certificate      : GitStream.Certificate?
    
    /// Sets the proxy of the given stream.
    public let setProxy         : GitStream.SetProxy?
    
    /// Reads from the given stream.
    public let read             : GitStream.Read?
    
    /// Writes to the given stream.
    public let write            : GitStream.Write?
    
    /// Closes the given stream.
    public let close            : GitStream.Close?
    
    /// Frees the memory allocated for the given `git_stream` instance.
    public let free             : GitStream.Free?
    
    
    
    /// Initializes a ``GitStream`` instance from the given `git_stream`
    /// instance.
    /// - Parameter stream: The `git_stream` instance to use.
    internal init(
        cValue stream: git_stream
    )
    {
        self.version            = stream.version
        self.encrypted          = Bool(stream.encrypted)
        self.proxySupport       = Bool(stream.proxy_support)
        self.timeout            = stream.timeout
        self.connectTimeout     = stream.connect_timeout
        self.connect            = stream.connect
        self.certificate        = stream.certificate
        self.setProxy           = stream.set_proxy
        self.read               = stream.read
        self.write              = stream.write
        self.close              = stream.close
        self.free               = stream.free
    }
    
    
    
    /// The callback invoked to connect the given stream.
    /// - Parameter stream: The stream to connect.
    /// - Returns: `0` on success, or an error code.
    public typealias Connect = @convention(c)
    (
        UnsafeMutablePointer<git_stream>?
    ) -> Int32
    
    
    
    /// The callback invoked to validate the given certificate.
    /// - Parameters:
    ///   - cert: The certificate to validate.
    ///   - stream: The stream being connected.
    /// - Returns: `0` on success, or an error code.
    public typealias Certificate = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_cert>?>?,
        UnsafeMutablePointer<git_stream>?,
    ) -> Int32
    
    
    
    /// The callback invoked to set the proxy of the given stream.
    /// - Parameters:
    ///   - stream: The stream to update.
    ///   - opts: The proxy options to use.
    /// - Returns: `0` on success, or an error code.
    public typealias SetProxy = @convention(c)
    (
        UnsafeMutablePointer<git_stream>?,
        UnsafePointer<git_proxy_options>?
    ) -> Int32
    
    
    
    /// The callback invoked to read from the given stream.
    /// - Parameters:
    ///   - stream: The stream from which to read.
    ///   - data: The buffer in which to store the read data.
    ///   - len: The length of `data`.
    /// - Returns: The number of read bytes, or an error code.
    public typealias Read = @convention(c)
    (
        UnsafeMutablePointer<git_stream>?,
        UnsafeMutableRawPointer?,
        Int
    ) -> Int
    
    
    
    /// The callback invoked to write to the given stream.
    /// - Parameters:
    ///   - stream: The stream to which to write.
    ///   - data: The data to write.
    ///   - len: The length of `data`.
    ///   - flags: The flags to use.
    /// - Returns: The number of written bytes, or an error code.
    public typealias Write = @convention(c)
    (
        UnsafeMutablePointer<git_stream>?,
        UnsafePointer<CChar>?,
        Int,
        Int32
    ) -> Int
    
    
    
    /// The callback invoked to close the given stream.
    /// - Parameter stream: The stream to close.
    /// - Returns: `0` on success, or an error code.
    public typealias Close = @convention(c)
    (
        UnsafeMutablePointer<git_stream>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_stream` instance.
    /// - Parameter stream: The stream to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_stream>?
    ) -> Void
}



/// Stream registration information.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_stream_registration` instead.
///
/// ## C Equivalent
///
/// [`git_stream_registration`](https://libgit2.org/docs/reference/main/sys/stream/git_stream_registration.html)
public struct GitStreamRegistration: CStruct, Sendable
{
    /// The struct version.
    public let version      : Int32
    
    /// Creates a new connection to the given host and port.
    public let initialize   : GitStreamRegistration.Initialize?
    
    /// Creates a new connection on top of the given stream.
    public let wrap         : GitStreamRegistration.Wrap?
    
    
    
    /// Initializes a ``GitStreamRegistration`` instance from the given
    /// `git_stream_registration` instance.
    /// - Parameter streamRegistration: The `git_stream_registration` instance
    /// to use.
    internal init(
        cValue streamRegistration: git_stream_registration
    )
    {
        self.version    = streamRegistration.version
        self.initialize = streamRegistration.`init`
        self.wrap       = streamRegistration.wrap
    }
    
    
    
    /// The callback invoked to create a new connection to the given host and
    /// port.
    /// - Parameters:
    ///   - out: The pointer in which to store the stream.
    ///   - host: The name of the host to which to connect the stream.
    ///   - port: The port to which to connect the stream.
    /// - Returns: `0` on success, or an error code.
    public typealias Initialize = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_stream>?>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to create a new connection on top of the given
    /// stream.
    /// - Parameters:
    ///   - out: The pointer in which to store the stream.
    ///   - input: The stream to which to add TLS.
    ///   - host: The name of the host to which the stream is connected. This
    ///   will be used for certificate validation.
    /// - Returns: `0` on success, or an error code.
    ///
    /// ## Discussion
    ///
    /// If the given stream is a TLS stream, then this callback may be used to
    /// proxy a TLS stream over an HTTP CONNECT session. If this callback is
    /// used to unset the stream, then HTTP CONNECT proxies will not be
    /// supported.
    public typealias Wrap = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_stream>?>?,
        UnsafeMutablePointer<git_stream>?,
        UnsafePointer<CChar>?
    ) -> Int32
}
