//! `SkyIsland2Mission`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item1`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SkyIsland2Mission = @This();

pub const sheet_name = "SkyIsland2Mission";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xec50a29c;
pub const Sheet = excel.Typed(SkyIsland2Mission);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown3(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn unknown4(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

/// Links to `EventItem`.
pub fn item1(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 20));
}

/// Links to `EventItem`.
pub fn item2(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 24));
}

pub fn popRange0(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn popRange1(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn popRange2(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 52);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 56);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 60));
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 62);
}

/// Links to `SkyIsland2MissionDetail`.
pub fn objective1(self: @This()) excel.Link(sheets.SkyIsland2MissionDetail) {
    return .of(self.row.at(u16, 64));
}

/// Links to `SkyIsland2MissionDetail`.
pub fn objective2(self: @This()) excel.Link(sheets.SkyIsland2MissionDetail) {
    return .of(self.row.at(u16, 66));
}

/// Links to `SkyIsland2MissionDetail`.
pub fn objective3(self: @This()) excel.Link(sheets.SkyIsland2MissionDetail) {
    return .of(self.row.at(u16, 68));
}

pub fn requiredAmount1(self: @This()) u8 {
    return self.row.at(u8, 70);
}

pub fn requiredAmount2(self: @This()) u8 {
    return self.row.at(u8, 71);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 72);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 73);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 74);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 75);
}
