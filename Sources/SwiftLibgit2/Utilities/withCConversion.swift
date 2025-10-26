//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Foundation



/// Calls the given closure within a `do`/`catch` block and returns
/// ``GitErrorCode/gitEUser`` if an error is thrown.
/// - Parameter body: The closure to call.
/// - Returns: The return value of the given closure or the `code` property
/// of a thrown `NSError`, converted to a ``GitErrorCode`` instance, or
/// ``GitErrorCode/gitEUser`` for any other thrown error.
internal func withCConversion(
    _ body: () throws -> Int32
) -> GitErrorCode
{
    var result: Int32 = GitErrorCode.gitEUser.rawValue
    
    do
    {
        result = try body()
    }
    catch let error as NSError
    {
        if
            error.code >= Int32.min,
            error.code <= Int32.max
        {
            result = Int32(error.code)
        }
    }
    catch
    {
        /// Non-`NSError` cases return the default value.
    }
    
    return GitErrorCode(rawValue: result)
}
