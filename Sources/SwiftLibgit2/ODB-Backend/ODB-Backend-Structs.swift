//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for configuring a packfile object backend.
///
/// ## C Equivalent
///
/// [`git_odb_backend_pack_options`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_backend_pack_options.html)
public struct GitODBBackendPackOptions: CStructMutable, CConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitODBBackendPackOptionsVersion``.
    public var version  : UInt32
    
    /// The type of ID to use for the object database.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitOIDT/gitOIDSHA1``.
    public var oidType  : GitOIDT
    
    
    
    /// Initializes a ``GitODBBackendPackOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version : UInt32    = gitODBBackendPackOptionsVersion,
        oidType : GitOIDT   = .gitOIDSHA1
    )
    {
        self.version    = version
        self.oidType    = oidType
    }
    
    
    
    /// Initializes a ``GitODBBackendPackOptions`` instance from the given
    /// `git_odb_backend_pack_options` instance.
    /// - Parameter odbBackendPackOptions: The `git_odb_backend_pack_options`
    /// instance to use.
    internal init(
        cValue odbBackendPackOptions: git_odb_backend_pack_options
    )
    {
        self.version    = odbBackendPackOptions.version
        self.oidType    = GitOIDT(cValue: odbBackendPackOptions.oid_type) ?? .gitOIDSHA1
    }
    
    
    
    /// Converts the ``GitODBBackendPackOptions`` instance into a
    /// `git_odb_backend_pack_options` instance.
    /// - Returns: The `git_odb_backend_pack_options` instance.
    internal func cValue() -> git_odb_backend_pack_options
    {
        var odbBackendPackOptions = git_odb_backend_pack_options()
        
        odbBackendPackOptions.version   = version
        odbBackendPackOptions.oid_type  = oidType.cValue()
        
        return odbBackendPackOptions
    }
}



/// The options for configuring a loose object backend.
///
/// ## C Equivalent
///
/// [`git_odb_backend_loose_options`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_backend_loose_options.html)
public struct GitODBBackendLooseOptions: CStructMutable, CConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitODBBackendLooseOptionsVersion``.
    public var version  : UInt32
    
    /// The type of ID to use for the object database.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitOIDT/gitOIDSHA1``.
    public var oidType  : GitOIDT
    
    
    
    /// Initializes a ``GitODBBackendLooseOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version : UInt32    = gitODBBackendLooseOptionsVersion,
        oidType : GitOIDT   = .gitOIDSHA1
    )
    {
        self.version    = version
        self.oidType    = oidType
    }
    
    
    
    /// Initializes a ``GitODBBackendLooseOptions`` instance from the given
    /// `git_odb_backend_loose_options` instance.
    /// - Parameter odbBackendLooseOptions: The `git_odb_backend_loose_options`
    /// instance to use.
    internal init(
        cValue odbBackendLooseOptions: git_odb_backend_loose_options
    )
    {
        self.version    = odbBackendLooseOptions.version
        self.oidType    = GitOIDT(cValue: odbBackendLooseOptions.oid_type) ?? .gitOIDSHA1
    }
    
    
    
    /// Converts the ``GitODBBackendLooseOptions`` instance into a
    /// `git_odb_backend_loose_options` instance.
    /// - Returns: The `git_odb_backend_loose_options` instance.
    internal func cValue() -> git_odb_backend_loose_options
    {
        var odbBackendLooseOptions = git_odb_backend_loose_options()
        
        odbBackendLooseOptions.version      = version
        odbBackendLooseOptions.oid_type     = oidType.cValue()
        
        return odbBackendLooseOptions
    }
}



/// A stream to read and write from an object database backend.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_odb_stream` instead.
///
/// ## C Equivalent
///
/// [`git_odb_stream`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_stream.html)
public struct GitODBStream: CStruct
{
    /// The object database backend.
    public let backend          : UnsafeMutablePointer<git_odb_backend>
    
    /// The file mode and object type (regular file, symbolic link, or Gitlink).
    public let mode             : UInt32
    
    /// The hash context.
    public let hashCtx          : UnsafeMutableRawPointer?
    
    /// The declared object size.
    public let declaredSize     : GitObjectSizeT
    
    /// The total number of received bytes.
    public let receivedBytes    : GitObjectSizeT
    
    /// Writes at most the specified number of bytes into the given buffer,
    /// and advances the stream.
    public let read             : GitODBStream.Read?
    
    /// Writes the specified number of bytes into the given buffer.
    public let write            : GitODBStream.Write?
    
    /// Stores the contents of the stream as an object with the given ID.
    ///
    /// ## Discussion
    ///
    /// This method might not be invoked if any of the following are true:
    ///
    /// - An error occured in an earlier ``write`` callback.
    /// - The object referred to by the given ID already exists in any backend.
    /// - The final number of received bytes is different from the declared
    /// size of the object.
    public let finalizeWrite    : GitODBStream.FinalizeWrite?
    
