//! Tests for `src/sheets`, which can't hold its own as it's all made by tools/excel-sheets. The ones
//! that read the game skip unless `WRAITH_FFXIV_GAME` names its `game` folder.

const std = @import("std");
const t = std.testing;

const sqpack = @import("sqpack");
const excel = @import("excel");
const sheets = @import("sheets");

fn openGame() !sqpack.Pack {
    const dir = t.environ.getAlloc(t.allocator, "WRAITH_FFXIV_GAME") catch return error.SkipZigTest;
    defer t.allocator.free(dir);
    return .open(t.io, t.allocator, dir);
}

test "typed rows read their columns and links" {
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    var raw: excel.Sheets = try .open(t.io, t.allocator, &pack, .english);
    defer raw.close();

    const items = try raw.typed(t.io, sheets.Item);
    const graha = (try items.row(t.io, 23992)).?;
    try t.expectEqualStrings("Wind-up G'raha Tia", graha.name());

    const jobs = try sheets.ClassJob.Sheet.open(&raw, t.io);
    const paladin = (try jobs.row(t.io, 19)).?;
    try t.expectEqualStrings("PLD", paladin.abbreviation());
    const crystal = (try paladin.itemSoulCrystal().get(&raw, t.io)).?;
    try t.expectEqualStrings("Soul of the Paladin", crystal.name());

    // Arrays of structs, and arrays in them
    const shops = try raw.typed(t.io, sheets.SpecialShop);
    var it = shops.rows();
    var bought: usize = 0;
    while (try it.next(t.io)) |shop| {
        for (0..sheets.SpecialShop.item_len) |i| {
            const entry = shop.item(i);
            for (0..sheets.SpecialShop.ItemEntry.item_len) |j| {
                if (entry.item(j).id != 0) bought += 1;
            }
        }
    }
    try t.expect(bought > 1000);
}

test "every typed sheet matches the game, and every column reads" {
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    var raw: excel.Sheets = try .open(t.io, t.allocator, &pack, .english);
    defer raw.close();

    @setEvalBranchQuota(1_000_000);
    var matched: usize = 0;
    var changed: std.ArrayList([]const u8) = .empty;
    defer changed.deinit(t.allocator);
    var rows: usize = 0;
    var sum: u64 = 0;
    inline for (sheets.all) |T| {
        if (raw.typed(t.io, T)) |sheet| {
            matched += 1;
            var it = sheet.rows();
            while (try it.next(t.io)) |row| {
                readAll(T, row, &sum);
                rows += 1;
            }
        } else |err| switch (err) {
            // Patched since the schema was made
            error.SheetChanged => try changed.append(t.allocator, T.sheet_name),
            else => return err,
        }
    }
    if (changed.items.len != 0) {
        std.debug.print("{d} sheets changed since their schema:", .{changed.items.len});
        for (changed.items) |name| std.debug.print(" {s}", .{name});
        std.debug.print("\n", .{});
    }
    try t.expect(matched > sheets.all.len * 9 / 10);
    try t.expect(rows > 500_000);
}

/// Calls every column's function, through every index of arrays, into `sum`.
fn readAll(comptime T: type, v: T, sum: *u64) void {
    inline for (comptime std.meta.declarations(T)) |name| {
        const f = @field(T, name);
        const F = @TypeOf(f);
        if (@typeInfo(F) != .@"fn") continue;
        const info = @typeInfo(F).@"fn";
        const R = info.return_type.?;
        switch (info.param_types.len) {
            1 => take(R, f(v), sum),
            2 => for (0..@field(T, snake(name) ++ "_len")) |i| take(R, f(v, i), sum),
            3 => {
                const lens = @field(T, snake(name) ++ "_len");
                for (0..lens[0]) |i| for (0..lens[1]) |j| take(R, f(v, i, j), sum);
            },
            else => @compileError("no test for " ++ name),
        }
    }
}

fn take(comptime R: type, v: R, sum: *u64) void {
    switch (@typeInfo(R)) {
        .bool => sum.* +%= @intFromBool(v),
        .int => sum.* +%= if (R == u64) v else @as(u64, @bitCast(@as(i64, v))),
        .float => sum.* +%= @as(u32, @bitCast(v)),
        .pointer => sum.* +%= v.len,
        .@"struct" => if (@hasField(R, "at")) readAll(R, v, sum) else {
            sum.* +%= v.id;
        },
        else => @compileError("no test for " ++ @typeName(R)),
    }
}

/// The generator's names for array lengths, `receiveCount` to `receive_count`.
fn snake(comptime name: []const u8) []const u8 {
    comptime {
        var out: []const u8 = "";
        for (name, 0..) |c, i| {
            if (std.ascii.isUpper(c) and i != 0) {
                const next_lower = i + 1 < name.len and std.ascii.isLower(name[i + 1]);
                if (!std.ascii.isUpper(name[i - 1]) or next_lower) out = out ++ "_";
            }
            out = out ++ .{std.ascii.toLower(c)};
        }
        return out;
    }
}
