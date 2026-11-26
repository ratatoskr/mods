//! `IKDRoute`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDRoute = @This();

pub const sheet_name = "IKDRoute";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x195ec33c;
pub const Sheet = excel.Typed(IKDRoute);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const spot_len = 3;
/// Links to `IKDSpot`.
pub fn spot(self: @This(), n0: usize) excel.Link(sheets.IKDSpot) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn altImage(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// Links to `ContentFinderCondition`.
pub fn instance(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 28));
}

/// Links to `Quest`.
pub fn prerequisiteQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 32));
}

pub const time_len = 3;
/// Links to `IKDTimeDefine`.
pub fn time(self: @This(), n0: usize) excel.Link(sheets.IKDTimeDefine) {
    return .of(self.row.at(u8, offsets_2[n0]));
}

const offsets_1 = [3]u16{ 4, 8, 12 };
const offsets_2 = [3]u16{ 36, 37, 38 };
