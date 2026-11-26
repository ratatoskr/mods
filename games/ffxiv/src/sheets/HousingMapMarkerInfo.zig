//! `HousingMapMarkerInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingMapMarkerInfo = @This();

pub const sheet_name = "HousingMapMarkerInfo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x13236296;
pub const Sheet = excel.Typed(HousingMapMarkerInfo);

row: excel.Row,

pub fn x(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn y(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn z(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 12);
}

/// Links to `Map`.
pub fn map(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 16));
}
