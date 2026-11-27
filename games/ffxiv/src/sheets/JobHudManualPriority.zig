//! `JobHudManualPriority`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const JobHudManualPriority = @This();

pub const sheet_name = "JobHudManualPriority";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa1142ce7;
pub const Sheet = excel.Typed(JobHudManualPriority);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "JobHudManual[0]", "JobHudManual[1]", "JobHudManual[2]", "JobHudManual[3]", "JobHudManual[4]", "JobHudManual[5]", "JobHudManual[6]", "JobHudManual[7]" };

pub const job_hud_manual_len = 8;
/// Links to `JobHudManual`.
pub fn jobHudManual(self: @This(), n0: usize) excel.Link(sheets.JobHudManual) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 0, 1, 2, 3, 4, 5, 6, 7 };
