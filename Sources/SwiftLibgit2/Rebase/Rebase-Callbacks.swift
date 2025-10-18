//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to add a signature to the rebase commit.
/// - Parameters:
///   - signature: The signature to add to the commit.
///   - signatureField: The header field containing the signature.
///   - commitContent: The content of the unsigned commit to use.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If this function and ``GitCommitCreateCB`` are both provided to
/// ``GitRebaseOptions``, then this function will not be invoked.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``GitRebaseOptions/commitCreateCB`` instead.
///
/// ## C Equivalent
///
/// This callback does not have a named equivalent in libgit2, but exists as
/// the ``GitRebaseOptions/signingCB`` property on ``GitRebaseOptions``.
public typealias GitRebaseSigningCB = @convention(c)
(
    UnsafeMutablePointer<git_buf>?,
    UnsafeMutablePointer<git_buf>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32
