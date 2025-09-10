//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Flags controlling the behavior of attribute examination.
///
/// ## Discussion
///
/// The properties of ``GitAttrCheckFlagsT`` correspond to flag macros in libgit2. For consistency
/// with other APIs, swift-libgit2 presents them as if they were an enum in libgit2.
///
/// ## C Equivalent
///
/// [`GIT_ATTR_CHECK_FILE_THEN_INDEX`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_CHECK_FILE_THEN_INDEX.html)
///
/// [`GIT_ATTR_CHECK_INDEX_THEN_FILE`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_CHECK_INDEX_THEN_FILE.html)
///
/// [`GIT_ATTR_CHECK_INDEX_ONLY`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_CHECK_INDEX_ONLY.html)
///
/// [`GIT_ATTR_CHECK_NO_SYSTEM`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_CHECK_NO_SYSTEM.html)
///
/// [`GIT_ATTR_CHECK_INCLUDE_HEAD`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_CHECK_INCLUDE_HEAD.html)
///
/// [`GIT_ATTR_CHECK_INCLUDE_COMMIT`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_CHECK_INCLUDE_COMMIT.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public struct GitAttrCheckFlagsT: OptionSet, Sendable
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitAttrCheckFlagsT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Examine attributes in the working directory, then in the index.
    public static let gitAttrCheckFileThenIndex     = GitAttrCheckFlagsT(rawValue: UInt32(GIT_ATTR_CHECK_FILE_THEN_INDEX))
    
    /// Examine attributes in the index, then in the working directory.
    public static let gitAttrCheckIndexThenFile     = GitAttrCheckFlagsT(rawValue: UInt32(GIT_ATTR_CHECK_INDEX_THEN_FILE))
    
    /// Examine attributes only in the index.
    public static let gitAttrCheckIndexOnly         = GitAttrCheckFlagsT(rawValue: UInt32(GIT_ATTR_CHECK_INDEX_ONLY))
    
    /// Ignore the system attributes.
    public static let gitAttrCheckNoSystem          = GitAttrCheckFlagsT(rawValue: UInt32(GIT_ATTR_CHECK_NO_SYSTEM))
    
    /// Honor `.gitattributes` in the HEAD revision.
    public static let gitAttrCheckIncludeHEAD       = GitAttrCheckFlagsT(rawValue: UInt32(GIT_ATTR_CHECK_INCLUDE_HEAD))
    
    /// Honor `.gitattributes` in a specific commit.
    public static let gitAttrCheckIncludeCommit     = GitAttrCheckFlagsT(rawValue: UInt32(GIT_ATTR_CHECK_INCLUDE_COMMIT))
}



/// Possible states for an attribute.
///
/// ## C Equivalent
///
/// [`git_attr_value_t`](https://libgit2.org/docs/reference/main/attr/git_attr_value_t.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public enum GitAttrValueT: UInt32
{
    /// The attribute has been left unspecified.
    case gitAttrValueUnspecified    = 0
    
    /// The attribute has been set.
    case gitAttrValueTrue           = 1
    
    /// The attribute has been unset.
    case gitAttrValueFalse          = 2
    
    /// The attribute has a value.
    case gitAttrValueString         = 3
    
    
    
    /// The equivalent C enum value.
    internal var cValue: git_attr_value_t
    {
        switch self
        {
            case .gitAttrValueUnspecified   : return GIT_ATTR_VALUE_UNSPECIFIED
            case .gitAttrValueTrue          : return GIT_ATTR_VALUE_TRUE
            case .gitAttrValueFalse         : return GIT_ATTR_VALUE_FALSE
            case .gitAttrValueString        : return GIT_ATTR_VALUE_STRING
        }
    }
}
