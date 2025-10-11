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
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let originalSwiftArrayOfOIDs: [GitOID] =
            [
                GitOID(),
                headOID,
                GitOID()
            ]
            
            
            
            let cOIDs = UnsafeMutablePointer<git_oid>.allocate(
                capacity: originalSwiftArrayOfOIDs.count
            )
            
            defer
            {
                cOIDs.deallocate()
            }
            
            
            
            for (index, swiftOID) in originalSwiftArrayOfOIDs.enumerated()
            {
                cOIDs[index] = swiftOID.cValue()
            }
            
            
            
            var cOIDArray = git_oidarray()
            
            cOIDArray.ids       = cOIDs
            cOIDArray.count     = originalSwiftArrayOfOIDs.count
            
            
            
            let convertedSwiftArrayOfOIDs: [GitOID] = Array(cOIDArray)
            
            XCTAssertEqual(convertedSwiftArrayOfOIDs.count, originalSwiftArrayOfOIDs.count)
            
            for (index, swiftOID) in convertedSwiftArrayOfOIDs.enumerated()
            {
                XCTAssertEqual(swiftOID, originalSwiftArrayOfOIDs[index])
            }
        }
    }
    
    
    
    func testWithArrayOfGitOIDs() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let arrayOfOIDs: [GitOID] =
            [
                GitOID(),
                headOID,
                GitOID()
            ]
            
            
            
            try arrayOfOIDs.withArrayOfGitOIDs
            {
                cArrayOfOIDs, cArrayOfOIDsCount in
                
                XCTAssertEqual(cArrayOfOIDsCount, arrayOfOIDs.count)
                
                guard let cArrayOfOIDs: UnsafePointer<git_oid> = cArrayOfOIDs
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
            
            
            
            try [].withArrayOfGitOIDs
            {
                cOIDs, cOIDsCount in
                
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
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
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
            
            
            
            try outerArrayOfOIDs.withArrayOfGitOIDs
            {
                cOuterArrayOfOIDs, cOuterArrayOfOIDsCount in
                
                XCTAssertEqual(cOuterArrayOfOIDsCount, outerArrayOfOIDs.count)
                
                guard let cOuterArrayOfOIDs: UnsafePointer<git_oid>
                        = cOuterArrayOfOIDs
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
                
                
                
                try innerArrayOfOIDs.withArrayOfGitOIDs
                {
                    cInnerArrayOfOIDs, cInnerArrayOfOIdsCount in
                    
                    XCTAssertEqual(cInnerArrayOfOIdsCount, innerArrayOfOIDs.count)
                    
                    guard let cInnerArrayOfOIDs: UnsafePointer<git_oid>
                            = cInnerArrayOfOIDs
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
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
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
                /// memory does not need to be freed separately after being
                /// assigned to `oidArray.pointee.ids`.
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
