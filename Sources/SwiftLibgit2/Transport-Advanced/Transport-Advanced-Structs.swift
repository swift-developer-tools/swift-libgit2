//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The negotiation state during a fetch smart transport negotiation.
///
/// ## C Equivalent
///
/// [`git_fetch_negotiation`](https://libgit2.org/docs/reference/main/sys/transport/git_fetch_negotiation.html)
public struct GitFetchNegotiation: CStructReadable, WithCConvertible, Sendable
{
    /// The available remote references.
    public let refs             : [GitRemoteHEAD]
    
    /// The length of ``refs``.
    public var refsLen          : Int
    {
        return refs.count
    }
    
    /// The shallow roots of the remote.
    public let shallowRoots     : [GitOID]
    
    /// The length of ``shallowRoots``.
    public var shallowRootsLen  : Int
    {
        return shallowRoots.count
    }
    
    /// The shallowness of the fetch operation.
    public let depth            : Int32
    
    
    
    /// Initializes a ``GitFetchNegotiation`` instance from the given
    /// `git_fetch_negotiation` instance.
    /// - Parameter fetchNegotiation: The `git_fetch_negotiation` instance
    /// to use.
    internal init(
        cValue fetchNegotiation: git_fetch_negotiation
    )
    {
        self.refs           = Array(fetchNegotiation.refs, count: fetchNegotiation.refs_len)
        self.shallowRoots   = Array(fetchNegotiation.shallow_roots, count: fetchNegotiation.shallow_roots_len)
        self.depth          = fetchNegotiation.depth
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_fetch_negotiation` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_fetch_negotiation>) throws -> T
    ) throws -> T
    {
        var fetchNegotiation = git_fetch_negotiation()
        
        fetchNegotiation.depth = depth
        
        return try refs.withArrayOfGitRemoteHEADs
        {
            cRefs, cRefsCount in
            
            fetchNegotiation.refs       = cRefs
            fetchNegotiation.refs_len   = cRefsCount
            
            return try shallowRoots.withArrayOfGitOIDs
            {
                cShallowRoots, cShallowRootsCount in
                
                fetchNegotiation.shallow_roots      = cShallowRoots
                fetchNegotiation.shallow_roots_len  = cShallowRootsCount
                
                return try body(&fetchNegotiation)
            }
        }
    }
}



/// Stream registration information.
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_transport` instead.
///
/// ## C Equivalent
///
/// [`git_transport`](https://libgit2.org/docs/reference/main/sys/transport/git_transport.html)
public struct GitTransport: CStruct, Sendable
{
    /// The struct version.
    public let version          : UInt32
    
    /// Connects the given transport.
    public let connect          : GitTransport.Connect?
    
    /// Sets the remote connection options of the given transport.
    public let setConnectOpts   : GitTransport.SetConnectOpts?
    
    /// Gets the capabilities of the specified remote.
    public let capabilities     : GitTransport.Capabilities?
    
    /// Gets the available references of the specified remote.
    public let ls               : GitTransport.LS?
    
    /// Executes the given push operation.
    public let push             : GitTransport.Push?
    
    /// Negotiates a fetch operation with the specified remote.
    public let negotiateFetch   : GitTransport.NegotiateFetch?
    
    /// Gets the IDs shallow roots of specified remote.
    public let shallowRoots     : GitTransport.ShallowRoots?
    
    /// Downloads the packfile from the given repository.
    public let downloadPack     : GitTransport.DownloadPack?
    
    /// Checks whether the given transport is connected.
    public let isConnected      : GitTransport.IsConnected?
    
    /// Cancels any outstanding operation of the given transport.
    public let cancel           : GitTransport.Cancel?
    
    /// Closes the connection of the given transport.
    public let close            : GitTransport.Close?
    
    /// Frees the memory allocated for the given `git_transport` instance.
    public let free             : GitTransport.Free?
    
    
    
    /// Initializes a ``GitTransport`` instance from the given `git_transport`
    /// instance.
    /// - Parameter transport: The `git_transport` instance to use.
    internal init(
        cValue transport: git_transport
    )
    {
        self.version            = transport.version
        self.connect            = transport.connect
        self.setConnectOpts     = transport.set_connect_opts
        self.capabilities       = transport.capabilities
        self.ls                 = transport.ls
        self.push               = transport.push
        self.negotiateFetch     = transport.negotiate_fetch
        self.shallowRoots       = transport.shallow_roots
        self.downloadPack       = transport.download_pack
        self.isConnected        = transport.is_connected
        self.cancel             = transport.cancel
        self.close              = transport.close
        self.free               = transport.free
    }
    
    
    
    /// The callback invoked to connect the given transport.
    /// - Parameters:
    ///   - transport: The transport to connect.
    ///   - url: The remote URL to which to connect.
    ///   - direction: The direction of the connection.
    ///   - connectOpts: The remote connection options to use.
    /// - Returns: `0` on success, or an error code.
    public typealias Connect = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?,
        UnsafePointer<CChar>?,
        Int32,
        UnsafePointer<git_remote_connect_options>?
    ) -> Int32
    
    
    
    /// The callback invoked to set the remote connection options of the
    /// given transport.
    /// - Parameters:
    ///   - transport: The transport to update.
    ///   - connectOpts: The remote connection options to use.
    /// - Returns: `0` on success, or an error code.
    public typealias SetConnectOpts = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?,
        UnsafePointer<git_remote_connect_options>?
    ) -> Int32
    
    
    
