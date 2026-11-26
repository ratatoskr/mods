//! `EventCustomIconType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventCustomIconType = @This();

pub const sheet_name = "EventCustomIconType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9a111885;
pub const Sheet = excel.Typed(EventCustomIconType);

row: excel.Row,

pub const icons_len = 10;
pub fn icons(self: @This(), n0: usize) IconsEntry {
    std.debug.assert(n0 < 10);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const IconsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn announceQuest(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn announceQuestLocked(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn mapAnnounceQuest1(self: @This()) u32 {
        return self.row.at(u32, offsets_3[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn mapAnnounceQuestLocked(self: @This()) u32 {
        return self.row.at(u32, offsets_4[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn mapAnnounceQuest2(self: @This()) u32 {
        return self.row.at(u32, offsets_5[self.at[0]]);
    }
};

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 200);
}

const offsets_1 = [10]u16{ 0, 20, 40, 60, 80, 100, 120, 140, 160, 180 };
const offsets_2 = [10]u16{ 4, 24, 44, 64, 84, 104, 124, 144, 164, 184 };
const offsets_3 = [10]u16{ 8, 28, 48, 68, 88, 108, 128, 148, 168, 188 };
const offsets_4 = [10]u16{ 12, 32, 52, 72, 92, 112, 132, 152, 172, 192 };
const offsets_5 = [10]u16{ 16, 36, 56, 76, 96, 116, 136, 156, 176, 196 };
