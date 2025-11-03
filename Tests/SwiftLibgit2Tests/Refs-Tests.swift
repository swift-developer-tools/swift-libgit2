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



final class RefsTests: XCTestCaseStopOnFail
{
    func testGitReferenceCreateAndLookup() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var symbolicRefPointer  : OpaquePointer?    = nil
            var lookupRefPointer    : OpaquePointer?    = nil
            
            defer
            {
                gitReferenceFree(ref: symbolicRefPointer)
                gitReferenceFree(ref: lookupRefPointer)
            }
            
            
            
            let refCreateSymbolicResult: GitErrorCode
                = gitReferenceSymbolicCreate(
                    out:            &symbolicRefPointer,
                    repo:           repository.pointer,
                    name:           Self.symbolicRefFullName,
                    target:         Self.directRefFullName,
                    force:          false,
                    logMessage:     "Create symbolic reference"
                )
            
            XCTAssertOK(refCreateSymbolicResult)
            XCTAssertNotNil(symbolicRefPointer)
            
            
            
            let refLookupResult: GitErrorCode = gitReferenceLookup(
                out:    &lookupRefPointer,
                repo:   repository.pointer,
                name:   Self.directRefFullName
            )
            
            XCTAssertOK(refLookupResult)
            XCTAssertNotNil(lookupRefPointer)
        }
    }
    
    
    
    func testGitReferenceCreateMatching() throws
    {
        try withDirectRef
        {
            repository, _ in
            
            var matchingRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: matchingRefPointer)
            }
            
            
            
            let headOID: GitOID = repository.headOID
            
            let commitOID: GitOID = try repository.commit(
                "New matching content",
                toFile:     "matching.txt",
                message:    "Matching commit"
            )
            
            
            
            var refCreateMatchingResult: GitErrorCode
                = gitReferenceCreateMatching(
                    out:            &matchingRefPointer,
                    repo:           repository.pointer,
                    name:           Self.directRefFullName,
                    id:             commitOID,
                    force:          false,
                    currentID:      headOID,
                    logMessage:     "Create with matching"
                )
            
            /// This should fail since a reference with the specified name
            /// already exists.
            XCTAssertNotOK(refCreateMatchingResult)
            
            
            
            /// Overwrite the existing reference.
            refCreateMatchingResult = gitReferenceCreateMatching(
                out:            &matchingRefPointer,
                repo:           repository.pointer,
                name:           Self.directRefFullName,
                id:             commitOID,
                force:          true,
                currentID:      headOID,
                logMessage:     "Create with matching"
            )
            
            XCTAssertOK(refCreateMatchingResult)
            
            guard let matchingRefPointer: OpaquePointer = matchingRefPointer
            else
            {
                XCTFail("The matching reference pointer was nil.")
                return
            }
            
            
            
            let targetOID: GitOID?
                = gitReferenceTarget(ref: matchingRefPointer)
            
            XCTAssertNotNil(targetOID)
            XCTAssertEqual(targetOID, commitOID)
        }
    }
    
    
    
    func testGitReferenceDelete() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            let refDeleteResult: GitErrorCode
                = gitReferenceDelete(ref: directRefPointer)
            
            XCTAssertOK(refDeleteResult)
        }
    }
    
    
    
    func testGitReferenceDupAndCmp() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            var duplicatedRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: duplicatedRefPointer)
            }
            
            
            
            let refDupResult: GitErrorCode = gitReferenceDup(
                dest:       &duplicatedRefPointer,
                source:     directRefPointer
            )
            
            XCTAssertOK(refDupResult)
            
            guard let duplicatedRefPointer: OpaquePointer
                    = duplicatedRefPointer
            else
            {
                XCTFail("The duplicated reference pointer was nil.")
                return
            }
            
            
            
            let refsAreEqual: Bool = gitReferenceCmp(
                ref1:   directRefPointer,
                ref2:   duplicatedRefPointer
            )
            
            XCTAssertTrue(refsAreEqual)
        }
    }
    
    
    
    func testGitReferenceEnsureLog() throws
    {
        try withDirectRef
        {
            repository, _ in
            
            var customRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: customRefPointer)
            }
            
            
            
            let customRefName: String = "refs/custom/no-log"
            
            let refCreateResult: GitErrorCode = gitReferenceCreate(
                out:            &customRefPointer,
                repo:           repository.pointer,
                name:           customRefName,
                id:             repository.headOID,
                force:          false,
                logMessage:     "Create custom reference"
            )
            
            XCTAssertOK(refCreateResult)
            XCTAssertNotNil(customRefPointer)
            
            
            
            let refHasLogBeforeEnsure: Bool? = gitReferenceHasLog(
                repo:       repository.pointer,
                refName:    customRefName
            )
            
            XCTAssertNotNil(refHasLogBeforeEnsure)
            XCTAssertFalse(refHasLogBeforeEnsure ?? true)
            
            
            
            let refEnsureLogResult: GitErrorCode = gitReferenceEnsureLog(
                repo:       repository.pointer,
                refName:    customRefName
            )
            
            XCTAssertOK(refEnsureLogResult)
            
            
            
            let refHasLogAfterEnsure: Bool? = gitReferenceHasLog(
                repo:       repository.pointer,
                refName:    customRefName
            )
            
            XCTAssertNotNil(refHasLogAfterEnsure)
            XCTAssertTrue(refHasLogAfterEnsure ?? false)
        }
    }
    
    
    
    func testGitReferenceForEach() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let refForEachResult: GitErrorCode = gitReferenceForEach(
                    repo:       repository.pointer,
                    callback:   Self.refForEachCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(refForEachResult)
            }
            
            XCTAssertGreaterThan(callbackData.refCount, 0)
            XCTAssertNotNil(callbackData.lastRefName)
        }
    }
    
    
    
    func testGitReferenceForEachGlob() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let refForEachGlobResult: GitErrorCode
                    = gitReferenceForEachGlob(
                        repo:       repository.pointer,
                        glob:       "refs/heads/*",
                        callback:   Self.refForEachNameCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(refForEachGlobResult)
            }
            
            XCTAssertGreaterThan(callbackData.refCount, 0)
            XCTAssertNotNil(callbackData.lastRefName)
            XCTAssertTrue(callbackData.lastRefName?.hasPrefix("refs/heads") ?? false)
        }
    }
    
    
    
    func testGitReferenceForEachName() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var callbackData = CallbackData()
            
            let refForEachNameCB: GitReferenceForEachNameCB =
            {
                name, payload in
                
                guard
                    let payload: UnsafeMutableRawPointer = payload,
                    let refName = String(optionalCString: name)
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.refCount     += 1
                payloadPointer.pointee.lastRefName  = refName
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let refForEachNameResult: GitErrorCode
                    = gitReferenceForEachName(
                        repo:       repository.pointer,
                        callback:   refForEachNameCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(refForEachNameResult)
            }
            
            XCTAssertGreaterThan(callbackData.refCount, 0)
            XCTAssertNotNil(callbackData.lastRefName)
        }
    }
    
    
    
    func testGitReferenceFormatT() throws
    {
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatNormal.rawValue, GIT_REFERENCE_FORMAT_NORMAL.rawValue)
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatAllowOneLevel.rawValue, GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL.rawValue)
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatRefspecPattern.rawValue, GIT_REFERENCE_FORMAT_REFSPEC_PATTERN.rawValue)
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatRefspecShorthand.rawValue, GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND.rawValue)
        
        XCTAssertEqual(GitReferenceFormatT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatNormal.cValue(), GIT_REFERENCE_FORMAT_NORMAL)
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatAllowOneLevel.cValue(), GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL)
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatRefspecPattern.cValue(), GIT_REFERENCE_FORMAT_REFSPEC_PATTERN)
        XCTAssertEqual(GitReferenceFormatT.gitReferenceFormatRefspecShorthand.cValue(), GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND)
        
        XCTAssertEqual(GitReferenceFormatT(cValue: GIT_REFERENCE_FORMAT_NORMAL), .gitReferenceFormatNormal)
        XCTAssertEqual(GitReferenceFormatT(cValue: GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL), .gitReferenceFormatAllowOneLevel)
        XCTAssertEqual(GitReferenceFormatT(cValue: GIT_REFERENCE_FORMAT_REFSPEC_PATTERN), .gitReferenceFormatRefspecPattern)
        XCTAssertEqual(GitReferenceFormatT(cValue: GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND), .gitReferenceFormatRefspecShorthand)
        
        
        
        let flags: GitReferenceFormatT =
        [
            .gitReferenceFormatAllowOneLevel,
            .gitReferenceFormatRefspecPattern
        ]
        
        XCTAssertTrue(flags.contains(.gitReferenceFormatAllowOneLevel))
        XCTAssertTrue(flags.contains(.gitReferenceFormatRefspecPattern))
        XCTAssertFalse(flags.contains(.gitReferenceFormatRefspecShorthand))
    }
    
    
    
    func testGitReferenceFree() throws
    {
        gitReferenceFree(ref: nil)
    }
    
    
    
    func testGitReferenceHasLog() throws
    {
        try withDirectRef
        {
            repository, _ in
            
            let refHasLog: Bool? = gitReferenceHasLog(
                repo:       repository.pointer,
                refName:    Self.directRefFullName
            )
            
            XCTAssertNotNil(refHasLog)
            XCTAssertTrue(refHasLog ?? false)
        }
    }
    
    
    
    func testGitReferenceIsBranch() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            let refIsBranch: Bool = gitReferenceIsBranch(ref: directRefPointer)
            
            XCTAssertTrue(refIsBranch)
        }
    }
    
    
    
    func testGitReferenceIsNote() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            let refIsNote: Bool = gitReferenceIsNote(ref: directRefPointer)
            
            XCTAssertFalse(refIsNote)
        }
    }
    
    
    
    func testGitReferenceIsRemote() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            let refIsRemote: Bool = gitReferenceIsRemote(ref: directRefPointer)
            
            XCTAssertFalse(refIsRemote)
        }
    }
    
    
    
    func testGitReferenceIsTag() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            let refIsTag: Bool = gitReferenceIsTag(ref: directRefPointer)
            
            XCTAssertFalse(refIsTag)
        }
    }
    
    
    
    func testGitReferenceIteratorFree() throws
    {
        gitReferenceIteratorFree(iter: nil)
    }
    
    
    
    func testGitReferenceIteratorGlobNewAndNext() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var iterator: UnsafeMutablePointer<git_reference_iterator>? = nil
            
            defer
            {
                gitReferenceIteratorFree(iter: iterator)
            }
            
            
            
            let refIteratorGlobNewResult: GitErrorCode
                = gitReferenceIteratorGlobNew(
                    out:    &iterator,
                    repo:   repository.pointer,
                    glob:   "refs/heads/*"
                )
            
            XCTAssertOK(refIteratorGlobNewResult)
            
            guard let iterator: UnsafeMutablePointer<git_reference_iterator>
                    = iterator
            else
            {
                XCTFail("The reference iterator was nil.")
                return
            }
            
            
            
            var nextRefName : String?   = nil
            var refCount    : Int       = 0
            
            while true
            {
                let refNextNameResult: GitErrorCode = gitReferenceNextName(
                    out:    &nextRefName,
                    iter:   iterator
                )
                
                if refNextNameResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(refNextNameResult)
                XCTAssertNotNil(nextRefName)
                
                if let name = String(optionalCString: nextRefName)
                {
                    XCTAssertTrue(name.hasPrefix("refs/heads/"))
                }
                
                refCount += 1
            }
            
            XCTAssertGreaterThan(refCount, 0)
        }
    }
    
    
    
    func testGitReferenceIteratorNewAndNext() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var iterator: UnsafeMutablePointer<git_reference_iterator>? = nil
            
            defer
            {
                gitReferenceIteratorFree(iter: iterator)
            }
            
            
            
            let refIteratorNewResult: GitErrorCode = gitReferenceIteratorNew(
                out:    &iterator,
                repo:   repository.pointer
            )
            
            XCTAssertOK(refIteratorNewResult)
            
            guard let iterator: UnsafeMutablePointer<git_reference_iterator>
                    = iterator
            else
            {
                XCTFail("The reference iterator was nil.")
                return
            }
            
            
            
            var nextRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: nextRefPointer)
            }
            
            
            
            var refCount: Int = 0
            
            while true
            {
                let refNextResult: GitErrorCode = gitReferenceNext(
                    out:    &nextRefPointer,
                    iter:   iterator
                )
                
                if refNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(refNextResult)
                XCTAssertNotNil(nextRefPointer)
                
                refCount += 1
            }
            
            XCTAssertGreaterThan(refCount, 0)
        }
    }
    
    
    
    func testGitReferenceList() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var otherDirectRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: otherDirectRefPointer)
            }
            
            
            
            let refFullName: String = "refs/heads/another-ref"
            
            let refCreateResult: GitErrorCode = gitReferenceCreate(
                out:            &otherDirectRefPointer,
                repo:           repository.pointer,
                name:           refFullName,
                id:             repository.headOID,
                force:          false,
                logMessage:     "Create another direct reference"
            )
            
            XCTAssertOK(refCreateResult)
            XCTAssertNotNil(otherDirectRefPointer)
            
            
            
            var refNames: [String] = []
            
            let refListResult: GitErrorCode = gitReferenceList(
                array:  &refNames,
                repo:   repository.pointer
            )
            
            XCTAssertOK(refListResult)
            XCTAssertGreaterThanOrEqual(refNames.count, 2)
            XCTAssertTrue(refNames.contains(Self.directRefFullName))
            XCTAssertTrue(refNames.contains(refFullName))
        }
    }
    
    
    
    func testGitReferenceNameAndShorthand() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            let fullName: String? = gitReferenceName(ref: directRefPointer)
            
            XCTAssertNotNil(fullName)
            XCTAssertEqual(fullName, Self.directRefFullName)
            
            
            
            let shorthandName: String?
                = gitReferenceShorthand(ref: directRefPointer)
            
            XCTAssertNotNil(shorthandName)
            XCTAssertEqual(shorthandName, Self.directRefName)
            
            
            
            let ownerPointer: OpaquePointer
                = gitReferenceOwner(ref: directRefPointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
        }
    }
    
    
    
    func testGitReferenceNameIsValid() throws
    {
        let refNamesAndValidity: [String : Bool] =
        [
            "refs/heads/feature/hello-world"    : true,
            "refs/heads/feature/hello..world"   : false,
            "refs/heads/feature/hello~world"    : false,
            "HEAD"                              : true
        ]
        
        
        
        var isValid: Bool = false
        
        for (refName, validity) in refNamesAndValidity
        {
            isValid = !validity
            
            let refNameIsValidResult: GitErrorCode = gitReferenceNameIsValid(
                valid:      &isValid,
                refName:    refName
            )
            
            XCTAssertOK(refNameIsValidResult)
            XCTAssertEqual(isValid, validity)
        }
    }
    
    
    
    func testGitReferenceNameToID() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var symbolicRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: symbolicRefPointer)
            }
            
            
            
            let refCreateSymbolicResult: GitErrorCode
                = gitReferenceSymbolicCreate(
                    out:            &symbolicRefPointer,
                    repo:           repository.pointer,
                    name:           Self.symbolicRefFullName,
                    target:         Self.directRefFullName,
                    force:          false,
                    logMessage:     "Create symbolic reference"
                )
            
            XCTAssertOK(refCreateSymbolicResult)
            XCTAssertNotNil(symbolicRefPointer)
            
            
            
            var resolvedOID = GitOID()
            
            let refNameToIDResult: GitErrorCode = gitReferenceNameToID(
                out:    &resolvedOID,
                repo:   repository.pointer,
                name:   Self.symbolicRefFullName
            )
            
            XCTAssertOK(refNameToIDResult)
            XCTAssertNotZeroOID(resolvedOID)
            
            
            
            let directTargetOID: GitOID?
                = gitReferenceTarget(ref: directRefPointer)
            
            XCTAssertNotNil(directTargetOID)
            XCTAssertEqual(directTargetOID, resolvedOID)
        }
    }
    
    
    
    func testGitReferenceNormalizeName() throws
    {
        var normalizedData = Data(count: 256)
        
        var refNormalizeNameResult: GitErrorCode = gitReferenceNormalizeName(
            bufferOut:      &normalizedData,
            bufferSize:     normalizedData.count,
            name:           "refs//heads///feature/hello-world",
            flags:          .gitReferenceFormatNormal
        )
        
        XCTAssertOK(refNormalizeNameResult)
        
        
        
        guard let normalizedName = String(
            bytes:      normalizedData,
            encoding:   .utf8
        )
        else
        {
            XCTFail("The normalized name was nil.")
            return
        }
        
        let removeCharacterSet = CharacterSet(charactersIn: "\0")
        
        let trimmedName: String = normalizedName
            .trimmingCharacters(in: removeCharacterSet)
        
        XCTAssertEqual(trimmedName, "refs/heads/feature/hello-world")
        
        
        
        let combinedFlags: GitReferenceFormatT =
        [
            .gitReferenceFormatAllowOneLevel,
            .gitReferenceFormatRefspecShorthand
        ]
        
        let namesAndFlags: [String : GitReferenceFormatT] =
        [
            "FETCH_HEAD"            : .gitReferenceFormatAllowOneLevel,
            "refs/heads/*/feature"  : .gitReferenceFormatRefspecPattern,
            "HEAD"                  : combinedFlags
        ]
        
        for (name, flags) in namesAndFlags
        {
            normalizedData = Data(count: 256)
            
            refNormalizeNameResult = gitReferenceNormalizeName(
                bufferOut:      &normalizedData,
                bufferSize:     normalizedData.count,
                name:           name,
                flags:          flags
            )
            
            XCTAssertOK(refNormalizeNameResult)
        }
    }
    
    
    
    func testGitReferencePeel() throws
    {
        try withDirectRef
        {
            _, directRefPointer in
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let refPeelResult: GitErrorCode = gitReferencePeel(
                out:    &objectPointer,
                ref:    directRefPointer,
                type:   .gitObjectCommit
            )
            
            XCTAssertOK(refPeelResult)
            XCTAssertNotNil(objectPointer)
        }
    }
    
    
    
    func testGitReferenceRemove() throws
    {
        try withDirectRef
        {
            repository, _ in
            
            let refRemoveResult: GitErrorCode = gitReferenceRemove(
                repo:   repository.pointer,
                name:   Self.directRefFullName
            )
            
            XCTAssertOK(refRemoveResult)
        }
    }
    
    
    
    func testGitReferenceResolveAndDWIM() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var symbolicRefPointer  : OpaquePointer?    = nil
            var resolvedRefPointer  : OpaquePointer?    = nil
            var dwimRefPointer      : OpaquePointer?    = nil
            
            defer
            {
                gitReferenceFree(ref: symbolicRefPointer)
                gitReferenceFree(ref: resolvedRefPointer)
                gitReferenceFree(ref: dwimRefPointer)
            }
            
            
            
            let refCreateSymbolicResult: GitErrorCode
                = gitReferenceSymbolicCreate(
                    out:            &symbolicRefPointer,
                    repo:           repository.pointer,
                    name:           Self.symbolicRefFullName,
                    target:         Self.directRefFullName,
                    force:          false,
                    logMessage:     "Create symbolic reference"
                )
            
            XCTAssertOK(refCreateSymbolicResult)
            
            guard let symbolicRefPointer: OpaquePointer = symbolicRefPointer
            else
            {
                XCTFail("The symbolic reference pointer was nil.")
                return
            }
            
            
            
            let refResolveResult: GitErrorCode = gitReferenceResolve(
                out:    &resolvedRefPointer,
                ref:    symbolicRefPointer
            )
            
            XCTAssertOK(refResolveResult)
            
            guard let resolvedRefPointer: OpaquePointer = resolvedRefPointer
            else
            {
                XCTFail("The resolved reference pointer was nil.")
                return
            }
            
            
            
            let resolvedRefType: GitReferenceT?
                = gitReferenceType(ref: resolvedRefPointer)
            
            XCTAssertNotNil(resolvedRefType)
            XCTAssertEqual(resolvedRefType, .gitReferenceDirect)
            
            
            
            let resolvedRefTargetOID: GitOID?
                = gitReferenceTarget(ref: resolvedRefPointer)
            
            XCTAssertNotNil(resolvedRefTargetOID)
            XCTAssertEqual(resolvedRefTargetOID, repository.headOID)
            
            
            
            let refDWIMResult: GitErrorCode = gitReferenceDWIM(
                out:        &dwimRefPointer,
                repo:       repository.pointer,
                shorthand:  Self.directRefName
            )
            
            XCTAssertOK(refDWIMResult)
            XCTAssertNotNil(dwimRefPointer)
        }
    }
    
    
    
    func testGitReferenceSetTargetAndName() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var newRefPointer       : OpaquePointer?    = nil
            var renamedRefPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitReferenceFree(ref: newRefPointer)
                gitReferenceFree(ref: renamedRefPointer)
            }
            
            
            
            let newCommitOID: GitOID = try repository.commit(
                "New content",
                toFile:     "new.txt",
                message:    "New commit"
            )
            
            let refSetTargetResult: GitErrorCode = gitReferenceSetTarget(
                out:            &newRefPointer,
                ref:            directRefPointer,
                id:             newCommitOID,
                logMessage:     "Update reference target"
            )
            
            XCTAssertOK(refSetTargetResult)
            
            guard let newRefPointer: OpaquePointer = newRefPointer
            else
            {
                XCTFail("The new reference pointer was nil.")
                return
            }
            
            
            
            let newRefTargetOID: GitOID?
                = gitReferenceTarget(ref: newRefPointer)
            
            XCTAssertNotNil(newRefTargetOID)
            XCTAssertEqual(newRefTargetOID, newCommitOID)
            
            
            
            let newRefFullName: String = "refs/heads/renamed-ref"
            
            let refRenameResult: GitErrorCode = gitReferenceRename(
                newRef:         &renamedRefPointer,
                ref:            newRefPointer,
                newName:        newRefFullName,
                force:          false,
                logMessage:     "Rename reference"
            )
            
            XCTAssertOK(refRenameResult)
            
            guard let renamedRefPointer: OpaquePointer = renamedRefPointer
            else
            {
                XCTFail("The renamed reference pointer was nil.")
                return
            }
            
            
            
            let renamedRefName: String?
                = gitReferenceName(ref: renamedRefPointer)
            
            XCTAssertNotNil(renamedRefName)
            XCTAssertEqual(renamedRefName, newRefFullName)
        }
    }
    
    
    
    func testGitReferenceSymbolicCreateMatching() throws
    {
        try Repository.withIndex
        {
            repository, _ in
            
            var matchingRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: matchingRefPointer)
            }
            
            
            
            let refSymbolicCreateMatchingResult: GitErrorCode
                = gitReferenceSymbolicCreateMatching(
                    out:            &matchingRefPointer,
                    repo:           repository.pointer,
                    name:           Self.symbolicRefFullName,
                    target:         Self.directRefFullName,
                    force:          false,
                    currentValue:   nil,
                    logMessage:     "Create symbolic with matching"
                )
            
            XCTAssertOK(refSymbolicCreateMatchingResult)
            
            guard let matchingRefPointer: OpaquePointer = matchingRefPointer
            else
            {
                XCTFail("The matching reference pointer was nil.")
                return
            }
            
            
            
            let symbolicRefType: GitReferenceT?
                = gitReferenceType(ref: matchingRefPointer)
            
            XCTAssertNotNil(symbolicRefType)
            XCTAssertEqual(symbolicRefType, .gitReferenceSymbolic)
            
            
            
            let symbolicTarget: String?
                = gitReferenceSymbolicTarget(ref: matchingRefPointer)
            
            XCTAssertNotNil(symbolicTarget)
            XCTAssertEqual(symbolicTarget, Self.directRefFullName)
        }
    }
    
    
    
    func testGitReferenceSymbolicSetTarget() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var symbolicRefPointer  : OpaquePointer?    = nil
            var updatedRefPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitReferenceFree(ref: symbolicRefPointer)
                gitReferenceFree(ref: updatedRefPointer)
            }
            
            
            
            let refCreateSymbolicResult: GitErrorCode
                = gitReferenceSymbolicCreate(
                    out:            &symbolicRefPointer,
                    repo:           repository.pointer,
                    name:           Self.symbolicRefFullName,
                    target:         Self.directRefFullName,
                    force:          false,
                    logMessage:     "Create symbolic reference"
                )
            
            XCTAssertOK(refCreateSymbolicResult)
            
            guard let symbolicRefPointer: OpaquePointer = symbolicRefPointer
            else
            {
                XCTFail("The symbolic reference pointer was nil.")
                return
            }
            
            
            
            let refSymbolicSetTargetResult: GitErrorCode
                = gitReferenceSymbolicSetTarget(
                    out:            &updatedRefPointer,
                    ref:            symbolicRefPointer,
                    target:         Self.symbolicRefFullName,
                    logMessage:     "Update symbolic target"
                )
            
            XCTAssertOK(refSymbolicSetTargetResult)
            
            guard let updatedRefPointer: OpaquePointer = updatedRefPointer
            else
            {
                XCTFail("The updated reference pointer was nil.")
                return
            }
            
            
            
            let newSymbolicTarget: String?
                = gitReferenceSymbolicTarget(ref: updatedRefPointer)
            
            XCTAssertNotNil(newSymbolicTarget)
            XCTAssertEqual(newSymbolicTarget, Self.symbolicRefFullName)
        }
    }
    
    
    
    func testGitReferenceT() throws
    {
        XCTAssertEqual(GitReferenceT.gitReferenceInvalid.rawValue, GIT_REFERENCE_INVALID.rawValue)
        XCTAssertEqual(GitReferenceT.gitReferenceDirect.rawValue, GIT_REFERENCE_DIRECT.rawValue)
        XCTAssertEqual(GitReferenceT.gitReferenceSymbolic.rawValue, GIT_REFERENCE_SYMBOLIC.rawValue)
        XCTAssertEqual(GitReferenceT.gitReferenceAll.rawValue, GIT_REFERENCE_ALL.rawValue)
        
        XCTAssertNil(GitReferenceT(rawValue: 123))
        
        XCTAssertEqual(GitReferenceT.gitReferenceInvalid.cValue(), GIT_REFERENCE_INVALID)
        XCTAssertEqual(GitReferenceT.gitReferenceDirect.cValue(), GIT_REFERENCE_DIRECT)
        XCTAssertEqual(GitReferenceT.gitReferenceSymbolic.cValue(), GIT_REFERENCE_SYMBOLIC)
        XCTAssertEqual(GitReferenceT.gitReferenceAll.cValue(), GIT_REFERENCE_ALL)
        
        XCTAssertEqual(GitReferenceT(cValue: GIT_REFERENCE_INVALID), .gitReferenceInvalid)
        XCTAssertEqual(GitReferenceT(cValue: GIT_REFERENCE_DIRECT), .gitReferenceDirect)
        XCTAssertEqual(GitReferenceT(cValue: GIT_REFERENCE_SYMBOLIC), .gitReferenceSymbolic)
        XCTAssertEqual(GitReferenceT(cValue: GIT_REFERENCE_ALL), .gitReferenceAll)
    }
    
    
    
    func testGitReferenceTargetPeel() throws
    {
        try withDirectRef
        {
            repository, _ in
            
            var tagRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: tagRefPointer)
            }
            
            
            
            let refCreateResult: GitErrorCode = gitReferenceCreate(
                out:            &tagRefPointer,
                repo:           repository.pointer,
                name:           "refs/tags/some-tag",
                id:             repository.headOID,
                force:          false,
                logMessage:     "Create tag reference"
            )
            
            XCTAssertOK(refCreateResult)
            
            guard let tagRefPointer: OpaquePointer = tagRefPointer
            else
            {
                XCTFail("The tag reference pointer was nil.")
                return
            }
            
            
            
            let refIsTag: Bool = gitReferenceIsTag(ref: tagRefPointer)
            
            XCTAssertTrue(refIsTag)
            
            
            
            let peeledOID: GitOID? = gitReferenceTargetPeel(ref: tagRefPointer)
            
            XCTAssertNil(peeledOID)
        }
    }
    
    
    
    func testGitReferenceTypeAndTarget() throws
    {
        try withDirectRef
        {
            repository, directRefPointer in
            
            var symbolicRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: symbolicRefPointer)
            }
            
            
            
            let refCreateSymbolicResult: GitErrorCode
                = gitReferenceSymbolicCreate(
                    out:            &symbolicRefPointer,
                    repo:           repository.pointer,
                    name:           Self.symbolicRefFullName,
                    target:         Self.directRefFullName,
                    force:          false,
                    logMessage:     "Create symbolic reference"
                )
            
            XCTAssertOK(refCreateSymbolicResult)
            
            guard let symbolicRefPointer: OpaquePointer = symbolicRefPointer
            else
            {
                XCTFail("The symbolic reference pointer was nil.")
                return
            }
            
            
            
            let symbolicRefType: GitReferenceT?
                = gitReferenceType(ref: symbolicRefPointer)
            
            XCTAssertNotNil(symbolicRefType)
            XCTAssertEqual(symbolicRefType, .gitReferenceSymbolic)
            
            
            
            let symbolicTarget: String?
                = gitReferenceSymbolicTarget(ref: symbolicRefPointer)
            
            XCTAssertNotNil(symbolicTarget)
            XCTAssertEqual(symbolicTarget, Self.directRefFullName)
        }
    }
}



