//! `HousingYardObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingYardObject = @This();

pub const sheet_name = "HousingYardObject";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa0acf7ca;
pub const Sheet = excel.Typed(HousingYardObject);

row: excel.Row,

/// Links by `UsageType`: 16 to `HousingTrainingDoll`.
pub fn usageParameter(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `CustomTalk`.
pub fn customTalk(self: @This()) excel.Link(sheets.CustomTalk) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

pub fn modelKey(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn housingItemCategory(self: @This()) u8 {
    return self.row.at(u8, 14);
}

/// 0 = Static furnishing
/// 2 = Garden Patch
/// 5 = Chocobo Stable
/// 6 = Duties Permit
/// 14 = Message Book
/// 16 = Striking Dummy
pub fn usageType(self: @This()) u8 {
    return self.row.at(u8, 15);
}

/// Any furnishings with the same type are counted towards the limit. For example, all garden patches are grouped together under the same key.
pub fn placeLimitType(self: @This()) u8 {
    return self.row.at(u8, 16);
}

/// Links to `HousingPlacement`.
pub fn placement(self: @This()) excel.Link(sheets.HousingPlacement) {
    return .of(self.row.at(u8, 17));
}

/// Links to `HousingUnplacement`.
pub fn unplacement(self: @This()) excel.Link(sheets.HousingUnplacement) {
    return .of(self.row.at(u8, 18));
}

/// Links to `HousingUnplacement`.
pub fn unplacementStorage(self: @This()) excel.Link(sheets.HousingUnplacement) {
    return .of(self.row.at(u8, 19));
}

pub fn destroyOnRemoval(self: @This()) bool {
    return self.row.bitAt(20, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(20, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(20, 2);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(20, 3);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(20, 4);
}
