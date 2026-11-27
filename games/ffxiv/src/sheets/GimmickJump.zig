//! `GimmickJump`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GimmickJump = @This();

pub const sheet_name = "GimmickJump";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6f038739;
pub const Sheet = excel.Typed(GimmickJump);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "FallDamage", "Height", "LoopMotion", "EndMotion", "StartClient", "Unknown0", "Unknown1", "Unknown2", "Unknown3" };

/// Links to `ActionTimeline`.
pub fn loopMotion(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u32, 0));
}

/// Links to `ActionTimeline`.
pub fn endMotion(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u32, 4));
}

pub fn fallDamage(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn height(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn startClient(self: @This()) bool {
    return self.row.bitAt(16, 0);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(16, 1);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(16, 2);
}
