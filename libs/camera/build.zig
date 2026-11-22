const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const plugin: wraith.Plugin = .init(b, .{
        .name = "camera",
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    plugin.install(b);

    // The camera maths, without the plugin around it
    const main = plugin.main();
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/rig.zig"),
        .target = main.target,
        .imports = &.{.{ .name = "wraith_sdk", .module = main.sdk }},
    }) });
    b.step("test", "Run tests").dependOn(&b.addRunArtifact(tests).step);
}
