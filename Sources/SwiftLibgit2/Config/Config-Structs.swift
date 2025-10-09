//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// An entry in a configuration file.
///
/// ## C Equivalent
///
/// [`git_config_entry`](https://libgit2.org/docs/reference/main/config/git_config_entry.html)
public struct GitConfigEntry: GitStructInternalMutable, WithCConvertible
{
    /// The normalized name of the configuration entry.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var name            : String?           = nil
    
    /// The value of the configuration entry.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var value           : String?           = nil
    
    /// The type of backend in which the configuration entry exists (for example, `file`).
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var backendType     : String?           = nil
    
    /// The path to the origin of the configuration entry.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// For configuration files, this represents the path to the file.
    public private(set) var originPath      : String?           = nil
    
    /// The depth of includes where the configuration entry was found.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public private(set) var includeDepth    : UInt32            = 0
    
    /// The configuration level for the file in which the configuration entry was found.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitConfigLevelT/gitConfigLevelLocal``.
    public private(set) var level           : GitConfigLevelT   = .gitConfigLevelLocal
    
    
    
    /// Creates a ``GitConfigEntry`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitConfigEntry`` instance from a `git_config_entry` instance.
    /// - Parameter configEntry: The `git_config_entry` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``level`` defaults to ``GitConfigLevelT/gitConfigLevelLocal`` if an unexpected
    /// value is encountered, although this should never occur.
    internal init(
        cValue configEntry: git_config_entry
    )
    {
        self.name           = String(optionalCString: configEntry.name)
        self.value          = String(optionalCString: configEntry.value)
        self.backendType    = String(optionalCString: configEntry.backend_type)
        self.originPath     = String(optionalCString: configEntry.origin_path)
        self.includeDepth   = configEntry.include_depth
        self.level          = GitConfigLevelT(cValue: configEntry.level) ?? .gitConfigLevelLocal
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_config_entry` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_config_entry>) throws -> T
    ) rethrows -> T
    {
        var configEntry = git_config_entry()
        
        configEntry.include_depth   = includeDepth
        configEntry.level           = level.cValue()
        
        return try name.withOptionalCString
        {
            cName in
            
            configEntry.name = cName
            
            return try value.withOptionalCString
            {
                cValue in
                
                configEntry.value = cValue
                
                return try backendType.withOptionalCString
                {
                    cBackendType in
                    
                    configEntry.backend_type = cBackendType
                    
                    return try originPath.withOptionalCString
                    {
                        cOriginPath in
                        
                        configEntry.origin_path = cOriginPath
                        
                        return try body(&configEntry)
                    }
                }
            }
        }
    }
}




/// A mapping from configuration variables to integer values.
///
/// ## Discussion
///
/// This defines how configuration values should be mapped to integer constants by specifying the
/// type of value ot match, an optional string to match against, and the integer value to map when
/// a match is found.
///
/// ## C Equivalent
///
/// [`git_configmap`](https://libgit2.org/docs/reference/main/config/git_configmap.html)
public struct GitConfigMap: GitStructMutable, WithCConvertible
{
    /// The type of configuration value to match.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitConfigMapT/gitConfigMapFalse``.
    public var type     : GitConfigMapT     = .gitConfigMapFalse
    
    /// The specific string to match against.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// When ``type`` is ``GitConfigMapT/gitConfigMapString``, this specifies the exact
    /// string value to match using case-insensitive comparison. This is ignored for other types.
    public var strMatch : String?           = nil
    
    /// The integer value to return when a match is found.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mapValue : Int               = 0
    
    
    
    /// Creates a ``GitConfigMap`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitConfigMap`` instance from a `git_configmap` instance.
    /// - Parameter configMap: The `git_configmap` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``certType`` defaults to ``GitCertT/gitCertNone`` if an unexpected
    /// value is encountered, although this should never occur.
    internal init(
        cValue configMap: git_configmap
    )
    {
        self.type       = GitConfigMapT(cValue: configMap.type) ?? .gitConfigMapFalse
        self.strMatch   = String(optionalCString: configMap.str_match)
        self.mapValue   = Int(configMap.map_value)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_configmap` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_configmap>) throws -> T
    ) rethrows -> T
    {
        var configMap = git_configmap()
        
        configMap.type          = type.cValue()
        configMap.map_value     = Int32(mapValue)
        
        return try strMatch.withOptionalCString
        {
            cStrMatch in
            
            configMap.str_match = cStrMatch
            
            return try body(&configMap)
        }
    }
}
