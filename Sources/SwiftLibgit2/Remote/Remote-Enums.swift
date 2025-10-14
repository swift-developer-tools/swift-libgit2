//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Remote redirection settings.
///
/// ## Discussion
///
/// The default behavior of Git is to follow a redirect on the initial request
/// (`/info/refs`), but not on subsequent requests.
///
/// ## C Equivalent
///
/// [`git_remote_redirect_t`](https://libgit2.org/docs/reference/main/remote/git_remote_redirect_t.html)
public enum GitRemoteRedirectT: UInt32, CEnum
{
    /// Do not follow any off-site redirects at any stage of the fetch or push
    /// operation.
    case gitRemoteRedirectNone      = 0
    
    /// Allow off-site redirects only upon the initial request.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    case gitRemoteRedirectInitial   = 1
    
    /// Allow redirects at any stage in the fetch or push operation.
    case gitRemoteRedirectAll       = 2
    
    
    
    /// Creates a ``GitRemoteRedirectT`` instance from a `git_remote_redirect_t`
    /// instance.
    /// - Parameter remoteRedirect: The `git_remote_redirect_t` instance to use.
    internal init?(
        cValue remoteRedirect: git_remote_redirect_t
    )
    {
        switch remoteRedirect
        {
            case GIT_REMOTE_REDIRECT_NONE       : self = .gitRemoteRedirectNone
            case GIT_REMOTE_REDIRECT_INITIAL    : self = .gitRemoteRedirectInitial
            case GIT_REMOTE_REDIRECT_ALL        : self = .gitRemoteRedirectAll
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitRemoteRedirectT`` instance into a
    /// `git_remote_redirect_t` instance.
    /// - Returns: The `git_remote_redirect_t` instance.
    internal func cValue() -> git_remote_redirect_t
    {
        switch self
        {
            case .gitRemoteRedirectNone     : return GIT_REMOTE_REDIRECT_NONE
            case .gitRemoteRedirectInitial  : return GIT_REMOTE_REDIRECT_INITIAL
            case .gitRemoteRedirectAll      : return GIT_REMOTE_REDIRECT_ALL
        }
    }
}



/// The flags controlling remote creation.
///
/// ## C Equivalent
///
/// [`git_remote_create_flags`](https://libgit2.org/docs/reference/main/remote/git_remote_create_flags.html)
public struct GitRemoteCreateFlags: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitRemoteCreateFlags`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitRemoteCreateFlags`` instance from a
    /// `git_remote_create_flags` instance.
    /// - Parameter remoteCreateFlags: The `git_remote_create_flags` instance
    /// to use.
    internal init(
        cValue remoteCreateFlags: git_remote_create_flags
    )
    {
        self.rawValue = remoteCreateFlags.rawValue
    }
    
    
    
    /// Ignore the repository's `apply.insteadOf` configuration.
    public static let gitRemoteCreateSkipInsteadOf          = GitRemoteCreateFlags(rawValue: GIT_REMOTE_CREATE_SKIP_INSTEADOF.rawValue)
    
    /// Do not build a fetchspec from the name if no fetchspec has been set.
    public static let gitRemoteCreateSkipDefaultFetchspec   = GitRemoteCreateFlags(rawValue: GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC.rawValue)
    
    
    
    /// Converts the ``GitRemoteCreateFlags`` instance into a
    /// `git_remote_create_flags` instance.
    /// - Returns: The `git_remote_create_flags` instance.
    internal func cValue() -> git_remote_create_flags
    {
        return git_remote_create_flags(rawValue)
    }
}



/// The flags controlling remote updates.
///
/// ## C Equivalent
///
/// [`git_remote_update_flags`](https://libgit2.org/docs/reference/main/remote/git_remote_update_flags.html)
public struct GitRemoteUpdateFlags: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Creates a ``GitRemoteUpdateFlags`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Creates a ``GitRemoteUpdateFlags`` instance from a
    /// `git_remote_update_flags` instance.
    /// - Parameter remoteUpdateFlags: The `git_remote_update_flags` instance
    /// to use.
    internal init(
        cValue remoteUpdateFlags: git_remote_update_flags
    )
    {
        self.rawValue = remoteUpdateFlags.rawValue
    }
    
    
    
    /// Update `FETCH_HEAD` during fetch operations.
    public static let gitRemoteUpdateFetchHEAD          = GitRemoteUpdateFlags(rawValue: GIT_REMOTE_UPDATE_FETCHHEAD.rawValue)
    
    /// Report status updates even for references that have not changed.
    public static let gitRemoteUpdateReportUnchanged    = GitRemoteUpdateFlags(rawValue: GIT_REMOTE_UPDATE_REPORT_UNCHANGED.rawValue)
    
    
    
    /// Converts the ``GitRemoteUpdateFlags`` instance into a
    /// `git_remote_update_flags` instance.
    /// - Returns: The `git_remote_update_flags` instance.
    internal func cValue() -> git_remote_update_flags
    {
        return git_remote_update_flags(rawValue)
    }
}



/// The type of remote operation that was completed.
///
/// ## C Equivalent
///
/// [`git_remote_completion_t`](https://libgit2.org/docs/reference/main/remote/git_remote_completion_t.html)
public enum GitRemoteCompletionT: UInt32, CEnum
{
    /// Remote downloading has completed.
    case gitRemoteCompletionDownload    = 0
    
