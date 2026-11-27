//! `WorldDCGroupType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WorldDCGroupType = @This();

pub const sheet_name = "WorldDCGroupType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf3edfad8;
pub const Sheet = excel.Typed(WorldDCGroupType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "NeolobbyId", "PvPRegion", "Region", "IsCloud" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `WorldPhysicalDC`.
pub fn pvPRegion(self: @This()) excel.Link(sheets.WorldPhysicalDC) {
    return .of(self.row.at(u16, 4));
}

pub fn neolobbyId(self: @This()) u8 {
    return self.row.at(u8, 6);
}

/// Links to `WorldRegionGroup`.
pub fn region(self: @This()) excel.Link(sheets.WorldRegionGroup) {
    return .of(self.row.at(u8, 7));
}

pub fn isCloud(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
