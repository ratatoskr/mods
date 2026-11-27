//! `CreditList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CreditList = @This();

pub const sheet_name = "CreditList";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x089033fa;
pub const Sheet = excel.Typed(CreditList);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Scale", "Icon", "Font", "Unknown0", "Unknown1", "Cast" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `CreditFont`.
pub fn font(self: @This()) excel.Link(sheets.CreditFont) {
    return .of(self.row.at(u32, 4));
}

/// Links to `CreditListText`.
pub fn cast(self: @This()) excel.Link(sheets.CreditListText) {
    return .of(self.row.at(u32, 8));
}

pub fn scale(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 15);
}
