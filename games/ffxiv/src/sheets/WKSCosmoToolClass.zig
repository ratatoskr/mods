//! `WKSCosmoToolClass`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSCosmoToolClass = @This();

pub const sheet_name = "WKSCosmoToolClass";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa887d3d5;
pub const Sheet = excel.Typed(WKSCosmoToolClass);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Stages[0].Name", "Stages[1].Name", "Stages[2].Name", "Stages[3].Name", "Stages[4].Name", "Stages[5].Name", "Stages[6].Name", "Stages[7].Name", "Stages[8].Name", "Stages[9].Name", "Stages[10].Name", "Stages[11].Name", "Stages[12].Name", "Stages[13].Name", "Stages[14].Name", "Stages[15].Name", "Stages[16].Name", "Stages[17].Name", "Stages[18].Name", "Stages[19].Name", "Stages[0].Item", "Stages[1].Item", "Stages[2].Item", "Stages[3].Item", "Stages[4].Item", "Stages[5].Item", "Stages[6].Item", "Stages[7].Item", "Stages[8].Item", "Stages[9].Item", "Stages[10].Item", "Stages[11].Item", "Stages[12].Item", "Stages[13].Item", "Stages[14].Item", "Stages[15].Item", "Stages[16].Item", "Stages[17].Item", "Stages[18].Item", "Stages[19].Item", "Stages[0].Unknown0", "Stages[1].Unknown0", "Stages[2].Unknown0", "Stages[3].Unknown0", "Stages[4].Unknown0", "Stages[5].Unknown0", "Stages[6].Unknown0", "Stages[7].Unknown0", "Stages[8].Unknown0", "Stages[9].Unknown0", "Stages[10].Unknown0", "Stages[11].Unknown0", "Stages[12].Unknown0", "Stages[13].Unknown0", "Stages[14].Unknown0", "Stages[15].Unknown0", "Stages[16].Unknown0", "Stages[17].Unknown0", "Stages[18].Unknown0", "Stages[19].Unknown0", "Types[0].Name", "Types[1].Name", "Types[2].Name", "Types[3].Name", "Types[4].Name", "Types[5].Name", "Types[6].Name", "Types[0].CosmicName", "Types[1].CosmicName", "Types[2].CosmicName", "Types[3].CosmicName", "Types[4].CosmicName", "Types[5].CosmicName", "Types[6].CosmicName", "Types[0].Icon", "Types[1].Icon", "Types[2].Icon", "Types[3].Icon", "Types[4].Icon", "Types[5].Icon", "Types[6].Icon", "DataAmount", "Name" };

pub const stages_len = 20;
pub fn stages(self: @This(), n0: usize) StagesEntry {
    std.debug.assert(n0 < 20);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const StagesEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn unknown0(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    /// Links to `Item`.
    pub fn item(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(i32, offsets_2[self.at[0]]));
    }

    /// Links to `WKSCosmoToolName`.
    pub fn name(self: @This()) excel.Link(sheets.WKSCosmoToolName) {
        return .of(self.row.at(u16, offsets_3[self.at[0]]));
    }
};

pub const types_len = 7;
pub fn types(self: @This(), n0: usize) TypesEntry {
    std.debug.assert(n0 < 7);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const TypesEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn icon(self: @This()) u32 {
        return self.row.at(u32, offsets_4[self.at[0]]);
    }

    /// Links to `WKSCosmoToolName`.
    pub fn name(self: @This()) excel.Link(sheets.WKSCosmoToolName) {
        return .of(self.row.at(u16, offsets_5[self.at[0]]));
    }

    /// Links to `WKSCosmoToolName`.
    pub fn cosmicName(self: @This()) excel.Link(sheets.WKSCosmoToolName) {
        return .of(self.row.at(u16, offsets_6[self.at[0]]));
    }
};

/// Links to `WKSCosmoToolName`.
pub fn name(self: @This()) excel.Link(sheets.WKSCosmoToolName) {
    return .of(self.row.at(u16, 296));
}

/// Links to `WKSCosmoToolDataAmount`.
pub fn dataAmount(self: @This()) excel.Link(sheets.WKSCosmoToolDataAmount) {
    return .of(self.row.at(u8, 298));
}

const offsets_1 = [20]u16{ 0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 144, 156, 168, 180, 192, 204, 216, 228 };
const offsets_2 = [20]u16{ 4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124, 136, 148, 160, 172, 184, 196, 208, 220, 232 };
const offsets_3 = [20]u16{ 8, 20, 32, 44, 56, 68, 80, 92, 104, 116, 128, 140, 152, 164, 176, 188, 200, 212, 224, 236 };
const offsets_4 = [7]u16{ 240, 248, 256, 264, 272, 280, 288 };
const offsets_5 = [7]u16{ 244, 252, 260, 268, 276, 284, 292 };
const offsets_6 = [7]u16{ 246, 254, 262, 270, 278, 286, 294 };
