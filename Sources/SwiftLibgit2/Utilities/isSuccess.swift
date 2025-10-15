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
///   - defaultSuccess: Whether a result that is not of the type
///   ``GitErrorCode`` should be considered successful.
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
    
    return defaultSuccess
}