    /// Frees the memory allocated for the given `git_odb_stream` instance.
    ///
    /// ## Discussion
    ///
    /// This method may be called without previously invoking ``finalizeWrite``
    /// if an error occurs, or if the object is alreaedy present in the object
    /// database.
    public let free             : GitODBStream.Free?
    
    
    
    /// Initializes a ``GitODBStream`` instance from the given `git_odb_stream`
    /// instance.
    /// - Parameter odbStream: The `git_odb_stream` instance to use.
    internal init(
        cValue odbStream: git_odb_stream
    )
    {
        self.backend        = odbStream.backend
        self.mode           = odbStream.mode
        self.hashCtx        = odbStream.hash_ctx
        self.declaredSize   = odbStream.declared_size
        self.receivedBytes  = odbStream.received_bytes
        self.read           = odbStream.read
        self.write          = odbStream.write
        self.finalizeWrite  = odbStream.finalize_write
        self.free           = odbStream.free
    }
    
    
    
    /// The callback invoked to read from the given stream.
    /// - Parameters:
    ///   - stream: The stream from which to read.
    ///   - buffer: The buffer to which to write.
    ///   - len: The number of bytes to write into `buffer`.
    /// - Returns: `0` on success, or an error code.
    public typealias Read = @convention(c)
    (
        UnsafeMutablePointer<git_odb_stream>?,
        UnsafeMutablePointer<CChar>?,
        Int
    ) -> Int32
    
    
    
    /// The callback invoked to write to the given stream.
    /// - Parameters:
    ///   - stream: The stream to which to write.
    ///   - buffer: The buffer to write.
    ///   - len: The length of `buffer`.
    /// - Returns: `0` on success, or an error code.
    public typealias Write = @convention(c)
    (
        UnsafeMutablePointer<git_odb_stream>?,
        UnsafePointer<CChar>?,
        Int
    ) -> Int32
    
    
    
    /// The callback invoked to store the contents of the given stream as an
    /// object with the given ID.
    /// - Parameters:
    ///   - stream: The stream containing the contents to store.
    ///   - oid: The ID with which to store the contents of the given stream.
    /// - Returns: `0` on success, or an error code.
    public typealias FinalizeWrite = @convention(c)
    (
        UnsafeMutablePointer<git_odb_stream>?,
        UnsafePointer<git_oid>?,
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_odb_stream` instance.
    /// - Parameter stream: The stream to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_odb_stream>?
    ) -> Void
}



/// A stream to write a packfile to the object database.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_odb_writepack` instead.
///
/// ## C Equivalent
///
/// [`git_odb_writepack`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_writepack.html)
public struct GitODBWritePack: CStruct
{
    /// The object database backend.
    public let backend  : UnsafeMutablePointer<git_odb_backend>
    
    /// Appends data to the packfile.
    public let append   : GitODBWritePack.Append?
    
    /// Commits the packfile to the object database.
    public let commit   : GitODBWritePack.Commit?
    
    /// Frees the memory allocated for the given `git_odb_writepack` instance.
    public let free     : GitODBWritePack.Free?
    
    
    
    /// Initializes a ``GitODBWritePack`` instance from the given
    /// `git_odb_writepack` instance.
    /// - Parameter odbWritePack: The `git_odb_writepack` instance to use.
    internal init(
        cValue odbWritePack: git_odb_writepack
    )
    {
        self.backend    = odbWritePack.backend
        self.append     = odbWritePack.append
        self.commit     = odbWritePack.commit
        self.free       = odbWritePack.free
    }
    
    
    
    /// The callback invoked to append data to the packfile.
    /// - Parameters:
    ///   - writepack: The writepack to use.
    ///   - data: The data to append.
    ///   - len: The length of `data`.
    ///   - stats: The information about the progress of indexing the packfile.
    /// - Returns: `0` on success, or an error code.
    public typealias Append = @convention(c)
    (
        UnsafeMutablePointer<git_odb_writepack>?,
        UnsafeRawPointer?,
        Int,
        UnsafeMutablePointer<git_indexer_progress>?
    ) -> Int32
    
    
    
    /// The callback invoked to commit the packfile to the object database.
    /// - Parameters:
    ///   - writepack: The writepack to use.
    ///   - stats: The information about the progress of indexing the packfile.
    /// - Returns: `0` on success, or an error code.
    public typealias Commit = @convention(c)
    (
        UnsafeMutablePointer<git_odb_writepack>?,
        UnsafeMutablePointer<git_indexer_progress>?,
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_odb_writepack` instance.
    /// - Parameter writepack: The writepack to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_odb_writepack>?
    ) -> Void
}
