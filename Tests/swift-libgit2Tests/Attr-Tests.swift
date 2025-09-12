//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



final class AttrTests: XCTestCaseStopOnFail
{
    // MARK: - testGitAttrAddMacro()
    
    func testGitAttrAddMacro() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attrAddMacroResult: Int32 = gitAttrAddMacro(
                repo:       repository.pointer,
                name:       "testmacro",
                values:     "text eol=crlf"
            )
            
            XCTAssertOK(attrAddMacroResult)
            
            
            
            let macroContent: String = "*.macro testmacro\n"
            
            let gitAttributesURL: URL = repository.url.appending(
                path:           ".gitattributes",
                directoryHint:  .notDirectory
            )
            
            
            
            let existingContent : String    = try String(contentsOf: gitAttributesURL)
            let newContent      : String    = existingContent + macroContent
            
            try newContent.atomicWrite(to: gitAttributesURL)
            
            
            
            let testFileURL: URL = repository.url.appending(
                path:           "test.macro",
                directoryHint:  .notDirectory
            )
            
            try "Macro test file".atomicWrite(to: testFileURL)
            
            
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetResult: Int32 = gitAttrGet(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.macro",
                name:       "text"
            )
            
            XCTAssertOK(attrGetResult)
            XCTAssertTrue(gitAttrIsTrue(attr: valueOut))
        }
    }
    
    
    
    // MARK: - testGitAttrCacheFlush()
    
    func testGitAttrCacheFlush() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attrCacheFlushResult: Int32 = gitAttrCacheFlush(repo: repository.pointer)
            
            XCTAssertOK(attrCacheFlushResult)
            
            
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetResult: Int32 = gitAttrGet(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.txt",
                name:       "text"
            )
            
            XCTAssertOK(attrGetResult)
            XCTAssertTrue(gitAttrIsTrue(attr: valueOut))
        }
    }
    
    
    
    // MARK: - testGitAttrCheckFlags()
    
    func testGitAttrCheckFlags() throws
    {
        XCTAssertEqual(GitAttrCheckFlagsT.gitAttrCheckFileThenIndex.rawValue, UInt32(GIT_ATTR_CHECK_FILE_THEN_INDEX))
        XCTAssertEqual(GitAttrCheckFlagsT.gitAttrCheckIndexThenFile.rawValue, UInt32(GIT_ATTR_CHECK_INDEX_THEN_FILE))
        XCTAssertEqual(GitAttrCheckFlagsT.gitAttrCheckIndexOnly.rawValue, UInt32(GIT_ATTR_CHECK_INDEX_ONLY))
        XCTAssertEqual(GitAttrCheckFlagsT.gitAttrCheckNoSystem.rawValue, UInt32(GIT_ATTR_CHECK_NO_SYSTEM))
        XCTAssertEqual(GitAttrCheckFlagsT.gitAttrCheckIncludeHEAD.rawValue, UInt32(GIT_ATTR_CHECK_INCLUDE_HEAD))
        XCTAssertEqual(GitAttrCheckFlagsT.gitAttrCheckIncludeCommit.rawValue, UInt32(GIT_ATTR_CHECK_INCLUDE_COMMIT))
        XCTAssertEqual(GitAttrCheckFlagsT(rawValue: 123).rawValue, 123)
        
        
        
        let flags: GitAttrCheckFlagsT =
        [
            .gitAttrCheckIndexOnly,
            .gitAttrCheckNoSystem
        ]
        
        XCTAssertTrue(flags.contains(.gitAttrCheckIndexOnly))
        XCTAssertTrue(flags.contains(.gitAttrCheckNoSystem))
        XCTAssertFalse(flags.contains(.gitAttrCheckIncludeCommit))
    }
    
    
    
    // MARK: - testGitAttrForEach()
    
    func testGitAttrForEach() throws
    {
        try gitAttrForEachFlow(options: nil)
    }
    
    
    
    // MARK: - testGitAttrForEachExt()
    
    func testGitAttrForEachExt() throws
    {
        try gitAttrForEachFlow(options: GitAttrOptions())
    }
    
    
    
    // MARK: - testGitAttrGetExt()
    
    func testGitAttrGetExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetExtResult: Int32 = gitAttrGetExt(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                opts:       GitAttrOptions(),
                path:       "data.bin",
                name:       "binary"
            )
            
            XCTAssertOK(attrGetExtResult)
            XCTAssertNotNil(valueOut)
            XCTAssertTrue(gitAttrIsTrue(attr: valueOut))
        }
    }
    
    
    
    // MARK: testGitAttrGetMany()
    
    func testGitAttrGetMany() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = ["text", "eol"]
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: attributeCount)
            
            defer
            {
                valueOut.deinitialize(count: attributeCount)
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyResult: Int32 = gitAttrGetMany(
                valueOut:   valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.txt",
                numAttr:    attributeCount,
                names:      attributeNames
            )
            
            XCTAssertOK(attrGetManyResult)
            
            
            
            let textAttribute: UnsafePointer<CChar>? = valueOut[0]
            
            XCTAssertNotNil(textAttribute)
            XCTAssertTrue(gitAttrIsTrue(attr: textAttribute))
            
            
            
            let eolAttribute: UnsafePointer<CChar>? = valueOut[1]
            
            guard let eolAttribute: UnsafePointer<CChar> = eolAttribute
            else
            {
                XCTFail("The EOL attribute was nil.")
                return
            }
            
            XCTAssertTrue(gitAttrHasValue(attr: eolAttribute))
            XCTAssertEqual(String(cString: eolAttribute), "lf")
        }
    }
    
    
    
    // MARK: testGitAttrGetManyExt()
    
    func testGitAttrGetManyExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = ["custom"]
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: attributeCount)
            
            defer
            {
                valueOut.deinitialize(count: attributeCount)
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyExtResult: Int32 = gitAttrGetManyExt(
                valueOut:   valueOut,
                repo:       repository.pointer,
                opts:       GitAttrOptions(),
                path:       "file.special",
                numAttr:    attributeCount,
                names:      attributeNames
            )
            
            XCTAssertOK(attrGetManyExtResult)
            
            
            
            let customAttribute: UnsafePointer<CChar>? = valueOut[0]
            
            guard let customAttribute: UnsafePointer<CChar> = customAttribute
            else
            {
                XCTFail("The custom attribute was nil.")
                return
            }
            
            XCTAssertTrue(gitAttrHasValue(attr: customAttribute))
            XCTAssertEqual(String(cString: customAttribute), "customvalue")
        }
    }
    
    
    
    // MARK: testGitAttrGetManyWithEmptyArray()
    
    func testGitAttrGetManyWithEmptyArray() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = []
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: attributeCount)
            
            defer
            {
                valueOut.deinitialize(count: attributeCount)
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyResult: Int32 = gitAttrGetMany(
                valueOut:   valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.txt",
                numAttr:    attributeCount,
                names:      attributeNames
            )
            
            XCTAssertOK(attrGetManyResult)
            
            
            
            let firstAttribute: UnsafePointer<CChar>? = valueOut[0]
            
            XCTAssertNil(firstAttribute)
            XCTAssertTrue(gitAttrIsUnspecified(attr: firstAttribute))
        }
    }
    
    
    
    // MARK: testGitAttrGetManyExtWithEmptyArray()
    
    func testGitAttrGetManyExtWithEmptyArray() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = []
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: attributeCount)
            
            defer
            {
                valueOut.deinitialize(count: attributeCount)
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyExtResult: Int32 = gitAttrGetManyExt(
                valueOut:   valueOut,
                repo:       repository.pointer,
                opts:       GitAttrOptions(),
                path:       "file.special",
                numAttr:    attributeCount,
                names:      attributeNames
            )
            
            XCTAssertOK(attrGetManyExtResult)
            
            
            
            let firstAttribute: UnsafePointer<CChar>? = valueOut[0]
            
            XCTAssertNil(firstAttribute)
            XCTAssertTrue(gitAttrIsUnspecified(attr: firstAttribute))
        }
    }
    
    
    
    // MARK: - testGitAttrMacros()
    
    func testGitAttrMacros() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            var attrGetResult: Int32 = gitAttrGet(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.txt",
                name:       "text"
            )
            
            XCTAssertOK(attrGetResult)
            XCTAssertEqual(gitAttrValue(attr: valueOut), .gitAttrValueTrue)
            XCTAssertTrue(gitAttrIsTrue(attr: valueOut))
            XCTAssertFalse(gitAttrIsFalse(attr: valueOut))
            XCTAssertFalse(gitAttrIsUnspecified(attr: valueOut))
            XCTAssertFalse(gitAttrHasValue(attr: valueOut))
            
            
            
            attrGetResult = gitAttrGet(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "negative.false",
                name:       "text"
            )
            
            XCTAssertOK(attrGetResult)
            XCTAssertEqual(gitAttrValue(attr: valueOut), .gitAttrValueFalse)
            XCTAssertFalse(gitAttrIsTrue(attr: valueOut))
            XCTAssertTrue(gitAttrIsFalse(attr: valueOut))
            XCTAssertFalse(gitAttrIsUnspecified(attr: valueOut))
            XCTAssertFalse(gitAttrHasValue(attr: valueOut))
            
            
            
            attrGetResult = gitAttrGet(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "file.special",
                name:       "custom"
            )
            
            XCTAssertOK(attrGetResult)
            XCTAssertEqual(gitAttrValue(attr: valueOut), .gitAttrValueString)
            XCTAssertFalse(gitAttrIsTrue(attr: valueOut))
            XCTAssertFalse(gitAttrIsFalse(attr: valueOut))
            XCTAssertFalse(gitAttrIsUnspecified(attr: valueOut))
            XCTAssertTrue(gitAttrHasValue(attr: valueOut))
            
            
            
            attrGetResult = gitAttrGet(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.txt",
                name:       "nonexistent"
            )
            
            XCTAssertOK(attrGetResult)
            XCTAssertEqual(gitAttrValue(attr: valueOut), .gitAttrValueUnspecified)
            XCTAssertFalse(gitAttrIsTrue(attr: valueOut))
            XCTAssertFalse(gitAttrIsFalse(attr: valueOut))
            XCTAssertTrue(gitAttrIsUnspecified(attr: valueOut))
            XCTAssertFalse(gitAttrHasValue(attr: valueOut))
        }
    }
    
    
    
    // MARK: - testGitAttrOptions()
    
    func testGitAttrOptions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var attrOptions = GitAttrOptions()
            
            XCTAssertEqual(attrOptions.version, gitAttrOptionsVersion)
            XCTAssertEqual(attrOptions.flags, [])
            XCTAssertNil(attrOptions.commitID)
            XCTAssertNotNil(attrOptions.attrCommitID)
            
            XCTAssertEqual(gitAttrOptionsVersion, UInt32(GIT_ATTR_OPTIONS_VERSION))
            
            
            
            attrOptions.flags = GitAttrCheckFlagsT(rawValue: 123)
            
            XCTAssertEqual(attrOptions.flags, GitAttrCheckFlagsT(rawValue: 123))
            
            
            
            attrOptions.flags =
            [
                .gitAttrCheckIndexOnly,
                .gitAttrCheckNoSystem
            ]
            
            XCTAssertTrue(attrOptions.flags.contains(.gitAttrCheckIndexOnly))
            XCTAssertTrue(attrOptions.flags.contains(.gitAttrCheckNoSystem))
            XCTAssertFalse(attrOptions.flags.contains(.gitAttrCheckIncludeHEAD))
            
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetExtResult: Int32 = gitAttrGetExt(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                opts:       attrOptions,
                path:       "test.txt",
                name:       "text"
            )
            
            XCTAssertOK(attrGetExtResult)
        }
    }
    
    
    
    // MARK: - testGitAttrValueT()
    
    func testGitAttrValueT() throws
    {
        XCTAssertEqual(GitAttrValueT.gitAttrValueUnspecified.rawValue, GIT_ATTR_VALUE_UNSPECIFIED.rawValue)
        XCTAssertEqual(GitAttrValueT.gitAttrValueTrue.rawValue, GIT_ATTR_VALUE_TRUE.rawValue)
        XCTAssertEqual(GitAttrValueT.gitAttrValueFalse.rawValue, GIT_ATTR_VALUE_FALSE.rawValue)
        XCTAssertEqual(GitAttrValueT.gitAttrValueString.rawValue, GIT_ATTR_VALUE_STRING.rawValue)
        XCTAssertNil(GitAttrValueT(rawValue: 123))
        
        XCTAssertEqual(GitAttrValueT.gitAttrValueUnspecified.cValue, GIT_ATTR_VALUE_UNSPECIFIED)
        XCTAssertEqual(GitAttrValueT.gitAttrValueTrue.cValue, GIT_ATTR_VALUE_TRUE)
        XCTAssertEqual(GitAttrValueT.gitAttrValueFalse.cValue, GIT_ATTR_VALUE_FALSE)
        XCTAssertEqual(GitAttrValueT.gitAttrValueString.cValue, GIT_ATTR_VALUE_STRING)
        
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_UNSPECIFIED), .gitAttrValueUnspecified)
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_TRUE), .gitAttrValueTrue)
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_FALSE), .gitAttrValueFalse)
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_STRING), .gitAttrValueString)
    }
}



