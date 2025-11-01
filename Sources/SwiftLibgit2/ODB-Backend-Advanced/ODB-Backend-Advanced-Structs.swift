//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A custom object database backend.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_odb_backend` instead.
///
/// ## C Equivalent
///
/// [`git_odb_backend`](https://libgit2.org/docs/reference/main/sys/odb_backend/git_odb_backend.html)
public struct GitODBBackend: CStruct
{
    /// The struct version.
    public let version      : UInt32
    
    /// The object database. The underlying type must be `git_odb`.
    public let odb          : OpaquePointer?
    
    /// Reads the specified object from the given object database backend.
    public let read         : GitODBBackend.Read?
    
    /// Reads the specified object from the given object database backend,
    /// using a prefix of the object's ID.
    public let readPrefix   : GitODBBackend.ReadPrefix?
    
    /// Reads the header of the specified object from the given object database
    /// backend, without reading its full contents.
    public let readHeader   : GitODBBackend.ReadHeader?
    
    /// Writes the specified object to the given object database backend.
    public let write        : GitODBBackend.Write?
    
    /// Opens a stream to write an object to the given object database backend.
    public let writestream  : GitODBBackend.Writestream?
    
    /// Opens a stream to read the specified object from the given object
    /// database backend.
    public let readstream   : GitODBBackend.Readstream?
    
    /// Checks whether the specified object can be found in the given object
    /// database backend.
    public let exists       : GitODBBackend.Exists?
    
    /// Checks whether the specified object can be found in the given object
    /// database backend, using a prefix of the object's ID.
    public let existsPrefix : GitODBBackend.ExistsPrefix?
    
    /// Refreshes the given object database backend to load newly added files.
    public let refresh      : GitODBBackend.Refresh?
    
    /// Loops over all objects available in the given object database backend.
    public let forEach      : GitODBBackend.ForEach?
    
    /// Opens a stream for writing a packfile to the given object database
    /// backend.
    public let writePack    : GitODBBackend.WritePack?
    
    /// Opens a stream for writing a multi-index packfile to the given object
    /// database backend.
    public let writeMidx    : GitODBBackend.WriteMidx?
    
    /// Updates the last-used time of the specified object in the given object
    /// database backend.
    public let freshen      : GitODBBackend.Freshen?
    
    /// Frees the memory allocated for the given `git_odb_backend` instance.
    public let free         : GitODBBackend.Free?
    
    
    
    /// Initializes a ``GitODBBackend`` instance from the given `git_odb_backend`
    /// instance.
    /// - Parameter backend: The `git_odb_backend` instance to use.
    internal init(
        cValue backend: git_odb_backend
    )
    {
        self.version        = backend.version
        self.odb            = backend.odb
        self.read           = backend.read
        self.readPrefix     = backend.read_prefix
        self.readHeader     = backend.read_header
        self.write          = backend.write
        self.writestream    = backend.writestream
        self.readstream     = backend.readstream
        self.exists         = backend.exists
        self.existsPrefix   = backend.exists_prefix
        self.refresh        = backend.refresh
        self.forEach        = backend.foreach
        self.writePack      = backend.writepack
        self.writeMidx      = backend.writemidx
        self.freshen        = backend.freshen
        self.free           = backend.free
    }
    
    
    
