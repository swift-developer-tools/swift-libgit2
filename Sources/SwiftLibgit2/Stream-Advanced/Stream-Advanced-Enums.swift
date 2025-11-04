//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The type of stream.
///
/// ## C Equivalent
///
/// [`git_stream_t`](https://libgit2.org/docs/reference/main/sys/stream/git_stream_t.html)
public enum GitStreamT: UInt32, CEnum
{
    /// A standard non-TLS socket.
    case gitStreamStandard  = 1
    
    /// A TLS-encrypted socket.
    case gitStreamTLS       = 2
    
    
    
    /// Initializes a ``GitStreamT`` instance from the given `git_stream_t`
    /// instance.
    /// - Parameter stream: The `git_stream_t` instance to use.
    internal init?(
        cValue stream: git_stream_t
    )
    {
        switch stream
        {
            case GIT_STREAM_STANDARD    : self = .gitStreamStandard
            case GIT_STREAM_TLS         : self = .gitStreamTLS
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitStreamT`` instance into a `git_stream_t` instance.
    /// - Returns: The `git_stream_t` instance.
    internal func cValue() -> git_stream_t
    {
        switch self
        {
            case .gitStreamStandard : return GIT_STREAM_STANDARD
            case .gitStreamTLS      : return GIT_STREAM_TLS
        }
    }
}
