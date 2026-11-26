//! `WarpLogic`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `WarpName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WarpLogic = @This();

pub const sheet_name = "WarpLogic";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x78e83215;
pub const Sheet = excel.Typed(WarpLogic);

row: excel.Row,

pub const warp_params_len = 10;
pub fn warpParams(self: @This(), n0: usize) WarpParamsEntry {
    std.debug.assert(n0 < 10);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const WarpParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn function(self: @This()) []const u8 {
        return self.row.stringAt(offsets_1[self.at[0]]);
    }

    /// Links to `HowTo`, `Item` or `Quest`, whichever has the row.
    pub fn argument(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }
};

pub fn question(self: @This()) []const u8 {
    return self.row.stringAt(80);
}

pub fn responseYes(self: @This()) []const u8 {
    return self.row.stringAt(84);
}

pub fn responseNo(self: @This()) []const u8 {
    return self.row.stringAt(88);
}

pub fn warpName(self: @This()) []const u8 {
    return self.row.stringAt(92);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 96);
}

pub fn canSkipCutscene(self: @This()) bool {
    return self.row.bitAt(100, 0);
}

const offsets_1 = [10]u16{ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72 };
const offsets_2 = [10]u16{ 4, 12, 20, 28, 36, 44, 52, 60, 68, 76 };
