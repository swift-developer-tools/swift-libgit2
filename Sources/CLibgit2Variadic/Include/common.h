//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

#ifndef common_h
#define common_h

#include <git2.h>



int git_libgit2_opt_get_mwindow_size(size_t *size);
int git_libgit2_opt_set_mwindow_size(size_t size);
int git_libgit2_opt_get_mwindow_mapped_limit(size_t *limit);
int git_libgit2_opt_set_mwindow_mapped_limit(size_t limit);
int git_libgit2_opt_get_mwindow_file_limit(size_t *limit);
int git_libgit2_opt_set_mwindow_file_limit(size_t limit);

int git_libgit2_opt_get_search_path(int level, git_buf *buf);
int git_libgit2_opt_set_search_path(int level, const char *path);

int git_libgit2_opt_set_cache_object_limit(git_object_t type, size_t size);
int git_libgit2_opt_set_cache_max_size(ssize_t max_storage_bytes);
int git_libgit2_opt_enable_caching(int enabled);
int git_libgit2_opt_get_cached_memory(ssize_t *current, ssize_t *allowed);

int git_libgit2_opt_get_template_path(git_buf *out);
int git_libgit2_opt_set_template_path(const char *path);

int git_libgit2_opt_set_ssl_cert_locations(const char *file, const char *path);
int git_libgit2_opt_add_ssl_x509_cert(const void *cert);
int git_libgit2_opt_set_ssl_ciphers(const char *ciphers);

int git_libgit2_opt_set_user_agent(const char *user_agent);
int git_libgit2_opt_get_user_agent(git_buf *out);
int git_libgit2_opt_set_user_agent_product(const char *user_agent_product);
int git_libgit2_opt_get_user_agent_product(git_buf *out);

int git_libgit2_opt_set_windows_sharemode(unsigned long value);
int git_libgit2_opt_get_windows_sharemode(unsigned long *value);

int git_libgit2_opt_enable_strict_object_creation(int enabled);
int git_libgit2_opt_enable_strict_symbolic_ref_creation(int enabled);
int git_libgit2_opt_enable_strict_hash_verification(int enabled);

int git_libgit2_opt_enable_ofs_delta(int enabled);
int git_libgit2_opt_enable_fsync_gitdir(int enabled);
int git_libgit2_opt_enable_unsaved_index_safety(int enabled);
int git_libgit2_opt_disable_pack_keep_file_checks(int enabled);
int git_libgit2_opt_enable_http_expect_continue(int enabled);

int git_libgit2_opt_set_allocator(git_allocator *allocator);

int git_libgit2_opt_get_pack_max_objects(size_t *out);
int git_libgit2_opt_set_pack_max_objects(size_t objects);

int git_libgit2_opt_set_odb_packed_priority(int priority);
int git_libgit2_opt_set_odb_loose_priority(int priority);

int git_libgit2_opt_get_extensions(git_strarray *out);
int git_libgit2_opt_set_extensions(const char **extensions, size_t len);

int git_libgit2_opt_get_owner_validation(int *enabled);
int git_libgit2_opt_set_owner_validation(int enabled);

int git_libgit2_opt_get_homedir(git_buf *out);
int git_libgit2_opt_set_homedir(const char *path);

int git_libgit2_opt_get_server_connect_timeout(int *timeout);
int git_libgit2_opt_set_server_connect_timeout(int timeout);
int git_libgit2_opt_get_server_timeout(int *timeout);
int git_libgit2_opt_set_server_timeout(int timeout);



#endif // !common_h
