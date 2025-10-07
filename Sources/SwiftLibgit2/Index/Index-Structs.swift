//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The index entry timestamp.
///
/// ## C Equivalent
///
/// [`git_index_time`](https://libgit2.org/docs/reference/main/index/git_index_time.html)
public struct GitIndexTime: GitStructMutable, CConvertible
{
    /// The number of seconds since the UNIX epoch.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var seconds      : Int32     = 0
    
    /// The nanoseconds fraction of the timestamp.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var nanoseconds  : UInt32    = 0
    
    
    
    /// Creates a ``GitIndexTime`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitIndexTime`` instance from a `git_index_time` instance.
    /// - Parameter indexTime: The `git_index_time` instance to use.
    internal init(
        cValue indexTime: git_index_time
    )
    {
        self.seconds        = indexTime.seconds
        self.nanoseconds    = indexTime.nanoseconds
    }
    
    
    
    /// Converts the ``GitIndexTime`` instance into a `git_index_time` instance.
    /// - Returns: The `git_index_time` instance.
    internal func cValue() -> git_index_time
    {
        var indexTime = git_index_time()
        
        indexTime.seconds       = seconds
        indexTime.nanoseconds   = nanoseconds
        
        return indexTime
    }
}



/// A signature for commits, tags, and other actions.
///
/// ## C Equivalent
///
/// [`git_index_entry`](https://libgit2.org/docs/reference/main/index/git_index_entry.html)
public struct GitIndexEntry: GitStructMutable, WithCConvertible
{
    /// The last time the file's metadata changed.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitIndexTime`` instance.
    public var cTime            : GitIndexTime                  = GitIndexTime(cValue: git_index_time())
    
    /// The last time the file's data changed.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitIndexTime`` instance.
    public var mTime            : GitIndexTime                  = GitIndexTime(cValue: git_index_time())
    
    /// The device ID containing the file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var dev              : UInt32                        = 0
    
    /// The inode number of the file.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var ino              : UInt32                        = 0
    
    /// The file mode and object type (regular file, symbolic link, or gitlink).
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mode             : UInt32                        = 0
    
    /// The user ID of the file owner.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var uid              : UInt32                        = 0
    
    /// The group ID of the file owner.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var gid              : UInt32                        = 0
    
    /// The on-disk file size.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var fileSize         : UInt32                        = 0
    
    /// The OID of the Git object.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var id               : GitOID                        = GitOID()
    
    /// The flags for index entries.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags            : GitIndexEntryFlagT            = []
    
    /// The flags for on-disk fields of an index entry.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flagsExtended    : GitIndexEntryExtendedFlagT    = []
    
    /// The entry path name, relative to the repository's root folder.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty string.
    public  var path            : String                        = ""
    
    
    
    /// Creates a ``GitIndexEntry`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitIndexEntry`` instance from a `git_index_entry` instance.
    /// - Parameter indexEntry: The `git_index_entry` instance to use.
    internal init(
        cValue indexEntry: git_index_entry
    )
    {
        self.cTime          = GitIndexTime(cValue: indexEntry.ctime)
        self.mTime          = GitIndexTime(cValue: indexEntry.mtime)
        self.dev            = indexEntry.dev
        self.ino            = indexEntry.ino
        self.mode           = indexEntry.mode
        self.uid            = indexEntry.uid
        self.gid            = indexEntry.gid
        self.fileSize       = indexEntry.file_size
        self.id             = GitOID(cValue: indexEntry.id)
        self.flags          = GitIndexEntryFlagT(rawValue: UInt32(indexEntry.flags))
        self.flagsExtended  = GitIndexEntryExtendedFlagT(rawValue: UInt32(indexEntry.flags_extended))
        self.path           = String(optionalCString: indexEntry.path) ?? ""
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_index_entry` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_index_entry>) throws -> T
    ) rethrows -> T
    {
        var indexEntry = git_index_entry()
        
        indexEntry.ctime            = cTime.cValue()
        indexEntry.mtime            = mTime.cValue()
        indexEntry.dev              = dev
        indexEntry.ino              = ino
        indexEntry.mode             = mode
        indexEntry.uid              = uid
        indexEntry.gid              = gid
        indexEntry.file_size        = fileSize
        indexEntry.id               = id.cValue()
        indexEntry.flags            = UInt16(flags.rawValue & 0xFFFF)
        indexEntry.flags_extended   = UInt16(flagsExtended.rawValue & 0xFFFF)
        
        return try path.withCString
        {
            cPath in
            
            indexEntry.path = cPath
            
            return try body(&indexEntry)
        }
    }
}
