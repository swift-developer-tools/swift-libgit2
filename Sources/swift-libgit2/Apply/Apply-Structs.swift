//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for the apply process.
///
/// ## C Equivalent
///
/// [`git_apply_options`](https://libgit2.org/docs/reference/main/apply/git_apply_options.html)
public struct GitApplyOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitApplyOptionsVersion``.
    public var version : UInt32
    
    /// The callback that will be made per delta (file) when applying a patch.
    public var deltaCB : GitApplyDeltaCB?
    
    /// The callback that will be made per hunk when applying a patch.
    public var hunkCB  : GitApplyHunkCB?
    
    /// The caller-specified payload passed to both ``GitApplyOptions/deltaCB`` and
    /// ``GitApplyOptions/hunkCB``.
    public var payload : UnsafeMutableRawPointer?
    
    /// The flags to use when applying.
    public var flags   : GitApplyFlagsT
    
    
    
    /// Creates a ``GitApplyOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to ``gitApplyOptionsVersion``.
    public init?(
        version: UInt32 = gitApplyOptionsVersion
    )
    {
        var applyOptions = git_apply_options()
        
        let applyOptionsInitResult: Int32 = git_apply_options_init(
            &applyOptions,
            version
        )
        
        if applyOptionsInitResult != GIT_OK.rawValue
        {
            return nil
        }
        
        self.init(cValue: applyOptions)
    }
    
    
    
    /// Creates a ``GitApplyOptions`` instance from a `git_apply_options` instance.
    /// - Parameter applyOptions: The `git_apply_options` instance to use.
    internal init(
        cValue applyOptions: git_apply_options
    )
    {
        self.version    = applyOptions.version
        self.deltaCB    = applyOptions.delta_cb
        self.hunkCB     = applyOptions.hunk_cb
        self.payload    = applyOptions.payload
        self.flags      = GitApplyFlagsT(rawValue: applyOptions.flags)
    }
    
    
    
    /// The equivalent C value.
    ///
    /// ## Discussion
    ///
    /// This value will be `nil` if the initialization failed.
    internal var cValue: git_apply_options?
    {
        var applyOptions = git_apply_options()
        
        let applyOptionsInitResult: Int32 = git_apply_options_init(
            &applyOptions,
            version
        )
        
        if applyOptionsInitResult != GIT_OK.rawValue
        {
            return nil
        }
        
        applyOptions.delta_cb   = deltaCB
        applyOptions.hunk_cb    = hunkCB
        applyOptions.payload    = payload
        applyOptions.flags      = flags.rawValue
        
        return applyOptions
    }
}
