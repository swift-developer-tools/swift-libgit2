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



final class OIDArrayTests: XCTestCaseStopOnFail
{
    func testGitOIDArrayDispose() throws
    {
        var oidArray = git_oidarray()
        
        gitOIDArrayDispose(array: &oidArray)
        gitOIDArrayDispose(array: &oidArray)
        gitOIDArrayDispose(array: nil)
    }
    
    
    
    func testGitOIDArrayInit() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let swiftArrayOfOIDs: [GitOID] =
            [
                GitOID(),
                repository.headOID,
                GitOID()
            ]
            
            
            
            let cArrayOfOIDs = UnsafeMutablePointer<git_oid>.allocate(
                capacity: swiftArrayOfOIDs.count
            )
            
            defer
            {
                cArrayOfOIDs.deallocate()
            }
            
            
            
            for (index, swiftOID) in swiftArrayOfOIDs.enumerated()
            {
                cArrayOfOIDs[index] = swiftOID.cValue()
            }
            
            
            
            var cOIDArray = git_oidarray()
            
            cOIDArray.ids       = cArrayOfOIDs
            cOIDArray.count     = swiftArrayOfOIDs.count
            
            
            
            let convertedSwiftArrayOfOIDs: [GitOID] = Array(cOIDArray)
            
            XCTAssertEqual(convertedSwiftArrayOfOIDs.count, swiftArrayOfOIDs.count)
            
            for (index, swiftOID) in convertedSwiftArrayOfOIDs.enumerated()
            {
                XCTAssertEqual(swiftOID, swiftArrayOfOIDs[index])
            }
        }
    }
    
    
    
    func testWithArrayOfGitOIDs() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let arrayOfOIDs: [GitOID] =
            [
                GitOID(),
                repository.headOID,
                GitOID()
            ]
            
            
            
            arrayOfOIDs.withArrayOfGitOIDs
            {
                cArrayOfOIDs, cArrayOfOIDsCount in
                
                XCTAssertEqual(cArrayOfOIDsCount, arrayOfOIDs.count)
                
                guard let cArrayOfOIDs
                else
                {
                    XCTFail("The array of C OIDs was nil.")
                    return
                }
                
                
                
                for (index, swiftOID) in arrayOfOIDs.enumerated()
                {
                    let cOID: git_oid = cArrayOfOIDs[index]
                    
                    XCTAssertEqual(GitOID(cValue: cOID), swiftOID)
                }
            }
            
            
            
            /// Use explicit type annotations for the closure parameters
            /// so the compiler knows which overloaded method to use.
            [].withArrayOfGitOIDs
            {
                (
                    cOIDs       : UnsafeMutablePointer<git_oid>?,
                    cOIDsCount  : Int
                ) in
                
                XCTAssertNil(cOIDs)
                XCTAssertEqual(cOIDsCount, 0)
            }
            
            
            
            [].withArrayOfGitOIDs
            {
                (
                    cOIDs       : UnsafeMutablePointer<UnsafePointer<git_oid>?>?,
                    cOIDsCount  : Int
                ) in
                
                XCTAssertNil(cOIDs)
                XCTAssertEqual(cOIDsCount, 0)
            }
        }
    }
    
    
    
    func testWithArrayOfGitOIDsNested() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = repository.headOID
            
            let outerArrayOfOIDs: [GitOID] =
            [
                GitOID(),
                GitOID()
            ]
            
            let innerArrayOfOIDs: [GitOID] =
            [
                headOID,
                headOID
            ]
            
            
            
            outerArrayOfOIDs.withArrayOfGitOIDs
            {
                cOuterArrayOfOIDs, cOuterArrayOfOIDsCount in
                
                XCTAssertEqual(cOuterArrayOfOIDsCount, outerArrayOfOIDs.count)
                
                guard let cOuterArrayOfOIDs
                else
                {
                    XCTFail("The outer array of C OIDs was nil.")
                    return
                }
                
                for (index, swiftOID) in outerArrayOfOIDs.enumerated()
                {
                    let cOID: git_oid = cOuterArrayOfOIDs[index]
                    
                    XCTAssertEqual(GitOID(cValue: cOID), swiftOID)
                }
                
                
                
                innerArrayOfOIDs.withArrayOfGitOIDs
                {
                    cInnerArrayOfOIDs, cInnerArrayOfOIdsCount in
                    
                    XCTAssertEqual(cInnerArrayOfOIdsCount, innerArrayOfOIDs.count)
                    
                    guard let cInnerArrayOfOIDs
                    else
                    {
                        XCTFail("The inner array of C OIDs was nil.")
                        return
                    }
                    
                    for (index, swiftOID) in innerArrayOfOIDs.enumerated()
                    {
                        let cOID: git_oid = cInnerArrayOfOIDs[index]
                        
                        XCTAssertEqual(GitOID(cValue: cOID), swiftOID)
                    }
                    
                    
                    
                    /// Test `outerArrayOfOIDs` again within the
                    /// `innerArrayOfOIDs` closure.
                    XCTAssertEqual(cOuterArrayOfOIDsCount, outerArrayOfOIDs.count)
                    
                    for (index, swiftOID) in outerArrayOfOIDs.enumerated()
                    {
                        let cOID: git_oid = cOuterArrayOfOIDs[index]
                        
                        XCTAssertEqual(GitOID(cValue: cOID), swiftOID)
                    }
                }
            }
        }
    }
    
    
    
    func testWithMutableArrayOfGitOIDs() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = repository.headOID
            
            var arrayOfOIDs: [GitOID] =
            [
                GitOID(),
                GitOID(),
                GitOID()
            ]
            
            
            
            /// Simulate libgit2 populating the array.
            try arrayOfOIDs.withMutatingGitOIDArray
            {
                oidArray in
                
                XCTAssertNotNil(oidArray.pointee.ids)
                XCTAssertEqual(oidArray.pointee.count, 3)
                
                oidArray.pointee.ids[0] = headOID.cValue()
                oidArray.pointee.ids[1] = headOID.cValue()
                oidArray.pointee.ids[2] = headOID.cValue()
            }
            
            XCTAssertEqual(arrayOfOIDs.count, 3)
            XCTAssertEqual(arrayOfOIDs[0], headOID)
            XCTAssertEqual(arrayOfOIDs[1], headOID)
            XCTAssertEqual(arrayOfOIDs[2], headOID)
            
            
            
            var emptyArrayOfOIDs: [GitOID] = []
            
            try emptyArrayOfOIDs.withMutatingGitOIDArray
            {
                oidArray in
                
                XCTAssertNil(oidArray.pointee.ids)
                XCTAssertEqual(oidArray.pointee.count, 0)
                
                /// Since the receiver array was empty, `oidArray` will be
                /// freed with ``gitOIDArrayDispose(array:)``. The allocated
                /// memory does not need to be freed after being assigned to
                /// `oidArray.pointee.ids`.
                let cOIDs = UnsafeMutablePointer<git_oid>.allocate(capacity: 3)
                
                cOIDs[0] = headOID.cValue()
                cOIDs[1] = headOID.cValue()
                cOIDs[2] = headOID.cValue()
                
                oidArray.pointee.ids    = cOIDs
                oidArray.pointee.count  = 3
            }
            
            XCTAssertEqual(emptyArrayOfOIDs.count, 3)
            XCTAssertEqual(emptyArrayOfOIDs[0], headOID)
            XCTAssertEqual(emptyArrayOfOIDs[1], headOID)
            XCTAssertEqual(emptyArrayOfOIDs[2], headOID)
        }
    }
}
