//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The time in a signature.
///
/// ## C Equivalent
///
/// [`git_time`](https://libgit2.org/docs/reference/main/types/git_time.html)
public struct GitTime
{
    /// The UNIX timestamp in seconds.
    public let time     : GitTimeT
    
    /// The timezone offset in minutes.
    public let offset   : Int32
    
    /// The indicator for questionable `-0000` offsets in the signature.
    public let sign     : CChar
    
    
    
    /// Creates a ``GitTime`` instance from a `git_time` instance.
    /// - Parameter time: The `git_time` instance to use.
    internal init(
        cValue time: git_time
    )
    {
        self.time       = time.time
        self.offset     = time.offset
        self.sign       = time.sign
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_time
    {
        var cTime = git_time()
        
        cTime.time      = time
        cTime.offset    = offset
        cTime.sign      = sign
        
        return cTime
    }
}



/// A type to write in a streaming fashion.
///
/// ## Discussion
///
/// This struct is provided for documentation purposes, but is not used by other bindings.
///
/// `git_writestream` is treated as an opaque struct since its function pointers are
/// allocated and managed by libgit2, and cannot be meaningfully recreated or translated.
///
/// ## C Equivalent
///
/// [`git_writestream`](https://libgit2.org/docs/reference/main/types/git_writestream.html)
public struct GitWritestream
{
    /// The function to write to the stream.
    public let write: @convention(c)
    (
        UnsafeMutablePointer<git_writestream>?,
        UnsafePointer<CChar>?,
        Int
    ) -> Int32
    
    /// The function to close the stream.
    public let close: @convention(c)
    (
        UnsafeMutablePointer<git_writestream>?
    ) -> Int32
    
    /// The function to free the stream.
    public let free: @convention(c)
    (
        UnsafeMutablePointer<git_writestream>?
    ) -> Void
    
    
    
    /// Creates a ``GitWritestream`` instance from a `git_writestream` instance.
    /// - Parameter writeStream: The `git_writestream` instance to use.
    internal init(
        cValue writeStream: git_writestream
    )
    {
        self.write  = writeStream.write
        self.close  = writeStream.close
        self.free   = writeStream.free
    }
}
