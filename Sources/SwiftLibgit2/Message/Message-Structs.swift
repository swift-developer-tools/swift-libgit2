//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A message trailer.
///
/// ## C Equivalent
///
/// [`git_message_trailer`](https://libgit2.org/docs/reference/main/message/git_message_trailer.html)
public struct GitMessageTrailer: CStructReadable, WithCConvertible
{
    /// The message trailer key.
    public let key      : String?
    
    /// The message trailer value.
    public let value    : String?
    
    
    
    /// Initializes a ``GitMessageTrailer`` instance from the given
    /// `git_message_trailer` instance.
    /// - Parameter messageTrailer: The `git_message_trailer` instance to use.
    internal init(
        cValue messageTrailer: git_message_trailer
    )
    {
        self.key    = String(optionalCString: messageTrailer.key)
        self.value  = String(optionalCString: messageTrailer.value)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_message_trailer` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_message_trailer>) throws -> T
    ) rethrows -> T
    {
        var messageTrailer = git_message_trailer()
        
        return try key.withOptionalCString
        {
            cKey in
            
            messageTrailer.key = cKey
            
            return try value.withOptionalCString
            {
                cValue in
                
                messageTrailer.value = cValue
                
                return try body(&messageTrailer)
            }
        }
    }
}



/// An array of message trailers.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All bindings use an array of ``GitMessageTrailer``
/// instances instead.
///
/// ## C Equivalent
///
/// [`git_message_trailer_array`](https://libgit2.org/docs/reference/main/message/git_message_trailer_array.html)
public struct GitMessageTrailerArray: CStruct
{
    /// The array of message trailers.
    public let trailers         : [GitMessageTrailer]
    
    /// The length of ``trailers``.
    public var count            : Int
    {
        return trailers.count
    }
    
    /// The trailer block.
    ///
    /// ## Discussion
    ///
    /// This is intended to be a private libgit2 field and should not be
    /// used by callers.
    private let trailerBlock    : String?
    
    
    
    /// Initializes a ``GitMessageTrailerArray`` instance from the given
    /// `git_message_trailer_array` instance.
    /// - Parameter messageTrailerArray: The `git_message_trailer_array`
    /// instance to use.
    internal init(
        cValue messageTrailerArray: git_message_trailer_array
    )
    {
        self.trailers       = Array(messageTrailerArray)
        self.trailerBlock   = String(optionalCString: messageTrailerArray._trailer_block)
        
    }
}
