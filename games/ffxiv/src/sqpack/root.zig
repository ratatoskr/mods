//! FFXIV's packed game files. `Pack` opens the lot and reads files by path:
//!
//!     var pack: sqpack.Pack = try .open(io, gpa, "C:/.../game");
//!     defer pack.close(io, gpa);
//!     const exl = try pack.read(io, gpa, "exd/root.exl");
//!     defer gpa.free(exl);
//!
//! Needs only std and libdeflate, which it builds, so it can be used without the plugin.

const std = @import("std");

pub const Pack = @import("Pack.zig");
pub const Path = @import("Path.zig");
pub const Category = Path.Category;
pub const Chunk = @import("Chunk.zig");
pub const format = @import("format.zig");
pub const index = @import("index.zig");
pub const Inflater = @import("Inflater.zig");

test {
    std.testing.refAllDecls(@This());
    _ = @import("unpack.zig");
}

/// Tests that need the game skip unless `WRAITH_FFXIV_GAME` names its `game` folder.
fn openGame() !Pack {
    const t = std.testing;
    const dir = t.environ.getAlloc(t.allocator, "WRAITH_FFXIV_GAME") catch return error.SkipZigTest;
    defer t.allocator.free(dir);
    return .open(t.io, t.allocator, dir);
}

test "reads each kind of file" {
    const t = std.testing;
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    try t.expect(pack.repos[0].version().len > 0);

    const files = [_]struct { path: []const u8, crc: u32 }{
        .{ .path = "chara/equipment/e0436/material/v0001/mt_c0101e0436_top_a.mtrl", .crc = 0x09CEAFA0 },
        .{ .path = "chara/equipment/e0436/texture/v01_c0101e0436_top_m.tex", .crc = 0x0AA576DD },
        .{ .path = "chara/equipment/e0436/model/c0101e0436_top.mdl", .crc = 0xCE430290 },
    };
    for (files) |f| {
        const bytes = try pack.read(t.io, t.allocator, f.path);
        defer t.allocator.free(bytes);
        try t.expectEqual(f.crc, Path.Crc.hash(bytes));
    }
    try t.expect(pack.exists("EXD/root.exl"));
    try t.expect(!pack.exists("exd/not_a_file.exl"));
    try t.expectError(error.FileNotFound, pack.read(t.io, t.allocator, "exd/not_a_file.exl"));

    // Its header says it's 37540 bytes, but its mips come to less
    const sky = try pack.read(t.io, t.allocator, "bgcommon/nature/sky/texture/sky_047.tex");
    defer t.allocator.free(sky);
    try t.expectEqual(35052, sky.len);
}

test "a clash of hashes finds both files" {
    const t = std.testing;
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    // Both have the same index2 hash, so only their paths tell them apart
    const a: Path = try .parse("bg/ffxiv/sea_s1/fld/s1f2/grass/038_004_012_l.ggd");
    const b: Path = try .parse("bg/ffxiv/cos_c1/hou/c1w1/bgplate/0055.mdl");
    try t.expectEqual(a.hash2, b.hash2);
    const chunk = &pack.repos[0].chunks.get(.bg)[0];
    const in_a = chunk.index2.?.find(a.hash2, a.text()).?;
    const in_b = chunk.index2.?.find(b.hash2, b.text()).?;
    try t.expect(in_a != in_b);
    try t.expectEqual(chunk.index1.?.find(a.hash1, a.text()).?, in_a);
}

test "files all over unpack" {
    const t = std.testing;
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    var read: usize = 0;
    for (pack.repos) |*repo| for (&repo.chunks.values) |chunks| for (chunks) |*c| {
        const entries = (c.index1 orelse continue).entries;
        // A spread of each one's, rather than all of them
        const step = @max(1, entries.len / 50);
        var i: usize = 0;
        while (i < entries.len) : (i += step) {
            const bytes = c.read(t.io, t.allocator, entries[i].data) catch |err| switch (err) {
                // Placeholders for files that aren't there
                error.FileNotFound => continue,
                else => return err,
            };
            t.allocator.free(bytes);
            read += 1;
        }
    };
    try t.expect(read > 1000);
}