extension AttrTests
{
    // MARK: - gitAttrForEachFlow()

    /// Tests looping over all the attributes in the given path, with or without extended options.
    /// - Parameter options: The options to use when querying the attributes.
    /// - Throws: An `Error` if repository initialization fails.
    private func gitAttrForEachFlow(
        options: GitAttrOptions?
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var attributes: [String : String] = [:]
            
            let callback: GitAttrForEachCB =
            {
                cName, cValue, cPayload in
                
                guard
                    let cName       : UnsafePointer<CChar>      = cName,
                    let cValue      : UnsafePointer<CChar>      = cValue,
                    let cPayload    : UnsafeMutableRawPointer   = cPayload
                else
                {
                    return GIT_OK.rawValue
                }
                
                
                
                let name    = String(cString: cName)
                let value   = String(cString: cValue)
                
                
                
                let payloadPointer: UnsafeMutablePointer<[String : String]>
                    = cPayload.assumingMemoryBound(to: [String : String].self)
                
                payloadPointer.pointee[name] = value
                
                
                
                return GIT_OK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &attributes)
            {
                attributesPointer in
                
                if let options: GitAttrOptions = options
                {
                    let attrForEachExtResult: Int32 = gitAttrForEachExt(
                        repo:       repository.pointer,
                        opts:       options,
                        path:       "test.txt",
                        callback:   callback,
                        payload:    UnsafeMutableRawPointer(attributesPointer)
                    )
                    
                    XCTAssertOK(attrForEachExtResult)
                }
                else
                {
                    let attrForEachResult: Int32 = gitAttrForEach(
                        repo:       repository.pointer,
                        flags:      .gitAttrCheckFileThenIndex,
                        path:       "test.txt",
                        callback:   callback,
                        payload:    UnsafeMutableRawPointer(attributesPointer)
                    )
                    
                    XCTAssertOK(attrForEachResult)
                }
            }
            
            
            
            XCTAssertGreaterThan(attributes.keys.count, 0)
            XCTAssertTrue(attributes.keys.contains("text"))
        }
    }
}
