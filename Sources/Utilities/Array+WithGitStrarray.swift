//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



internal extension Array where Element == String
{
    /// Calls the given closure with a pointer to a `git_strarray` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// `git_strarray_dispose()` cannot be used here, since that function is
    /// intended to free the strings of a `git_strarray` which was allocated by libgit2.
    func withGitStrarray<T>(
        _ body: (UnsafeMutablePointer<git_strarray>) -> T
    ) -> T
    {
        var strarray = git_strarray()
        
        defer
        {
            if
                strarray.count > 0,
                strarray.strings != nil
            {
                strarray.strings?.deallocate()
            }
        }
        
        
        
        guard !self.isEmpty
        else
        {
            return body(&strarray)
        }
        
        
        
        return withArrayOfCStrings(self)
        {
            cStrings in
            
            let pointers = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(
                capacity: cStrings.count
            )
            
            for (index, cString) in cStrings.enumerated()
            {
                pointers[index] = cString
            }
            
            strarray.strings    = pointers
            strarray.count      = cStrings.count
            
            return body(&strarray)
        }
    }
}
