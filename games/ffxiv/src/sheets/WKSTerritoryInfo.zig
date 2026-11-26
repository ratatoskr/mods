//! `WKSTerritoryInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSTerritoryInfo = @This();

pub const sheet_name = "WKSTerritoryInfo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd96307a2;
pub const Sheet = excel.Typed(WKSTerritoryInfo);

row: excel.Row,

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u32, 28));
}

/// Links to `ENpcBase`.
pub fn mechaEventNpc(self: @This()) excel.Link(sheets.ENpcBase) {
    return .of(self.row.at(u32, 32));
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 36));
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 46);
}
