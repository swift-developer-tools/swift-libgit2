//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



internal extension Array where Element == GitConfigLevelT
{
    /// Calls the given closure with a mutable pointer to an array of
    /// `git_config_level_t` instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withArrayOfGitConfigLevels<T>(
        _ body: (UnsafeMutablePointer<git_config_level_t>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        let arrayOfConfigLevels: [git_config_level_t]
            = self.map { $0.cValue() }
        
        return try arrayOfConfigLevels.withUnsafeBufferPointer
        {
            arrayOfConfigLevelsBufferPointer in
            
            guard let baseAddress: UnsafePointer<git_config_level_t>
                    = arrayOfConfigLevelsBufferPointer.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            let mutableBaseAddress: UnsafeMutablePointer<git_config_level_t>
                = UnsafeMutablePointer(mutating: baseAddress)
            
            return try body(
                mutableBaseAddress,
                arrayOfConfigLevels.count
            )
        }
    }
}
