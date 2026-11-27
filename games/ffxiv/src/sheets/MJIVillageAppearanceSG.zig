//! `MJIVillageAppearanceSG`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIVillageAppearanceSG = @This();

pub const sheet_name = "MJIVillageAppearanceSG";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8caa5cf;
pub const Sheet = excel.Typed(MJIVillageAppearanceSG);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "VillageAppearanceData[0].SGB", "VillageAppearanceData[1].SGB", "VillageAppearanceData[2].SGB", "VillageAppearanceData[3].SGB", "VillageAppearanceData[4].SGB", "VillageAppearanceData[0].UnknownParam", "VillageAppearanceData[1].UnknownParam", "VillageAppearanceData[2].UnknownParam", "VillageAppearanceData[3].UnknownParam", "VillageAppearanceData[4].UnknownParam" };

pub const village_appearance_data_len = 5;
pub fn villageAppearanceData(self: @This(), n0: usize) VillageAppearanceDataEntry {
    std.debug.assert(n0 < 5);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const VillageAppearanceDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn unknownParam(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    /// Links to `ExportedSG`.
    pub fn sgb(self: @This()) excel.Link(sheets.ExportedSG) {
        return .of(self.row.at(u16, offsets_2[self.at[0]]));
    }
};

const offsets_1 = [5]u16{ 0, 8, 16, 24, 32 };
const offsets_2 = [5]u16{ 4, 12, 20, 28, 36 };
