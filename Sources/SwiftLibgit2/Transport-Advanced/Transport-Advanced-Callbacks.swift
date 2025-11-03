//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to create a new subtransport for the given smart
/// transport.
/// - Parameters:
///   - out: The pointer in which to store the smart subtransport.
///   - owner: The transport owner to use.
///   - param: The input parameter to use.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_smart_subtransport_cb()`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_subtransport_cb.html)
public typealias GitSmartSubtransportCB = @convention(c)
(
    UnsafeMutablePointer<UnsafeMutablePointer<git_smart_subtransport>?>?,
    UnsafeMutablePointer<git_transport>?,
    UnsafeMutableRawPointer?
) -> Int32
