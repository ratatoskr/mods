const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const plugin: wraith.Plugin = .init(b, .{
        .name = "posing",
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    plugin.install(b);

    // The pose maths and edits, without the plugin around them
    const main = plugin.main();
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/pose.zig"),
        .target = main.target,
        .imports = &.{.{ .name = "wraith_sdk", .module = main.sdk }},
    }) });
    b.step("test", "Run tests").dependOn(&b.addRunArtifact(tests).step);
}
