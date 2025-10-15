//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import XCTest
@testable import SwiftLibgit2



final class MessageTests: XCTestCaseStopOnFail
{
    func testGitMessagePrettify() throws
    {
        var data            : Data      = Data()
        let whitespace      : String    = "   "
        let shortMessage    : String    = "Hello World!"
        
        let shortMessagePrettifyResult: GitErrorCode = gitMessagePrettify(
            out:            &data,
            message:        whitespace + shortMessage + whitespace,
            stripComments:  false,
            commentChar:    nil
        )
        
        XCTAssertOK(shortMessagePrettifyResult)
        XCTAssertEqual(data, whitespace + shortMessage + "\n")
        
        
        
        let commentCharacter = CChar(UnicodeScalar("/").value)
        
        var longMessage: String =
        """
        \(shortMessage)
        // Goodbye World!
        """
        
        var longMessagePrettifyResult: GitErrorCode = gitMessagePrettify(
            out:            &data,
            message:        longMessage,
            stripComments:  true,
            commentChar:    commentCharacter
        )
        
        XCTAssertOK(longMessagePrettifyResult)
        XCTAssertEqual(data, shortMessage + "\n")
        
        
        
        longMessage += "\n"
        
        longMessagePrettifyResult = gitMessagePrettify(
            out:            &data,
            message:        longMessage,
            stripComments:  false,
            commentChar:    commentCharacter
        )
        
        XCTAssertOK(longMessagePrettifyResult)
        XCTAssertEqual(data, longMessage)
        
        
        
        /// If `stripComments` is `true`, `commentChar` must not be `nil`.
        let invalidMessagePrettifyResult: GitErrorCode = gitMessagePrettify(
            out:            &data,
            message:        shortMessage,
            stripComments:  true,
            commentChar:    nil
        )
        
        XCTAssertEqual(invalidMessagePrettifyResult, .gitEUser)
    }
    
    
    
    func testGitMessageTrailer() throws
    {
        let messageTrailer = GitMessageTrailer(cValue: git_message_trailer())
        
        XCTAssertNil(messageTrailer.key)
        XCTAssertNil(messageTrailer.value)
        
        messageTrailer.withCValue
        {
            cMessageTrailer in
            
            XCTAssertNil(cMessageTrailer.pointee.key)
            XCTAssertNil(cMessageTrailer.pointee.value)
        }
    }
    
    
    
    func testGitMessageTrailers() throws
    {
        let key     : String    = "Signed-off-by"
        let value1  : String    = "Someone <someone@example.com>"
        let value2  : String    = "Another <another@example.com>"
        
        let message: String =
        """
        Subject
        
        Message
        
        \(key): \(value1)
        \(key): \(value2)
        """
        
        
        
        var arrayOfMessageTrailers: [GitMessageTrailer] = []
        
        let messageTrailersResult: GitErrorCode = gitMessageTrailers(
            arr:        &arrayOfMessageTrailers,
            message:    message
        )
        
        XCTAssertOK(messageTrailersResult)
        XCTAssertEqual(arrayOfMessageTrailers.count, 2)
        XCTAssertEqual(arrayOfMessageTrailers[0].key, key)
        XCTAssertEqual(arrayOfMessageTrailers[0].value, value1)
        XCTAssertEqual(arrayOfMessageTrailers[1].key, key)
        XCTAssertEqual(arrayOfMessageTrailers[1].value, value2)
    }
    
    
    
    func testGitMessageTrailerArrayDispose() throws
    {
        var messageTrailerArray = git_message_trailer_array()
        
        gitMessageTrailerArrayFree(arr: &messageTrailerArray)
        gitMessageTrailerArrayFree(arr: &messageTrailerArray)
        gitMessageTrailerArrayFree(arr: nil)
    }
    
    
    
    func testWithArrayOfGitMessageTrailers() throws
    {
        let arrayOfInvalidMessageTrailers: [GitMessageTrailer] =
        [
            GitMessageTrailer(cValue: git_message_trailer()),
            GitMessageTrailer(cValue: git_message_trailer())
        ]
        
        try arrayOfInvalidMessageTrailers.withArrayOfMessageTrailers
        {
            cArrayOfMessageTrailers, cArrayOfMessageTrailersCount in
            
            XCTAssertNil(cArrayOfMessageTrailers)
            XCTAssertEqual(cArrayOfMessageTrailersCount, 0)
        }
        
        
        
        let key     : String    = "Signed-off-by"
        let value1  : String    = "Someone <someone@example.com>"
        let value2  : String    = "Another <another@example.com>"
        
        try key.withCString
        {
            cKey in
            
            try value1.withCString
            {
                cValue1 in
                
                try value2.withCString
                {
                    cValue2 in
                    
                    let cMessageTrailer1 = git_message_trailer(
                        key:    cKey,
                        value:  cValue1
                    )
                    
                    let cMessageTrailer2 = git_message_trailer(
                        key:    cKey,
                        value:  cValue2
                    )
                    
                    let arrayOfMessageTrailers: [GitMessageTrailer] =
                    [
                        GitMessageTrailer(cValue: cMessageTrailer1),
                        GitMessageTrailer(cValue: cMessageTrailer2)
                    ]
                    
                    
                    
                    try arrayOfMessageTrailers.withArrayOfMessageTrailers
                    {
                        cArrayOfMessageTrailers, cArrayOfMessageTrailersCount in
                        
                        XCTAssertEqual(cArrayOfMessageTrailersCount, arrayOfMessageTrailers.count)
                        
                        guard let cArrayOfMessageTrailers: UnsafePointer<git_message_trailer>
                                = cArrayOfMessageTrailers
                        else
                        {
                            XCTFail("The array of C message trailers was nil.")
                            return
                        }
                        
                        
                        
                        for (index, swiftMessageTrailer) in arrayOfMessageTrailers.enumerated()
                        {
                            let cMessageTrailer: git_message_trailer
                                = cArrayOfMessageTrailers[index]
                            
                            let cKey    = String(optionalCString: cMessageTrailer.key)
                            let cValue  = String(optionalCString: cMessageTrailer.value)
                            
                            XCTAssertEqual(cKey, swiftMessageTrailer.key)
                            XCTAssertEqual(cValue, swiftMessageTrailer.value)
                        }
                    }
                }
            }
        }
        
        
        
        try [].withArrayOfMessageTrailers
        {
            cArrayOfMessageTrailers, cArrayOfMessageTrailersCount in
            
            XCTAssertNil(cArrayOfMessageTrailers)
            XCTAssertEqual(cArrayOfMessageTrailersCount, 0)
        }
    }
    
    
    
