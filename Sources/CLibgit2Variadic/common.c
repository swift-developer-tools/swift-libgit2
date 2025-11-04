//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

#include "common.h"



int git_libgit2_opt_get_mwindow_size(
    size_t *size
)
{
    return git_libgit2_opts(GIT_OPT_GET_MWINDOW_SIZE, size);
}



int git_libgit2_opt_set_mwindow_size(
    size_t size
)
{
    return git_libgit2_opts(GIT_OPT_SET_MWINDOW_SIZE, size);
}



int git_libgit2_opt_get_mwindow_mapped_limit(
    size_t *limit
)
{
    return git_libgit2_opts(GIT_OPT_GET_MWINDOW_MAPPED_LIMIT, limit);
}



int git_libgit2_opt_set_mwindow_mapped_limit(
    size_t limit
)
{
    return git_libgit2_opts(GIT_OPT_SET_MWINDOW_MAPPED_LIMIT, limit);
}



int git_libgit2_opt_get_mwindow_file_limit(
    size_t *limit
)
{
    return git_libgit2_opts(GIT_OPT_GET_MWINDOW_FILE_LIMIT, limit);
}



int git_libgit2_opt_set_mwindow_file_limit(
    size_t limit
)
{
    return git_libgit2_opts(GIT_OPT_SET_MWINDOW_FILE_LIMIT, limit);
}



int git_libgit2_opt_get_search_path(
    int level,
    git_buf *buf
)
{
    return git_libgit2_opts(GIT_OPT_GET_SEARCH_PATH, level, buf);
}



int git_libgit2_opt_set_search_path(
    int level,
    const char *path
)
{
    return git_libgit2_opts(GIT_OPT_SET_SEARCH_PATH, level, path);
}



int git_libgit2_opt_set_cache_object_limit(
    git_object_t type,
    size_t size
)
{
    return git_libgit2_opts(GIT_OPT_SET_CACHE_OBJECT_LIMIT, type, size);
}



int git_libgit2_opt_set_cache_max_size(
    ssize_t max_storage_bytes
)
{
    return git_libgit2_opts(GIT_OPT_SET_CACHE_MAX_SIZE, max_storage_bytes);
}



int git_libgit2_opt_enable_caching(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_CACHING, enabled);
}



int git_libgit2_opt_get_cached_memory(
    ssize_t *current,
    ssize_t *allowed
)
{
    return git_libgit2_opts(GIT_OPT_GET_CACHED_MEMORY, current, allowed);
}



int git_libgit2_opt_get_template_path(
    git_buf *out
)
{
    return git_libgit2_opts(GIT_OPT_GET_TEMPLATE_PATH, out);
}



int git_libgit2_opt_set_template_path(
    const char *path
)
{
    return git_libgit2_opts(GIT_OPT_SET_TEMPLATE_PATH, path);
}



int git_libgit2_opt_set_ssl_cert_locations(
    const char *file,
    const char *path
)
{
    return git_libgit2_opts(GIT_OPT_SET_SSL_CERT_LOCATIONS, file, path);
}



int git_libgit2_opt_add_ssl_x509_cert(
    const void *cert
)
{
    return git_libgit2_opts(GIT_OPT_ADD_SSL_X509_CERT, cert);
}



int git_libgit2_opt_set_ssl_ciphers(
    const char *ciphers
)
{
    return git_libgit2_opts(GIT_OPT_SET_SSL_CIPHERS, ciphers);
}



int git_libgit2_opt_set_user_agent(
    const char *user_agent
)
{
    return git_libgit2_opts(GIT_OPT_SET_USER_AGENT, user_agent);
}



int git_libgit2_opt_get_user_agent(
    git_buf *out
)
{
    return git_libgit2_opts(GIT_OPT_GET_USER_AGENT, out);
}



int git_libgit2_opt_set_user_agent_product(
    const char *user_agent_product
)
{
    return git_libgit2_opts(GIT_OPT_SET_USER_AGENT_PRODUCT, user_agent_product);
}



int git_libgit2_opt_get_user_agent_product(
    git_buf *out
)
{
    return git_libgit2_opts(GIT_OPT_GET_USER_AGENT_PRODUCT, out);
}



