//! `AirshipExplorationPart`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AirshipExplorationPart = @This();

pub const sheet_name = "AirshipExplorationPart";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc971f464;
pub const Sheet = excel.Typed(AirshipExplorationPart);

row: excel.Row,

pub fn class(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn surveillance(self: @This()) i16 {
    return self.row.at(i16, 2);
}

pub fn retrieval(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn speed(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub fn range(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn favor(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn slot(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn rank(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn components(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn repairMaterials(self: @This()) u8 {
    return self.row.at(u8, 15);
}
