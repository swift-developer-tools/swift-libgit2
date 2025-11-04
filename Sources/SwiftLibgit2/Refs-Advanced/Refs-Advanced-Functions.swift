//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new direct reference using the given name and ID.
/// - Parameters:
///   - name: The reference name to use.
///   - oid: The reference ID to use.
///   - peel: The ID of the first non-tag object to use.
/// - Returns: The new direct reference using the given name and ID.
///
/// ## C Equivalent
///
/// [`git_reference__alloc()`](https://libgit2.org/docs/reference/main/sys/refs/git_reference__alloc.html)
public func gitReferenceAlloc(
    name    : String,
    oid     : GitOID,
    peel    : GitOID?
) -> OpaquePointer?
{
    return try? oid.withCValue
    {
        cOID in
        
        return try peel.withOptionalCValue
        {
            cPeel in
            
            return git_reference__alloc(
                name,
                cOID,
                cPeel
            )
        }
    }
}



/// Creates a new symbolic reference using the given name and target.
/// - Parameters:
///   - name: The reference name to use.
///   - target: The reference target to use.
/// - Returns: The new direct reference using the given name and target.
///
/// ## C Equivalent
///
/// [`git_reference__alloc_symbolic()`](https://libgit2.org/docs/reference/main/sys/refs/git_reference__alloc_symbolic.html)
public func gitReferenceAllocSymbolic(
    name    : String,
    target  : String
) -> OpaquePointer?
{
    return git_reference__alloc_symbolic(
        name,
        target
    )
}
