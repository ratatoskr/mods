//! `StatusLoopVFX`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `VFX`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const StatusLoopVFX = @This();

pub const sheet_name = "StatusLoopVFX";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd5619c7c;
pub const Sheet = excel.Typed(StatusLoopVFX);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "VFX[0]", "Unknown0", "VFX[1]", "Unknown1", "VFX[2]", "VFX[3]", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6" };

pub const vfx_len = 4;
/// Links to `VFX`.
pub fn vfx(self: @This(), n0: usize) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(12, 0);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(12, 1);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(12, 2);
}

const offsets_1 = [4]u16{ 0, 2, 4, 6 };
