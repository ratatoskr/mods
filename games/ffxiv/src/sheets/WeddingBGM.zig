//! `WeddingBGM`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Song`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeddingBGM = @This();

pub const sheet_name = "WeddingBGM";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d65a9f1;
pub const Sheet = excel.Typed(WeddingBGM);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Song", "SongName" };

pub fn songName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `BGM`.
pub fn song(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 4));
}
