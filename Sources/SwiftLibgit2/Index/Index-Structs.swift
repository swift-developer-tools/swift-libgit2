//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// The index entry timestamp.
///
/// ## C Equivalent
///
/// [`git_index_time`](https://libgit2.org/docs/reference/main/index/git_index_time.html)
public struct GitIndexTime: CStructMutable, CConvertible, Sendable
{
    /// The number of seconds since the UNIX epoch.
    ///
    /// The default value is `0`.
    public var seconds      : Int32
    
    /// The nanoseconds fraction of the timestamp.
    ///
    /// The default value is `0`.
    public var nanoseconds  : UInt32
    
    
    
    /// Initializes a ``GitIndexTime`` instance, optionally specifying values
    /// for its properties.
    public init(
        seconds     : Int32     = 0,
        nanoseconds : UInt32    = 0
    )
    {
        self.seconds        = seconds
        self.nanoseconds    = nanoseconds
    }
    
    
    
    /// Initializes a ``GitIndexTime`` instance from the given `git_index_time`
    /// instance.
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
public struct GitIndexEntry: CStructMutable, WithCConvertible, Sendable
{
    /// The last time the file's metadata changed.
    ///
    /// The default value is a default-initialized ``GitIndexTime`` instance.
    public var cTime            : GitIndexTime
    
    /// The last time the file's data changed.
    ///
    /// The default value is a default-initialized ``GitIndexTime`` instance.
    public var mTime            : GitIndexTime
    
    /// The device ID containing the file.
    ///
    /// The default value is `0`.
    public var dev              : UInt32
    
    /// The inode number of the file.
    ///
    /// The default value is `0`.
    public var ino              : UInt32
    
    /// The file mode and object type (regular file, symbolic link, or Gitlink).
    ///
    /// The default value is `0`.
    public var mode             : UInt32
    
    /// The user ID of the file owner.
    ///
    /// The default value is `0`.
    public var uid              : UInt32
    
    /// The group ID of the file owner.
    ///
    /// The default value is `0`.
    public var gid              : UInt32
    
    /// The on-disk file size.
    ///
    /// The default value is `0`.
    public var fileSize         : UInt32
    
    /// The ID of the Git object.
    ///
    /// The default value is `0`.
    public var id               : GitOID
    
    /// The flags for index entries.
    ///
    /// The default value is an empty option set.
    public var flags            : GitIndexEntryFlagT
    
    /// The flags for on-disk fields of the index entry.
    ///
    /// The default value is an empty option set.
    public var flagsExtended    : GitIndexEntryExtendedFlagT
    
    /// The entry path name, relative to the repository's root folder.
    ///
    /// The default value is an empty string.
    public  var path            : String
    
    
    
    /// Initializes a ``GitIndexEntry`` instance, optionally specifying
    /// values for its properties.
    public init(
        cTime           : GitIndexTime?                 = nil,
        mTime           : GitIndexTime?                 = nil,
        dev             : UInt32                        = 0,
        ino             : UInt32                        = 0,
        mode            : UInt32                        = 0,
        uid             : UInt32                        = 0,
        gid             : UInt32                        = 0,
        fileSize        : UInt32                        = 0,
        id              : GitOID                        = GitOID(),
        flags           : GitIndexEntryFlagT            = [],
        flagsExtended   : GitIndexEntryExtendedFlagT    = [],
        path            : String                        = ""
    )
    {
        let indexTime = GitIndexTime(cValue: git_index_time())
        
        self.cTime          = cTime ?? indexTime
        self.mTime          = mTime ?? indexTime
        self.dev            = dev
        self.ino            = ino
        self.mode           = mode
        self.uid            = uid
        self.gid            = gid
        self.fileSize       = fileSize
        self.id             = id
        self.flags          = flags
        self.flagsExtended  = flagsExtended
        self.path           = path
    }
    
    
    
    /// Initializes a ``GitIndexEntry`` instance from the given
    /// `git_index_entry` instance.
    ///
    /// The C enum members of ``GitIndexEntryFlagT`` and
    /// ``GitIndexEntryExtendedFlagT`` use a type of `UInt32`, but the `flags`
    /// and `flags_extended` fields of `git_index_entry` use `UInt16`. The
    /// values can be safely cast from `UInt16` to `UInt32`, since this is a
    /// widening conversion.
    ///
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
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_index_entry`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_index_entry>) throws -> T
    ) throws -> T
    {
        guard
            flags.rawValue <= UInt16.max,
            flagsExtended.rawValue <= UInt16.max
        else
        {
            throw NSError.makeCConversionError()
        }
        
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
        indexEntry.flags            = UInt16(flags.rawValue)
        indexEntry.flags_extended   = UInt16(flagsExtended.rawValue)
        
        return try path.withCString
        {
            cPath in
            
            indexEntry.path = cPath
            
            return try body(&indexEntry)
        }
    }
}
