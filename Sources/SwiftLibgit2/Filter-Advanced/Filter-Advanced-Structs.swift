//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A custom filter.
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_filter` instead.
///
/// ## C Equivalent
///
/// [`git_filter`](https://libgit2.org/docs/reference/main/sys/filter/git_filter.html)
public struct GitFilter: CStruct, Sendable
{
    /// The struct version.
    public let version      : UInt32
    
    /// The whitespace-separated list of attribute names to check.
    public let attributes   : String?
    
    /// The callback invoked to initialize the filter.
    public let initialize   : GitFilterInitFN?
    
    /// The callback invoked to shut down the filter.
    public let shutdown     : GitFilterShutdownFN?
    
    /// The callback invoked to determine whether a source needs the filter.
    public let check        : GitFilterCheckFN?
    
    /// The callback invoked to perform data filtering.
    public let apply        : GitFilterApplyFN?
    
    /// The callback invoked to perform data filtering.
    public let stream       : GitFilterStreamFN?
    
    /// The callback invoked to clean up after the filter has been applied.
    public let cleanup      : GitFilterCleanupFN?
    
    
    
    /// Initializes a ``GitFilter`` instance from the given `git_filter`
    /// instance.
    /// - Parameter filter: The `git_filter` instance to use.
    internal init(
        cValue filter: git_filter
    )
    {
        self.version        = filter.version
        self.attributes     = String(optionalCString: filter.attributes)
        self.initialize     = filter.initialize
        self.shutdown       = filter.shutdown
        self.check          = filter.check
        self.apply          = filter.apply
        self.stream         = filter.stream
        self.cleanup        = filter.cleanup
    }
}
