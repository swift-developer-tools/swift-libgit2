//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// An entry in a backend configuration file.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use ``GitConfigEntry`` instead.
///
/// ## C Equivalent
///
/// [`git_config_backend_entry`](https://libgit2.org/docs/reference/main/sys/config/git_config_backend_entry.html)
public struct GitConfigBackendEntry: CStruct, Sendable
{
    /// Allocates memory for the given number of bytes.
    public let entry    : GitConfigEntry
    
    /// Frees the memory allocated for the given `git_config_backend_entry`
    /// instance.
    public let free     : GitConfigBackendEntry.Free?
    
    
    
    /// Initializes a ``GitConfigBackendEntry`` instance from the given
    /// `git_config_backend_entry` instance.
    /// - Parameter configBackendEntry: The `git_config_backend_entry` instance
    /// to use.
    internal init(
        cValue configBackendEntry: git_config_backend_entry
    )
    {
        self.entry  = GitConfigEntry(cValue: configBackendEntry.entry)
        self.free   = configBackendEntry.free
    }
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_config_backend_entry` instance.
    /// - Parameter entry: The configuration backend entry to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend_entry>?
    ) -> Void
}



/// A configuration iterator.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_config_iterator` instead.
///
/// ## C Equivalent
///
/// [`git_config_iterator`](https://libgit2.org/docs/reference/main/sys/config/git_config_iterator.html)
public struct GitConfigIterator: CStruct
{
    /// The configuration file.
    public let backend  : UnsafeMutablePointer<git_config_backend>?
    
    /// The flags controlling configuration iteration.
    public let flags    : UInt32
    
    /// Gets the next backend entry.
    public let next     : GitConfigIterator.Next?
    
    /// Frees the memory allocated for the iterator.
    public let free     : GitConfigIterator.Free?
    
    
    
    /// Initializes a ``GitConfigIterator`` instance from the given
    /// `git_config_iterator` instance.
    /// - Parameter configIterator: The `git_config_iterator` instance
    /// to use.
    internal init(
        cValue configIterator: git_config_iterator
    )
    {
        self.backend    = configIterator.backend
        self.flags      = configIterator.flags
        self.next       = configIterator.next
        self.free       = configIterator.free
    }
    
    
    
    /// The callback invoked to get the next backend entry.
    /// - Parameters:
    ///   - entry: The pointer in which to store the backend entry.
    ///   - iter: The iterator to use.
    /// - Returns: `0` on success, or an error code.
    public typealias Next = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_config_backend_entry>?>?,
        UnsafeMutablePointer<git_config_iterator>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_config_iterator` instance.
    /// - Parameter iter: The configuration iterator to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_config_iterator>?
    ) -> Void
}



/// A generic configuration backend.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_config_backend` instead.
///
/// ## C Equivalent
///
/// [`git_config_backend`](https://libgit2.org/docs/reference/main/sys/config/git_config_backend.html)
public struct GitConfigBackend: CStruct
{
    /// The struct version.
    public let version      : UInt32
    
    /// Whether the backend is for a snapshot.
    public let readOnly     : Bool
    
    /// The repository configuration.
    public let cfg          : OpaquePointer?
    
    /// Opens the backend at the given level.
    public let open         : GitConfigBackend.Open?
    
    /// Gets the specified configuration entry from the backend.
    public let get          : GitConfigBackend.Get?
    
    /// Sets a configuration entry in the backend.
    public let set          : GitConfigBackend.Set?
    
    /// Sets a multivar entry in the backend.
    public let setMultivar  : GitConfigBackend.SetMultivar?
    
    /// Deletes the specified configuration entry from the backend.
    public let del          : GitConfigBackend.Del?
    
    /// Deletes the specified multivar entry from the backend.
    public let delMultivar  : GitConfigBackend.DelMultivar?
    
    /// Creates an iterator for the backend.
    public let iterator     : GitConfigBackend.Iterator?
    
    /// Creates a read-only snapshot of the backend.
    public let snapshot     : GitConfigBackend.Snapshot?
    
    /// Locks the backend.
    public let lock         : GitConfigBackend.Lock?
    
    /// Unlocks the backend.
    public let unlock       : GitConfigBackend.Unlock?
    
    /// Frees the memory allocated for the backend.
    public let free         : GitConfigBackend.Free?
    
    
    
    /// Initializes a ``GitConfigBackend`` instance from the given
    /// `git_config_backend` instance.
    /// - Parameter configBackend: The `git_config_backend` instance
    /// to use.
    internal init(
        cValue configBackend: git_config_backend
    )
    {
        self.version        = configBackend.version
        self.readOnly       = Bool(configBackend.readonly)
        self.cfg            = configBackend.cfg
        self.open           = configBackend.open
        self.get            = configBackend.get
        self.set            = configBackend.set
        self.setMultivar    = configBackend.set_multivar
        self.del            = configBackend.del
        self.delMultivar    = configBackend.del_multivar
        self.iterator       = configBackend.iterator
        self.snapshot       = configBackend.snapshot
        self.lock           = configBackend.lock
        self.unlock         = configBackend.unlock
        self.free           = configBackend.free
    }
    
    
    
    /// The callback invoked to open the file at the given level.
    /// - Parameters:
    ///   - backend: The configuration file to open.
    ///   - level: The priority level of the configuration file.
    ///   - repo: The repository containing the configuration file. The
    ///   underlying type must be `git_repository`.
    /// - Returns: `0` on success, or an error code.
    public typealias Open = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        git_config_level_t,
        OpaquePointer?
    ) -> Int32
    
    
    
