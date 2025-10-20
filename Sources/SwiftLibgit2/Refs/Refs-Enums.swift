//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling reference name validation.
///
/// ## C Equivalent
///
/// [`git_reference_format_t`](https://libgit2.org/docs/reference/main/refs/git_reference_format_t.html)
public struct GitReferenceFormatT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitReferenceFormatT`` instance from the given raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitReferenceFormatT`` instance from the given
    /// `git_reference_format_t` instance.
    /// - Parameter referenceFormat: The `git_reference_format_t` instance to
    /// use.
    internal init(
        cValue referenceFormat: git_reference_format_t
    )
    {
        self.rawValue = referenceFormat.rawValue
    }
    
    
    
    /// Use no particular normalization.
    public static let gitReferenceFormatNormal              = GitReferenceFormatT(rawValue: GIT_REFERENCE_FORMAT_NORMAL.rawValue)
    
    /// Control whether one-level reference names are accepted.
    ///
    /// ## Discussion
    ///
    /// One-level reference names are reference names that do not contain
    /// multiple separated components. They are expected to be written using
    /// only uppercase letters and an underscore, for example, `FETCH_HEAD`.
    public static let gitReferenceFormatAllowOneLevel       = GitReferenceFormatT(rawValue: GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL.rawValue)
    
    /// Interpret the reference name as a reference pattern for a refspec,
    /// as used with remote repositories.
    ///
    /// ## Discussion
    ///
    /// If this flag is enabled, the reference name is allowed to contain a
    /// single asterisk (`*`) in place of one full pathname component.
    public static let gitReferenceFormatRefspecPattern      = GitReferenceFormatT(rawValue: GIT_REFERENCE_FORMAT_REFSPEC_PATTERN.rawValue)
    
    /// Interpret the reference name as part of a refspec in shorthand form,
    /// so the one-level naming rules are not enforced.
    public static let gitReferenceFormatRefspecShorthand    = GitReferenceFormatT(rawValue: GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND.rawValue)
    
    
    
    /// Converts the ``GitReferenceFormatT`` instance into a
    /// `git_reference_format_t` instance.
    /// - Returns: The `git_reference_format_t` instance.
    internal func cValue() -> git_reference_format_t
    {
        return git_reference_format_t(rawValue)
    }
}



/// The type of reference.
///
/// ## C Equivalent
///
/// [`git_reference_t`](https://libgit2.org/docs/reference/main/refs/git_reference_t.html)
public enum GitReferenceT: UInt32, CEnum
{
    /// An invalid reference.
    case gitReferenceInvalid    = 0
    
    /// A reference that points to an ID.
    case gitReferenceDirect     = 1
    
    /// A reference that points to another reference.
    case gitReferenceSymbolic   = 2
    
    /// Any reference.
    case gitReferenceAll        = 3
    
    
    
    /// Initializes a ``GitReferenceT`` instance from the given
    /// `git_reference_t` instance.
    /// - Parameter reference: The `git_reference_t` instance to use.
    internal init?(
        cValue reference: git_reference_t
    )
    {
        switch reference
        {
            case GIT_REFERENCE_INVALID  : self = .gitReferenceInvalid
            case GIT_REFERENCE_DIRECT   : self = .gitReferenceDirect
            case GIT_REFERENCE_SYMBOLIC : self = .gitReferenceSymbolic
            case GIT_REFERENCE_ALL      : self = .gitReferenceAll
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitReferenceT`` instance into a `git_reference_t`
    /// instance.
    /// - Returns: The `git_reference_t` instance.
    internal func cValue() -> git_reference_t
    {
        switch self
        {
            case .gitReferenceInvalid   : return GIT_REFERENCE_INVALID
            case .gitReferenceDirect    : return GIT_REFERENCE_DIRECT
            case .gitReferenceSymbolic  : return GIT_REFERENCE_SYMBOLIC
            case .gitReferenceAll       : return GIT_REFERENCE_ALL
        }
    }
}
