// libdeflate's decompressor, built in this one file without libc. See Inflater.zig.

// Its memset and friends become compiler builtins, and nothing pulls in stdlib.h
#define FREESTANDING

#include "lib/deflate_decompress.c"
#include "lib/x86/cpu_features.c"
#include "lib/arm/cpu_features.c"

// Usually utils.c's, for libdeflate_alloc_decompressor, which isn't used. Zig owns the memory.
malloc_func_t libdeflate_default_malloc_func = NULL;
free_func_t libdeflate_default_free_func = NULL;

size_t ffxiv_inflater_size(void) {
    return sizeof(struct libdeflate_decompressor);
}

// `state` is ffxiv_inflater_size bytes, zeroed before its first use. Only succeeds if `in` unpacks
// to exactly `out_len` bytes.
int ffxiv_inflate(void *state, const void *in, size_t in_len, void *out, size_t out_len) {
    return libdeflate_deflate_decompress(state, in, in_len, out, out_len, NULL);
}
