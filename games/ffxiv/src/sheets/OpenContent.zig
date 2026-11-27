//! `OpenContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OpenContent = @This();

pub const sheet_name = "OpenContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x170b114d;
pub const Sheet = excel.Typed(OpenContent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "OpenContentData[0].Content", "OpenContentData[1].Content", "OpenContentData[2].Content", "OpenContentData[3].Content", "OpenContentData[4].Content", "OpenContentData[5].Content", "OpenContentData[6].Content", "OpenContentData[7].Content", "OpenContentData[8].Content", "OpenContentData[9].Content", "OpenContentData[10].Content", "OpenContentData[11].Content", "OpenContentData[12].Content", "OpenContentData[13].Content", "OpenContentData[14].Content", "OpenContentData[15].Content", "OpenContentData[0].CandidateName", "OpenContentData[1].CandidateName", "OpenContentData[2].CandidateName", "OpenContentData[3].CandidateName", "OpenContentData[4].CandidateName", "OpenContentData[5].CandidateName", "OpenContentData[6].CandidateName", "OpenContentData[7].CandidateName", "OpenContentData[8].CandidateName", "OpenContentData[9].CandidateName", "OpenContentData[10].CandidateName", "OpenContentData[11].CandidateName", "OpenContentData[12].CandidateName", "OpenContentData[13].CandidateName", "OpenContentData[14].CandidateName", "OpenContentData[15].CandidateName" };

pub const open_content_data_len = 16;
pub fn openContentData(self: @This(), n0: usize) OpenContentDataEntry {
    std.debug.assert(n0 < 16);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const OpenContentDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `OpenContentCandidateName`.
    pub fn candidateName(self: @This()) excel.Link(sheets.OpenContentCandidateName) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    /// Links to `ContentFinderCondition`.
    pub fn content(self: @This()) excel.Link(sheets.ContentFinderCondition) {
        return .of(self.row.at(u16, offsets_2[self.at[0]]));
    }
};

const offsets_1 = [16]u16{ 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120 };
const offsets_2 = [16]u16{ 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124 };
