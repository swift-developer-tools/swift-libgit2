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



final class OIDTests: XCTestCaseStopOnFail
{
    func testGitOID() throws
    {
        let oid = GitOID()
        
        XCTAssertZeroOID(oid)
        XCTAssertEqual(oid.id.count, GitOID.size)
        
        oid.withCValue
        {
            cOID in
            
            XCTAssertZeroOID(GitOID(cValue: cOID.pointee))
        }
    }
    
    
    
    func testGitOIDCmpAndEqual() throws
    {
        try withHEADOID
        {
            repository, headOID, headOIDString in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            var oidsEqual: Bool = gitOIDEqual(
                a:  firstCommitOID,
                b:  firstCommitOID
            )
            
            XCTAssertTrue(oidsEqual)
            
            
            
            oidsEqual = gitOIDEqual(
                a:  secondCommitOID,
                b:  secondCommitOID
            )
            
            XCTAssertTrue(oidsEqual)
            
            
            
            oidsEqual = gitOIDEqual(
                a:  firstCommitOID,
                b:  secondCommitOID
            )
            
            XCTAssertFalse(oidsEqual)
            
            
            
            var oidCmpResult: Int = gitOIDCmp(
                a:  firstCommitOID,
                b:  firstCommitOID
            )
            
            XCTAssertEqual(oidCmpResult, 0)
            
            
            
            oidCmpResult = gitOIDCmp(
                a:  firstCommitOID,
                b:  secondCommitOID
            )
            
            XCTAssertTrue(oidCmpResult == 1 || oidCmpResult == -1)
            
            
            
            let reverseOIDCmpResult: Int = gitOIDCmp(
                a:  firstCommitOID,
                b:  secondCommitOID
            )
            
            XCTAssertNotEqual(reverseOIDCmpResult, -oidCmpResult)
        }
    }



    func testGitOIDCpy() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            var copiedOID = GitOID()
            
            let oidCpyResult: GitErrorCode = gitOIDCpy(
                out:    &copiedOID,
                src:    headOID
            )
            
