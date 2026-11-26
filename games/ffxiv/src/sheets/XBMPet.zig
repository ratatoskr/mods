//! `XBMPet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMPet = @This();

pub const sheet_name = "XBMPet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xed3c4185;
pub const Sheet = excel.Typed(XBMPet);

row: excel.Row,

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn trickDescription(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn temperedDescription(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// Links to `Pet`.
pub fn pet(self: @This()) excel.Link(sheets.Pet) {
    return .of(self.row.at(i32, 16));
}

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 20));
}

/// Links by `LocationKey`: 1 to `PlaceName`, 2 to `ContentFinderCondition`.
pub fn location(self: @This()) u16 {
    return self.row.at(u16, 22);
}

/// Lookup from Addon#R17741 through Addon#R17748 through array in exe .rdata section
pub fn classification(self: @This()) u8 {
    return self.row.at(u8, 24);
}

/// Main RowId for XBMPetParamGrow where subrow is Rank - 1
/// Links to `XBMPetParamGrow`.
pub fn paramGrow(self: @This()) excel.Link(sheets.XBMPetParamGrow) {
    return .of(self.row.at(u8, 25));
}

pub fn satietyMax(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn locationKey(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub const unknown12_len = 5;
pub fn unknown12(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_1[n0]);
}

pub fn inflictsSlow(self: @This()) bool {
    return self.row.at(u8, 33) != 0;
}

pub fn inflictsPetrify(self: @This()) bool {
    return self.row.at(u8, 34) != 0;
}

pub fn inflictsParalysis(self: @This()) bool {
    return self.row.at(u8, 35) != 0;
}

pub fn inflictsInterrupt(self: @This()) bool {
    return self.row.at(u8, 36) != 0;
}

pub fn inflictsBlind(self: @This()) bool {
    return self.row.at(u8, 37) != 0;
}

pub fn inflictsPoison(self: @This()) bool {
    return self.row.at(u8, 38) != 0;
}

pub fn inflictsStun(self: @This()) bool {
    return self.row.at(u8, 39) != 0;
}

pub fn inflictsSleep(self: @This()) bool {
    return self.row.at(u8, 40) != 0;
}

pub fn inflictsBind(self: @This()) bool {
    return self.row.at(u8, 41) != 0;
}

pub fn inflictsHeavy(self: @This()) bool {
    return self.row.at(u8, 42) != 0;
}

/// includes actions that inflict flat damage or cause death
pub fn inflictsDeath(self: @This()) bool {
    return self.row.at(u8, 43) != 0;
}

const offsets_1 = [5]u16{ 28, 29, 30, 31, 32 };
