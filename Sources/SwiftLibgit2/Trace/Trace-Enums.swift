//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The available trace levels.
///
/// When tracing is set to a particular level, callers will be provided tracing
/// at the specified level and at all lower levels.
///
/// ## C Equivalent
///
/// [`git_trace_level_t`](https://libgit2.org/docs/reference/main/trace/git_trace_level_t.html)
public enum GitTraceLevelT: UInt32, CEnum
{
    /// Do not perform tracing.
    case gitTraceNone   = 0
    
    /// Trace severe errors that may impact the program's execution.
    case gitTraceFatal  = 1
    
    /// Trace errors that do not impact the program's execution.
    case gitTraceError  = 2
    
    /// Trace warnings that suggest abnormal data.
    case gitTraceWarn   = 3
    
    /// Trace informational messages about the program's execution.
    case gitTraceInfo   = 4
    
    /// Trace detailed debugging data.
    case gitTraceDebug  = 5
    
    /// Trace exceptionally detailed debugging data.
    case gitTraceTrace  = 6
    
    
    
    /// Initializes a ``GitTraceLevelT`` instance from the given
    /// `git_trace_level_t` instance.
    /// - Parameter traceLevel: The `git_trace_level_t` instance to use.
    internal init?(
        cValue traceLevel: git_trace_level_t
    )
    {
        switch traceLevel
        {
            case GIT_TRACE_NONE     : self = .gitTraceNone
            case GIT_TRACE_FATAL    : self = .gitTraceFatal
            case GIT_TRACE_ERROR    : self = .gitTraceError
            case GIT_TRACE_WARN     : self = .gitTraceWarn
            case GIT_TRACE_INFO     : self = .gitTraceInfo
            case GIT_TRACE_DEBUG    : self = .gitTraceDebug
            case GIT_TRACE_TRACE    : self = .gitTraceTrace
            default                 : return nil
        }
    }
    
    
    
    /// Converts the ``GitTraceLevelT`` instance into a `git_trace_level_t`
    /// instance.
    /// - Returns: The `git_trace_level_t` instance.
    internal func cValue() -> git_trace_level_t
    {
        switch self
        {
            case .gitTraceNone  : return GIT_TRACE_NONE
            case .gitTraceFatal : return GIT_TRACE_FATAL
            case .gitTraceError : return GIT_TRACE_ERROR
            case .gitTraceWarn  : return GIT_TRACE_WARN
            case .gitTraceInfo  : return GIT_TRACE_INFO
            case .gitTraceDebug : return GIT_TRACE_DEBUG
            case .gitTraceTrace : return GIT_TRACE_TRACE
        }
    }
}
