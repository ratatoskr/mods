//! `DefaultTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DefaultTalk = @This();

pub const sheet_name = "DefaultTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe6dec88d;
pub const Sheet = excel.Typed(DefaultTalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "DefaultTalkParams[0].Unknown1", "DefaultTalkParams[1].Unknown1", "DefaultTalkParams[2].Unknown1", "DefaultTalkParams[0].ActionTimelinePose", "DefaultTalkParams[1].ActionTimelinePose", "DefaultTalkParams[2].ActionTimelinePose", "DefaultTalkParams[0].Unknown2", "DefaultTalkParams[1].Unknown2", "DefaultTalkParams[2].Unknown2", "DefaultTalkParams[0].Unknown0", "DefaultTalkParams[1].Unknown0", "DefaultTalkParams[2].Unknown0", "DefaultTalkParams[0].Unknown3", "DefaultTalkParams[1].Unknown3", "DefaultTalkParams[2].Unknown3", "DefaultTalkParams[0].Unknown4", "DefaultTalkParams[1].Unknown4", "DefaultTalkParams[2].Unknown4", "Text[0]", "Text[1]", "Text[2]" };

pub const default_talk_params_len = 3;
pub fn defaultTalkParams(self: @This(), n0: usize) DefaultTalkParamsEntry {
    std.debug.assert(n0 < 3);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const DefaultTalkParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `ActionTimeline`.
    pub fn actionTimelinePose(self: @This()) excel.Link(sheets.ActionTimeline) {
        return .of(self.row.at(u16, offsets_1[self.at[0]]));
    }

    pub fn unknown0(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_3[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u8 {
        return self.row.at(u8, offsets_4[self.at[0]]);
    }

    pub fn unknown3(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }

    pub fn unknown4(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_6[self.at[0]] >> 3), @intCast(offsets_6[self.at[0]] & 7));
    }
};

pub const text_len = 3;
pub fn text(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_7[n0]);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 40);
}

const offsets_1 = [3]u16{ 0, 8, 16 };
const offsets_2 = [3]u16{ 2, 10, 18 };
const offsets_3 = [3]u16{ 4, 12, 20 };
const offsets_4 = [3]u16{ 5, 13, 21 };
const offsets_5 = [3]u16{ 6, 14, 22 };
const offsets_6 = [3]u32{ 56, 120, 184 };
const offsets_7 = [3]u16{ 24, 28, 32 };
