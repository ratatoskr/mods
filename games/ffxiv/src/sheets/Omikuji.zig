//! `Omikuji`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Fortune`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Omikuji = @This();

pub const sheet_name = "Omikuji";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x11155d32;
pub const Sheet = excel.Typed(Omikuji);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GuidanceAdventure", "GuidanceRelationships", "GuidanceProsperity", "GuidanceConflict", "GuidanceFavor", "Fortune", "Description" };

pub fn fortune(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn guidanceAdventure(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn guidanceRelationships(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn guidanceProsperity(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn guidanceConflict(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn guidanceFavor(self: @This()) i32 {
    return self.row.at(i32, 24);
}
