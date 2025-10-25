//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
@testable import SwiftLibgit2



/// Checks whether the given libgit2 operation result is ``GitErrorCode/gitOK``,
/// and clears the last libgit2 error otherwise.
/// - Parameter errorCode: The libgit2 operation result to check.
/// - Returns: Whether the given libgit2 operation result is
/// ``GitErrorCode/gitOK``.
func isOK(
    _ errorCode: GitErrorCode
) -> Bool
{
    let isOK: Bool = errorCode == .gitOK
    
    if !isOK
    {
        // TODO: Replace when `git_error_clear()` has a binding, and remove CLibgit2 import.
        git_error_clear()
    }
    
    return isOK
}