    /// The callback invoked to read the specified object from the given
    /// object database backend.
    /// - Parameters:
    ///   - buffer: The pointer in which to store the object data. This must
    ///   be allocated using ``gitODBBackendDataAlloc(backend:len:)``.
    ///   - size: The pointer in which to store the size of the object data.
    ///   - type: The pointer in which to store the type of the object.
    ///   - backend: The object database backend from which to read the object.
    ///   - id: The ID of the object to read.
    /// - Returns: `0` on success, or an error code.
    public typealias Read = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafeMutablePointer<Int>?,
        UnsafeMutablePointer<git_object_t>?,
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?
    ) -> Int32
    
    
    
    /// The callback invoked to read the specified object from the given
    /// object database backend, using a prefix of the object's ID.
    /// - Parameters:
    ///   - idOut: The pointer in which to store the full object ID.
    ///   - buffer: The pointer in which to store the object data. This must
    ///   be allocated using ``gitODBBackendDataAlloc(backend:len:)``.
    ///   - size: The pointer in which to store the size of the object data.
    ///   - type: The pointer in which to store the type of the object.
    ///   - backend: The object database backend from which to read the object.
    ///   - id: The prefix of the ID of the object to read.
    ///   - len: The length of the objects's ID prefix. This must be greater
    ///   than or equal to ``gitOIDMinPrefixLen``, and long enough to identify
    ///   a unique object matching the prefix.
    /// - Returns: `0` on success, or an error code.
    public typealias ReadPrefix = @convention(c)
    (
        UnsafeMutablePointer<git_oid>?,
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafeMutablePointer<Int>?,
        UnsafeMutablePointer<git_object_t>?,
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?,
        Int
    ) -> Int32
    
    
    
    /// The callback invoked to read the header of the specified object from
    /// the given object database backend, without reading its full contents.
    /// - Parameters:
    ///   - lenOut: The pointer in which to store the object size.
    ///   - type: The pointer in which to store the object type.
    ///   - backend: The object database backend from which to read the object.
    ///   - id: The prefix of the ID of the object to read.
    /// - Returns: `0` on success, or an error code.
    public typealias ReadHeader = @convention(c)
    (
        UnsafeMutablePointer<Int>?,
        UnsafeMutablePointer<git_object_t>?,
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?
    ) -> Int32
    
    
    
    /// The callback invoked to write the specified object to the given object
    /// database backend.
    /// - Parameters:
    ///   - backend: The object database backend to update.
    ///   - id: The ID of the object to write.
    ///   - data: The object data to write.
    ///   - len: The length of `data`.
    ///   - type: The type of object to write.
    /// - Returns: `0` on success, or an error code.
    public typealias Write = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?,
        UnsafeRawPointer?,
        Int,
        git_object_t
    ) -> Int32
    
    
    
    /// The callback invoked to open a stream to write an object to the given
    /// object database backend.
    /// - Parameters:
    ///   - stream: The pointer in which to store the stream.
    ///   - backend: The object database backend to update.
    ///   - size: The size of the object to write.
    ///   - type: The type of the object to write.
    /// - Returns: `0` on success, or an error code.
    public typealias Writestream = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_odb_stream>?>?,
        UnsafeMutablePointer<git_odb_backend>?,
        git_object_size_t,
        git_object_t
    ) -> Int32
    
    
    
    /// The callback invoked to open a stream to read the specified object
    /// from the given object database backend.
    /// - Parameters:
    ///   - stream: The pointer in which to store the stream.
    ///   - size: The pointer in which to store the size of the object.
    ///   - type: The pointer in which to store the type of the object.
    ///   - backend: The object database backend from which to read.
    ///   - id: The ID of the object to read.
    /// - Returns: `0` on success, or an error code.
    public typealias Readstream = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_odb_stream>?>?,
        UnsafeMutablePointer<Int>?,
        UnsafeMutablePointer<git_object_t>?,
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?
    ) -> Int32
    
    
    
    /// The callback invoked to check whether the specified object can be
    /// found in the given object database backend.
    /// - Parameters:
    ///   - backend: The object database backend to search.
    ///   - id: The ID of the object for which to search.
    /// - Returns: Whether the specified object can be found in the given
    /// object database backend, or an error code.
    public typealias Exists = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?
    ) -> Int32
    
    
    
    /// The callback invoked to check whether the specified object can be
    /// found in the given object database backend, using a prefix of the
    /// object's ID.
    /// - Parameters:
    ///   - idOut: The pointer in which to store the full object ID.
    ///   - backend: The object database backend to search.
    ///   - id: The prefix of the ID of the object to read.
    ///   - len: The length of the objects's ID prefix. This must be greater
    ///   than or equal to ``gitOIDMinPrefixLen``, and long enough to identify
    ///   a unique object matching the prefix.
    /// - Returns: Whether the specified object can be found in the given
    /// object database backend, or an error code.
    public typealias ExistsPrefix = @convention(c)
    (
        UnsafeMutablePointer<git_oid>?,
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?,
        Int
    ) -> Int32
    
    
    
    /// The callback invoked to refresh the given object database backend to
    /// load newly added files.
    /// - Parameter backend: The object database backend to refresh.
    /// - Returns: `0` on success, or an error code.
    ///
    /// ## Discussion
    ///
    /// The object database layer will automatically invoke this callback when
    /// needed on failed lookups.
    public typealias Refresh = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?
    ) -> Int32
    
    
    
    /// The callback invoked to loop over all objects available in the given
    /// object database backend.
    /// - Parameters:
    ///   - backend: The object database backend to search.
    ///   - forEachCB: The ``GitODBForEachCB`` callback to invoke for each
    ///   object.
    ///   - payload: The payload to pass to `forEachCB`.
    /// - Returns: `0` on success, or an error code.
    public typealias ForEach = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?,
        GitODBForEachCB?,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    
    
    /// The callback invoked to open a stream for writing a packfile to the
    /// given object database backend.
    /// - Parameters:
    ///   - writepack: The pointer in which to store the writepack functions.
    ///   - backend: The object database backend from which to read.
    ///   - odb: The object database from which to read.
    ///   - progressCB: The ``GitIndexerProgressCB`` callback to invoke to
    ///   report indexing progress.
    ///   - payload: The payload to pass to `progressCB`.
    /// - Returns: `0` on success, or an error code.
    public typealias WritePack = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_odb_writepack>?>?,
        UnsafeMutablePointer<git_odb_backend>?,
        OpaquePointer?,
        GitIndexerProgressCB?,
        UnsafeMutableRawPointer?
    ) -> Int32
    
    
    
    /// The callback invoked to open a stream for writing a multi-index
    /// packfile to the given object database backend.
    /// - Parameter backend: The object database backend from which to read.
    /// - Returns: `0` on success, or an error code.
    public typealias WriteMidx = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?
    ) -> Int32
    
    
    
    /// The callback invoked to update the last-used time of the specified
    /// object in the given object database backend.
    /// - Parameters:
    ///   - backend: The object database backend to to update.
    ///   - id: The ID of the object to freshen.
    /// - Returns: `0` on success, or an error code.
    ///
    /// ## Discussion
    ///
    /// The last-used time of an object occurs when
    /// ``gitODBWrite(out:odb:data:len:type:)`` is called, but the specified
    /// object already exists and will not be rewritten.
    ///
    /// The underlying implementation may need to update the last-used
    /// timestamps.
    public typealias Freshen = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?,
        UnsafePointer<git_oid>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_odb_backend` instance.
    /// - Parameter ptr: The object database backend to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_odb_backend>?
    ) -> Void
}
