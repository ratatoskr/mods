//! `MinionStage`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MinionStage = @This();

pub const sheet_name = "MinionStage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf88a13df;
pub const Sheet = excel.Typed(MinionStage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Unknown2", "Unknown1" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(6, 0);
}
