//! `Transformation`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Transformation = @This();

pub const sheet_name = "Transformation";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa1ab3fab;
pub const Sheet = excel.Typed(Transformation);

row: excel.Row,

pub fn speed(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 4);
}

/// Links to `Action`.
pub fn action6(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 8));
}

/// Links to `BNpcCustomize`.
pub fn bNpcCustomize(self: @This()) excel.Link(sheets.BNpcCustomize) {
    return .of(self.row.at(i32, 12));
}

/// Links to `NpcEquip`.
pub fn npcEquip(self: @This()) excel.Link(sheets.NpcEquip) {
    return .of(self.row.at(i32, 16));
}

/// Links to `BNpcName`.
pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u16, 20));
}

pub const action_len = 7;
/// Links to `Action`.
pub fn action(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Links to `Action`.
pub fn removeAction(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 36));
}

/// Links to `VFX`.
pub fn startVFX(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 38));
}

/// Links to `VFX`.
pub fn endVFX(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 40));
}

/// Links to `Action`.
pub fn action7(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 42));
}

/// Links to `ModelChara`.
pub fn model(self: @This()) excel.Link(sheets.ModelChara) {
    return .of(self.row.at(i16, 44));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 47);
}

/// Links to `RPParameter`.
pub fn rpParameter(self: @This()) excel.Link(sheets.RPParameter) {
    return .of(self.row.at(u8, 48));
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 49);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 50);
}

pub const ex_hotbar_enable_config_len = 7;
pub fn exHotbarEnableConfig(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_2[n0]) != 0;
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(58, 0);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(58, 1);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(58, 2);
}

pub fn isPvP(self: @This()) bool {
    return self.row.bitAt(58, 3);
}

pub fn isEvent(self: @This()) bool {
    return self.row.bitAt(58, 4);
}

pub fn playerCamera(self: @This()) bool {
    return self.row.bitAt(58, 5);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(58, 6);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(58, 7);
}

pub fn unknown16(self: @This()) bool {
    return self.row.bitAt(59, 0);
}

pub fn unknown17(self: @This()) bool {
    return self.row.bitAt(59, 1);
}

const offsets_1 = [7]u16{ 22, 24, 26, 28, 30, 32, 34 };
const offsets_2 = [7]u16{ 51, 52, 53, 54, 55, 56, 57 };
