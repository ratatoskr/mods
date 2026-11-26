//! `GatheringNotebookList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringNotebookList = @This();

pub const sheet_name = "GatheringNotebookList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1da7bb26;
pub const Sheet = excel.Typed(GatheringNotebookList);

row: excel.Row,

pub const gathering_item_len = 100;
/// Links to `GatheringItem`.
pub fn gatheringItem(self: @This(), n0: usize) excel.Link(sheets.GatheringItem) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 400);
}

const offsets_1 = [100]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 172, 176, 180, 184, 188, 192, 196, 200, 204, 208, 212, 216, 220, 224, 228, 232, 236, 240, 244, 248, 252, 256, 260, 264, 268, 272, 276, 280, 284, 288, 292, 296, 300, 304, 308, 312, 316, 320, 324, 328, 332, 336, 340, 344, 348, 352, 356, 360, 364, 368, 372, 376, 380, 384, 388, 392, 396 };
