//! `Frontline03`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Frontline03 = @This();

pub const sheet_name = "Frontline03";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x605090e3;
pub const Sheet = excel.Typed(Frontline03);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "OvooData[0].Unknown0", "OvooData[1].Unknown0", "OvooData[2].Unknown0", "OvooData[0].Unknown1", "OvooData[1].Unknown1", "OvooData[2].Unknown1", "OvooData[0].Unknown2", "OvooData[1].Unknown2", "OvooData[2].Unknown2", "OvooData[0].EmptyIcon", "OvooData[1].EmptyIcon", "OvooData[2].EmptyIcon", "OvooData[0].MaelstromIcon", "OvooData[1].MaelstromIcon", "OvooData[2].MaelstromIcon", "OvooData[0].TwinAdderIcon", "OvooData[1].TwinAdderIcon", "OvooData[2].TwinAdderIcon", "OvooData[0].ImmortalFlamesIcon", "OvooData[1].ImmortalFlamesIcon", "OvooData[2].ImmortalFlamesIcon" };

pub const ovoo_data_len = 3;
pub fn ovooData(self: @This(), n0: usize) OvooDataEntry {
    std.debug.assert(n0 < 3);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const OvooDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn emptyIcon(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn maelstromIcon(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn twinAdderIcon(self: @This()) u32 {
        return self.row.at(u32, offsets_3[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn immortalFlamesIcon(self: @This()) u32 {
        return self.row.at(u32, offsets_4[self.at[0]]);
    }

    pub fn unknown0(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }
};

const offsets_1 = [3]u16{ 0, 20, 40 };
const offsets_2 = [3]u16{ 4, 24, 44 };
const offsets_3 = [3]u16{ 8, 28, 48 };
const offsets_4 = [3]u16{ 12, 32, 52 };
const offsets_5 = [3]u16{ 16, 36, 56 };
const offsets_6 = [3]u16{ 17, 37, 57 };
const offsets_7 = [3]u16{ 18, 38, 58 };
