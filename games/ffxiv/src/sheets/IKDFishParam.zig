//! `IKDFishParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Fish`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDFishParam = @This();

pub const sheet_name = "IKDFishParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1b55da98;
pub const Sheet = excel.Typed(IKDFishParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Fish", "PartyBonus", "IndividualBonus" };

/// Links to `FishParameter`.
pub fn fish(self: @This()) excel.Link(sheets.FishParameter) {
    return .of(self.row.at(u32, 0));
}

/// Links to `IKDContentBonus`.
pub fn partyBonus(self: @This()) excel.Link(sheets.IKDContentBonus) {
    return .of(self.row.at(u8, 4));
}

/// Links to `IKDContentBonus`.
pub fn individualBonus(self: @This()) excel.Link(sheets.IKDContentBonus) {
    return .of(self.row.at(u8, 5));
}
