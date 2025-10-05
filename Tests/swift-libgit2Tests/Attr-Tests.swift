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



final class AttrTests: XCTestCaseStopOnFail
{
    func testGitAttrAddMacro() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attrAddMacroResult: GitErrorCode = gitAttrAddMacro(
                repo:       repository.pointer,
                name:       "testmacro",
                values:     "text eol=crlf"
            )
            
            XCTAssertOK(attrAddMacroResult)
            
            
            
            try repository.modifyFile(
                path:       ".gitattributes",
                content:    "*.macro testmacro\n",
                append:     true
            )
            
            try repository.modifyFile(
                path:       "test.macro",
                content:    "Macro test file"
            )
            
            
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetResult: GitErrorCode = gitAttrGet(
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
    
    
    
    func testGitAttrCacheFlush() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attrCacheFlushResult: GitErrorCode = gitAttrCacheFlush(repo: repository.pointer)
            
            XCTAssertOK(attrCacheFlushResult)
            
            
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetResult: GitErrorCode = gitAttrGet(
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
    
    
    
    func testGitAttrForEach() throws
    {
        try testGitAttrForEachFlow(options: nil)
    }
    
    
    
    func testGitAttrForEachExt() throws
    {
        try testGitAttrForEachFlow(options: GitAttrOptions())
    }
    
    
    
    func testGitAttrGetExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetExtResult: GitErrorCode = gitAttrGetExt(
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
    
    
    
    func testGitAttrGetMany() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = ["text", "eol"]
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(
                capacity: attributeCount
            )
            
            defer
            {
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyResult: GitErrorCode = gitAttrGetMany(
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
            
            guard let eolAttributeString = String(optionalCString: eolAttribute)
            else
            {
                XCTFail("The EOL attribute string was nil.")
                return
            }
            
            XCTAssertEqual(eolAttributeString, "lf")
        }
    }
    
    
    
    func testGitAttrGetManyExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = ["custom"]
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(
                capacity: attributeCount
            )
            
            defer
            {
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyExtResult: GitErrorCode = gitAttrGetManyExt(
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
            
            guard let customAttributeString = String(optionalCString: customAttribute)
            else
            {
                XCTFail("The custom attribute string was nil.")
                return
            }
            
            XCTAssertEqual(customAttributeString, "customvalue")
        }
    }
    
    
    
    func testGitAttrGetManyWithEmptyArray() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = []
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(
                capacity: attributeCount
            )
            
            defer
            {
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyResult: GitErrorCode = gitAttrGetMany(
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
    
    
    
    func testGitAttrGetManyExtWithEmptyArray() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attributeNames  : [String]  = []
            let attributeCount  : Int       = attributeNames.count
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(
                capacity: attributeCount
            )
            
            defer
            {
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyExtResult: GitErrorCode = gitAttrGetManyExt(
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
    
    
    
    func testGitAttrMacros() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            var attrGetResult: GitErrorCode = gitAttrGet(
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
    
    
    
    func testGitAttrOptions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let attrOptions = GitAttrOptions()
            
            XCTAssertEqual(attrOptions.version, gitAttrOptionsVersion)
            XCTAssertEqual(attrOptions.flags, [])
            XCTAssertNil(attrOptions.commitID)
            XCTAssertZeroOID(attrOptions.attrCommitID)
            
            XCTAssertEqual(gitAttrOptionsVersion, UInt32(GIT_ATTR_OPTIONS_VERSION))
            
            attrOptions.withCValue
            {
                cAttrOptions in
                
                XCTAssertEqual(cAttrOptions.pointee.version, gitAttrOptionsVersion)
                XCTAssertEqual(cAttrOptions.pointee.flags, 0)
                XCTAssertNil(cAttrOptions.pointee.commit_id)
                XCTAssertZeroOID(GitOID(cValue: cAttrOptions.pointee.attr_commit_id))
            }
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetExtResult: GitErrorCode = gitAttrGetExt(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                opts:       attrOptions,
                path:       "test.txt",
                name:       "text"
            )
            
            XCTAssertOK(attrGetExtResult)
        }
    }
    
    
    
    func testGitAttrValueT() throws
    {
        XCTAssertEqual(GitAttrValueT.gitAttrValueUnspecified.rawValue, GIT_ATTR_VALUE_UNSPECIFIED.rawValue)
        XCTAssertEqual(GitAttrValueT.gitAttrValueTrue.rawValue, GIT_ATTR_VALUE_TRUE.rawValue)
        XCTAssertEqual(GitAttrValueT.gitAttrValueFalse.rawValue, GIT_ATTR_VALUE_FALSE.rawValue)
        XCTAssertEqual(GitAttrValueT.gitAttrValueString.rawValue, GIT_ATTR_VALUE_STRING.rawValue)
        XCTAssertNil(GitAttrValueT(rawValue: 123))
        
        XCTAssertEqual(GitAttrValueT.gitAttrValueUnspecified.cValue(), GIT_ATTR_VALUE_UNSPECIFIED)
        XCTAssertEqual(GitAttrValueT.gitAttrValueTrue.cValue(), GIT_ATTR_VALUE_TRUE)
        XCTAssertEqual(GitAttrValueT.gitAttrValueFalse.cValue(), GIT_ATTR_VALUE_FALSE)
        XCTAssertEqual(GitAttrValueT.gitAttrValueString.cValue(), GIT_ATTR_VALUE_STRING)
        
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_UNSPECIFIED), .gitAttrValueUnspecified)
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_TRUE), .gitAttrValueTrue)
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_FALSE), .gitAttrValueFalse)
        XCTAssertEqual(GitAttrValueT(cValue: GIT_ATTR_VALUE_STRING), .gitAttrValueString)
    }
}



// MARK: - Extensions

extension AttrTests
{
    /// Tests looping over all the attributes in the given path, with or without extended options.
    /// - Parameter options: The options to use when querying the attributes.
    /// - Throws: An error if repository initialization fails.
    private func testGitAttrForEachFlow(
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
                    let name        : String                    = String(optionalCString: cName),
                    let value       : String                    = String(optionalCString: cValue),
                    let cPayload    : UnsafeMutableRawPointer   = cPayload
                else
                {
                    return GitErrorCode.gitOK.rawValue
                }
                
                
                
                let payloadPointer: UnsafeMutablePointer<[String : String]>
                    = cPayload.assumingMemoryBound(to: [String : String].self)
                
                payloadPointer.pointee[name] = value
                
                
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &attributes)
            {
                attributesPointer in
                
                if let options: GitAttrOptions = options
                {
                    let attrForEachExtResult: GitErrorCode = gitAttrForEachExt(
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
                    let attrForEachResult: GitErrorCode = gitAttrForEach(
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