    /// The callback invoked to get the value of the specified configuration
    /// variable.
    /// - Parameters:
    ///   - backend: The configuration file to search.
    ///   - key: The key of the configuration variable.
    ///   - entry: The pointer in which to store the backend entry.
    /// - Returns: `0` on success, or an error code.
    public typealias Get = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        UnsafePointer<CChar>?,
        UnsafeMutablePointer<UnsafeMutablePointer<git_config_backend_entry>?>?
    ) -> Int32
    
    
    
    /// The callback invoked to set a configuration entry in the backend.
    /// - Parameters:
    ///   - backend: The configuration file to update.
    ///   - key: The key of the configuration variable.
    ///   - value: The value of the configuration variable.
    /// - Returns: `0` on success, or an error code.
    public typealias Set = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to set a multivar entry in the backend.
    /// - Parameters:
    ///   - backend: The configuration file to update.
    ///   - name: The name of the multivar entry.
    ///   - regExp: The regular expression used to match the configuration
    ///   names.
    ///   - value: The value to set.
    /// - Returns: `0` on success, or an error code.
    public typealias SetMultivar = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to delete the specified configuration entry from
    /// the backend.
    /// - Parameters:
    ///   - backend: The configuration file to update.
    ///   - key: The key of the configuration variable.
    /// - Returns: `0` on success, or an error code.
    public typealias Del = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to delete the specified multivar entry from the
    /// backend.
    /// - Parameters:
    ///   - backend: The configuration file to update.
    ///   - key: The key of the configuration variable.
    ///   - regExp: The regular expression used to match the configuration
    ///   names.
    /// - Returns: `0` on success, or an error code.
    public typealias DelMultivar = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        UnsafePointer<CChar>?,
        UnsafePointer<CChar>?
    ) -> Int32
    
    
    
    /// The callback invoked to create an iterator for the backend.
    /// - Parameters:
    ///   - iterator: The pointer in which to store the iterator.
    ///   - backend: The configuration file to iterate.
    /// - Returns: `0` on success, or an error code.
    public typealias Iterator = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_config_iterator>?>?,
        UnsafeMutablePointer<git_config_backend>?
    ) -> Int32
    
    
    
    /// The callback invoked to create a read-only snapshot of the backend.
    /// - Parameters:
    ///   - snapshot: The pointer in which to store the snapshot.
    ///   - backend: The configuration file to snapshot.
    /// - Returns: `0` on success, or an error code.
    public typealias Snapshot = @convention(c)
    (
        UnsafeMutablePointer<UnsafeMutablePointer<git_config_backend>?>?,
        UnsafeMutablePointer<git_config_backend>?
    ) -> Int32
    
    
    
    /// The callback invoked to lock the backend.
    /// - Parameter backend: The configuration file to lock.
    /// - Returns: `0` on success, or an error code.
    public typealias Lock = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?
    ) -> Int32
    
    
    
    /// The callback invoked to unlock the backend.
    /// - Parameters:
    ///   - backend: The configuration file to unlock.
    ///   - success: Whether to commit changes (`1`) or roll them back (`0`).
    /// - Returns: `0` on success, or an error code.
    public typealias Unlock = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?,
        Int32
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_config_backend` instance.
    /// - Parameter backend: The configuration file to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_config_backend>?
    ) -> Void
}



/// The options for in-memory configuration backends.
///
/// ## C Equivalent
///
/// [`git_config_backend_memory_options`](https://libgit2.org/docs/reference/main/sys/config/git_config_backend_memory_options.html)
public struct GitConfigBackendMemoryOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitConfigBackendMemoryOptionsVersion``.
    public var version      : UInt32
    
    /// The type of backend.
    ///
    /// ## Discussion
    ///
    /// The default value is `in-memory`.
    public var backendType  : String
    
    /// The path to the origin.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If this is `nil`, then it will be left unset in the configuration
    /// entries.
    public var originPath   : String?
    
    
    
    /// Initializes a ``GitConfigBackendMemoryOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version     : UInt32    = gitConfigBackendMemoryOptionsVersion,
        backendType : String    = "in-memory",
        originPath  : String?   = nil
    )
    {
        self.version        = version
        self.backendType    = backendType
        self.originPath     = originPath
    }
    
    
    
    /// Initializes a ``GitConfigBackendMemoryOptions`` instance from the given
    /// `git_config_backend_memory_options` instance.
    /// - Parameter configBackendMemoryOptions: The
    /// `git_config_backend_memory_options` instance to use.
    internal init(
        cValue configBackendMemoryOptions: git_config_backend_memory_options
    )
    {
        self.version        = configBackendMemoryOptions.version
        self.backendType    = String(optionalCString: configBackendMemoryOptions.backend_type) 
                                ?? "in-memory"
        self.originPath     = String(optionalCString: configBackendMemoryOptions.origin_path)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_config_backend_memory_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_config_backend_memory_options>) throws -> T
    ) rethrows -> T
    {
        var configBackendMemoryOptions = git_config_backend_memory_options()
        
        configBackendMemoryOptions.version = version
        
        return try backendType.withCString
        {
            cBackendType in
            
            configBackendMemoryOptions.backend_type = cBackendType
            
            return try originPath.withOptionalCString
            {
                cOriginPath in
                
                configBackendMemoryOptions.origin_path = cOriginPath
                
                return try body(&configBackendMemoryOptions)
            }
        }
    }
}
