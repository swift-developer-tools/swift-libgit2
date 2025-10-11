//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Checks whether the given attribute is set.
/// - Parameter attr: The attribute to check.
/// - Returns: Whether the given attribute is set.
///
/// ## Discussion
///
/// In core Git parlance, this is the value for set attributes.
///
/// For example, if the attribute file contains `*.c foo`, then for file
/// `xyz.c`, looking up attribute `foo` gives a value for which
/// ``gitAttrIsTrue(attr:)`` will return `true`.
///
/// ## C Equivalent
///
/// [`GIT_ATTR_IS_TRUE(attr)`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_IS_TRUE.html)
public func gitAttrIsTrue(
    attr: UnsafePointer<CChar>?
) -> Bool
{
    return gitAttrValue(attr: attr) == .gitAttrValueTrue
}



/// Checks whether the given attribute is unset.
/// - Parameter attr: The attribute to check.
/// - Returns: Whether the given attribute is unset.
///
/// ## Discussion
///
/// In core Git parlance, this is the value for unset attributes (not to be
/// confused with values that are unspecified).
///
/// For example, if the attribute file contains `*.h -foo`, then for file
/// `zyx.h`, looking up attribute `foo` gives a value for which
/// ``gitAttrIsFalse(attr:)`` will return `true`.
///
/// ## C Equivalent
///
/// [`GIT_ATTR_IS_FALSE(attr)`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_IS_FALSE.html)
public func gitAttrIsFalse(
    attr: UnsafePointer<CChar>?
) -> Bool
{
    return gitAttrValue(attr: attr) == .gitAttrValueFalse
}



/// Checks whether the given attribute is unspecified.
/// - Parameter attr: The attribute to check.
/// - Returns: Whether the given attribute is unspecified.
///
/// ## Discussion
///
/// An attribute may be unspecified due to the it not being mentioned at all
/// or because the it was explicitly set to unspecified via the exclamation
/// mark (`!`) operator.
///
/// For example, if the attribute file contains:
/// `*.c foo *.h -foo onefile.c !foo`, then for file `onefile.c`, looking up
/// attribute `foo` yields a value for which ``gitAttrIsUnspecified(attr:)``
/// returns `true`.
///
/// Looking up `foo` on file `onefile.rb` or looking up `bar` on any file will
/// yield a value for which ``gitAttrIsUnspecified(attr:)`` will return `true`.
///
/// ## C Equivalent
///
/// [`GIT_ATTR_IS_UNSPECIFIED(attr)`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_IS_UNSPECIFIED.html)
public func gitAttrIsUnspecified(
    attr: UnsafePointer<CChar>?
) -> Bool
{
    return gitAttrValue(attr: attr) == .gitAttrValueUnspecified
}



/// Checks whether the given attribute is set to a value.
/// - Parameter attr: The attribute to check.
/// - Returns: Whether the given attribute is set to a value.
///
/// ## Discussion
///
/// An attribute may be set to a value as opposed to being set, unset, or
/// unspecified.
///
/// For example, if the attribute file contains: `*.txt eol=lf`, then for file
/// `onefile.txt`, looking up attribute `eol` yields a value for which
/// ``gitAttrHasValue(attr:)`` will return `true`.
///
/// ## C Equivalent
///
/// [`GIT_ATTR_HAS_VALUE(attr)`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_HAS_VALUE.html)
public func gitAttrHasValue(
    attr: UnsafePointer<CChar>?
) -> Bool
{
    return gitAttrValue(attr: attr) == .gitAttrValueString
}



/// The current version for ``GitAttrOptions``.
///
/// ## C Equivalent
///
/// [`GIT_ATTR_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/attr/GIT_ATTR_OPTIONS_VERSION.html)
public let gitAttrOptionsVersion: UInt32 = 1
