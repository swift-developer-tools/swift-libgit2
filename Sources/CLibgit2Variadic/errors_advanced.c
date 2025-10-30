//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

#include "errors_advanced.h"



int _git_error_set(
    int         error_class,
    const char  *fmt,
    va_list     args
)
{
    va_list args_copy;
    
    va_copy(
        args_copy,
        args
    );
    
    
    
    int size = vsnprintf(
        NULL,
        0,
        fmt,
        args_copy
    );
    
    va_end(args_copy);
    
    if (size < 0)
    {
        return GIT_EUSER;
    }
    
    
    
    int buffer_size = size + 1;
    
    char *buffer = malloc(buffer_size);
    
    if (!buffer)
    {
        return GIT_EUSER;
    }
    
    vsnprintf(
        buffer,
        buffer_size,
        fmt,
        args
    );
    
    git_error_set(
        error_class,
        "%s",
        buffer
    );
    
    
    
    free(buffer);
    
    return GIT_OK;
}
