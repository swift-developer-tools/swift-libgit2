//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

#ifndef commit_h
#define commit_h

#include <git2.h>
#include <stdarg.h>



int _git_commit_create_v(
    git_oid                 *id,
    git_repository          *repo,
    const char              *update_ref,
    const git_signature     *author,
    const git_signature     *committer,
    const char              *message_encoding,
    const char              *message,
    const git_tree          *tree,
    size_t                  parent_count,
    va_list                 parents
);



#endif // !commit_h