    /// The callback invoked to get the capabilities of the specified remote.
    /// - Parameters:
    ///   - out: The pointer in which to store the capabilities.
    ///   - transport: The transport to use.
    /// - Returns: `0` on success, or an error code.
    public typealias Capabilities = @convention(c)
    (
        UnsafeMutablePointer<UInt32>?,
        UnsafeMutablePointer<git_transport>?
    ) -> Int32
    
    
    
    /// The callback invoked to get the available references of the specified
    /// remote.
    /// - Parameters:
    ///   - out: The pointer in which to store the available references.
    ///   - size: The pointer in which to store the length of `out`.
    ///   - transport: The transport to use.
    /// - Returns: `0` on success, or an error code.
    public typealias LS = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<UnsafePointer<git_remote_head>?>?>?,
        UnsafeMutablePointer<Int>?,
        UnsafeMutablePointer<git_transport>?
    ) -> Int32
    
    
    
    /// The callback invoked to execute the given push operation.
    /// - Parameters:
    ///   - transport: The transport to use.
    ///   - push: The push operation to execute. The underlying type must be
    ///   `git_push`.
    /// - Returns: `0` on success, or an error code.
    public typealias Push = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?,
        OpaquePointer?
    ) -> Int32
    
    
    
    /// The callback invoked to negotiate a fetch operation with the specified
    /// remote.
    /// - Parameters:
    ///   - transport: The transport to use.
    ///   - repo: The repository to use. The underlying type must be
    ///   `git_repository`.
    ///   - fetchData: The negotiation state.
    /// - Returns: `0` on success, or an error code.
    public typealias NegotiateFetch = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?,
        OpaquePointer?,
        UnsafePointer<git_fetch_negotiation>?
    ) -> Int32
    
    
    
    /// The callback invoked to get the IDs shallow roots of specified remote.
    /// - Parameters:
    ///   - out: The pointer in which to store the IDs.
    ///   - transport: The transport to use.
    /// - Returns: `0` on success, or an error code.
    public typealias ShallowRoots = @convention(c)
    (
        UnsafeMutablePointer<git_oidarray>?,
        UnsafeMutablePointer<git_transport>?
    ) -> Int32
    
    
    
    /// The callback invoked to download the packfile from the given repository.
    /// - Parameters:
    ///   - transport: The transport to use.
    ///   - repo: The repository to use. The underlying type must be
    ///   `git_repository`.
    ///   - stats: The information about the progress of indexing the packfile.
    /// - Returns: `0` on success, or an error code.
    public typealias DownloadPack = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?,
        OpaquePointer?,
        UnsafeMutablePointer<git_indexer_progress>?
    ) -> Int32
    
    
    
    /// The callback invoked to check whether the given transport is connected.
    /// - Parameter transport: The transport to check.
    /// - Returns: Whether the given transport is connected, or an error code.
    public typealias IsConnected = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?
    ) -> Int32
    
    
    
    /// The callback invoked to cancel any outstanding operation of the given
    /// transport.
    /// - Parameter transport: The transport to cancel.
    public typealias Cancel = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?
    ) -> Void
    
    
    
    /// The callback invoked to close the connection of the given transport.
    /// - Parameter transport: The transport to close.
    /// - Returns: `0` on success, or an error code.
    public typealias Close = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_transport` instance.
    /// - Parameter transport: The transport to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_transport>?
    ) -> Void
}



/// A stream used by a smart transport to read and write data from a
/// subtransport.
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_smart_subtransport_stream`
/// instead.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport_stream`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport_stream.html)
public struct GitSmartSubtransportStream: CStruct
{
    /// The subtransport.
    public let subtransport : UnsafeMutablePointer<git_smart_subtransport>?
    