            XCTAssertOK(oidCpyResult)
            XCTAssertEqual(copiedOID, headOID)
        }
    }
    
    
    
    func testGitOIDDefault() throws
    {
        XCTAssertEqual(gitOIDDefault, .gitOIDSHA1)
    }
    
    
    
    func testGitOIDFmt() throws
    {
        try withHEADOID
        {
            _, headOID, _ in
            
            let bufferSize: Int = gitOIDSHA1HexSize + 1
            
            let buffer = UnsafeMutablePointer<CChar>
                .allocate(capacity: bufferSize)
            
            buffer.initialize(
                repeating:  0,
                count:      bufferSize
            )
            
            defer
            {
                buffer.deinitialize(count: bufferSize)
                buffer.deallocate()
            }
            
            
            
            let oidFmtResult: GitErrorCode = gitOIDFmt(
                out:    buffer,
                id:     headOID
            )
            
            XCTAssertOK(oidFmtResult)
            
            
            
            buffer[gitOIDSHA1HexSize] = 0
            
            let formattedString: String? = String(optionalCString: buffer)
            
            XCTAssertNotNil(formattedString)
            XCTAssertEqual(formattedString?.count, gitOIDSHA1HexSize)
            
            
            
            let expectedString: String? = gitOIDToStrS(oid: headOID)
            
            XCTAssertNotNil(expectedString)
            XCTAssertEqual(formattedString, expectedString)
        }
    }
    
    
    
    func testGitOIDFromRaw() throws
    {
        try withHEADOID
        {
            _, headOID, _ in
            
            let rawData: Data = headOID.id
            
            XCTAssertEqual(rawData.count, gitOIDSHA1Size)
            
            
            
            var parsedOID = GitOID()
            
            let oidFromRawResult: GitErrorCode = gitOIDFromRaw(
                out:    &parsedOID,
                raw:    rawData
            )
            
            XCTAssertOK(oidFromRawResult)
            XCTAssertEqual(parsedOID, headOID)
        }
    }
    
    
    
    func testGitOIDFromStrAndToStrS() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            var parsedOID = GitOID()
            
            let oidFromStrResult: GitErrorCode = gitOIDFromStr(
                out:    &parsedOID,
                str:    headOIDString
            )
            
            XCTAssertOK(oidFromStrResult)
            XCTAssertEqual(parsedOID, headOID)
        }
    }
    
    
    
    func testGitOIDFromStrP() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            let prefixLength: Int = 7
            
            let partialOIDString = String(headOIDString.prefix(prefixLength))
            
            
            
            var parsedOID = GitOID()
            
            let oidFromStrPResult: GitErrorCode = gitOIDFromStrP(
                out:    &parsedOID,
                str:    partialOIDString
            )
            
            XCTAssertOK(oidFromStrPResult)
            XCTAssertNotEqual(parsedOID, headOID)
            
            
            
            let oidPrefixesEqual: Bool = gitOIDNCmp(
                a:      headOID,
                b:      parsedOID,
                len:    prefixLength
            )
            
            XCTAssertTrue(oidPrefixesEqual)
        }
    }
    
    
    
    func testGitOIDFromStrN() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            let evenPrefixLength: Int = 10
            
            var parsedOID = GitOID()
            
            let evenOIDFromStrNResult: GitErrorCode = gitOIDFromStrN(
                out:        &parsedOID,
                str:        headOIDString,
                length:     evenPrefixLength
            )
            
            XCTAssertOK(evenOIDFromStrNResult)
            XCTAssertNotEqual(parsedOID, headOID)
            
            
            
            let oddOIDPrefixesEqual: Bool = gitOIDNCmp(
                a:      parsedOID,
                b:      headOID,
                len:    evenPrefixLength
            )
            
            XCTAssertTrue(oddOIDPrefixesEqual)
            
            
            
            parsedOID = GitOID()
            
            let oddPrefixLength: Int = evenPrefixLength - 1
            
            let oddOIDFromStrNResult: GitErrorCode = gitOIDFromStrN(
                out:        &parsedOID,
                str:        headOIDString,
                length:     oddPrefixLength
            )
            
            XCTAssertOK(oddOIDFromStrNResult)
            XCTAssertNotEqual(parsedOID, headOID)
            
            
            
            let evenOIDPrefixesEqual: Bool = gitOIDNCmp(
                a:      parsedOID,
                b:      headOID,
                len:    oddPrefixLength
            )
            
            XCTAssertTrue(evenOIDPrefixesEqual)
        }
    }
    
    
    
    func testGitOIDIsZero() throws
    {
        var isOIDZero: Bool = gitOIDIsZero(id: GitOID())
        
        XCTAssertTrue(isOIDZero)
        
        
        
        try withHEADOID
        {
            _, headOID, _ in
            
            isOIDZero = gitOIDIsZero(id: headOID)
            
            XCTAssertFalse(isOIDZero)
        }
        
        
        
        isOIDZero = gitOIDIsZero(id: gitOIDSHA1Zero)
        
        XCTAssertTrue(isOIDZero)
    }
    
    
    
    func testGitOIDMaxSize() throws
    {
        XCTAssertEqual(Int32(gitOIDMaxSize), GIT_OID_MAX_SIZE)
    }
    
    
    
    func testGitOIDMaxHexSize() throws
    {
        XCTAssertEqual(Int32(gitOIDMaxHexSize), GIT_OID_MAX_HEXSIZE)
    }
    
    
    
    func testGitOIDMinPrefixLen() throws
    {
        XCTAssertEqual(Int32(gitOIDMinPrefixLen), GIT_OID_MINPREFIXLEN)
    }
    
    
    
    func testGitOIDNCmp() throws
    {
        try withHEADOID
        {
            repository, headOID, _ in
            
            let otherCommitOID: GitOID = try repository.commit(
                "Other content",
                toFile:     "other.txt",
                message:    "Other commit"
            )
            
            
            
            let prefixLength: Int = 7
            
            let oidPrefixesEqual: Bool = gitOIDNCmp(
                a:      headOID,
                b:      headOID,
                len:    prefixLength
            )
            
            XCTAssertTrue(oidPrefixesEqual)
            
            
            
            let oidsEqualNCmp: Bool = gitOIDNCmp(
                a:      headOID,
                b:      otherCommitOID,
                len:    gitOIDSHA1HexSize
            )
            
            XCTAssertFalse(oidsEqualNCmp)
            
            
            
            let oidsEqual: Bool = gitOIDEqual(
                a:  headOID,
                b:  otherCommitOID
            )
            
            XCTAssertFalse(oidsEqual)
        }
    }
    
    
    
    func testGitOIDNFmt() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            let bufferSize: Int = gitOIDSHA1HexSize + 1
            
            let buffer = UnsafeMutablePointer<CChar>
                .allocate(capacity: bufferSize)
            
            buffer.initialize(
                repeating:  0,
                count:      bufferSize
            )
            
            defer
            {
                buffer.deinitialize(count: bufferSize)
                buffer.deallocate()
            }
            
            
            
            let prefixLength: Int = 10
            
            let partialOIDString = String(headOIDString.prefix(prefixLength))
            
            let oidNFmtResult: GitErrorCode = gitOIDNFmt(
                out:    buffer,
                n:      prefixLength,
                id:     headOID
            )
            
            XCTAssertOK(oidNFmtResult)
            
            
            
            buffer[gitOIDSHA1HexSize] = 0
            
            let formattedString: String? = String(optionalCString: buffer)
            
            XCTAssertNotNil(formattedString)
            XCTAssertEqual(formattedString?.count, prefixLength)
            XCTAssertEqual(formattedString, partialOIDString)
        }
    }
    
    
    
    func testGitOIDPathFmt() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            /// Add space for the null terminator and the slash.
            let bufferSize: Int = gitOIDSHA1HexSize + 2
            
            let buffer = UnsafeMutablePointer<CChar>
                .allocate(capacity: bufferSize)
            
            buffer.initialize(
                repeating:  0,
                count:      bufferSize
            )
            
            defer
            {
                buffer.deinitialize(count: bufferSize)
                buffer.deallocate()
            }
            
            
            
            let oidPathFmtResult: GitErrorCode = gitOIDPathFmt(
                out:    buffer,
                id:     headOID
            )
            
            XCTAssertOK(oidPathFmtResult)
            
            
            
            buffer[gitOIDSHA1HexSize + 1] = 0
            
            let pathString: String? = String(optionalCString: buffer)
            
            XCTAssertNotNil(pathString)
            XCTAssertEqual(pathString?.count, gitOIDSHA1HexSize + 1)
            XCTAssertTrue(pathString?.contains("/") ?? false)
            
            
            
            let expectedPrefix  = String(headOIDString.prefix(2))
            let expectedSuffix  = String(headOIDString.dropFirst(2))
            
            XCTAssertEqual(pathString, "\(expectedPrefix)/\(expectedSuffix)")
        }
    }
    
    
    
    func testGitOIDSHA1HexSize() throws
    {
        XCTAssertEqual(Int32(gitOIDSHA1HexSize), GIT_OID_SHA1_HEXSIZE)
    }
    
    
    
    func testGitOIDSHA1HexZero() throws
    {
        XCTAssertEqual(gitOIDSHA1HexZero, GIT_OID_SHA1_HEXZERO)
    }
    
    
    
    func testGitOIDSHA1Size() throws
    {
        XCTAssertEqual(Int32(gitOIDSHA1Size), GIT_OID_SHA1_SIZE)
    }
    
    
    
    func testGitOIDSHA1Zero() throws
    {
        XCTAssertZeroOID(gitOIDSHA1Zero)
    }
    
    
    
    func testGitOIDSHA256HexSize() throws
    {
        XCTAssertEqual(gitOIDSHA256HexSize, gitOIDSHA256Size * 2)
    }
    
    
    
    func testGitOIDSHA256HexZero() throws
    {
        let sha256Zeros = String(
            repeating:  "0",
            count:      Int(gitOIDSHA256HexSize)
        )
        
        XCTAssertEqual(gitOIDSHA256HexZero, sha256Zeros)
    }
    
    
    
    func tesetGitOIDSHA256Size() throws
    {
        XCTAssertEqual(gitOIDSHA256Size, 32)
    }
    
    
    
    func testGitOIDShortenFree() throws
    {
        gitOIDShortenFree(os: nil)
    }
    
    
    
    func testGitOIDShortenNewAndAdd() throws
    {
        try withHEADOID
        {
            repository, headOID, _ in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Third content",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            guard let firstOIDString: String
                    = gitOIDToStrS(oid: firstCommitOID)
            else
            {
                XCTFail("The first OID string was nil.")
                return
            }
            
            guard let secondOIDString: String
                    = gitOIDToStrS(oid: secondCommitOID)
            else
            {
                XCTFail("The second OID string was nil.")
                return
            }
            
            guard let thirdOIDString: String
                    = gitOIDToStrS(oid: thirdCommitOID)
            else
            {
                XCTFail("The third OID string was nil.")
                return
            }
            
            
            
            let minimumLength: Int32 = 7
            
            let oidShortener: OpaquePointer
                = gitOIDShortenNew(minLength: Int(minimumLength))
            
            defer
            {
                gitOIDShortenFree(os: oidShortener)
            }
            
            
            
            let firstAddResult: Int32 = gitOIDShortenAdd(
                os:         oidShortener,
                textID:     firstOIDString
            )
            
            XCTAssertGreaterThanOrEqual(firstAddResult, minimumLength)
            
            
            
            let secondAddResult: Int32 = gitOIDShortenAdd(
                os:         oidShortener,
                textID:     secondOIDString
            )
            
            XCTAssertGreaterThanOrEqual(secondAddResult, minimumLength)
            
            
            
            let thirdAddResult: Int32 = gitOIDShortenAdd(
                os:         oidShortener,
                textID:     thirdOIDString
            )
            
            XCTAssertGreaterThanOrEqual(thirdAddResult, minimumLength)
        }
    }
    
    
    
    func testGitOIDStrEqAndStrCmp() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            var oidStringsEqual: Bool = gitOIDStrEq(
                id:     headOID,
                str:    headOIDString
            )
            
            XCTAssertTrue(oidStringsEqual)
            
            
            
            let differentOIDString = String(
                repeating:  "1",
                count:      gitOIDSHA1HexSize
            )
            
            oidStringsEqual = gitOIDStrEq(
                id:     headOID,
                str:    differentOIDString
            )
            
            XCTAssertFalse(oidStringsEqual)
            
            
            
            var strCmpResult: Int = gitOIDStrCmp(
                id:     headOID,
                str:    headOIDString
            )
            
            XCTAssertEqual(strCmpResult, 0)
            
            
            
            strCmpResult = gitOIDStrCmp(
                id:     headOID,
                str:    differentOIDString
            )
            
            XCTAssertTrue(strCmpResult == 1 || strCmpResult == -1)
            
            
            
            strCmpResult = gitOIDStrCmp(
                id:     headOID,
                str:    "invalid-oid"
            )
            
            XCTAssertEqual(strCmpResult, -1)
        }
    }
    
    
    
    func testGitOIDT() throws
    {
        XCTAssertEqual(GitOIDT.gitOIDSHA1.rawValue, GIT_OID_SHA1.rawValue)
        
        XCTAssertNil(GitOIDT(rawValue: 123))
        
        XCTAssertEqual(GitOIDT.gitOIDSHA1.cValue(), GIT_OID_SHA1)
        
        XCTAssertEqual(GitOIDT(cValue: GIT_OID_SHA1), .gitOIDSHA1)
    }
    
    
    
    func testGitOIDToStr() throws
    {
        try withHEADOID
        {
            _, headOID, headOIDString in
            
            let fullBufferSize: Int = gitOIDSHA1HexSize + 1
            
            let fullBuffer = UnsafeMutablePointer<CChar>
                .allocate(capacity: fullBufferSize)
            
            fullBuffer.initialize(
                repeating:  0,
                count:      fullBufferSize
            )
            
            defer
            {
                fullBuffer.deinitialize(count: fullBufferSize)
                fullBuffer.deallocate()
            }
            
            
            
            let fullString: String? = gitOIDToStr(
                out:    fullBuffer,
                n:      fullBufferSize,
                id:     headOID
            )
            
            XCTAssertNotNil(fullString)
            XCTAssertEqual(fullString, headOIDString)
            
            
            
            let shortBufferSize: Int = 10
            
            let shortBuffer = UnsafeMutablePointer<CChar>
                .allocate(capacity: shortBufferSize)
            
            shortBuffer.initialize(
                repeating:  0,
                count:      shortBufferSize
            )
            
            defer
            {
                shortBuffer.deinitialize(count: shortBufferSize)
                shortBuffer.deallocate()
            }
            
            
            
            /// Account for the null terminator.
            let expectedShortStringSize: Int = shortBufferSize - 1
            
            let expectedShortString
                = String(headOIDString.prefix(expectedShortStringSize))
            
            let shortString: String? = gitOIDToStr(
                out:    shortBuffer,
                n:      shortBufferSize,
                id:     headOID
            )
            
            XCTAssertNotNil(shortString)
            XCTAssertEqual(shortString?.count, expectedShortStringSize)
            XCTAssertEqual(shortString, expectedShortString)
        }
    }
}



// MARK: - Extensions

private extension OIDTests
{
    /// Calls the given closure with a ``Repository`` instance, the HEAD
    /// OID of that repository, and the string representation of that OID.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withHEADOID(
        _ body: (Repository, GitOID, String) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = repository.headOID
            
            guard let headOIDString: String = gitOIDToStrS(oid: headOID)
            else
            {
                throw NSError.makeError("The HEAD OID string was nil.")
            }
            
            XCTAssertEqual(headOIDString.count, gitOIDSHA1HexSize)
            
            
            
            let oidStringsEqual: Bool = gitOIDStrEq(
                id:     headOID,
                str:    headOIDString
            )
            
            XCTAssertTrue(oidStringsEqual)
            
            
            
            try body(
                repository,
                headOID,
                headOIDString
            )
        }
    }
}
