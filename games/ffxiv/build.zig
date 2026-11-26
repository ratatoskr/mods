const std = @import("std");
const wraith = @import("wraith");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Their own modules, so other packages can take just the game's files or sheets
    const game = addGameModules(b, target, optimize, true);

    const plugin: wraith.Plugin = .init(b, .{
        .name = "ffxiv",
        .root_source_file = b.path("src/plugin/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    for (plugin.arches) |arch| {
        const mods = addGameModules(b, arch.target, optimize, false);
        arch.mod.addImport("sqpack", mods.sqpack);
        arch.mod.addImport("excel", mods.excel);
        arch.mod.addImport("sheets", mods.sheets);
    }
    plugin.install(b);

    // The generator runs on this machine, whatever the plugin's built for
    const generator = b.createModule(.{
        .root_source_file = b.path("tools/excel-sheets/main.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseSafe,
    });

    // WRAITH_FFXIV_GAME=<the game folder> runs the ones that read its files
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = game.sqpack })).step);
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = game.excel })).step);
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/sheets.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "sqpack", .module = game.sqpack },
            .{ .name = "excel", .module = game.excel },
            .{ .name = "sheets", .module = game.sheets },
        },
    }) })).step);
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = generator })).step);
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

    // EXDSchema's sheets as src/sheets, through tools/excel-sheets. Doesn't need the game.
    const gen = b.addRunArtifact(b.addExecutable(.{ .name = "excel-sheets", .root_module = generator }));
    gen.addDirectoryArg(b.dependency("exdschema", .{}).path("."));
    gen.addDirectoryArg(b.path("src/sheets"));
    gen.has_side_effects = true;
    const fmt = b.addFmt(.{ .paths = &.{b.path("src/sheets")} });
    fmt.step.dependOn(&gen.step);
    b.step("excel-sheets", "Write src/sheets from EXDSchema").dependOn(&fmt.step);
}

const GameModules = struct { sqpack: *std.Build.Module, excel: *std.Build.Module, sheets: *std.Build.Module };

/// `public` adds them to the package, for other packages to import.
fn addGameModules(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, public: bool) GameModules {
    const sqpack_options: std.Build.Module.CreateOptions = .{ .root_source_file = b.path("src/sqpack/root.zig"), .target = target, .optimize = optimize };
    const sqpack = if (public) b.addModule("sqpack", sqpack_options) else b.createModule(sqpack_options);
    addLibdeflate(b, sqpack);
    const excel_options: std.Build.Module.CreateOptions = .{
        .root_source_file = b.path("src/excel/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "sqpack", .module = sqpack }},
    };
    const excel = if (public) b.addModule("excel", excel_options) else b.createModule(excel_options);
    const sheets_options: std.Build.Module.CreateOptions = .{
        .root_source_file = b.path("src/sheets/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "excel", .module = excel }},
    };
    const sheets = if (public) b.addModule("sheets", sheets_options) else b.createModule(sheets_options);
    return .{ .sqpack = sqpack, .excel = excel, .sheets = sheets };
}

/// Its decompressor, through src/sqpack/deflate.c, which needs no libc.
fn addLibdeflate(b: *std.Build, mod: *std.Build.Module) void {
    mod.addIncludePath(b.dependency("libdeflate", .{}).path(""));
    mod.addCSourceFile(.{ .file = b.path("src/sqpack/deflate.c"), .flags = &.{ "-std=c99", "-ffreestanding" } });
}
