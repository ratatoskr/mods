const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const plugin: wraith.Plugin = .init(b, .{
        .name = "screenshot",
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = optimize,
    });
    const tinyexr = b.dependency("tinyexr", .{});
    for (plugin.arches) |arch| {
        arch.mod.linkLibrary(exrLibrary(b, tinyexr, arch.target));
        const header = b.addTranslateC(.{
            .root_source_file = tinyexr.path("include/exr.h"),
            .target = arch.target,
            .optimize = optimize,
            .link_libc = true,
        });
        arch.mod.addImport("exr", header.createModule());
    }
    plugin.install(b);
    b.getInstallStep().dependOn(&b.addInstallFile(tinyexr.path("LICENSE"), "licenses/tinyexr.txt").step);
    b.getInstallStep().dependOn(&b.addInstallFile(tinyexr.path("deps/zstd/LICENSE"), "licenses/zstd.txt").step);
}

/// Always optimized, it's slow otherwise.
fn exrLibrary(b: *std.Build, tinyexr: *std.Build.Dependency, target: std.Build.ResolvedTarget) *std.Build.Step.Compile {
    const module = b.createModule(.{ .target = target, .optimize = .ReleaseFast, .link_libc = true });
    module.addIncludePath(tinyexr.path("include"));
    module.addIncludePath(tinyexr.path("src"));
    module.addIncludePath(tinyexr.path("deps/zstd"));
    module.addCSourceFiles(.{
        .root = tinyexr.path(""),
        .files = &.{
            "src/exr_attr.c",           "src/exr_b44.c",            "src/exr_codec.c",
            "src/exr_color.c",          "src/exr_context.c",        "src/exr_convert.c",
            "src/exr_core.c",           "src/exr_cpu.c",            "src/exr_deep.c",
            "src/exr_deflate.c",        "src/exr_half.c",           "src/exr_jph.c",
            "src/exr_fpnge.c",          "src/exr_jph_simd.c",       "src/exr_jph_simd_neon.c",
            "src/exr_libdeflate.c",     "src/exr_mip.c",            "src/exr_piz.c",
            "src/exr_pxr24.c",          "src/exr_reader.c",         "src/exr_resize.c",
            "src/exr_rle.c",            "src/exr_simd_neon.c",      "src/exr_simd_x86.c",
            "src/exr_source.c",         "src/exr_source_part.c",    "src/exr_thread.c",
            "src/exr_tonemap.c",        "src/exr_util_simd_neon.c", "src/exr_util_simd_x86.c",
            "src/exr_writer.c",         "src/exr_zip.c",            "src/exr_zstd.c",
            "deps/zstd/tinyexr_zstd.c",
        },
        .flags = &.{"-std=c11"},
    });
    return b.addLibrary(.{ .name = "tinyexr", .linkage = .static, .root_module = module });
}
