//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the object database backend write behavior.
///
/// ## C Equivalent
///
/// [`git_odb_backend_loose_flag_t`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_backend_loose_flag_t.html)
public struct GitODBBackendLooseFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitODBBackendLooseFlagT`` instance from the given raw
    /// value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitODBBackendLooseFlagT`` instance from the given
    /// `git_odb_backend_loose_flag_t` instance.
    /// - Parameter odbBackendLooseFlag: The `git_odb_backend_loose_flag_t`
    /// instance to use.
    internal init(
        cValue odbBackendLooseFlag: git_odb_backend_loose_flag_t
    )
    {
        self.rawValue = odbBackendLooseFlag.rawValue
    }
    
    
    
    /// Perform an `fysync` on write.
    public static let gitODBBackendLooseFSync = GitODBBackendLooseFlagT(rawValue: GIT_ODB_BACKEND_LOOSE_FSYNC.rawValue)
    
    
    
    /// Converts the ``GitODBBackendLooseFlagT`` instance into a
    /// `git_odb_backend_loose_flag_t` instance.
    /// - Returns: The `git_odb_backend_loose_flag_t` instance.
    internal func cValue() -> git_odb_backend_loose_flag_t
    {
        return git_odb_backend_loose_flag_t(rawValue)
    }
}



/// The object database streaming mode.
///
/// ## C Equivalent
///
/// [`git_odb_stream_t`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_stream_t.html)
public enum GitODBStreamT: UInt32, CEnum
{
    /// Open the stream with read-only access.
    case gitStreamRDOnly    = 2
    
    /// Open the stream with write-only access.
    case gitStreamWROnly    = 4
    
    /// Open the stream with read-write access.
    case gitStreamRW        = 6
    
    
    
    /// Initializes a ``GitODBStreamT`` instance from the given
    /// `git_odb_stream_t` instance.
    /// - Parameter odbStream: The `git_odb_stream_t` instance to use.
    internal init?(
        cValue odbStream: git_odb_stream_t
    )
    {
        switch odbStream
        {
            case GIT_STREAM_RDONLY  : self = .gitStreamRDOnly
            case GIT_STREAM_WRONLY  : self = .gitStreamWROnly
            case GIT_STREAM_RW      : self = .gitStreamRW
            default                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitODBStreamT`` instance into a `git_odb_stream_t`
    /// instance.
    /// - Returns: The `git_odb_stream_t` instance.
    internal func cValue() -> git_odb_stream_t
    {
        switch self
        {
            case .gitStreamRDOnly   : return GIT_STREAM_RDONLY
            case .gitStreamWROnly   : return GIT_STREAM_WRONLY
            case .gitStreamRW       : return GIT_STREAM_RW
        }
    }
}
