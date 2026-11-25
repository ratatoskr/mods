const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Its own module, so other packages can take just the game's files
    const sqpack = b.addModule("sqpack", .{ .root_source_file = b.path("src/sqpack/root.zig"), .target = target, .optimize = optimize });
    addLibdeflate(b, sqpack);

    const plugin: wraith.Plugin = .init(b, .{
        .name = "ffxiv",
        .root_source_file = b.path("src/plugin/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    for (plugin.arches) |arch| {
        const mod = b.createModule(.{ .root_source_file = b.path("src/sqpack/root.zig"), .target = arch.target, .optimize = optimize });
        addLibdeflate(b, mod);
        arch.mod.addImport("sqpack", mod);
    }
    plugin.install(b);

    // WRAITH_FFXIV_GAME=<the game folder> runs the ones that read its files
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = sqpack })).step);
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = plugin.main().mod })).step);
    // It ships ClientStructs' schemas and libdeflate, so their licenses go with them
    b.installFile("THIRD_PARTY_NOTICES.md", "THIRD_PARTY_NOTICES.md");

    // ClientStructs' types as schemas/clientstructs, through tools/ClientStructsSal. Needs the .NET SDK.
    const client_structs = b.dependency("ffxivclientstructs", .{});
    const run = b.addSystemCommand(&.{ "dotnet", "run", "-c", "Release", "--project" });
    run.addFileArg(b.path("tools/ClientStructsSal/ClientStructsSal.csproj"));
    // Kept between runs, so dotnet only builds what changed, and out of the dependency's folder
    run.addPrefixedDirectoryArg("--artifacts-path=", b.path(".zig-cache/client-structs"));
    run.addPrefixedDirectoryArg("-p:ClientStructsDir=", client_structs.path("."));
    run.addArg("--");
    run.addDirectoryArg(b.path("schemas/clientstructs"));
    run.has_side_effects = true;
    b.step("client-structs", "Write schemas/clientstructs from FFXIVClientStructs").dependOn(&run.step);
}

/// Its decompressor, through src/sqpack/deflate.c, which needs no libc.
fn addLibdeflate(b: *std.Build, mod: *std.Build.Module) void {
    mod.addIncludePath(b.dependency("libdeflate", .{}).path(""));
    mod.addCSourceFile(.{ .file = b.path("src/sqpack/deflate.c"), .flags = &.{ "-std=c99", "-ffreestanding" } });
}
