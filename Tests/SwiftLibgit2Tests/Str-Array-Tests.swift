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
@testable import SwiftLibgit2TestUtilities



final class StrArrayTests: XCTestCaseStopOnFail
{
    func testGitStrArrayDispose() throws
    {
        var strArray = git_strarray()
        
        gitStrArrayDispose(array: &strArray)
        gitStrArrayDispose(array: &strArray)
        gitStrArrayDispose(array: nil)
    }
    
    
    
    func testWithGitStrArray() throws
    {
        let strings: [String] = ["hello", "world"]
        
        try strings.withGitStrArray
        {
            strArray in
            
            XCTAssertEqual(strArray.pointee.count, strings.count)
            
            guard let cStrings: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>
                    = strArray.pointee.strings
            else
            {
                XCTFail("The C strings were nil.")
                return
            }
            
            
            
            for (index, swiftString) in strings.enumerated()
            {
                guard let cString = String(optionalCString: cStrings[index])
                else
                {
                    XCTFail("The C string at index \(index) was nil.")
                    return
                }
                
                XCTAssertEqual(cString, swiftString)
            }
        }
        
        
        
        try [].withGitStrArray
        {
            strArray in
            
            XCTAssertNil(strArray.pointee.strings)
            XCTAssertEqual(strArray.pointee.count, 0)
        }
    }
    
    
    
    func testWithGitStrArrayNested() throws
    {
        let outerArray  : [String]  = ["outer1", "outer2"]
        let innerArray  : [String]  = ["inner1", "inner2"]
        
        try outerArray.withGitStrArray
        {
            outerStrArray in
            
            XCTAssertEqual(outerStrArray.pointee.count, outerArray.count)
            XCTAssertNotNil(outerStrArray.pointee.strings)
            
            guard let outerCStrings = outerStrArray.pointee.strings
            else
            {
                XCTFail("The outer C strings were nil.")
                return
            }
            
            for (index, swiftString) in outerArray.enumerated()
            {
                guard let cString
                        = String(optionalCString: outerCStrings[index])
                else
                {
                    XCTFail("The C string at index \(index) was nil.")
                    return
                }
                
                XCTAssertEqual(cString, swiftString)
            }
            
            
            
            try innerArray.withGitStrArray
            {
                innerStrArray in
                
                XCTAssertEqual(innerStrArray.pointee.count, innerArray.count)
                XCTAssertNotNil(innerStrArray.pointee.strings)
                
                guard let innerCStrings = innerStrArray.pointee.strings
                else
                {
                    XCTFail("The inner C strings were nil.")
                    return
                }
                
                for (index, swiftString) in innerArray.enumerated()
                {
                    guard let cString
                            = String(optionalCString: innerCStrings[index])
                    else
                    {
                        XCTFail("The C string at index \(index) was nil.")
                        return
                    }
                    
                    XCTAssertEqual(cString, swiftString)
                }
                
                
                
                /// Test `outerArray` again within the `innerArray` closure.
                XCTAssertEqual(outerStrArray.pointee.count, outerArray.count)
                XCTAssertNotNil(outerStrArray.pointee.strings)
                
                guard let outerCStrings = outerStrArray.pointee.strings
                else
                {
                    XCTFail("The outer C strings were nil")
                    return
                }
                
                for (index, swiftString) in outerArray.enumerated()
                {
                    guard let cString
                            = String(optionalCString: outerCStrings[index])
                    else
                    {
                        XCTFail("The C string at index \(index) was nil.")
                        return
                    }
                    
                    XCTAssertEqual(cString, swiftString)
                }
            }
        }
    }
}
