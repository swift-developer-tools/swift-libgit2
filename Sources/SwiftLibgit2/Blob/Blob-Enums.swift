//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of the blob filtering operation.
///
/// ## C Equivalent
///
/// [`git_blob_filter_flag_t`](https://libgit2.org/docs/reference/main/blob/git_blob_filter_flag_t.html)
public struct GitBlobFilterFlagT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitBlobFilterFlagT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitBlobFilterFlagT`` instance from a
    /// `git_blob_filter_flag_t` instance.
    /// - Parameter blobFilterFlag: The `git_blob_filter_flag_t` instance
    /// to use.
    internal init(
        cValue blobFilterFlag: git_blob_filter_flag_t
    )
    {
        self.rawValue = blobFilterFlag.rawValue
    }
    
    
    
    /// Filters will not be applied to binary files.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    public static let gitBlobFilterCheckForBinary           = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_CHECK_FOR_BINARY.rawValue)
    
    /// Filters will not load configuration from the system-wide
    /// `.gitattributes` in `/etc`
    /// (or the system-equivalent directory).
    public static let gitBlobFilterNoSystemAttributes       = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES.rawValue)
    
    /// Filters will be loaded from `.gitattributes` in the HEAD commit.
    public static let gitBlobFilterAttributesFromHEAD       = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD.rawValue)
    
    /// Filters will be loaded from `.gitattributes` in the specified commit.
    public static let gitBlobFilterAttributesFromCommit     = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT.rawValue)
    
    
    
    /// Converts the ``GitBlobFilterFlagT`` instance into a
    /// `git_blob_filter_flag_t` instance.
    /// - Returns: The `git_blob_filter_flag_t` instance.
    internal func cValue() -> git_blob_filter_flag_t
    {
        return git_blob_filter_flag_t(rawValue)
    }
}
