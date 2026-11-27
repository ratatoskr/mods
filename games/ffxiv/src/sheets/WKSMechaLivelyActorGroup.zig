//! `WKSMechaLivelyActorGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMechaLivelyActorGroup = @This();

pub const sheet_name = "WKSMechaLivelyActorGroup";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xf85dc334;
pub const Sheet = excel.Typed(WKSMechaLivelyActorGroup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown7", "Unknown8", "Unknown6", "Unknown9", "Unknown10", "Unknown4", "Unknown5" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 22);
}
