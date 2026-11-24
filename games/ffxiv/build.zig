const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const plugin: wraith.Plugin = .init(b, .{
        .name = "ffxiv",
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    plugin.install(b);
    // It ships ClientStructs' schemas, so its license goes with them
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
