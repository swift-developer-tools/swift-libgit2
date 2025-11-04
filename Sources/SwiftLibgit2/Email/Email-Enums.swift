//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the formatting of generated emails.
///
/// ## C Equivalent
///
/// [`git_email_create_flags_t`](https://libgit2.org/docs/reference/main/email/git_email_create_flags_t.html)
public struct GitEmailCreateFlagsT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitEmailCreateFlagsT`` instance from the given raw
    /// value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitEmailCreateFlagsT`` instance from the given
    /// `git_email_create_flags_t` instance.
    /// - Parameter emailCreateFlags: The `git_email_create_flags_t` instance
    /// to use.
    internal init(
        cValue emailCreateFlags: git_email_create_flags_t
    )
    {
        self.rawValue = emailCreateFlags.rawValue
    }
    
    
    
    /// Use the normal patch formatting.
    public static let gitEmailCreateDefault         = GitEmailCreateFlagsT(rawValue: GIT_EMAIL_CREATE_DEFAULT.rawValue)
    
    /// Do not include patch numbers in the subject prefix.
    public static let gitEmailCreateOmitNumbers     = GitEmailCreateFlagsT(rawValue: GIT_EMAIL_CREATE_OMIT_NUMBERS.rawValue)
    
    /// Include numbers in the subject prefix, even when the patch is for
    /// a single commit.
    public static let gitEmailCreateAlwaysNumber    = GitEmailCreateFlagsT(rawValue: GIT_EMAIL_CREATE_ALWAYS_NUMBER.rawValue)
    
    /// Do not perform rename or similarity detection.
    public static let gitEmailCreateNoRenames       = GitEmailCreateFlagsT(rawValue: GIT_EMAIL_CREATE_NO_RENAMES.rawValue)
    
    
    
    /// Converts the ``GitEmailCreateFlagsT`` instance into a
    /// `git_email_create_flags_t` instance.
    /// - Returns: The `git_email_create_flags_t` instance.
    internal func cValue() -> git_email_create_flags_t
    {
        return git_email_create_flags_t(rawValue)
    }
}
