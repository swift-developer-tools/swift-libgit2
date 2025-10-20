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



final class RefspecTests: XCTestCaseStopOnFail
{
    func testGitRefspecDirection() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let direction: GitDirection?
                = gitRefspecDirection(refspec: refspecPointer)
            
            XCTAssertNotNil(direction)
            XCTAssertEqual(direction, .gitDirectionFetch)
        }
    }
    
    
    
    func testGitRefspecDst() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let destinationSpecifier: String?
                = gitRefspecDst(refspec: refspecPointer)
            
            XCTAssertNotNil(destinationSpecifier)
            XCTAssertEqual(destinationSpecifier, Self.fetchDestination)
        }
    }
    
    
    
    func testGitRefspecDstMatches() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let refNamesAndMatchResults: [String : Bool] =
            [
                "refs/remotes/origin/main"      : true,
                "refs/heads/main"               : false,
                "refs/remotes/origin/feature"   : true
            ]
            
            for (refName, matchResult) in refNamesAndMatchResults
            {
                let destinationMatches: Bool = gitRefspecDstMatches(
                    refspec:    refspecPointer,
                    refName:    refName
                )
                
                XCTAssertEqual(destinationMatches, matchResult)
            }
        }
    }
    
    
    
    func testGitRefspecForce() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let forceUpdateIsSet: Bool
                = gitRefspecForce(refspec: refspecPointer)
            
            XCTAssertFalse(forceUpdateIsSet)
        }
        
        
        
        var refspecPointer: OpaquePointer? = nil
        
        defer
        {
            gitRefspecFree(refspec: refspecPointer)
        }
        
        
        
        let refspecParseResult: GitErrorCode = gitRefspecParse(
            refspec:    &refspecPointer,
            input:      "+\(Self.fetchRefspec)",
            isFetch:    true
        )
        
        XCTAssertOK(refspecParseResult)
        
        guard let refspecPointer: OpaquePointer = refspecPointer
        else
        {
            XCTFail("The refspec pointer was nil.")
            return
        }
        
        
        let forceUpdateIsSet: Bool
            = gitRefspecForce(refspec: refspecPointer)
        
        XCTAssertTrue(forceUpdateIsSet)
    }
    
    
    
    func testGitRefspecFree() throws
    {
        gitRefspecFree(refspec: nil)
    }
    
    
    
    func testGitRefspecParse() throws
    {
        try withRefspecPointer
        {
            _ in
        }
    }
    
    
    
    func testGitRefspecRTransform() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let refNamesAndTransformedNames: [String : String] =
            [
                "refs/remotes/origin/main"          : "refs/heads/main" ,
                "refs/remotes/origin/feature/new"   : "refs/heads/feature/new"
            ]
            
            for (refName, transformedName) in refNamesAndTransformedNames
            {
                var transformedData = Data()
                
                let refspecRTransformResult: GitErrorCode
                    = gitRefspecRTransform(
                        out:    &transformedData,
                        spec:   refspecPointer,
                        name:   refName
                    )
                
                XCTAssertOK(refspecRTransformResult)
                XCTAssertEqual(transformedData, transformedName)
            }
        }
    }
    
    
    
    func testGitRefspecSrc() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let sourceSpecifier: String?
                = gitRefspecSrc(refspec: refspecPointer)
            
            XCTAssertNotNil(sourceSpecifier)
            XCTAssertEqual(sourceSpecifier, Self.fetchSource)
        }
    }
    
    
    
    func testGitRefspecSrcMatches() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let refNamesAndMatchResults: [String : Bool] =
            [
                "refs/heads/main"           : true,
                "refs/tags/v1.0.0"          : false,
                "refs/heads/feature/new"    : true
            ]
            
            for (refName, matchResult) in refNamesAndMatchResults
            {
                let sourceMatches: Bool = gitRefspecSrcMatches(
                    refspec:    refspecPointer,
                    refName:    refName
                )
                
                XCTAssertEqual(sourceMatches, matchResult)
            }
        }
    }
    
    
    
    func testGitRefspecSrcMatchesNegative() throws
    {
        var refspecPointer: OpaquePointer? = nil
        
        defer
        {
            gitRefspecFree(refspec: refspecPointer)
        }
        
        
        
        let refspec: String = "refs/heads/exclude"
        
        let refspecParseResult: GitErrorCode = gitRefspecParse(
            refspec:    &refspecPointer,
            input:      "^\(refspec)",
            isFetch:    true
        )
        
        XCTAssertOK(refspecParseResult)
        
        guard let refspecPointer: OpaquePointer = refspecPointer
        else
        {
            XCTFail("The refspec pointer was nil.")
            return
        }
        
        
        
        let refNamesAndMatchResults: [String : Bool] =
        [
            "refs/heads/main"               : false,
            refspec                         : true,
            "refs/remotes/origin/exclude"   : false
        ]
        
        for (refName, matchResult) in refNamesAndMatchResults
        {
            let sourceMatchesNegative: Bool = gitRefspecSrcMatchesNegative(
                refspec:    refspecPointer,
                refName:    refName
            )
            
            XCTAssertEqual(sourceMatchesNegative, matchResult)
        }
    }
    
    
    
    func testGitRefspecString() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let refspecString: String?
                = gitRefspecString(refspec: refspecPointer)
            
            XCTAssertNotNil(refspecString)
            XCTAssertEqual(refspecString, Self.fetchRefspec)
        }
    }
    
    
    
    func testGitRefspecTransform() throws
    {
        try withRefspecPointer
        {
            refspecPointer in
            
            let refNamesAndTransformedNames: [String : String] =
            [
                "refs/heads/main"           : "refs/remotes/origin/main",
                "refs/heads/feature/new"    : "refs/remotes/origin/feature/new"
            ]
            
            for (refName, transformedName) in refNamesAndTransformedNames
            {
                var transformedData = Data()
                
                let refspecTransformResult: GitErrorCode = gitRefspecTransform(
                    out:    &transformedData,
                    spec:   refspecPointer,
                    name:   refName
                )
                
                XCTAssertOK(refspecTransformResult)
                XCTAssertEqual(transformedData, transformedName)
            }
        }
    }
}



// MARK: - Extensions

private extension RefspecTests
{
    static let fetchSource      : String    = "refs/heads/*"
    static let fetchDestination : String    = "refs/remotes/origin/*"
    static let fetchRefspec     : String    = "\(fetchSource):\(fetchDestination)"
    
    
    
    /// Calls the given closure with a pointer to a fetch refspec.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withRefspecPointer(
        _ body: (OpaquePointer) throws -> Void
    ) throws
    {
        var refspecPointer: OpaquePointer? = nil
        
        defer
        {
            gitRefspecFree(refspec: refspecPointer)
        }
        
        
        
        let refspecParseResult: GitErrorCode = gitRefspecParse(
            refspec:    &refspecPointer,
            input:      Self.fetchRefspec,
            isFetch:    true
        )
        
        XCTAssertOK(refspecParseResult)
        
        guard let refspecPointer: OpaquePointer = refspecPointer
        else
        {
            throw NSError.makeError("The refspec pointer was nil.")
        }
        
        try body(refspecPointer)
    }
}
