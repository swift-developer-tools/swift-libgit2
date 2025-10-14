//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags controlling the behavior of attribute examination.
///
/// ## Discussion
///
/// - Note: The options of ``GitAttrCheckFlagsT`` correspond to flag macros
/// in libgit2. For consistency with other APIs and type-safe usage,
/// swift-libgit2 binds these macros as if they were a bitset enum in libgit2.
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
public struct GitAttrCheckFlagsT: GitOptionSet
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
    
    
    
    /// Creates a ``GitAttrCheckFlagsT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    internal init(
        cValue rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Examine attributes in the working directory, then in the index.
    public static let gitAttrCheckFileThenIndex     = GitAttrCheckFlagsT(rawValue: UInt32(0))
    
    /// Examine attributes in the index, then in the working directory.
    public static let gitAttrCheckIndexThenFile     = GitAttrCheckFlagsT(rawValue: 1)
    
    /// Examine attributes only in the index.
    public static let gitAttrCheckIndexOnly         = GitAttrCheckFlagsT(rawValue: 2)
    
    /// Ignore the system attributes.
    public static let gitAttrCheckNoSystem          = GitAttrCheckFlagsT(rawValue: 1 << 2)
    
    /// Honor `.gitattributes` in the HEAD revision.
    public static let gitAttrCheckIncludeHEAD       = GitAttrCheckFlagsT(rawValue: 1 << 3)
    
    /// Honor `.gitattributes` in a specific commit.
    public static let gitAttrCheckIncludeCommit     = GitAttrCheckFlagsT(rawValue: 1 << 4)
    
    
    
    /// Converts the ``GitAttrCheckFlagsT`` instance into a raw value.
    /// - Returns: The raw value.
    ///
    /// ## Discussion
    ///
    /// Since the options of ``GitAttrCheckFlagsT`` correspond to flag macros
    /// in libgit2, there is no equivalent C value other than the raw value.
    internal func cValue() -> UInt32
    {
        return rawValue
    }
}



/// The possible states of an attribute.
///
/// ## C Equivalent
///
/// [`git_attr_value_t`](https://libgit2.org/docs/reference/main/attr/git_attr_value_t.html)
public enum GitAttrValueT: UInt32, CEnum
{
    /// The attribute has been left unspecified.
    case gitAttrValueUnspecified    = 0
    
    /// The attribute has been set.
    case gitAttrValueTrue           = 1
    
    /// The attribute has been unset.
    case gitAttrValueFalse          = 2
    
    /// The attribute has a value.
    case gitAttrValueString         = 3
    
    
    
    /// Creates a ``GitAttrValueT`` instance from a `git_attr_value_t` instance.
    /// - Parameter attrValue: The `git_attr_value_t` instance to use.
    internal init?(
        cValue attrValue: git_attr_value_t
    )
    {
        switch attrValue
        {
            case GIT_ATTR_VALUE_UNSPECIFIED : self = .gitAttrValueUnspecified
            case GIT_ATTR_VALUE_TRUE        : self = .gitAttrValueTrue
            case GIT_ATTR_VALUE_FALSE       : self = .gitAttrValueFalse
            case GIT_ATTR_VALUE_STRING      : self = .gitAttrValueString
            default                         : return nil
        }
    }
    
    
    
    /// Converts the ``GitAttrValueT`` instance into a `git_attr_value_t`
    /// instance.
    /// - Returns: The `git_attr_value_t` instance.
    internal func cValue() -> git_attr_value_t
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
