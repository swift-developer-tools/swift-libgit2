//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Foundation



internal extension String
{
    /// Creates a new string from the given fixed-size C character array.
    /// - Parameters:
    ///   - cArray: The fixed-size C character array.
    ///   - count: The number of meaningful bytes. Pass `nil` to scan for the
    ///   null terminator.
    ///
    /// ## Discussion
    ///
    /// Use this initializer to convert fixed-size C character arrays.
    ///
    /// When a length field is available in the C struct, pass it as the
    /// `count` parameter for better performance. Otherwise, the array must
    /// be null-terminated.
    ///
    /// This initializer is failable rather than returning an empty string.
    /// Although a fixed-size C character array will never be `nil`, the array
    /// could contain meaningless zero-initialized fields, unpopulated fields
    /// after an error, or empty values. In these cases, `nil` is more
    /// semantically correct than an empty string. Similarly, while libgit2
    /// should generally provide valid UTF-8 data, the encoding may fail in
    /// some scenarios.
    ///
    /// - Note: A generic type is used for `cArray` because Swift represents
    /// fixed-size C character arrays as `CChar` tuples. The generic type
    /// allows this initializer to accept arrays of any length.
    init?<T>(
        cArray  : T,
        count   : Int?  = nil
    )
    {
        let string: String? = withUnsafeBytes(of: cArray)
        {
            bytes in
            
            if let count: Int = count
            {
                guard count > 0
                else
                {
                    return ""
                }
                
                return bytes.withMemoryRebound(to: UInt8.self)
                {
                    pointer in
                    
                    guard let baseAddress: UnsafePointer<UInt8>
                            = pointer.baseAddress
                    else
                    {
                        return nil
                    }
                    
                    return String(
                        bytes:      UnsafeBufferPointer(
                                        start: baseAddress,
                                        count: count
                                    ),
                        encoding:   .utf8
                    )
                }
            }
            
            return bytes.withMemoryRebound(to: CChar.self)
            {
                pointer in
                
                return String(optionalCString: pointer.baseAddress)
            }
        }
        
        
        
        guard let string: String = string
        else
        {
            return nil
        }
        
        self = string
    }
    
    
    
    /// Copies the receiver string into a fixed-size C character array buffer.
    /// - Parameters:
    ///   - cArray: The pointer to the destination buffer.
    ///   - byteCount: The size of the destination buffer, including space for
    ///   the null terminator.
    ///
    /// ## Discussion
    ///
    /// Use this method to populate fixed-size C character array fields.
    /// The string content will be truncated if it exceeds `byteCount - 1`.
    ///
    /// - Important: The destination buffer must have at least `byteCount`
    /// bytes of allocated memory. This method will zero the entire buffer
    /// before copying to ensure a clean state.
    func copyMemory(
        to cArray   : UnsafeMutablePointer<CChar>,
        byteCount   : Int
    )
    {
        guard byteCount >= 0
        else
        {
            return
        }
        
        self.withCString
        {
            cString in
            
            memset(
                cArray,
                0,
                byteCount
            )
            
            /// Leave space for the null terminator.
            let copyLength: Int = min(
                strlen(cString),
                byteCount - 1
            )
            
            if copyLength > 0
            {
                _ = memcpy(
                    cArray,
                    cString,
                    copyLength
                )
            }
            
            cArray[copyLength] = 0
        }
    }
}
