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



final class HashSigAdvancedTests: XCTestCaseStopOnFail
{
    func testGitHashSigCreateAndCompare() throws
    {
        createAndCompare(option: .gitHashSigNormal)
        createAndCompare(option: .gitHashSigIgnoreWhitespace)
        createAndCompare(option: .gitHashSigSmartWhitespace)
    }
    
    
    
    func testGitHashSigCreateFromFileAndCompare() throws
    {
        try createAndCompareFromFile(option: .gitHashSigNormal)
        try createAndCompareFromFile(option: .gitHashSigIgnoreWhitespace)
        try createAndCompareFromFile(option: .gitHashSigSmartWhitespace)
    }
    
    
    
    func testGitHashSigFree() throws
    {
        gitHashSigFree(sig: nil)
    }
    
    
    
    func testGitHashSigOptionT() throws
    {
        XCTAssertEqual(GitHashSigOptionT.gitHashSigNormal.rawValue, GIT_HASHSIG_NORMAL.rawValue)
        XCTAssertEqual(GitHashSigOptionT.gitHashSigIgnoreWhitespace.rawValue, GIT_HASHSIG_IGNORE_WHITESPACE.rawValue)
        XCTAssertEqual(GitHashSigOptionT.gitHashSigSmartWhitespace.rawValue, GIT_HASHSIG_SMART_WHITESPACE.rawValue)
        XCTAssertEqual(GitHashSigOptionT.gitHashSigAllowSmallFiles.rawValue, GIT_HASHSIG_ALLOW_SMALL_FILES.rawValue)
        
        XCTAssertEqual(GitHashSigOptionT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitHashSigOptionT.gitHashSigNormal.cValue(), GIT_HASHSIG_NORMAL)
        XCTAssertEqual(GitHashSigOptionT.gitHashSigIgnoreWhitespace.cValue(), GIT_HASHSIG_IGNORE_WHITESPACE)
        XCTAssertEqual(GitHashSigOptionT.gitHashSigSmartWhitespace.cValue(), GIT_HASHSIG_SMART_WHITESPACE)
        XCTAssertEqual(GitHashSigOptionT.gitHashSigAllowSmallFiles.cValue(), GIT_HASHSIG_ALLOW_SMALL_FILES)
        
        XCTAssertEqual(GitHashSigOptionT(cValue: GIT_HASHSIG_NORMAL), .gitHashSigNormal)
        XCTAssertEqual(GitHashSigOptionT(cValue: GIT_HASHSIG_IGNORE_WHITESPACE), .gitHashSigIgnoreWhitespace)
        XCTAssertEqual(GitHashSigOptionT(cValue: GIT_HASHSIG_SMART_WHITESPACE), .gitHashSigSmartWhitespace)
        XCTAssertEqual(GitHashSigOptionT(cValue: GIT_HASHSIG_ALLOW_SMALL_FILES), .gitHashSigAllowSmallFiles)
        
        
        
        let flags: GitHashSigOptionT =
        [
            .gitHashSigIgnoreWhitespace,
            .gitHashSigSmartWhitespace
        ]
        
        XCTAssertTrue(flags.contains(.gitHashSigIgnoreWhitespace))
        XCTAssertTrue(flags.contains(.gitHashSigSmartWhitespace))
        XCTAssertFalse(flags.contains(.gitHashSigAllowSmallFiles))
    }
}



// MARK: - Extensions

private extension HashSigAdvancedTests
{
    static let content              : String    = "Line 1\nLine 2\nLine 3"
    static let whitespaceContent    : String    = "Line 1\n  Line 2\n  Line 3"
    
    
    