    /// Reads from the given stream.
    public let read         : GitSmartSubtransportStream.Read?
    
    /// Writes to the given stream.
    public let write        : GitSmartSubtransportStream.Write?
    
    /// Frees the memory allocated for the given `git_smart_subtransport_stream`
    /// instance.
    public let free         : GitSmartSubtransportStream.Free?
    
    
    
    /// Initializes a ``GitSmartSubtransportStream`` instance from the given
    /// `git_smart_subtransport_stream` instance.
    /// - Parameter smartSubtransportStream: The `git_smart_subtransport_stream`
    /// instance to use.
    internal init(
        cValue smartSubtransportStream: git_smart_subtransport_stream
    )
    {
        self.subtransport   = smartSubtransportStream.subtransport
        self.read           = smartSubtransportStream.read
        self.write          = smartSubtransportStream.write
        self.free           = smartSubtransportStream.free
    }
    
    
    
    /// The callback invoked to read from the given stream.
    ///
    /// The implementation may read less than requested.
    ///
    /// - Parameters:
    ///   - stream: The stream from which to read.
    ///   - buffer: The buffer in which to store the read data.
    ///   - bufSize: The length of `buffer`.
    ///   - bytesRead: The pointer in which to store the number of read bytes.
    /// - Returns: `0` on success, or an error code.
    public typealias Read = @convention(c)
    (
        UnsafeMutablePointer<git_smart_subtransport_stream>?,
        UnsafeMutablePointer<CChar>?,
        Int,
        UnsafeMutablePointer<Int>?
    ) -> Int32
    
    
    
    /// The callback invoked to write to the given stream.
    ///
    /// The implementation must write all the given data, or return an error.
    ///
    /// - Parameters:
    ///   - stream: The stream to which to write.
    ///   - data: The data to write.
    ///   - len: The length of `data`.
    /// - Returns: `0` on success, or an error code.
    public typealias Write = @convention(c)
    (
        UnsafeMutablePointer<git_smart_subtransport_stream>?,
        UnsafePointer<CChar>?,
        Int
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_smart_subtransport_stream` instance.
    /// - Parameter stream: The stream to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_smart_subtransport_stream>?
    ) -> Void
}



/// A subtransport that carries data for a smart transport.
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_smart_subtransport` instead.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport.html)
public struct GitSmartSubtransport: CStruct, Sendable
{
    /// Sets up the given subtransport stream for the given action.
    public let action   : GitSmartSubtransport.Action?
    
    /// Closes the given transport.
    public let close    : GitSmartSubtransport.Close?
    
    /// Frees the memory allocated for the given `git_smart_subtransport`
    /// instance.
    public let free     : GitSmartSubtransport.Free?
    
    
    
    /// Initializes a ``GitSmartSubtransport`` instance from the given
    /// `git_smart_subtransport` instance.
    /// - Parameter smartSubtransport: The `git_smart_subtransport` instance
    /// to use.
    internal init(
        cValue smartSubtransport: git_smart_subtransport
    )
    {
        self.action     = smartSubtransport.action
        self.close      = smartSubtransport.close
        self.free       = smartSubtransport.free
    }
    
    
    
