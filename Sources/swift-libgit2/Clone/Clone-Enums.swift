//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for bypassing the Git-aware transport on clone.
///
/// ## Discussion
///
/// Bypassing the Git-aware transport on clone means that instead of a fetch, libgit2 will copy the
/// object database directory instead of figuring out what it needs, which is faster. If possible, it will
/// hardlink the files to save space.
///
/// ## C Equivalent
///
/// [`git_clone_local_t`](https://libgit2.org/docs/reference/main/clone/git_clone_local_t.html)
public enum GitCloneLocalT: UInt32
{
    /// Bypass the Git-aware transport for local paths, but use a normal fetch for `file://` URLs.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    case gitCloneLocalAuto      = 0
    
    /// Bypass the Git-aware transport even for a `file://` URL.
    case gitCloneLocal          = 1
    
    /// Do not bypass the Git-aware transport.
    case gitCloneNoLocal        = 2
    
    /// Bypass the Git-aware transport, but do not try to use hardlinks.
    case gitCLoneLocalNoLinks   = 3
    
    
    
    /// Creates a ``GitCloneLocalT`` instance from a `git_clone_local_t` instance.
    /// - Parameter cloneLocal: The `git_clone_local_t` instance to use.
    internal init?(
        cValue cloneLocal: git_clone_local_t
    )
    {
        switch cloneLocal
        {
            case GIT_CLONE_LOCAL_AUTO       : self = .gitCloneLocalAuto
            case GIT_CLONE_LOCAL            : self = .gitCloneLocal
            case GIT_CLONE_NO_LOCAL         : self = .gitCloneNoLocal
            case GIT_CLONE_LOCAL_NO_LINKS   : self = .gitCLoneLocalNoLinks
            default                         : return nil
        }
    }
    
    
    
    /// The equivalent C enum value.
    internal var cValue: git_clone_local_t
    {
        switch self
        {
            case .gitCloneLocalAuto     : return GIT_CLONE_LOCAL_AUTO
            case .gitCloneLocal         : return GIT_CLONE_LOCAL
            case .gitCloneNoLocal       : return GIT_CLONE_NO_LOCAL
            case .gitCLoneLocalNoLinks  : return GIT_CLONE_LOCAL_NO_LINKS
        }
    }
}
