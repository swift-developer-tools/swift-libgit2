//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of
/// ``gitApply(repo:diff:location:options:)``.
///
/// ## C Equivalent
///
/// [`git_apply_flags_t`](https://libgit2.org/docs/reference/main/apply/git_apply_flags_t.html)
public struct GitApplyFlagsT: GitOptionSet
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
    
    
    
    /// Creates a ``GitApplyFlagsT`` instance from a `git_apply_flags_t`
    /// instance.
    /// - Parameter applyFlags: The `git_apply_flags_t` instance to use.
    internal init(
        cValue applyFlags: git_apply_flags_t
    )
    {
        self.rawValue = applyFlags.rawValue
    }
    
    
    
    /// Do not actually make changes, just test that the patch applies.
    ///
    /// ## Discussion
    ///
    /// This is the equivalent of `git apply --check`.
    public static let gitApplyCheck = GitApplyFlagsT(rawValue: GIT_APPLY_CHECK.rawValue)
    
    
    
    /// Converts the ``GitApplyFlagsT`` instance into a `git_apply_flags_t`
    /// instance.
    /// - Returns: The `git_apply_flags_t` instance.
    internal func cValue() -> git_apply_flags_t
    {
        return git_apply_flags_t(rawValue)
    }
}



/// Possible application locations for ``gitApply(repo:diff:location:options:)``.
///
/// ## C Equivalent
///
/// [`git_apply_location_t`](https://libgit2.org/docs/reference/main/apply/git_apply_location_t.html)
public struct GitApplyLocationT: GitOptionSet
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
    
    
    
    /// Creates a ``GitApplyLocationT`` instance from a `git_apply_location_t`
    /// instance.
    /// - Parameter applyLocation: The `git_apply_location_t` instance to use.
    internal init(
        cValue applyLocation: git_apply_location_t
    )
    {
        self.rawValue = applyLocation.rawValue
    }
    
    
    
    /// Apply the patch to the working directory, leaving the index untouched.
    ///
    /// ## Discussion
    ///
    /// This is the equivalent of `git apply` with no location argument.
    public static let gitApplyLocationWorkdir  = GitApplyLocationT(rawValue: GIT_APPLY_LOCATION_WORKDIR.rawValue)
    
    /// Apply the patch to the index, leaving the working directory untouched.
    ///
    /// ## Discussion
    ///
    /// This is the equivalent of `git apply --cached`.
    public static let gitApplyLocationIndex    = GitApplyLocationT(rawValue: GIT_APPLY_LOCATION_INDEX.rawValue)
    
    /// Apply the patch to both the working directory and the index.
    ///
    /// ## Discussion
    ///
    /// This is the equivalent of `git apply --index`.
    public static let gitApplyLocationBoth     = GitApplyLocationT(rawValue: GIT_APPLY_LOCATION_BOTH.rawValue)
    
    
    
    /// Converts the ``GitApplyLocationT`` instance into a
    /// `git_apply_location_t` instance.
    /// - Returns: The `git_apply_location_t` instance.
    internal func cValue() -> git_apply_location_t
    {
        return git_apply_location_t(rawValue)
    }
}
