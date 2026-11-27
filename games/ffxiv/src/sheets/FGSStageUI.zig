//! `FGSStageUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FGSStageUI = @This();

pub const sheet_name = "FGSStageUI";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x58fb0cc3;
pub const Sheet = excel.Typed(FGSStageUI);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown5", "Unknown6", "Unknown7", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown4(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 24);
}
