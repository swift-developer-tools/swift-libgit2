//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Diff performance data.
///
/// ## C Equivalent
///
/// [`git_diff_perfdata`](https://libgit2.org/docs/reference/main/sys/diff/git_diff_perfdata.html)
public struct GitDiffPerfData: CStructInternalMutable, CConvertible, Sendable
{
    /// The struct version.
    ///
    /// The default value is ``gitDiffPerfDataVersion``.
    public private(set) var version         : UInt32    = gitDiffPerfDataVersion
    
    /// The number of `stat()` invocations.
    ///
    /// The default value is `0`.
    public private(set) var statCalls       : Int       = 0
    
    /// The number of IDs calculated.
    ///
    /// The default value is `0`.
    public private(set) var oidCalculations : Int       = 0
    
    
    
    /// Initializes a default ``GitDiffPerfData``.
    public init() { }
    
    
    
    /// Initializes a ``GitDiffPerfData`` instance from the given
    /// `git_diff_perfdata` instance.
    /// - Parameter diffPerfData: The `git_diff_perfdata` instance to use.
    internal init(
        cValue diffPerfData: git_diff_perfdata
    )
    {
        self.version            = diffPerfData.version
        self.statCalls          = diffPerfData.stat_calls
        self.oidCalculations    = diffPerfData.oid_calculations
    }
    
    
    
    /// Converts the ``GitDiffPerfData`` instance into a `git_diff_perfdata`
    /// instance.
    /// - Returns: The `git_diff_perfdata` instance.
    internal func cValue() -> git_diff_perfdata
    {
        var diffPerfData = git_diff_perfdata()
        
        diffPerfData.version            = version
        diffPerfData.stat_calls         = statCalls
        diffPerfData.oid_calculations   = oidCalculations
        
        return diffPerfData
    }
}
