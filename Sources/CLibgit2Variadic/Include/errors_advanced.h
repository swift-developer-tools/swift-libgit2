//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

#ifndef errors_advanced_h
#define errors_advanced_h

#include <git2.h>
#include <stdarg.h>
#include <stdio.h>



int _git_error_set(
    int         error_class,
    const char  *fmt,
    va_list     args
);



#endif // !errors_advanced_h
