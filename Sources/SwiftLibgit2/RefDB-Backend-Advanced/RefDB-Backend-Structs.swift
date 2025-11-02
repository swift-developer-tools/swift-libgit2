//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A backend reference iterator.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_reference_iterator` instead.
///
/// ## C Equivalent
///
/// [`git_reference_iterator`](https://libgit2.org/docs/reference/main/sys/refdb_backend/git_reference_iterator.html)
public struct GitReferenceIterator: CStruct
{
    /// The reference database. The underlying type must be `git_refdb`.
    public let db       : OpaquePointer?
    
    /// Gets the next reference from the given reference iterator.
    public let next     : GitReferenceIterator.Next?
    
    /// Gets the next reference name from the given reference iterator.
    public let nextName : GitReferenceIterator.NextName?
    
    /// Frees the memory allocated for the given `git_reference_iterator`
    /// instance.
    public let free     : GitReferenceIterator.Free?
    
    
    
    /// Initializes a ``GitReferenceIterator`` instance from the given
    /// `git_reference_iterator` instance.
    /// - Parameter referenceIterator: The `git_reference_iterator` instance
    /// to use.
    internal init(
        cValue referenceIterator: git_reference_iterator
    )
    {
        self.db         = referenceIterator.db
        self.next       = referenceIterator.next
        self.nextName   = referenceIterator.next_name
        self.free       = referenceIterator.free
    }
    
    
    
    /// The callback invoked to get the next reference from the given
    /// reference iterator.
    /// - Parameters:
    ///   - ref: The pointer in which to store the reference. The underlying
    ///   type must be `git_reference`.
    ///   - iter: The reference iterator to use.
    /// - Returns: `0` on success, or an error code.
    public typealias Next = @convention(c)
    (
        UnsafeMutablePointer<OpaquePointer?>?,
        UnsafeMutablePointer<git_reference_iterator>?
    ) -> Int32
    
    
    
