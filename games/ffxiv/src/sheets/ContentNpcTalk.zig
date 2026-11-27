//! `ContentNpcTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentNpcTalk = @This();

pub const sheet_name = "ContentNpcTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcfa3d5cd;
pub const Sheet = excel.Typed(ContentNpcTalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "ContentTalk[0]", "ContentTalk[1]", "ContentTalk[2]", "ContentTalk[3]", "ContentTalk[4]", "ContentTalk[5]", "ContentTalk[6]", "ContentTalk[7]" };

pub const content_talk_len = 8;
/// Links to `ContentTalk`.
pub fn contentTalk(self: @This(), n0: usize) excel.Link(sheets.ContentTalk) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn @"type"(self: @This()) i32 {
    return self.row.at(i32, 32);
}

const offsets_1 = [8]u16{ 0, 4, 8, 12, 16, 20, 24, 28 };