    /// The callback invoked to set up the given subtransport stream for the
    /// given action.
    /// - Parameters:
    ///   - out: The pointer in which to store the smart subtransport stream.
    ///   - transport: The smart subtransport to use.
    ///   - url: The remote URL to use.
    ///   - action: The action to perform.
    /// - Returns: `0` on success, or an error code.
    public typealias Action = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_smart_subtransport_stream>?>?,
        UnsafeMutablePointer<git_smart_subtransport>?,
        UnsafePointer<CChar>?,
        git_smart_service_t
    ) -> Int32
    
    
    
    /// The callback invoked to close the given transport.
    ///
    /// Subtransports are guaranteed to be closed between actions, except for
    /// the following two "natural" progressions of actions against a constant
    /// URL:
    ///
    /// - ``GitSmartServiceT/gitServiceUploadPackLS`` to
    /// ``GitSmartServiceT/gitServiceUploadPack``.
    /// - ``GitSmartServiceT/gitServiceReceivePackLS`` to
    /// ``GitSmartServiceT/gitServiceReceivePack``.
    ///
    /// - Parameter transport: The transport to close.
    /// - Returns: `0` on success, or an error code.
    public typealias Close = @convention(c)
    (
        UnsafeMutablePointer<git_smart_subtransport>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_smart_subtransport` instance.
    /// - Parameter transport: The transport to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_smart_subtransport>?
    ) -> Void
}



/// A subtransport definition.
///
/// A smart transport knows how to speak the Git protocol, but it has no
/// knowledge of how to establish a connection between itself and another
/// endpoint, or how to move data back and forth. A smart transport uses
/// subtransports for these purposes.
///
/// Three subtransports are provided by libgit2: SSH, Git, and HTTP/HTTPS.
///
/// Subtransports can be a persistent connection or a request/response
/// connection. Smart transports handle the difference internally.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport_definition`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport_definition.html)
public struct GitSmartSubtransportDefinition: CStructMutable, CConvertible
{
    /// The callback invoked to create a new subtransport for the given smart
    /// transport.
    ///
    /// The default value is `nil`.
    ///
    /// - Important: This must not be `nil` at runtime.
    public var callback : GitSmartSubtransportCB?
    
    /// Whether the protocol is stateless.
    ///
    /// The default value is `false`.
    public var rpc      : Bool
    
    /// The payload passed to ``callback``.
    ///
    /// The default value is `nil`.
    public var param    : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitSmartSubtransportDefinition`` instance, optionally
    /// specifying values for its properties.
    public init(
        callback    : GitSmartSubtransportCB?   = nil,
        rpc         : Bool                      = false,
        param       : UnsafeMutableRawPointer?  = nil
    )
    {
        self.callback   = callback
        self.rpc        = rpc
        self.param      = param
    }
    
    
    
    /// Initializes a ``GitSmartSubtransportDefinition`` instance from the
    /// given `git_smart_subtransport_definition` instance.
    /// - Parameter smartSubtransportDefinition: The
    /// `git_smart_subtransport_definition` instance to use.
    internal init(
        cValue smartSubtransportDefinition: git_smart_subtransport_definition
    )
    {
        self.callback   = smartSubtransportDefinition.callback
        self.rpc        = Bool(smartSubtransportDefinition.rpc)
        self.param      = smartSubtransportDefinition.param
    }
    
    
    
    /// Converts the ``GitSmartSubtransportDefinition`` instance into a
    /// `git_smart_subtransport_definition` instance.
    /// - Returns: The `git_smart_subtransport_definition` instance.
    internal func cValue() -> git_smart_subtransport_definition
    {
        var smartSubtransportDefinition = git_smart_subtransport_definition()
        
        smartSubtransportDefinition.callback    = callback
        smartSubtransportDefinition.rpc         = rpc.uint32Value
        smartSubtransportDefinition.param       = param
        
        return smartSubtransportDefinition
    }
}