    /// Creates and compares two similarity signatures.
    /// - Parameter option: The flags controlling similarity signature
    /// computation.
    func createAndCompare(
        option: GitHashSigOptionT
    )
    {
        let normalData      = Data(Self.content.utf8)
        let whitespaceData  = Data(Self.whitespaceContent.utf8)
        
        
        
        var firstHashSignature  : OpaquePointer?    = nil
        var secondHashSignature : OpaquePointer?    = nil
        
        defer
        {
            gitHashSigFree(sig: firstHashSignature)
            gitHashSigFree(sig: secondHashSignature)
        }
        
        
        
        let hashSigOption: GitHashSigOptionT
            = option.union(.gitHashSigAllowSmallFiles)
        
        var hashSigCreateResult: GitErrorCode = gitHashSigCreate(
            out:        &firstHashSignature,
            buf:        normalData,
            bufLen:     normalData.count,
            opts:       hashSigOption
        )
        
        XCTAssertOK(hashSigCreateResult)
        
        guard let firstHashSignature: OpaquePointer = firstHashSignature
        else
        {
            XCTFail("The first hash signature was nil.")
            return
        }
        
        
        
        hashSigCreateResult = gitHashSigCreate(
            out:        &secondHashSignature,
            buf:        whitespaceData,
            bufLen:     whitespaceData.count,
            opts:       hashSigOption
        )
        
        XCTAssertOK(hashSigCreateResult)
        
        guard let secondHashSignature: OpaquePointer = secondHashSignature
        else
        {
            XCTFail("The second hash signature was nil.")
            return
        }
        
        
        
        let similarityScore: Int32 = gitHashSigCompare(
            a:  firstHashSignature,
            b:  secondHashSignature
        )
        
        XCTAssertGreaterThanOrEqual(similarityScore, 0)
        
        
        
        let isNormalHashSig: Bool = option.isEmpty
        
        if isNormalHashSig
        {
            XCTAssertLessThan(similarityScore, 100)
        }
        else
        {
            XCTAssertEqual(similarityScore, 100)
        }
    }
    
    
    
    /// Creates and compares two similarity signatures.
    /// - Parameter option: The flags controlling similarity signature
    /// computation.
    /// - Throws: An error if an operation fails.
    func createAndCompareFromFile(
        option: GitHashSigOptionT
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            let normalFileURL: URL = try repository.modifyFile(
                at:     "first.txt",
                with:   Self.content
            )
            
            let whitespaceFileURL: URL = try repository.modifyFile(
                at:     "second.txt",
                with:   Self.whitespaceContent
            )
            
            
            
            var firstHashSignature  : OpaquePointer?    = nil
            var secondHashSignature : OpaquePointer?    = nil
            
            defer
            {
                gitHashSigFree(sig: firstHashSignature)
                gitHashSigFree(sig: secondHashSignature)
            }
            
            
            
            let hashSigOption: GitHashSigOptionT
                = option.union(.gitHashSigAllowSmallFiles)
            
            var hashSigCreateFromFileResult: GitErrorCode
                = gitHashSigCreateFromFile(
                    out:    &firstHashSignature,
                    path:   normalFileURL.path(),
                    opts:   hashSigOption
                )
            
            XCTAssertOK(hashSigCreateFromFileResult)
            
            guard let firstHashSignature: OpaquePointer = firstHashSignature
            else
            {
                XCTFail("The first hash signature was nil.")
                return
            }
            
            
            
            hashSigCreateFromFileResult = gitHashSigCreateFromFile(
                out:    &secondHashSignature,
                path:   whitespaceFileURL.path(),
                opts:   hashSigOption
            )
            
            XCTAssertOK(hashSigCreateFromFileResult)
            
            guard let secondHashSignature: OpaquePointer = secondHashSignature
            else
            {
                XCTFail("The second hash signature was nil.")
                return
            }
            
            
            
            let similarityScore: Int32 = gitHashSigCompare(
                a:  firstHashSignature,
                b:  secondHashSignature
            )
            
            XCTAssertGreaterThanOrEqual(similarityScore, 0)
            
            
            
            let isNormalHashSig: Bool = option.isEmpty
            
            if isNormalHashSig
            {
                XCTAssertLessThan(similarityScore, 100)
            }
            else
            {
                XCTAssertEqual(similarityScore, 100)
            }
        }
    }
}
