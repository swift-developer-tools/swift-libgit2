//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The libgit2 semantic version string.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION.html)
public let libgit2Version: String
    = "\(libgit2VersionMajor).\(libgit2VersionMinor).\(libgit2VersionRevision)"



/// The libgit2 major version number.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_MAJOR`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_MAJOR.html)
public let libgit2VersionMajor: Int = 1



/// The libgit2 minor version number.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_MINOR`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_MINOR.html)
public let libgit2VersionMinor: Int = 9



/// The libgit2 revision version number.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_REVISION`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_REVISION.html)
public let libgit2VersionRevision: Int = 1




/// The libgit2 patch version number.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_PATCH`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_PATCH.html)
public let libgit2VersionPatch: Int = 0




/// The libgit2 prerelease version number.
///
/// For nightly builds during active development, the prerelease state name
/// will be `alpha`. Releases may have a `beta` or release candidate (`rc1`,
/// `rc2`, etc.) prerelease. This will be `nil` for a final release.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_PRERELEASE`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_PRERELEASE.html)
public let libgit2VersionPrerelease: String? = nil




/// The libgit2 ABI shared object version number.
///
/// This is changed only for breaking ABI changes and may not reflect the
/// API version number.
///
/// ## C Equivalent
///
/// [`LIBGIT2_SOVERSION`](https://libgit2.org/docs/reference/main/version/LIBGIT2_SOVERSION.html)
public let libgit2SOVersion: String
    = "\(libgit2VersionMajor).\(libgit2VersionMinor)"



/// The libgit2 version number.
///
/// This is an integer value representing the libgit2 semantic version number.
/// For example, `1.9.1` is `1_090_100`.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_NUMBER`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_NUMBER.html)
public let libgit2VersionNumber: Int = 1_090_100




/// Checks whether ``libgit2VersionNumber`` is greater than or equal to the
/// given version.
/// - Parameters:
///   - major: The major version number to check.
///   - minor: The minor version number to check.
///   - revision: The revision version number to check.
/// - Returns: Whether ``libgit2VersionNumber`` is greater than or equal to
/// the given version.
///
/// ## C Equivalent
///
/// [`LIBGIT2_VERSION_CHECK`](https://libgit2.org/docs/reference/main/version/LIBGIT2_VERSION_CHECK.html)
public func libgit2VersionCheck(
    major       : Int,
    minor       : Int,
    revision    : Int
) -> Bool
{
    let version: Int =
        (major * 1_000_000)
        + (minor * 10_000)
        + (revision * 100)
    
    return libgit2VersionNumber >= version
}
