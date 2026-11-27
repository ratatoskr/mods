//! `XPVPGroupActivity`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XPVPGroupActivity = @This();

pub const sheet_name = "XPVPGroupActivity";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfe4da36c;
pub const Sheet = excel.Typed(XPVPGroupActivity);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 12);
}
