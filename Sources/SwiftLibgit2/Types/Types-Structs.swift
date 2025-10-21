//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The time in a signature.
///
/// ## C Equivalent
///
/// [`git_time`](https://libgit2.org/docs/reference/main/types/git_time.html)
public struct GitTime: CStructReadable, CConvertible, Sendable
{
    /// The UNIX timestamp in seconds.
    public let time     : GitTimeT
    
    /// The timezone offset in minutes.
    public let offset   : Int32
    
    /// The indicator for questionable `-0000` offsets in the signature.
    public let sign     : CChar
    
    
    
    /// Initializes a ``GitTime`` instance from the given `git_time` instance.
    /// - Parameter time: The `git_time` instance to use.
    internal init(
        cValue time: git_time
    )
    {
        self.time       = time.time
        self.offset     = time.offset
        self.sign       = time.sign
    }
    
    
    
    /// Converts the ``GitTime`` instance into a `git_time` instance.
    /// - Returns: The `git_time` instance.
    internal func cValue() -> git_time
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
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_writestream` instead.
///
/// ## C Equivalent
///
/// [`git_writestream`](https://libgit2.org/docs/reference/main/types/git_writestream.html)
public struct GitWritestream: CStruct
{
    /// Writes to the stream.
    public let write    : Write?
    
    /// Closes the stream.
    public let close    : Close?
    
    /// Frees the memory allocated for the given `git_writestream` instance.
    public let free     : Free?
    
    
    
    /// Initializes a ``GitWritestream`` instance from the given
    /// `git_writestream` instance.
    /// - Parameter writeStream: The `git_writestream` instance to use.
    internal init(
        cValue writeStream: git_writestream
    )
    {
        self.write  = writeStream.write
        self.close  = writeStream.close
        self.free   = writeStream.free
    }
    
    
    
    /// The callback invoked to write to the given stream.
    /// - Parameters:
    ///   - stream: The stream to which to write.
    ///   - buffer: The buffer to write.
    ///   - len: The length of `buffer`.
    /// - Returns: `0` on success, or an error code.
    public typealias Write = @convention(c)
    (
        UnsafeMutablePointer<git_writestream>?,
        UnsafePointer<CChar>?,
        Int
    ) -> Int32
    
    
    
    /// The callback invoked to close the given stream.
    /// - Parameter stream: The stream to close.
    /// - Returns: `0` on success, or an error code.
    public typealias Close = @convention(c)
    (
        UnsafeMutablePointer<git_writestream>?
    ) -> Int32
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_writestream` instance.
    /// - Parameter stream: The stream to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_writestream>?
    ) -> Void
}