int git_libgit2_opt_set_windows_sharemode(
    unsigned long value
)
{
    return git_libgit2_opts(GIT_OPT_SET_WINDOWS_SHAREMODE, value);
}



int git_libgit2_opt_get_windows_sharemode(
    unsigned long *value
)
{
    return git_libgit2_opts(GIT_OPT_GET_WINDOWS_SHAREMODE, value);
}



int git_libgit2_opt_enable_strict_object_creation(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_STRICT_OBJECT_CREATION, enabled);
}



int git_libgit2_opt_enable_strict_symbolic_ref_creation(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_STRICT_SYMBOLIC_REF_CREATION, enabled);
}



int git_libgit2_opt_enable_strict_hash_verification(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION, enabled);
}



int git_libgit2_opt_enable_ofs_delta(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_OFS_DELTA, enabled);
}



int git_libgit2_opt_enable_fsync_gitdir(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_FSYNC_GITDIR, enabled);
}



int git_libgit2_opt_enable_unsaved_index_safety(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY, enabled);
}



int git_libgit2_opt_disable_pack_keep_file_checks(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_DISABLE_PACK_KEEP_FILE_CHECKS, enabled);
}



int git_libgit2_opt_enable_http_expect_continue(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_ENABLE_HTTP_EXPECT_CONTINUE, enabled);
}



int git_libgit2_opt_set_allocator(
    git_allocator *allocator
)
{
    return git_libgit2_opts(GIT_OPT_SET_ALLOCATOR, allocator);
}



int git_libgit2_opt_get_pack_max_objects(
    size_t *out
)
{
    return git_libgit2_opts(GIT_OPT_GET_PACK_MAX_OBJECTS, out);
}



int git_libgit2_opt_set_pack_max_objects(
    size_t objects
)
{
    return git_libgit2_opts(GIT_OPT_SET_PACK_MAX_OBJECTS, objects);
}



int git_libgit2_opt_set_odb_packed_priority(
    int priority
)
{
    return git_libgit2_opts(GIT_OPT_SET_ODB_PACKED_PRIORITY, priority);
}



int git_libgit2_opt_set_odb_loose_priority(
    int priority
)
{
    return git_libgit2_opts(GIT_OPT_SET_ODB_LOOSE_PRIORITY, priority);
}



int git_libgit2_opt_get_extensions(
    git_strarray *out
)
{
    return git_libgit2_opts(GIT_OPT_GET_EXTENSIONS, out);
}



int git_libgit2_opt_set_extensions(
    const char **extensions,
    size_t len
)
{
    return git_libgit2_opts(GIT_OPT_SET_EXTENSIONS, extensions, len);
}



int git_libgit2_opt_get_owner_validation(
    int *enabled
)
{
    return git_libgit2_opts(GIT_OPT_GET_OWNER_VALIDATION, enabled);
}



int git_libgit2_opt_set_owner_validation(
    int enabled
)
{
    return git_libgit2_opts(GIT_OPT_SET_OWNER_VALIDATION, enabled);
}



int git_libgit2_opt_get_homedir(
    git_buf *out
)
{
    return git_libgit2_opts(GIT_OPT_GET_HOMEDIR, out);
}



int git_libgit2_opt_set_homedir(
    const char *path
)
{
    return git_libgit2_opts(GIT_OPT_SET_HOMEDIR, path);
}



int git_libgit2_opt_get_server_connect_timeout(
    int *timeout
)
{
    return git_libgit2_opts(GIT_OPT_GET_SERVER_CONNECT_TIMEOUT, timeout);
}



int git_libgit2_opt_set_server_connect_timeout(
    int timeout
)
{
    return git_libgit2_opts(GIT_OPT_SET_SERVER_CONNECT_TIMEOUT, timeout);
}



int git_libgit2_opt_get_server_timeout(
    int *timeout
)
{
    return git_libgit2_opts(GIT_OPT_GET_SERVER_TIMEOUT, timeout);
}



int git_libgit2_opt_set_server_timeout(
    int timeout
)
{
    return git_libgit2_opts(GIT_OPT_SET_SERVER_TIMEOUT, timeout);
}
