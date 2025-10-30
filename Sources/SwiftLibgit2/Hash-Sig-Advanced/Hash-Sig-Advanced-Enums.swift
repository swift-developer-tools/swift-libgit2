//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling similarity signature computation.
///
/// ## C Equivalent
///
/// [`git_hashsig_option_t`](https://libgit2.org/docs/reference/main/sys/hashsig/git_hashsig_option_t.html)
public struct GitHashSigOptionT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitHashSigOptionT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitHashSigOptionT`` instance from the given
    /// `git_hashsig_option_t` instance.
    /// - Parameter hashSigOption: The `git_hashsig_option_t` instance
    /// to use.
    internal init(
        cValue hashSigOption: git_hashsig_option_t
    )
    {
        self.rawValue = hashSigOption.rawValue
    }
    
    
    
    /// Use all available data.
    ///
    /// ## Discussion
    ///
    /// This flag, ``gitHashSigIgnoreWhitespace``, and
    /// ``gitHashSigSmartWhitespace`` are mutually exclusive. They must not
    /// be combined.
    public static let gitHashSigNormal              = GitHashSigOptionT(rawValue: GIT_HASHSIG_NORMAL.rawValue)
    
    /// Ignore whitespace.
    ///
    /// ## Discussion
    ///
    /// This flag, ``gitHashSigNormal``, and ``gitHashSigSmartWhitespace``
    /// are mutually exclusive. They must not be combined.
    public static let gitHashSigIgnoreWhitespace    = GitHashSigOptionT(rawValue: GIT_HASHSIG_IGNORE_WHITESPACE.rawValue)
    
    /// Ignore carriage returns and all whitespace after line breaks.
    ///
    /// ## Discussion
    ///
    /// This flag, ``gitHashSigNormal``, and ``gitHashSigIgnoreWhitespace``
    /// are mutually exclusive. They must not be combined.
    public static let gitHashSigSmartWhitespace     = GitHashSigOptionT(rawValue: GIT_HASHSIG_SMART_WHITESPACE.rawValue)
    
    /// Allow small files to be hashed.
    public static let gitHashSigAllowSmallFiles     = GitHashSigOptionT(rawValue: GIT_HASHSIG_ALLOW_SMALL_FILES.rawValue)
    
    
    
    /// Converts the ``GitHashSigOptionT`` instance into a
    /// `git_hashsig_option_t` instance.
    /// - Returns: The `git_hashsig_option_t` instance.
    internal func cValue() -> git_hashsig_option_t
    {
        return git_hashsig_option_t(rawValue)
    }
}
