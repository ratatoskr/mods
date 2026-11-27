//! `DawnGrowMember`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Class`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DawnGrowMember = @This();

pub const sheet_name = "DawnGrowMember";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x83d96633;
pub const Sheet = excel.Typed(DawnGrowMember);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SelectImage[0]", "SelectImage[1]", "SelectImage[2]", "SelectImage[3]", "PortraitImage[0]", "PortraitImage[1]", "PortraitImage[2]", "PortraitImage[3]", "Class" };

pub const select_image_len = 4;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn selectImage(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub const portrait_image_len = 4;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn portraitImage(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_2[n0]);
}

/// Links to `DawnMemberUIParam`.
pub fn class(self: @This()) excel.Link(sheets.DawnMemberUIParam) {
    return .of(self.row.at(u8, 32));
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 16, 20, 24, 28 };
