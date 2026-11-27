//! `EventMountGimmickPathMove`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventMountGimmickPathMove = @This();

pub const sheet_name = "EventMountGimmickPathMove";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3896b423;
pub const Sheet = excel.Typed(EventMountGimmickPathMove);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown3", "Unknown2", "Unknown6", "Unknown9", "Unknown4", "Unknown5", "Unknown7", "Unknown8" };

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(18, 0);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(18, 1);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(18, 2);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(18, 3);
}
