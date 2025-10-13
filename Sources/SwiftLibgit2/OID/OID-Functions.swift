//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Compares two IDs for equality.
/// - Parameters:
///   - a: The first ID to compare.
///   - b: The second ID to compare.
/// - Returns: Whether the two IDs are equal.
///
/// ## C Equivalent
///
/// [`git_oid_equal()`](https://libgit2.org/docs/reference/main/oid/git_oid_equal.html)
public func gitOIDEqual(
    a   : GitOID,
    b   : GitOID
) -> Bool
{
    var cFirstOID   : git_oid   = a.cValue()
    var cSecondOID  : git_oid   = b.cValue()
    
    let oidEqualResult: Int32 = git_oid_equal(
        &cFirstOID,
        &cSecondOID
    )
    
    return Bool(oidEqualResult)
}
