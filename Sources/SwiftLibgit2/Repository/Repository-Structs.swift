//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// The options for repository initialization.
///
/// ## C Equivalent
///
/// [`git_repository_init_options`](https://libgit2.org/docs/reference/main/repository/git_repository_init_options.html)
public struct GitRepositoryInitOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRepositoryInitOptionsVersion``.
    public var version      : UInt32
    
    /// The flags controlling repository initialization.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags        : GitRepositoryInitFlagT
    
    /// The repository initialization mode.
    ///
    /// ## Discussion
    ///
    /// The default value is
    /// ``GitRepositoryInitModeT/gitRepositoryInitSharedUmask``.
    public var mode         : GitRepositoryInitModeT
    
    /// The path to the working directory.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use the repository path parent on non-bare repositories.
    ///
    /// If this is a relative path, it will be evaluate relative to the
    /// repository path. If this is not the natural working directory, a `.git`
    /// Gitlink file will be created at the specified location, linking to the
    /// repository path.
    public var workdirPath  : String?
    
    /// The contents of the repository description file.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use template content.
    public var description  : String?
    
    /// The path to the external template directory.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use the configuration or default directory options.
    public var templatePath : String?
    
    /// The name of the head at which to point HEAD.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to use `master` and point HEAD to `refs/heads/master`.
    ///
    /// If this begins with `refs/`, it will be verbatim. Otherwise,
    /// `refs/heads/` will be prefixed.
    public var initialHEAD  : String?
    
    /// The remote URL.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Pass `nil` to create an `origin` remote pointing to this URL.
    public var originURL    : String?
    
    
    
    /// Initializes a ``GitRepositoryInitOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version         : UInt32                    = gitRepositoryInitOptionsVersion,
        flags           : GitRepositoryInitFlagT    = [],
        mode            : GitRepositoryInitModeT    = .gitRepositoryInitSharedUmask,
        workdirPath     : String?                   = nil,
        description     : String?                   = nil,
        templatePath    : String?                   = nil,
        initialHEAD     : String?                   = nil,
        originURL       : String?                   = nil
    )
    {
        self.version        = version
        self.flags          = flags
        self.mode           = mode
        self.workdirPath    = workdirPath
        self.description    = description
        self.templatePath   = templatePath
        self.initialHEAD    = initialHEAD
        self.originURL      = originURL
    }
    
    
    
    /// Initializes a ``GitRepositoryInitOptions`` instance from the given
    /// `git_repository_init_options` instance.
    /// - Parameter repositoryInitOptions: The `git_repository_init_options`
    /// instance to use.
    internal init(
        cValue repositoryInitOptions: git_repository_init_options
    )
    {
        self.version        = repositoryInitOptions.version
        self.flags          = GitRepositoryInitFlagT(rawValue: repositoryInitOptions.flags)
        self.mode           = GitRepositoryInitModeT(rawValue: repositoryInitOptions.mode) ?? .gitRepositoryInitSharedUmask
        self.workdirPath    = String(optionalCString: repositoryInitOptions.workdir_path)
        self.description    = String(optionalCString: repositoryInitOptions.description)
        self.templatePath   = String(optionalCString: repositoryInitOptions.template_path)
        self.initialHEAD    = String(optionalCString: repositoryInitOptions.initial_head)
        self.originURL      = String(optionalCString: repositoryInitOptions.origin_url)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_repository_init_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_repository_init_options>) throws -> T
    ) throws -> T
    {
        var repositoryInitOptions = git_repository_init_options()
        
        let repositoryInitOptionsInitResult: GitErrorCode
            = gitRepositoryInitOptionsInit(
                opts:       &repositoryInitOptions,
                version:    version
            )
        
        if repositoryInitOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        repositoryInitOptions.flags     = flags.rawValue
        repositoryInitOptions.mode      = mode.rawValue
        
        return try workdirPath.withOptionalCString
        {
            cWorkdirPath in
            
            repositoryInitOptions.workdir_path = cWorkdirPath
            
            return try description.withOptionalCString
            {
                cDescription in
                
                repositoryInitOptions.description = cDescription
                
                return try templatePath.withOptionalCString
                {
                    cTemplatePath in
                    
                    repositoryInitOptions.template_path = cTemplatePath
                    
                    return try initialHEAD.withOptionalCString
                    {
                        cInitialHEAD in
                        
                        repositoryInitOptions.initial_head = cInitialHEAD
                        
                        return try originURL.withOptionalCString
                        {
                            cOriginURL in
                            
                            repositoryInitOptions.origin_url = cOriginURL
                            
                            return try body(&repositoryInitOptions)
                        }
                    }
                }
            }
        }
    }
}
