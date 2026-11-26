//! FFXIV's Excel sheets, the game's tables of items, actions, quests and the like, read raw. Columns
//! are by index, with the types the sheet's header gives them:
//!
//!     var sheets: excel.Sheets = try .open(io, gpa, &pack, .english);
//!     defer sheets.close();
//!     const items = try sheets.get(io, "Item");
//!     const row = (try items.row(io, 23992)) orelse return error.NoItem;
//!     const name = (try row.column(9)).string;
//!
//! The `sheets` module has typed sheets made from EXDSchema, on `Typed` and `Link`:
//!
//!     const items = try sheets.typed(io, ffxiv_sheets.Item);
//!     const name = (try items.row(io, 23992)).?.name();
//!
//! Needs only `sqpack`.

const std = @import("std");
const sqpack = @import("sqpack");

pub const Header = @import("Header.zig");
pub const Language = Header.Language;
pub const List = @import("List.zig");
pub const Row = @import("Row.zig");
pub const Sheet = @import("Sheet.zig");
pub const Sheets = @import("Sheets.zig");
pub const Typed = @import("typed.zig").Typed;
pub const Link = @import("typed.zig").Link;

test {
    std.testing.refAllDecls(@This());
}

/// Skips unless `WRAITH_FFXIV_GAME` names the game's `game` folder.
fn openGame() !sqpack.Pack {
    const t = std.testing;
    const dir = t.environ.getAlloc(t.allocator, "WRAITH_FFXIV_GAME") catch return error.SkipZigTest;
    defer t.allocator.free(dir);
    return .open(t.io, t.allocator, dir);
}

test "reads rows, subrows and every column type" {
    const t = std.testing;
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    var sheets: Sheets = try .open(t.io, t.allocator, &pack, .english);
    defer sheets.close();

    try t.expectEqualStrings("Tribe", sheets.list.nameOf(58).?);
    try t.expect(sheets.list.find("guild_order/GuildOrderGuide") != null);
    try t.expectError(error.NoSheet, sheets.get(t.io, "does_not_exist"));

    const items = try sheets.get(t.io, "item");
    try t.expectEqual(items, try sheets.get(t.io, "Item"));
    try t.expectEqual(.english, items.language);
    const graha = (try items.row(t.io, 23992)).?;
    try t.expectEqualStrings("Wind-up G'raha Tia", (try graha.column(9)).string);
    try t.expectEqual(null, try items.subrow(t.io, 23992, 1));
    try t.expectError(error.NoColumn, graha.column(500));

    // Not translated, so it's the sheet with no language
    const models = try sheets.get(t.io, "ModelChara");
    try t.expectEqual(.none, models.language);

    const quests = try sheets.get(t.io, "QuestDefineClient");
    try t.expectEqual(.subrows, quests.header.kind);
    try t.expect((try quests.subrowCount(t.io, 70198)).? > 8);
    const bind = (try quests.subrow(t.io, 70198, 8)).?;
    try t.expectEqualStrings("BIND_SEQ9_SUZAKU", (try bind.column(0)).string);
    try t.expectEqual(9623609, (try bind.column(1)).u32);
    try t.expectEqualStrings("LOC_GYODOU", (try (try quests.subrow(t.io, 70198, 11)).?.column(0)).string);
    try t.expectEqual(null, try quests.row(t.io, 50));
    try t.expectEqual(null, try quests.subrow(t.io, 70198, 100));

    const buddy = try sheets.get(t.io, "BuddyAction");
    var it = buddy.rows();
    var n: usize = 0;
    while (try it.next(t.io)) |_| n += 1;
    try t.expectEqual(buddy.header.rowCount(), n);
    try t.expectEqual(null, try (try sheets.get(t.io, "ActivityFeedButtons")).row(t.io, 500));
}

test "every column of every row of every sheet reads" {
    const t = std.testing;
    var pack = try openGame();
    defer pack.close(t.io, t.allocator);
    var sheets: Sheets = try .open(t.io, t.allocator, &pack, .english);
    defer sheets.close();

    var rows: usize = 0;
    for (sheets.list.by_name) |entry| {
        const sheet = sheets.get(t.io, entry.name) catch |err| switch (err) {
            // A few are listed with no files
            error.FileNotFound => continue,
            else => return err,
        };
        var it = sheet.rows();
        while (try it.next(t.io)) |row| {
            for (sheet.header.columns, 0..) |col, c| {
                _ = try row.column(c);
                if (col.type != .string) continue;
                // Strings are packed end to end, so a wrong base lands mid string
                const at = row.strings + try row.int(u32, col.offset);
                if (at != row.strings and row.bytes[at - 1] != 0) return error.StringMidway;
            }
            rows += 1;
        }
    }
    try t.expect(rows > 1_000_000);
}