    func testWithMutableArrayOfGitMessageTrailers() throws
    {
        let key     : String    = "Signed-off-by"
        let value1  : String    = "Someone <someone@example.com>"
        let value2  : String    = "Another <another@example.com>"
        
        let entries: [String] =
        [
            key,
            value1,
            key,
            value2
        ]
        
        
        
        try key.withCString
        {
            cKey in
            
            try value1.withCString
            {
                cValue1 in
                
                try value2.withCString
                {
                    cValue2 in
                    
                    let cMessageTrailer1 = git_message_trailer(
                        key:    cKey,
                        value:  cValue1
                    )
                    
                    let cMessageTrailer2 = git_message_trailer(
                        key:    cKey,
                        value:  cValue2
                    )
                    
                    var arrayOfMessageTrailers: [GitMessageTrailer] =
                    [
                        GitMessageTrailer(cValue: cMessageTrailer1),
                        GitMessageTrailer(cValue: cMessageTrailer2)
                    ]
                    
                    
                    
                    /// Simulate libgit2 populating the array.
                    try entries.withArrayOfImmutableCStrings
                    {
                        cEntries in
                        
                        try arrayOfMessageTrailers.withMutatingGitMessageTrailerArray
                        {
                            messageTrailerArray in
                            
                            XCTAssertNotNil(messageTrailerArray.pointee.trailers)
                            XCTAssertEqual(messageTrailerArray.pointee.count, 2)
                            
                            messageTrailerArray.pointee.trailers[0].key     = cEntries[0]
                            messageTrailerArray.pointee.trailers[0].value   = cEntries[1]
                            messageTrailerArray.pointee.trailers[1].key     = cEntries[2]
                            messageTrailerArray.pointee.trailers[1].value   = cEntries[3]
                        }
                    }
                    
                    XCTAssertEqual(arrayOfMessageTrailers.count, 2)
                    XCTAssertEqual(arrayOfMessageTrailers[0].key, key)
                    XCTAssertEqual(arrayOfMessageTrailers[0].value, value1)
                    XCTAssertEqual(arrayOfMessageTrailers[1].key, key)
                    XCTAssertEqual(arrayOfMessageTrailers[1].value, value2)
                }
            }
        }
        
        
        
        var emptyArrayOfMessageTrailers: [GitMessageTrailer] = []
        
        try entries.withArrayOfImmutableCStrings
        {
            cEntries in
            
            try emptyArrayOfMessageTrailers.withMutatingGitMessageTrailerArray
            {
                messageTrailerArray in
                
                XCTAssertNil(messageTrailerArray.pointee.trailers)
                XCTAssertEqual(messageTrailerArray.pointee.count, 0)
                
                /// Since the receiver array was empty, `messageTrailerArray`
                /// will be freed with ``gitMessageTrailerArrayFree(arr:)``.
                /// The allocated memory does not need to be freed after being
                /// assigned to `messageTrailerArray.pointee.trailers`.
                let cMessageTrailers = UnsafeMutablePointer<git_message_trailer>
                    .allocate(capacity: 2)
                
                cMessageTrailers[0].key     = cEntries[0]
                cMessageTrailers[0].value   = cEntries[1]
                cMessageTrailers[1].key     = cEntries[2]
                cMessageTrailers[1].value   = cEntries[3]
                
                messageTrailerArray.pointee.trailers    = cMessageTrailers
                messageTrailerArray.pointee.count       = 2
            }
            
            XCTAssertEqual(emptyArrayOfMessageTrailers.count, 2)
            XCTAssertEqual(emptyArrayOfMessageTrailers[0].key, key)
            XCTAssertEqual(emptyArrayOfMessageTrailers[0].value, value1)
            XCTAssertEqual(emptyArrayOfMessageTrailers[1].key, key)
            XCTAssertEqual(emptyArrayOfMessageTrailers[1].value, value2)
        }
    }
}
