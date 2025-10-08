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



final class ErrorsTests: XCTestCaseStopOnFail
{
    func testGitError() throws
    {
        let error = GitError(cValue: git_error())
        
        XCTAssertNil(error.message)
        XCTAssertEqual(error.klass, .gitErrorNone)
        
        error.withCValue
        {
            cError in
            
            XCTAssertNil(cError.pointee.message)
            XCTAssertEqual(GitErrorT(rawValue: cError.pointee.klass), .gitErrorNone)
        }
    }
    
    
    
    func testGitErrorCode() throws
    {
        XCTAssertEqual(GitErrorCode.gitOK.cValue(), GIT_OK)
        XCTAssertEqual(GitErrorCode.gitError.cValue(), GIT_ERROR)
        XCTAssertEqual(GitErrorCode.gitENotFound.cValue(), GIT_ENOTFOUND)
        XCTAssertEqual(GitErrorCode.gitEExists.cValue(), GIT_EEXISTS)
        XCTAssertEqual(GitErrorCode.gitEAmbiguous.cValue(), GIT_EAMBIGUOUS)
        XCTAssertEqual(GitErrorCode.gitEBufs.cValue(), GIT_EBUFS)
        XCTAssertEqual(GitErrorCode.gitEUser.cValue(), GIT_EUSER)
        XCTAssertEqual(GitErrorCode.gitEBareRepo.cValue(), GIT_EBAREREPO)
        XCTAssertEqual(GitErrorCode.gitEUnbornBranch.cValue(), GIT_EUNBORNBRANCH)
        XCTAssertEqual(GitErrorCode.gitEUnmerged.cValue(), GIT_EUNMERGED)
        XCTAssertEqual(GitErrorCode.gitENonFastForward.cValue(), GIT_ENONFASTFORWARD)
        XCTAssertEqual(GitErrorCode.gitEInvalidSpec.cValue(), GIT_EINVALIDSPEC)
        XCTAssertEqual(GitErrorCode.gitEConflict.cValue(), GIT_ECONFLICT)
        XCTAssertEqual(GitErrorCode.gitELocked.cValue(), GIT_ELOCKED)
        XCTAssertEqual(GitErrorCode.gitEModified.cValue(), GIT_EMODIFIED)
        XCTAssertEqual(GitErrorCode.gitEAuth.cValue(), GIT_EAUTH)
        XCTAssertEqual(GitErrorCode.gitECertificate.cValue(), GIT_ECERTIFICATE)
        XCTAssertEqual(GitErrorCode.gitEApplied.cValue(), GIT_EAPPLIED)
        XCTAssertEqual(GitErrorCode.gitEPeel.cValue(), GIT_EPEEL)
        XCTAssertEqual(GitErrorCode.gitEEOF.cValue(), GIT_EEOF)
        XCTAssertEqual(GitErrorCode.gitEInvalid.cValue(), GIT_EINVALID)
        XCTAssertEqual(GitErrorCode.gitEUncommitted.cValue(), GIT_EUNCOMMITTED)
        XCTAssertEqual(GitErrorCode.gitEDirectory.cValue(), GIT_EDIRECTORY)
        XCTAssertEqual(GitErrorCode.gitEMergeConflict.cValue(), GIT_EMERGECONFLICT)
        XCTAssertEqual(GitErrorCode.gitPassthrough.cValue(), GIT_PASSTHROUGH)
        XCTAssertEqual(GitErrorCode.gitIterOver.cValue(), GIT_ITEROVER)
        XCTAssertEqual(GitErrorCode.gitRetry.cValue(), GIT_RETRY)
        XCTAssertEqual(GitErrorCode.gitEMismatch.cValue(), GIT_EMISMATCH)
        XCTAssertEqual(GitErrorCode.gitEIndexDirty.cValue(), GIT_EINDEXDIRTY)
        XCTAssertEqual(GitErrorCode.gitEApplyFail.cValue(), GIT_EAPPLYFAIL)
        XCTAssertEqual(GitErrorCode.gitEOwner.cValue(), GIT_EOWNER)
        XCTAssertEqual(GitErrorCode.gitTimeout.cValue(), GIT_TIMEOUT)
        XCTAssertEqual(GitErrorCode.gitEUnchanged.cValue(), GIT_EUNCHANGED)
        XCTAssertEqual(GitErrorCode.gitENotSupported.cValue(), GIT_ENOTSUPPORTED)
        XCTAssertEqual(GitErrorCode.gitEReadOnly.cValue(), GIT_EREADONLY)
        
        XCTAssertEqual(GitErrorCode(rawValue: 123).cValue(), GIT_EUSER)
        
        XCTAssertEqual(GitErrorCode(cValue: GIT_OK), .gitOK)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ERROR), .gitError)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ENOTFOUND), .gitENotFound)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EEXISTS), .gitEExists)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EAMBIGUOUS), .gitEAmbiguous)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EBUFS), .gitEBufs)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EUSER), .gitEUser)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EBAREREPO), .gitEBareRepo)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EUNBORNBRANCH), .gitEUnbornBranch)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EUNMERGED), .gitEUnmerged)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ENONFASTFORWARD), .gitENonFastForward)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EINVALIDSPEC), .gitEInvalidSpec)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ECONFLICT), .gitEConflict)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ELOCKED), .gitELocked)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EMODIFIED), .gitEModified)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EAUTH), .gitEAuth)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ECERTIFICATE), .gitECertificate)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EAPPLIED), .gitEApplied)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EPEEL), .gitEPeel)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EEOF), .gitEEOF)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EINVALID), .gitEInvalid)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EUNCOMMITTED), .gitEUncommitted)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EDIRECTORY), .gitEDirectory)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EMERGECONFLICT), .gitEMergeConflict)
        XCTAssertEqual(GitErrorCode(cValue: GIT_PASSTHROUGH), .gitPassthrough)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ITEROVER), .gitIterOver)
        XCTAssertEqual(GitErrorCode(cValue: GIT_RETRY), .gitRetry)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EMISMATCH), .gitEMismatch)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EINDEXDIRTY), .gitEIndexDirty)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EAPPLYFAIL), .gitEApplyFail)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EOWNER), .gitEOwner)
        XCTAssertEqual(GitErrorCode(cValue: GIT_TIMEOUT), .gitTimeout)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EUNCHANGED), .gitEUnchanged)
        XCTAssertEqual(GitErrorCode(cValue: GIT_ENOTSUPPORTED), .gitENotSupported)
        XCTAssertEqual(GitErrorCode(cValue: GIT_EREADONLY), .gitEReadOnly)
    }
    
    
    
    func testGitErrorLast() throws
    {
        try Repository.withRepository
        {
            _ in
            
            let error: GitError = gitErrorLast()
            
            XCTAssertEqual(error.message, "no error")
            XCTAssertEqual(error.klass, .gitErrorNone)
        }
    }
    
    
    
    func testGitErrorT() throws
    {
        XCTAssertEqual(GitErrorT.gitErrorNone.cValue(), GIT_ERROR_NONE)
        XCTAssertEqual(GitErrorT.gitErrorNoMemory.cValue(), GIT_ERROR_NOMEMORY)
        XCTAssertEqual(GitErrorT.gitErrorOS.cValue(), GIT_ERROR_OS)
        XCTAssertEqual(GitErrorT.gitErrorInvalid.cValue(), GIT_ERROR_INVALID)
        XCTAssertEqual(GitErrorT.gitErrorReference.cValue(), GIT_ERROR_REFERENCE)
        XCTAssertEqual(GitErrorT.gitErrorZLib.cValue(), GIT_ERROR_ZLIB)
        XCTAssertEqual(GitErrorT.gitErrorRepository.cValue(), GIT_ERROR_REPOSITORY)
        XCTAssertEqual(GitErrorT.gitErrorConfig.cValue(), GIT_ERROR_CONFIG)
        XCTAssertEqual(GitErrorT.gitErrorRegex.cValue(), GIT_ERROR_REGEX)
        XCTAssertEqual(GitErrorT.gitErrorODB.cValue(), GIT_ERROR_ODB)
        XCTAssertEqual(GitErrorT.gitErrorIndex.cValue(), GIT_ERROR_INDEX)
        XCTAssertEqual(GitErrorT.gitErrorObject.cValue(), GIT_ERROR_OBJECT)
        XCTAssertEqual(GitErrorT.gitErrorNet.cValue(), GIT_ERROR_NET)
        XCTAssertEqual(GitErrorT.gitErrorTag.cValue(), GIT_ERROR_TAG)
        XCTAssertEqual(GitErrorT.gitErrorTree.cValue(), GIT_ERROR_TREE)
        XCTAssertEqual(GitErrorT.gitErrorIndexer.cValue(), GIT_ERROR_INDEXER)
        XCTAssertEqual(GitErrorT.gitErrorSSL.cValue(), GIT_ERROR_SSL)
        XCTAssertEqual(GitErrorT.gitErrorSubmodule.cValue(), GIT_ERROR_SUBMODULE)
        XCTAssertEqual(GitErrorT.gitErrorThread.cValue(), GIT_ERROR_THREAD)
        XCTAssertEqual(GitErrorT.gitErrorStash.cValue(), GIT_ERROR_STASH)
        XCTAssertEqual(GitErrorT.gitErrorCheckout.cValue(), GIT_ERROR_CHECKOUT)
        XCTAssertEqual(GitErrorT.gitErrorFetchHEAD.cValue(), GIT_ERROR_FETCHHEAD)
        XCTAssertEqual(GitErrorT.gitErrorMerge.cValue(), GIT_ERROR_MERGE)
        XCTAssertEqual(GitErrorT.gitErrorSSH.cValue(), GIT_ERROR_SSH)
        XCTAssertEqual(GitErrorT.gitErrorFilter.cValue(), GIT_ERROR_FILTER)
        XCTAssertEqual(GitErrorT.gitErrorRevert.cValue(), GIT_ERROR_REVERT)
        XCTAssertEqual(GitErrorT.gitErrorCallback.cValue(), GIT_ERROR_CALLBACK)
        XCTAssertEqual(GitErrorT.gitErrorCherrypick.cValue(), GIT_ERROR_CHERRYPICK)
        XCTAssertEqual(GitErrorT.gitErrorDescribe.cValue(), GIT_ERROR_DESCRIBE)
        XCTAssertEqual(GitErrorT.gitErrorRebase.cValue(), GIT_ERROR_REBASE)
        XCTAssertEqual(GitErrorT.gitErrorFileSystem.cValue(), GIT_ERROR_FILESYSTEM)
        XCTAssertEqual(GitErrorT.gitErrorPatch.cValue(), GIT_ERROR_PATCH)
        XCTAssertEqual(GitErrorT.gitErrorWorktree.cValue(), GIT_ERROR_WORKTREE)
        XCTAssertEqual(GitErrorT.gitErrorSHA.cValue(), GIT_ERROR_SHA)
        XCTAssertEqual(GitErrorT.gitErrorHTTP.cValue(), GIT_ERROR_HTTP)
        XCTAssertEqual(GitErrorT.gitErrorInternal.cValue(), GIT_ERROR_INTERNAL)
        XCTAssertEqual(GitErrorT.gitErrorGrafts.cValue(), GIT_ERROR_GRAFTS)
        
        XCTAssertEqual(GitErrorT(rawValue: 123).cValue(), GIT_ERROR_NONE)
        
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_NONE), .gitErrorNone)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_NOMEMORY), .gitErrorNoMemory)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_OS), .gitErrorOS)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_INVALID), .gitErrorInvalid)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_REFERENCE), .gitErrorReference)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_ZLIB), .gitErrorZLib)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_REPOSITORY), .gitErrorRepository)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_CONFIG), .gitErrorConfig)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_REGEX), .gitErrorRegex)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_ODB), .gitErrorODB)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_INDEX), .gitErrorIndex)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_OBJECT), .gitErrorObject)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_NET), .gitErrorNet)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_TAG), .gitErrorTag)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_TREE), .gitErrorTree)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_INDEXER), .gitErrorIndexer)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_SSL), .gitErrorSSL)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_SUBMODULE), .gitErrorSubmodule)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_THREAD), .gitErrorThread)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_STASH), .gitErrorStash)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_CHECKOUT), .gitErrorCheckout)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_FETCHHEAD), .gitErrorFetchHEAD)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_MERGE), .gitErrorMerge)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_SSH), .gitErrorSSH)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_FILTER), .gitErrorFilter)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_REVERT), .gitErrorRevert)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_CALLBACK), .gitErrorCallback)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_CHERRYPICK), .gitErrorCherrypick)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_DESCRIBE), .gitErrorDescribe)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_REBASE), .gitErrorRebase)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_FILESYSTEM), .gitErrorFileSystem)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_PATCH), .gitErrorPatch)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_WORKTREE), .gitErrorWorktree)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_SHA), .gitErrorSHA)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_HTTP), .gitErrorHTTP)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_INTERNAL), .gitErrorInternal)
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_GRAFTS), .gitErrorGrafts)
    }
}
