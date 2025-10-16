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
public struct GitConfigEntry: CFreeable, CStructInternalMutable, WithCConvertible, Sendable
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
    
    /// The type of backend in which the configuration entry exists
    /// (for example, `file`).
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
    
    /// The configuration level for the file in which the configuration entry
    /// was found.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitConfigLevelT/gitConfigLevelLocal``.
    public private(set) var level           : GitConfigLevelT   = .gitConfigLevelLocal
    
    
    
    /// Initializes a default ``GitConfigEntry`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitConfigEntry`` instance from the given
    /// `git_config_entry` instance.
    /// - Parameter configEntry: The `git_config_entry` instance to use.
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
    
    
    
    /// Frees the memory allocated for the C value.
    /// - Parameter pointer: The pointer to the memory to free.
    internal static func freeCValue(
        _ pointer: P
    )
    {
        gitConfigEntryFree(entry: pointer)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_config_entry`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
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
/// This defines how to map configuration values to integer constants by
/// specifying the type of value ot match, an optional string to match against,
/// and the integer value to map when a match is found.
///
/// ## C Equivalent
///
/// [`git_configmap`](https://libgit2.org/docs/reference/main/config/git_configmap.html)
public struct GitConfigMap: CStructMutable, WithCConvertible, Sendable
{
    /// The type of configuration value to match.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitConfigMapT/gitConfigMapFalse``.
    public var type     : GitConfigMapT
    
    /// The specific string to match against.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// When ``type`` is ``GitConfigMapT/gitConfigMapString``, this specifies
    /// the exact string value to match using case-insensitive comparison.
    /// This is ignored for other types.
    public var strMatch : String?
    
    /// The integer value to return when a match is found.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mapValue : Int32
    
    
    
    /// Initializes a ``GitConfigMap`` instance, optionally specifying values
    /// for its properties.
    public init(
        type        : GitConfigMapT     = .gitConfigMapFalse,
        strMatch    : String?           = nil,
        mapValue    : Int32             = 0
    )
    {
        self.type       = type
        self.strMatch   = strMatch
        self.mapValue   = mapValue
    }
    
    
    
    /// Initializes a ``GitConfigMap`` instance from the given `git_configmap`
    /// instance.
    /// - Parameter configMap: The `git_configmap` instance to use.
    internal init(
        cValue configMap: git_configmap
    )
    {
        self.type       = GitConfigMapT(cValue: configMap.type) ?? .gitConfigMapFalse
        self.strMatch   = String(optionalCString: configMap.str_match)
        self.mapValue   = configMap.map_value
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_configmap`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_configmap>) throws -> T
    ) rethrows -> T
    {
        var configMap = git_configmap()
        
        configMap.type          = type.cValue()
        configMap.map_value     = mapValue
        
        return try strMatch.withOptionalCString
        {
            cStrMatch in
            
            configMap.str_match = cStrMatch
            
            return try body(&configMap)
        }
    }
}
