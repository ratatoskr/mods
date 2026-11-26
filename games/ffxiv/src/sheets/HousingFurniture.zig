//! `HousingFurniture`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingFurniture = @This();

pub const sheet_name = "HousingFurniture";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xccfbe5ff;
pub const Sheet = excel.Typed(HousingFurniture);

row: excel.Row,

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
/// 3 = Vendor Permit
/// 4 = Crafting Workbenche
/// 7 = Food
/// 8 = Aetherial Wheel
/// 9 = Triple Triad Board
/// 10 = Orchestrion
/// 11 = Flowerpot
/// 12 = Vase
/// 13 = Aquarium
/// 14 = Message Book
/// 15 = Mannequin
pub fn usageType(self: @This()) u8 {
    return self.row.at(u8, 15);
}

/// Any furnishings with the same type are counted towards the limit. For example, all vendor permits are grouped together under the same key.
pub fn placeLimitType(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn aquariumTier(self: @This()) u8 {
    return self.row.at(u8, 17);
}

/// Links to `HousingPlacement`.
pub fn placement(self: @This()) excel.Link(sheets.HousingPlacement) {
    return .of(self.row.at(u8, 18));
}

/// Links to `HousingUnplacement`.
pub fn unplacement(self: @This()) excel.Link(sheets.HousingUnplacement) {
    return .of(self.row.at(u8, 19));
}

/// Links to `HousingUnplacement`.
pub fn unplacementStorage(self: @This()) excel.Link(sheets.HousingUnplacement) {
    return .of(self.row.at(u8, 20));
}

pub fn destroyOnRemoval(self: @This()) bool {
    return self.row.bitAt(21, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(21, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(21, 2);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(21, 3);
}
