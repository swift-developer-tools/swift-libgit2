//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Flags controlling the behavior of the blob filtering process.
///
/// ## C Equivalent
///
/// [`git_blob_filter_flag_t`](https://libgit2.org/docs/reference/main/blob/git_blob_filter_flag_t.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public struct GitBlobFilterFlagT: OptionSet, Sendable
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
    
    
    
    /// Filters will not be applied to binary files.
    public static let gitBlobFilterCheckForBinary           = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_CHECK_FOR_BINARY.rawValue)
    
    /// Filters will not load configuration from the system-wide `.gitattributes` in `/etc`
    /// (or the system-equivalent directory).
    public static let gitBlobFilterNoSystemAttributes       = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES.rawValue)
    
    /// Filters will be loaded from `.gitattributes` in the HEAD commit.
    public static let gitBlobFilterAttributesFromHEAD       = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD.rawValue)
    
    /// Filters will be loaded from `.gitattributes` in the specified commit.
    public static let gitBlobFilterAttributesFromCommit     = GitBlobFilterFlagT(rawValue: GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT.rawValue)
}
