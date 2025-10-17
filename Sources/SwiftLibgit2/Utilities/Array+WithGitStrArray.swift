//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



internal extension Array where Element == String
{
    /// Calls the given closure with a pointer to a `git_strarray` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// ``gitStrArrayDispose(array:)`` is not used here, since that function
    /// is intended to free the strings of a `git_strarray` which was allocated
    /// by libgit2. In this case, the strings are allocated by this method and
    /// must be manually freed. If the receiver is empty, the `body` closure is
    /// called with an empty read-only `git_strarray`, with no strings to free.
    func withGitStrArray<T>(
        _ body: (UnsafePointer<git_strarray>) throws -> T
    ) throws -> T
    {
        var strArray = git_strarray()
        
        guard !self.isEmpty
        else
        {
            return try body(&strArray)
        }
        
        
        
        return try self.withArrayOfCStrings
        {
            cStrings in
            
            let pointers = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>
                .allocate(capacity: cStrings.count)
            
            defer
            {
                pointers.deallocate()
            }
            
            
            
            /// ``Array<String>/withArrayOfCStrings(_:)`` appends a null
            /// terminator as the last element of the array, but `git_strarray`
            /// must not include this terminator, otherwise it will cause a
            /// runtime crash when libgit2 tries to read invalid memory.
            for (index, cString) in cStrings.dropLast().enumerated()
            {
                pointers[index] = cString
            }
            
            strArray.strings    = pointers
            strArray.count      = cStrings.count - 1
            
            return try body(&strArray)
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
            let cStrings: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>
                = strArray.strings
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