    /// The callback invoked to get the next reference name from the given
    /// reference iterator.
    /// - Parameters:
    ///   - ref: The pointer in which to store the reference name. The
    ///   underlying type must be `git_reference`.
    ///   - iter: The reference iterator to use.
    /// - Returns: `0` on success, or an error code.
    public typealias NextName = @convention(c)
    (
        UnsafeMutablePointer<UnsafePointer<CChar>?>?,
        UnsafeMutablePointer<git_reference_iterator>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_reference_iterator` instance.
    /// - Parameter iter: The reference iterator to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_reference_iterator>?
    ) -> Void
}



/// A custom reference database backend.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_refdb_backend` instead.
///
/// ## C Equivalent
///
/// [`git_refdb_backend`](https://libgit2.org/docs/reference/main/sys/refdb_backend/git_refdb_backend.html)
public struct GitRefDBBackend: CStruct, Sendable
{

    /// The struct version.
    public let version      : UInt32
    
    /// Checks whether the specified reference can be found in the given
    /// reference database backend.
    public let exists       : GitRefDBBackend.Exists?
    
    /// Gets the specified reference from the given reference database backend.
    public let lookup       : GitRefDBBackend.Lookup?
    
    /// Creates a reference iterator for the given reference database backend.
    public let iterator     : GitRefDBBackend.Iterator?
    
    /// Writes the given reference to the given reference database backend.
    public let write        : GitRefDBBackend.Write?
    
    /// Renames the specified reference the given reference database backend.
    public let rename       : GitRefDBBackend.Rename?
    
    /// Deletes the specified reference the given reference database backend.
    public let del          : GitRefDBBackend.Del?
    
    /// Suggests that the given reference database backend compress or optimize
    /// its references.
    public let compress     : GitRefDBBackend.Compress?
    
    /// Checks whether the specified reference has a log in the given
    /// reference database backend.
    public let hasLog       : GitRefDBBackend.HasLog?
    
    /// Ensures that the specified reference has a reflog in the given
    /// reference database backend.
    public let ensureLog    : GitRefDBBackend.EnsureLog?
    
    /// Frees the memory allocated for the given `git_refdb_backend` instance.
    public let free         : GitRefDBBackend.Free?
    
    /// Reads the reflog of the specified reference in the given reference
    /// database backend.
    public let reflogRead   : GitRefDBBackend.ReflogRead?
    
    /// Writes the given reflog to the given reference database backend.
    public let reflogWrite  : GitRefDBBackend.ReflogWrite?
    
    /// Renames the reflog of the given reference database backend.
    public let reflogRename : GitRefDBBackend.ReflogRename?
    
    /// Deletes the reflog of the given reference database backend.
    public let reflogDelete : GitRefDBBackend.ReflogDelete?
    
    /// Locks the specified reference in the given reference database backend.
    public let lock         : GitRefDBBackend.Lock?
    
    /// Unlocks the specified reference in the given reference database backend.
    public let unlock       : GitRefDBBackend.Unlock?
    
    
    
    /// Initializes a ``GitRefDBBackend`` instance from the given
    /// `git_refdb_backend` instance.
    /// - Parameter referenceIterator: The `git_refdb_backend` instance
    /// to use.
    internal init(
        cValue refDBBackend: git_refdb_backend
    )
    {
        self.version        = refDBBackend.version
        self.exists         = refDBBackend.exists
        self.lookup         = refDBBackend.lookup
        self.iterator       = refDBBackend.iterator
        self.write          = refDBBackend.write
        self.rename         = refDBBackend.rename
        self.del            = refDBBackend.del
        self.compress       = refDBBackend.compress
        self.hasLog         = refDBBackend.has_log
        self.ensureLog      = refDBBackend.ensure_log
        self.free           = refDBBackend.free
        self.reflogRead     = refDBBackend.reflog_read
        self.reflogWrite    = refDBBackend.reflog_write
        self.reflogRename   = refDBBackend.reflog_rename
        self.reflogDelete   = refDBBackend.reflog_delete
        self.lock           = refDBBackend.lock
        self.unlock         = refDBBackend.unlock
    }
    
    
    
    /// The callback invoked to check whether the specified reference can be
    /// found in the given reference database backend.
    /// - Parameters:
    ///   - exists: The pointer in which to store whether the specified
    ///   reference can be found in the given reference database backend.
    ///   - backend: The reference database backend to search.
    ///   - refName: The name of the reference for which to search.
    /// - Returns: `0` on success, or an error code.
    public typealias Exists = @convention(c)
    (
        UnsafeMutablePointer<Int32>?,
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to get the specified reference from the given
    /// reference database backend.
    /// - Parameters:
    ///   - out: The pointer in which to store the reference. The underlying
    ///   type must be `git_reference`.
    ///   - backend: The reference database backend to search.
    ///   - refName: The name of the reference for which to search.
    /// - Returns: `0` on success, or an error code.
    public typealias Lookup = @convention(c)
    (
        UnsafeMutablePointer<OpaquePointer?>?,
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to create a reference iterator for the given
    /// reference database backend.
    /// - Parameters:
    ///   - out: The pointer in which to store the reference iterator.
    ///   - backend: The reference database backend to iterate.
    ///   - glob: The pattern to use to filter references.
    /// - Returns: `0` on success, or an error code.
    public typealias Iterator = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_reference_iterator>?>?,
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to write the given reference to the given
    /// reference database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to update.
    ///   - ref: The reference to write. The underlying type must be
    ///   `git_reference`.
    ///   - force: Whether to overwrite an existing reference.
    ///   - who: The actor signature to use.
    ///   - message: The reflog message to use.
    ///   - old: The old reference ID to use.
    ///   - oldTarget: The name of the old target reference to use. This will
    ///   be checked for validity.
    /// - Returns: `0` on success, or an error code.
    ///
    /// ## Discussion
    ///
    /// If `old` is not `nil` and `force` is `false`, then the new reference
    /// value will be written only if the reference is at the given `old` ID.
    ///
    /// If `oldTarget` is not `nil` and `force` is `false`, then the new
    /// reference value will be written only if the symbolic reference is
    /// at the given `oldTarget`.
    ///
    /// If both `old` and `oldTarget` are `nil`, then the reference must not
    /// exist at the point of writing.
    public typealias Write = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        OpaquePointer?,
        Int32,
        UnsafePointer<git_signature>?,
        UnsafePointer<CChar>?,
        UnsafePointer<git_oid>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to rename the specified reference the given
    /// reference database backend.
    /// - Parameters:
    ///   - out: The pointer in which to store the reference. The underlying
    ///   type must be `git_reference`.
    ///   - backend: The reference database backend to update.
    ///   - oldName: The name of the reference to rename. This will be checked
    ///   for validity.
    ///   - newName: The new reference name to use. This will be checked for
    ///   validity.
    ///   - force: Whether to overwrite an existing reference.
    ///   - who: The actor signature to use.
    ///   - message: The reflog message to use.
    /// - Returns: `0` on success, or an error code.
    public typealias Rename = @convention(c)
    (
        UnsafeMutablePointer<OpaquePointer?>?,
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?,
        Int32,
        UnsafePointer<git_signature>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to delete the specified reference the given
    /// reference database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to update.
    ///   - refName: The name of the reference to delete. This will be checked
    ///   for validity.
    ///   - oldID: The old reference ID to use.
    ///   - oldTarget: The name of the old target reference to use. This will
    ///   be checked for validity.
    /// - Returns: `0` on success, or an error code.
    ///
    /// ## Discussion
    ///
    /// If `oldID` is not `nil` and `force` is `false`, then the new reference
    /// value will be deleted only if the reference is at the given `oldID`.
    ///
    /// If `oldTarget` is not `nil` and `force` is `false`, then the new
    /// reference value will be deleted only if the symbolic reference is
    /// at the given `oldTarget`.
    ///
    /// If both `oldID` and `oldTarget` are `nil`, then the reference must not
    /// exist at the point of deletion.
    public typealias Del = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?,
        UnsafePointer<git_oid>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to suggest that the given reference database
    /// backend compress or optimize its references.
    /// - Parameter backend: The reference database backend to update.
    /// - Returns: `0` on success, or an error code.
    ///
    /// ## Discussion
    ///
    /// This is implementation-specific. It may pack all loose references for
    /// on-disk reference databases.
    public typealias Compress = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?
    ) -> Int32
    
    
    
    /// The callback invoked to check whether the specified reference has a
    /// reflog in the given reference database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to search.
    ///   - refName: The name of the reference to check. This will be checked
    ///   for validity.
    /// - Returns: Whether the specified reference has a log in the given
    /// reference database backend, or an error code.
    public typealias HasLog = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to ensure that the specified reference has a
    /// reflog in the given reference database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to search.
    ///   - refName: The name of the reference to check. This will be checked
    ///   for validity.
    /// - Returns: `0` on success, or an error code.
    public typealias EnsureLog = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_refdb_backend` instance.
    /// - Parameter iter: The reference database backend to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?
    ) -> Void
    
    
    
    /// The callback invoked to read the reflog of the specified reference in
    /// the given reference database backend.
    /// - Parameters:
    ///   - out: The pointer in which to store the reflog. The underlying type
    ///   must be `git_reflog`.
    ///   - backend: The reference database backend to search.
    ///   - refName: The name of the reference to use. This will be checked
    ///   for validity.
    /// - Returns: `0` on success, or an error code.
    public typealias ReflogRead = @convention(c)
    (
        UnsafeMutablePointer<OpaquePointer?>?,
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to write the given reflog to the given reference
    /// database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to update.
    ///   - reflog: The reflog to write. The underlying type must be
    ///   `git_reflog`. This may contain entries that have already been written
    ///   to the disk.
    /// - Returns: `0` on success, or an error code.
    public typealias ReflogWrite = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        OpaquePointer?
    ) -> Int32
    
    
    
    /// The callback invoked to rename the reflog of the given reference
    /// database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to update.
    ///   - oldName: The name of the reflog to rename. This will be checked
    ///   for validity.
    ///   - newName: The new reflog name to use. This will be checked for
    ///   validity.
    /// - Returns: `0` on success, or an error code.
    public typealias ReflogRename = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to delete the reflog of the given reference
    /// database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to update.
    ///   - name: The name of the reflog to delete. This will be checked for
    ///   validity.
    /// - Returns: `0` on success, or an error code.
    public typealias ReflogDelete = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to lock the specified reference in the given
    /// reference database backend.
    /// - Parameters:
    ///   - payloadOut: The pointer in which to store the payload to pass to
    ///   ``Unlock``.
    ///   - backend: The reference database backend to update.
    ///   - refName: The name of the reflog to lock. This will be checked for
    ///   validity.
    /// - Returns: `0` on success, or an error code.
    public typealias Lock = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to unlock the specified reference in the given
    /// reference database backend.
    /// - Parameters:
    ///   - backend: The reference database backend to update.
    ///   - payload: The payload returned by ``Lock``.
    ///   - success: `1` if the reference should be updated, `2` if it should
    ///   be deleted, or `0` if the lock should be discarded.
    ///   - updateReflog: Whether to update the reflog.
    ///   - ref: The reference to unlock. The underlying type must be
    ///   `git_reference`.
    ///   - who: The actor signature to use.
    ///   - message: The reflog message to use.
    /// - Returns: `0` on success, or an error code.
    public typealias Unlock = @convention(c)
    (
        UnsafeMutablePointer<git_refdb_backend>?,
        UnsafeMutableRawPointer?,
        Int32,
        Int32,
        OpaquePointer?,
        UnsafePointer<git_signature>?,
        UnsafePointer<CChar>?
    ) -> Int32
}
