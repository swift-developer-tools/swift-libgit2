//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

#include "commit.h"



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
)
{
    if (parent_count == 0)
    {
        return git_commit_create(
            id,
            repo,
            update_ref,
            author,
            committer,
            message_encoding,
            message,
            tree,
            parent_count,
            NULL
        );
    }
    
    
    
    size_t parent_array_size = parent_count * sizeof(const git_commit *);
    
    const git_commit **parent_array = malloc(parent_array_size);
    
    if (!parent_array)
    {
        return GIT_EUSER;
    }
    
    
    
    for (size_t i = 0; i < parent_count; i++)
    {
        parent_array[i] = va_arg(
            parents,
            const git_commit *
        );
    }
    
    
    
    int commit_create_result = git_commit_create(
        id,
        repo,
        update_ref,
        author,
        committer,
        message_encoding,
        message,
        tree,
        parent_count,
        parent_array
    );
    
    free(parent_array);
    
    return commit_create_result;
}
