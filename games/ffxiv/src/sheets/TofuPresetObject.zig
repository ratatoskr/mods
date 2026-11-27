//! `TofuPresetObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Object`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuPresetObject = @This();

pub const sheet_name = "TofuPresetObject";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xab68c6f4;
pub const Sheet = excel.Typed(TofuPresetObject);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Object", "Unknown1", "Unknown2", "Unknown4", "Unknown3", "Unknown6", "Unknown5", "Unknown7", "Unknown8" };

/// Links to `TofuObject`.
pub fn object(self: @This()) excel.Link(sheets.TofuObject) {
    return .of(self.row.at(i32, 0));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(13, 0);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(13, 1);
}
