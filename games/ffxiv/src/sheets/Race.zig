//! `Race`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Feminine`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Race = @This();

pub const sheet_name = "Race";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3403807a;
pub const Sheet = excel.Typed(Race);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Masculine", "Feminine", "RSEMBody", "RSEMHands", "RSEMLegs", "RSEMFeet", "RSEFBody", "RSEFHands", "RSEFLegs", "RSEFFeet", "Unknown0", "ExPac" };

pub fn masculine(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn feminine(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `Item`.
pub fn rsemBody(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 8));
}

/// Links to `Item`.
pub fn rsefBody(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 12));
}

/// Links to `Item`.
pub fn rsemHands(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 16));
}

/// Links to `Item`.
pub fn rsefHands(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 20));
}

/// Links to `Item`.
pub fn rsemLegs(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 24));
}

/// Links to `Item`.
pub fn rsefLegs(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 28));
}

/// Links to `Item`.
pub fn rsemFeet(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 32));
}

/// Links to `Item`.
pub fn rsefFeet(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 36));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 40);
}

/// Links to `ExVersion`.
pub fn exPac(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 41));
}
