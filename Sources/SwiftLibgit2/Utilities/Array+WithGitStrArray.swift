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
    func withGitStrArray<T>(
        _ body: (UnsafeMutablePointer<git_strarray>) -> T
    ) -> T
    {
        var strArray = git_strarray()
        
        defer
        {
            if
                strArray.count > 0,
                strArray.strings != nil
            {
                strArray.strings?.deallocate()
            }
        }
        
        
        
        guard !self.isEmpty
        else
        {
            return body(&strArray)
        }
        
        
        
        return self.withArrayOfCStrings
        {
            cStrings in
            
            let pointers = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(
                capacity: cStrings.count
            )
            
            for (index, cString) in cStrings.enumerated()
            {
                pointers[index] = cString
            }
            
            strArray.strings    = pointers
            strArray.count      = cStrings.count
            
            return body(&strArray)
        }
    }
    
    
    
    /// Creates a `[String]` from a `git_strarray` instance.
    /// - Parameter strArray: The `git_strarray` instance to convert.
    init(
        _ strArray: git_strarray
    )
    {
        guard
            strArray.count > 0,
            let cStrings: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?> = strArray.strings
        else
        {
            self = []
            return
        }
        
        
        
        var swiftStrings: [String] = []
        
        swiftStrings.reserveCapacity(strArray.count)
        
        
        
        for index in 0..<strArray.count
        {
            if let swiftString = String(optionalCString: cStrings[index])
            {
                swiftStrings.append(swiftString)
            }
        }
        
        self = swiftStrings
    }
}
