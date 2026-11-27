//! `TofuPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuPreset = @This();

pub const sheet_name = "TofuPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x089dec9b;
pub const Sheet = excel.Typed(TofuPreset);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown13", "Category", "Unknown12", "Name", "Objects[0]", "Objects[1]", "Objects[2]", "Objects[3]", "Objects[4]", "Objects[5]", "Objects[6]", "Objects[7]", "Unknown10", "Unknown11" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `TofuPresetCategory`.
pub fn category(self: @This()) excel.Link(sheets.TofuPresetCategory) {
    return .of(self.row.at(i32, 4));
}

pub const objects_len = 8;
/// Links to `TofuPresetObject`.
pub fn objects(self: @This(), n0: usize) excel.Link(sheets.TofuPresetObject) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn unknown10(self: @This()) i32 {
    return self.row.at(i32, 40);
}

pub fn unknown11(self: @This()) i32 {
    return self.row.at(i32, 44);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(50, 0);
}

const offsets_1 = [8]u16{ 8, 12, 16, 20, 24, 28, 32, 36 };
