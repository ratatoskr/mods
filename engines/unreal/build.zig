const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const plugin: wraith.Plugin = .init(b, .{
        .name = "unreal",
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    plugin.install(b);

    const tests = b.addTest(.{ .root_module = plugin.main().mod });
    b.step("test", "Run tests").dependOn(&b.addRunArtifact(tests).step);
}
