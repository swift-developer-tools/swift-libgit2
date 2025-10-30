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
                values:     "text eol=\(gitFilterCRLF)"
            )
            
            XCTAssertOK(attrAddMacroResult)
            
            
            
            try repository.modifyFile(
                at:         ".gitattributes",
                with:       "*.macro testmacro\n",
                appending:  true
            )
            
            try repository.modifyFile(
                at:     "test.macro",
                with:   "Macro test file"
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
            
            let attrCacheFlushResult: GitErrorCode
                = gitAttrCacheFlush(repo: repository.pointer)
            
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
    
    
    
    func testGitAttrCheckFlagsT() throws
    {
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckFileThenIndex.rawValue), GIT_ATTR_CHECK_FILE_THEN_INDEX)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIndexThenFile.rawValue), GIT_ATTR_CHECK_INDEX_THEN_FILE)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIndexOnly.rawValue), GIT_ATTR_CHECK_INDEX_ONLY)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckNoSystem.rawValue), GIT_ATTR_CHECK_NO_SYSTEM)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIncludeHEAD.rawValue), GIT_ATTR_CHECK_INCLUDE_HEAD)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIncludeCommit.rawValue), GIT_ATTR_CHECK_INCLUDE_COMMIT)
        
        XCTAssertEqual(GitAttrCheckFlagsT(rawValue: 123).rawValue, 123)
        
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckFileThenIndex.cValue()), GIT_ATTR_CHECK_FILE_THEN_INDEX)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIndexThenFile.cValue()), GIT_ATTR_CHECK_INDEX_THEN_FILE)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIndexOnly.cValue()), GIT_ATTR_CHECK_INDEX_ONLY)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckNoSystem.cValue()), GIT_ATTR_CHECK_NO_SYSTEM)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIncludeHEAD.cValue()), GIT_ATTR_CHECK_INCLUDE_HEAD)
        XCTAssertEqual(Int32(GitAttrCheckFlagsT.gitAttrCheckIncludeCommit.cValue()), GIT_ATTR_CHECK_INCLUDE_COMMIT)
        
        XCTAssertEqual(GitAttrCheckFlagsT(cValue: UInt32(GIT_ATTR_CHECK_FILE_THEN_INDEX)), .gitAttrCheckFileThenIndex)
        XCTAssertEqual(GitAttrCheckFlagsT(cValue: UInt32(GIT_ATTR_CHECK_INDEX_THEN_FILE)), .gitAttrCheckIndexThenFile)
        XCTAssertEqual(GitAttrCheckFlagsT(cValue: UInt32(GIT_ATTR_CHECK_INDEX_ONLY)), .gitAttrCheckIndexOnly)
        XCTAssertEqual(GitAttrCheckFlagsT(cValue: UInt32(GIT_ATTR_CHECK_NO_SYSTEM)), .gitAttrCheckNoSystem)
        XCTAssertEqual(GitAttrCheckFlagsT(cValue: UInt32(GIT_ATTR_CHECK_INCLUDE_HEAD)), .gitAttrCheckIncludeHEAD)
        XCTAssertEqual(GitAttrCheckFlagsT(cValue: UInt32(GIT_ATTR_CHECK_INCLUDE_COMMIT)), .gitAttrCheckIncludeCommit)
        
        
        
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
        try Repository.withRepository
        {
            repository in
            
            var attributes: [String : String] = [:]
            
            withUnsafeMutablePointer(to: &attributes)
            {
                attributesPointer in
                
                let attrForEachResult: GitErrorCode = gitAttrForEach(
                    repo:       repository.pointer,
                    flags:      .gitAttrCheckFileThenIndex,
                    path:       "test.txt",
                    callback:   Self.attrForEachCB,
                    payload:    UnsafeMutableRawPointer(attributesPointer)
                )
                
                XCTAssertOK(attrForEachResult)
            }
            
            XCTAssertGreaterThan(attributes.keys.count, 0)
            XCTAssertTrue(attributes.keys.contains("text"))
        }
    }
    
    
    
    func testGitAttrForEachExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var attributes: [String : String] = [:]
            
            withUnsafeMutablePointer(to: &attributes)
            {
                attributesPointer in
                
                let attrForEachExtResult: GitErrorCode = gitAttrForEachExt(
                    repo:       repository.pointer,
                    opts:       nil,
                    path:       "test.txt",
                    callback:   Self.attrForEachCB,
                    payload:    UnsafeMutableRawPointer(attributesPointer)
                )
                
                XCTAssertOK(attrForEachExtResult)
            }
            
            XCTAssertGreaterThan(attributes.keys.count, 0)
            XCTAssertTrue(attributes.keys.contains("text"))
        }
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
                opts:       nil,
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
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>
                .allocate(capacity: attributeCount)
            
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
            
            
            
            let valueOut = UnsafeMutablePointer<UnsafePointer<CChar>?>
                .allocate(capacity: attributeCount)
            
            defer
            {
                valueOut.deallocate()
            }
            
            
            
            let attrGetManyExtResult: GitErrorCode = gitAttrGetManyExt(
                valueOut:   valueOut,
                repo:       repository.pointer,
                opts:       nil,
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
            
            guard let customAttributeString
                = String(optionalCString: customAttribute)
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
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetManyResult: GitErrorCode = gitAttrGetMany(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                flags:      .gitAttrCheckFileThenIndex,
                path:       "test.txt",
                numAttr:    0,
                names:      []
            )
            
            XCTAssertOK(attrGetManyResult)
        }
    }
    
    
    
    func testGitAttrGetManyExtWithEmptyArray() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var valueOut: UnsafePointer<CChar>? = nil
            
            let attrGetManyExtResult: GitErrorCode = gitAttrGetManyExt(
                valueOut:   &valueOut,
                repo:       repository.pointer,
                opts:       GitAttrOptions(),
                path:       "file.special",
                numAttr:    0,
                names:      []
            )
            
            XCTAssertOK(attrGetManyExtResult)
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
            
            try attrOptions.withCValue
            {
                cAttrOptions in
                
                XCTAssertEqual(cAttrOptions.pointee.version, gitAttrOptionsVersion)
                XCTAssertEqual(GitAttrCheckFlagsT(rawValue: cAttrOptions.pointee.flags), [])
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
    
    
    
    func testGitAttrOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitAttrOptionsVersion), GIT_ATTR_OPTIONS_VERSION)
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

private extension AttrTests
{
    static let attrForEachCB: GitAttrForEachCB =
    {
        name, value, payload in
        
        guard
            let payload: UnsafeMutableRawPointer = payload,
            let name    = String(optionalCString: name),
            let value   = String(optionalCString: value)
        else
        {
            XCTFail("All or some callback parameters were nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<[String : String]>
            = payload.assumingMemoryBound(to: [String : String].self)
        
        payloadPointer.pointee[name] = value
        
        return GitErrorCode.gitOK.rawValue
    }
}
