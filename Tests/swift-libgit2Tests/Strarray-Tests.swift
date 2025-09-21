//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import SwiftLibgit2



final class StrarrayTests: XCTestCaseStopOnFail
{
    // MARK: - testGitStrarray()
    
    func testGitStrarray() throws
    {
        let strings: [String] = ["hello", "world"]
        
        let strarray = GitStrArray(
            strings:    strings,
            count:      strings.count
        )
        
        XCTAssertEqual(strarray.strings, strings)
        XCTAssertEqual(strarray.count, strings.count)
        
        
        
        strings.withGitStrArray
        {
            strarray in
            
            /// Adjust for the null terminator in `git_strarray`.
            XCTAssertEqual(strarray.pointee.count - 1, strings.count)
            
            guard let cStrings: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?> = strarray.pointee.strings
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
        
        
        
        [].withGitStrArray
        {
            strarray in
            
            XCTAssertNil(strarray.pointee.strings)
            XCTAssertEqual(strarray.pointee.count, 0)
        }
    }
    
    
    
    // MARK: - testGitStrarrayDispose()
    
    func testGitStrarrayDispose() throws
    {
        gitStrarrayDispose(array: nil)
    }
    
    
    
    // MARK: - testGitStrarrayNested()
    
    func testGitStrarrayNested() throws
    {
        let outerArray  : [String]  = ["outer1", "outer2"]
        let innerArray  : [String]  = ["inner1", "inner2"]
        
        outerArray.withGitStrArray
        {
            outerStrarray in
            
            /// Adjust for the null terminator in `git_strarray`.
            XCTAssertEqual(outerStrarray.pointee.count - 1, outerArray.count)
            XCTAssertNotNil(outerStrarray.pointee.strings)
            
            guard let outerCStrings = outerStrarray.pointee.strings
            else
            {
                XCTFail("The outer C strings were nil.")
                return
            }
            
            for (index, swiftString) in outerArray.enumerated()
            {
                guard let cString = String(optionalCString: outerCStrings[index])
                else
                {
                    XCTFail("The C string at index \(index) was nil.")
                    return
                }
                
                XCTAssertEqual(cString, swiftString)
            }
            
            
            
            innerArray.withGitStrArray
            {
                innerStrarray in
                
                /// Adjust for the null terminator in `git_strarray`.
                XCTAssertEqual(innerStrarray.pointee.count - 1, innerArray.count)
                XCTAssertNotNil(innerStrarray.pointee.strings)
                
                guard let innerCStrings = innerStrarray.pointee.strings
                else
                {
                    XCTFail("The inner C strings were nil.")
                    return
                }
                
                for (index, swiftString) in innerArray.enumerated()
                {
                    guard let cString = String(optionalCString: innerCStrings[index])
                    else
                    {
                        XCTFail("The C string at index \(index) was nil.")
                        return
                    }
                    
                    XCTAssertEqual(cString, swiftString)
                }
                
                
                
                /// Test `outerArray` again within the `innerArray` closure.
                /// Adjust for the null terminator in `git_strarray`.
                XCTAssertEqual(outerStrarray.pointee.count - 1, outerArray.count)
                XCTAssertNotNil(outerStrarray.pointee.strings)
                
                guard let outerCStrings = outerStrarray.pointee.strings
                else
                {
                    XCTFail("The outer C strings were nil")
                    return
                }
                
                for (index, swiftString) in outerArray.enumerated()
                {
                    guard let cString = String(optionalCString: outerCStrings[index])
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