// MARK: - Extensions

private extension RefsTests
{
    static let directRefName        : String    = "direct-test"
    static let symbolicRefName      : String    = "symbolic-test"
    static let directRefFullName    : String    = "refs/heads/\(directRefName)"
    static let symbolicRefFullName  : String    = "refs/heads/\(symbolicRefName)"
    
    
    
    static let refForEachCB: GitReferenceForEachCB =
    {
        reference, payload in
        
        defer
        {
            gitReferenceFree(ref: reference)
        }
        
        guard
            let payload     : UnsafeMutableRawPointer   = payload,
            let reference   : OpaquePointer             = reference,
            let refName     : String                    = gitReferenceName(ref: reference)
        else
        {
            XCTFail("All or some callback parameters were nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.refCount     += 1
        payloadPointer.pointee.lastRefName  = refName
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    static let refForEachNameCB: GitReferenceForEachNameCB =
    {
        name, payload in
        
        guard
            let payload: UnsafeMutableRawPointer = payload,
            let refName = String(optionalCString: name)
        else
        {
            XCTFail("All or some callback parameters were nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.refCount     += 1
        payloadPointer.pointee.lastRefName  = refName
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    struct CallbackData
    {
        var refCount    : Int       = 0
        var lastRefName : String?   = nil
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a direct reference.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withDirectRef(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var directRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: directRefPointer)
            }
            
            
            
            let headOID: GitOID = repository.headOID
            
            let refCreateResult: GitErrorCode = gitReferenceCreate(
                out:            &directRefPointer,
                repo:           repository.pointer,
                name:           Self.directRefFullName,
                id:             headOID,
                force:          false,
                logMessage:     "Create direct reference"
            )
            
            XCTAssertOK(refCreateResult)
            
            guard let directRefPointer: OpaquePointer = directRefPointer
            else
            {
                XCTFail("The direct reference pointer was nil.")
                return
            }
            
            
            
            let directRefType: GitReferenceT?
                = gitReferenceType(ref: directRefPointer)
            
            XCTAssertNotNil(directRefType)
            XCTAssertEqual(directRefType, .gitReferenceDirect)
            
            
            
            let directTargetOID: GitOID?
                = gitReferenceTarget(ref: directRefPointer)
            
            XCTAssertNotNil(directTargetOID)
            XCTAssertEqual(directTargetOID, headOID)
            
            
            
            try body(
                repository,
                directRefPointer
            )
        }
    }
}
