//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Flags controlling the behavior of ``gitApply(repo:diff:location:options:)``.
///
/// ## Discussion
///
/// When the callback:
/// - Returns a negative value, the apply process will be aborted.
/// - Returns a positive value, the hunk will not be applied, but the apply process will continue.
/// - Returns `0`, the hunk will be applied, and the apply process will continue.
///
/// ## C Equivalent
///
/// [`git_apply_flags_t`](https://libgit2.org/docs/reference/main/apply/git_apply_flags_t.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public struct GitApplyFlagsT: OptionSet, Sendable
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitApplyFlagsT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Do not actually make changes, just test that the patch applies.
    /// This is the equivalent of `git apply --check`.
    public static let gitApplyCheck = GitApplyFlagsT(rawValue: GIT_APPLY_CHECK.rawValue)
}



/// Possible application locations for ``gitApply(repo:diff:location:options:)``.
///
/// ## C Equivalent
///
/// [`git_apply_location_t`](https://libgit2.org/docs/reference/main/apply/git_apply_location_t.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public struct GitApplyLocationT: OptionSet, Sendable
{
    /// The raw value to use.
    public let rawValue: UInt32
        
    /// Creates a ``GitApplyLocationT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Apply the patch to the working directory, leaving the index untouched.
    /// This is the equivalent of `git apply` with no location argument.
    public static let gitApplyLocationWorkdir  = GitApplyLocationT(rawValue: GIT_APPLY_LOCATION_WORKDIR.rawValue)
    
    /// Apply the patch to the index, leaving the working directory untouched.
    /// This is the equivalent of `git apply --cached`.
    public static let gitApplyLocationIndex    = GitApplyLocationT(rawValue: GIT_APPLY_LOCATION_INDEX.rawValue)
    
    /// Apply the patch to both the working directory and the index.
    /// This is the equivalent of `git apply --index`.
    public static let gitApplyLocationBoth     = GitApplyLocationT(rawValue: GIT_APPLY_LOCATION_BOTH.rawValue)
}
