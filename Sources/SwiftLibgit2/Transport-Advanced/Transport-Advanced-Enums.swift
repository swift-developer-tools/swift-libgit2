//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The actions that a smart transport can ask a subtransport to perform.
///
/// ## C Equivalent
///
/// [`git_smart_service_t`](https://libgit2.org/docs/reference/main/sys/transport/git_smart_service_t.html)
public enum GitSmartServiceT: UInt32, CEnum
{
    /// List the references available for fetching or cloning.
    ///
    /// This is equivalent to `git-upload-pack --advertise-refs` or
    /// `git-upload-pack --http-backend-info-refs`.
    case gitServiceUploadPackLS     = 1
    
    /// Fetch objects from the remote repository.
    ///
    /// This is equivalent to `git-upload-pack`.
    case gitServiceUploadPack       = 2
    
    /// List the references available for pushing.
    ///
    /// This is equivalent to `git-receive-pack --http-backend-info-refs`.
    case gitServiceReceivePackLS    = 3
    
    /// Push objects to the remote repository.
    ///
    /// This is equivalent to `git-receive-pack`.
    case gitServiceReceivePack      = 4
    
    
    
    /// Initializes a ``GitSmartServiceT`` instance from the given
    /// `git_smart_service_t` instance.
    /// - Parameter smartService: The `git_smart_service_t` instance to use.
    internal init?(
        cValue smartService: git_smart_service_t
    )
    {
        switch smartService
        {
            case GIT_SERVICE_UPLOADPACK_LS  : self = .gitServiceUploadPackLS
            case GIT_SERVICE_UPLOADPACK     : self = .gitServiceUploadPack
            case GIT_SERVICE_RECEIVEPACK_LS : self = .gitServiceReceivePackLS
            case GIT_SERVICE_RECEIVEPACK    : self = .gitServiceReceivePack
            default                         : return nil
        }
    }
    
    
    
    /// Converts the ``GitSmartServiceT`` instance into a `git_smart_service_t`
    /// instance.
    /// - Returns: The `git_smart_service_t` instance.
    internal func cValue() -> git_smart_service_t
    {
        switch self
        {
            case .gitServiceUploadPackLS    : return GIT_SERVICE_UPLOADPACK_LS
            case .gitServiceUploadPack      : return GIT_SERVICE_UPLOADPACK
            case .gitServiceReceivePackLS   : return GIT_SERVICE_RECEIVEPACK_LS
            case .gitServiceReceivePack     : return GIT_SERVICE_RECEIVEPACK
        }
    }
}
