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
        
        try error.withCValue
        {
            cError in
            
            XCTAssertNil(cError.pointee.message)
            XCTAssertEqual(GitErrorT(rawValue: cError.pointee.klass), .gitErrorNone)
        }
    }
    
    
    
    func testGitErrorCode() throws
    {
        XCTAssertEqual(GitErrorCode.gitOK.rawValue, GIT_OK.rawValue)
        XCTAssertEqual(GitErrorCode.gitError.rawValue, GIT_ERROR.rawValue)
        XCTAssertEqual(GitErrorCode.gitENotFound.rawValue, GIT_ENOTFOUND.rawValue)
        XCTAssertEqual(GitErrorCode.gitEExists.rawValue, GIT_EEXISTS.rawValue)
        XCTAssertEqual(GitErrorCode.gitEAmbiguous.rawValue, GIT_EAMBIGUOUS.rawValue)
        XCTAssertEqual(GitErrorCode.gitEBufs.rawValue, GIT_EBUFS.rawValue)
        XCTAssertEqual(GitErrorCode.gitEUser.rawValue, GIT_EUSER.rawValue)
        XCTAssertEqual(GitErrorCode.gitEBareRepo.rawValue, GIT_EBAREREPO.rawValue)
        XCTAssertEqual(GitErrorCode.gitEUnbornBranch.rawValue, GIT_EUNBORNBRANCH.rawValue)
        XCTAssertEqual(GitErrorCode.gitEUnmerged.rawValue, GIT_EUNMERGED.rawValue)
        XCTAssertEqual(GitErrorCode.gitENonFastForward.rawValue, GIT_ENONFASTFORWARD.rawValue)
        XCTAssertEqual(GitErrorCode.gitEInvalidSpec.rawValue, GIT_EINVALIDSPEC.rawValue)
        XCTAssertEqual(GitErrorCode.gitEConflict.rawValue, GIT_ECONFLICT.rawValue)
        XCTAssertEqual(GitErrorCode.gitELocked.rawValue, GIT_ELOCKED.rawValue)
        XCTAssertEqual(GitErrorCode.gitEModified.rawValue, GIT_EMODIFIED.rawValue)
        XCTAssertEqual(GitErrorCode.gitEAuth.rawValue, GIT_EAUTH.rawValue)
        XCTAssertEqual(GitErrorCode.gitECertificate.rawValue, GIT_ECERTIFICATE.rawValue)
        XCTAssertEqual(GitErrorCode.gitEApplied.rawValue, GIT_EAPPLIED.rawValue)
        XCTAssertEqual(GitErrorCode.gitEPeel.rawValue, GIT_EPEEL.rawValue)
        XCTAssertEqual(GitErrorCode.gitEEOF.rawValue, GIT_EEOF.rawValue)
        XCTAssertEqual(GitErrorCode.gitEInvalid.rawValue, GIT_EINVALID.rawValue)
        XCTAssertEqual(GitErrorCode.gitEUncommitted.rawValue, GIT_EUNCOMMITTED.rawValue)
        XCTAssertEqual(GitErrorCode.gitEDirectory.rawValue, GIT_EDIRECTORY.rawValue)
        XCTAssertEqual(GitErrorCode.gitEMergeConflict.rawValue, GIT_EMERGECONFLICT.rawValue)
        XCTAssertEqual(GitErrorCode.gitPassthrough.rawValue, GIT_PASSTHROUGH.rawValue)
        XCTAssertEqual(GitErrorCode.gitIterOver.rawValue, GIT_ITEROVER.rawValue)
        XCTAssertEqual(GitErrorCode.gitRetry.rawValue, GIT_RETRY.rawValue)
        XCTAssertEqual(GitErrorCode.gitEMismatch.rawValue, GIT_EMISMATCH.rawValue)
        XCTAssertEqual(GitErrorCode.gitEIndexDirty.rawValue, GIT_EINDEXDIRTY.rawValue)
        XCTAssertEqual(GitErrorCode.gitEApplyFail.rawValue, GIT_EAPPLYFAIL.rawValue)
        XCTAssertEqual(GitErrorCode.gitEOwner.rawValue, GIT_EOWNER.rawValue)
        XCTAssertEqual(GitErrorCode.gitTimeout.rawValue, GIT_TIMEOUT.rawValue)
        XCTAssertEqual(GitErrorCode.gitEUnchanged.rawValue, GIT_EUNCHANGED.rawValue)
        XCTAssertEqual(GitErrorCode.gitENotSupported.rawValue, GIT_ENOTSUPPORTED.rawValue)
        XCTAssertEqual(GitErrorCode.gitEReadOnly.rawValue, GIT_EREADONLY.rawValue)
        XCTAssertEqual(GitErrorCode.gitUnknown(-123).rawValue, -123)
        
        XCTAssertEqual(GitErrorCode(rawValue: 123).cValue(), GIT_EUSER)
        
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
        XCTAssertEqual(GitErrorCode.gitUnknown(-123).cValue(), GIT_EUSER)
        
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
        XCTAssertEqual(UInt32(GitErrorT.gitErrorNone.rawValue), GIT_ERROR_NONE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorNoMemory.rawValue), GIT_ERROR_NOMEMORY.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorOS.rawValue), GIT_ERROR_OS.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorInvalid.rawValue), GIT_ERROR_INVALID.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorReference.rawValue), GIT_ERROR_REFERENCE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorZLib.rawValue), GIT_ERROR_ZLIB.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorRepository.rawValue), GIT_ERROR_REPOSITORY.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorConfig.rawValue), GIT_ERROR_CONFIG.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorRegex.rawValue), GIT_ERROR_REGEX.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorODB.rawValue), GIT_ERROR_ODB.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorIndex.rawValue), GIT_ERROR_INDEX.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorObject.rawValue), GIT_ERROR_OBJECT.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorNet.rawValue), GIT_ERROR_NET.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorTag.rawValue), GIT_ERROR_TAG.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorTree.rawValue), GIT_ERROR_TREE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorIndexer.rawValue), GIT_ERROR_INDEXER.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorSSL.rawValue), GIT_ERROR_SSL.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorSubmodule.rawValue), GIT_ERROR_SUBMODULE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorThread.rawValue), GIT_ERROR_THREAD.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorStash.rawValue), GIT_ERROR_STASH.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorCheckout.rawValue), GIT_ERROR_CHECKOUT.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorFETCHHEAD.rawValue), GIT_ERROR_FETCHHEAD.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorMerge.rawValue), GIT_ERROR_MERGE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorSSH.rawValue), GIT_ERROR_SSH.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorFilter.rawValue), GIT_ERROR_FILTER.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorRevert.rawValue), GIT_ERROR_REVERT.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorCallback.rawValue), GIT_ERROR_CALLBACK.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorCherrypick.rawValue), GIT_ERROR_CHERRYPICK.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorDescribe.rawValue), GIT_ERROR_DESCRIBE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorRebase.rawValue), GIT_ERROR_REBASE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorFileSystem.rawValue), GIT_ERROR_FILESYSTEM.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorPatch.rawValue), GIT_ERROR_PATCH.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorWorktree.rawValue), GIT_ERROR_WORKTREE.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorSHA.rawValue), GIT_ERROR_SHA.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorHTTP.rawValue), GIT_ERROR_HTTP.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorInternal.rawValue), GIT_ERROR_INTERNAL.rawValue)
        XCTAssertEqual(UInt32(GitErrorT.gitErrorGrafts.rawValue), GIT_ERROR_GRAFTS.rawValue)
        XCTAssertEqual(GitErrorT.gitUnknown(-123).rawValue, -123)
        
        XCTAssertEqual(GitErrorT(rawValue: 123).cValue(), GIT_ERROR_NONE)
        
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
        XCTAssertEqual(GitErrorT.gitErrorFETCHHEAD.cValue(), GIT_ERROR_FETCHHEAD)
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
        XCTAssertEqual(GitErrorT.gitUnknown(-123).cValue(), GIT_ERROR_NONE)
        
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
        XCTAssertEqual(GitErrorT(cValue: GIT_ERROR_FETCHHEAD), .gitErrorFETCHHEAD)
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