    /// Remote indexing has completed.
    case gitRemoteCompletionIndexing    = 1
    
    /// A remote operation error has occurred.
    case gitRemoteCompletionError       = 2
    
    
    
    /// Creates a ``GitRemoteCompletionT`` instance from a
    /// `git_remote_completion_t` instance.
    /// - Parameter remoteCompletion: The `git_remote_completion_t` instance
    /// to use.
    internal init?(
        cValue remoteCompletion: git_remote_completion_t
    )
    {
        switch remoteCompletion
        {
            case GIT_REMOTE_COMPLETION_DOWNLOAD : self = .gitRemoteCompletionDownload
            case GIT_REMOTE_COMPLETION_INDEXING : self = .gitRemoteCompletionIndexing
            case GIT_REMOTE_COMPLETION_ERROR    : self = .gitRemoteCompletionError
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitRemoteCompletionT`` instance into a
    /// `git_remote_completion_t` instance.
    /// - Returns: The `git_remote_completion_t` instance.
    internal func cValue() -> git_remote_completion_t
    {
        switch self
        {
            case .gitRemoteCompletionDownload   : return GIT_REMOTE_COMPLETION_DOWNLOAD
            case .gitRemoteCompletionIndexing   : return GIT_REMOTE_COMPLETION_INDEXING
            case .gitRemoteCompletionError      : return GIT_REMOTE_COMPLETION_ERROR
        }
    }
}



/// The acceptable prune settings when performing a fetch operation.
///
/// ## C Equivalent
///
/// [`git_fetch_prune_t`](https://libgit2.org/docs/reference/main/remote/git_fetch_prune_t.html)
public enum GitFetchPruneT: UInt32, CEnum
{
    /// Use the setting from the configuration.
    case gitFetchPruneUnspecified   = 0
    
    /// Enable force-pruning.
    case gitFetchPrune              = 1
    
    /// Disable force-pruning.
    case gitFetchNoPrune            = 2
    
    
    
    /// Creates a ``GitFetchPruneT`` instance from a `git_fetch_prune_t`
    /// instance.
    /// - Parameter fetchPrune: The `git_fetch_prune_t` instance to use.
    internal init?(
        cValue fetchPrune: git_fetch_prune_t
    )
    {
        switch fetchPrune
        {
            case GIT_FETCH_PRUNE_UNSPECIFIED    : self = .gitFetchPruneUnspecified
            case GIT_FETCH_PRUNE                : self = .gitFetchPrune
            case GIT_FETCH_NO_PRUNE             : self = .gitFetchNoPrune
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitFetchPruneT`` instance into a `git_fetch_prune_t`
    /// instance.
    /// - Returns: The `git_fetch_prune_t` instance.
    internal func cValue() -> git_fetch_prune_t
    {
        switch self
        {
            case .gitFetchPruneUnspecified  : return GIT_FETCH_PRUNE_UNSPECIFIED
            case .gitFetchPrune             : return GIT_FETCH_PRUNE
            case .gitFetchNoPrune           : return GIT_FETCH_NO_PRUNE
        }
    }
}



/// The automatic tag-following option used to determine which `--tags` option
/// to use.
///
/// ## C Equivalent
///
/// [`git_remote_autotag_option_t`](https://libgit2.org/docs/reference/main/remote/git_remote_autotag_option_t.html)
public enum GitRemoteAutoTagOptionT: UInt32, CEnum
{
    /// Use the setting from the configuration.
    case gitRemoteDownloadTagsUnspecified   = 0
    
    /// Ask the server for tags pointing to objects that are already being
    /// downloaded.
    case gitRemoteDownloadTagsAuto          = 1
    
    /// Do not ask for any tags beyond the refspecs.
    case gitRemoteDownloadTagsNone          = 2
    
    /// Ask for all the tags.
    case gitRemoteDownloadTagsAll           = 3
    
    
    
    /// Creates a ``GitRemoteAutoTagOptionT`` instance from a
    /// `git_remote_autotag_option_t` instance.
    /// - Parameter remoteAutotagOption: The `git_remote_autotag_option_t`
    /// instance to use.
    internal init?(
        cValue remoteAutotagOption: git_remote_autotag_option_t
    )
    {
        switch remoteAutotagOption
        {
            case GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED   : self = .gitRemoteDownloadTagsUnspecified
            case GIT_REMOTE_DOWNLOAD_TAGS_AUTO          : self = .gitRemoteDownloadTagsAuto
            case GIT_REMOTE_DOWNLOAD_TAGS_NONE          : self = .gitRemoteDownloadTagsNone
            case GIT_REMOTE_DOWNLOAD_TAGS_ALL           : self = .gitRemoteDownloadTagsAll
            default                                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitRemoteAutoTagOptionT`` instance into a
    /// `git_remote_autotag_option_t` instance.
    /// - Returns: The `git_remote_autotag_option_t` instance.
    internal func cValue() -> git_remote_autotag_option_t
    {
        switch self
        {
            case .gitRemoteDownloadTagsUnspecified  : return GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED
            case .gitRemoteDownloadTagsAuto         : return GIT_REMOTE_DOWNLOAD_TAGS_AUTO
            case .gitRemoteDownloadTagsNone         : return GIT_REMOTE_DOWNLOAD_TAGS_NONE
            case .gitRemoteDownloadTagsAll          : return GIT_REMOTE_DOWNLOAD_TAGS_ALL
        }
    }
}



/// The shallowness of the fetch operation.
///
/// ## C Equivalent
///
/// [`git_fetch_depth_t`](https://libgit2.org/docs/reference/main/remote/git_fetch_depth_t.html)
public enum GitFetchDepthT: UInt32, CEnum
{
    /// Perform a full fetch operation.
    ///
    /// ## Discussion
    ///
    /// This is the default value.
    case gitFetchDepthFull          = 0
    
    /// Perform an unshallow fetch operation and fetch missing data.
    case gitFetchDepthUnshallow     = 2147483647
    
    
    
    /// Creates a ``GitFetchDepthT`` instance from a `git_fetch_depth_t`
    /// instance.
    /// - Parameter fetchDepth: The `git_fetch_depth_t` instance to use.
    internal init?(
        cValue fetchDepth: git_fetch_depth_t
    )
    {
        switch fetchDepth
        {
            case GIT_FETCH_DEPTH_FULL       : self = .gitFetchDepthFull
            case GIT_FETCH_DEPTH_UNSHALLOW  : self = .gitFetchDepthUnshallow
            default                         : return nil
        }
    }
    
    
    
    /// Converts the ``GitFetchDepthT`` instance into a `git_fetch_depth_t`
    /// instance.
    /// - Returns: The `git_fetch_depth_t` instance.
    internal func cValue() -> git_fetch_depth_t
    {
        switch self
        {
            case .gitFetchDepthFull         : return GIT_FETCH_DEPTH_FULL
            case .gitFetchDepthUnshallow    : return GIT_FETCH_DEPTH_UNSHALLOW
        }
    }
}
