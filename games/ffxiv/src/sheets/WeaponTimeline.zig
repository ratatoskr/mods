//! `WeaponTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeaponTimeline = @This();

pub const sheet_name = "WeaponTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7ba5390a;
pub const Sheet = excel.Typed(WeaponTimeline);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "File", "NextWeaponTimeline", "Unknown0", "Unknown1" };

pub fn file(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn nextWeaponTimeline(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(6, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(6, 1);
}
