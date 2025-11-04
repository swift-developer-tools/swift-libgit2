//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// Checks whether the given libgit2 operation result indicates success.
/// - Parameters:
///   - result: The libgit2 operation result.
///   - defaultSuccess: Whether to consider a result that is not a
///   ``GitErrorCode`` instance successful.
/// - Returns: Whether the given libgit2 operation result indicates success.
internal func isSuccess<T>(
    _ result        : T,
    defaultSuccess  : Bool  = true
) -> Bool
{
    if let errorCode = result as? GitErrorCode
    {
        return errorCode == .gitOK
    }
    else if let errorCode = result as? Int32
    {
        return GitErrorCode(rawValue: errorCode) == .gitOK
    }
    
    return defaultSuccess
}
