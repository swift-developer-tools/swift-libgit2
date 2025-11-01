//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A custom merge driver.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_merge_driver` instead.
///
/// ## C Equivalent
///
/// [`git_merge_driver`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver.html)
public struct GitMergeDriver: CStruct, Sendable
{
    /// The struct version.
    public let version      : UInt32
    
    /// The callback invoked to initialize the merge driver.
    public let initialize   : GitMergeDriverInitFN?
    
    /// The callback invoked to shut down the merge driver.
    public let shutdown     : GitMergeDriverShutdownFN?
    
    /// The callback invoked to perform the merge.
    public let apply        : GitMergeDriverApplyFN?
    
    
    
    /// Initializes a ``GitMergeDriver`` instance from the given
    /// `git_merge_driver` instance.
    /// - Parameter mergeDriver: The `git_merge_driver` instance to use.
    internal init(
        cValue mergeDriver: git_merge_driver
    )
    {
        self.version        = mergeDriver.version
        self.initialize     = mergeDriver.initialize
        self.shutdown       = mergeDriver.shutdown
        self.apply          = mergeDriver.apply
    }
}
