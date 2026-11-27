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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icons[0].AnnounceQuest", "Icons[1].AnnounceQuest", "Icons[2].AnnounceQuest", "Icons[3].AnnounceQuest", "Icons[4].AnnounceQuest", "Icons[5].AnnounceQuest", "Icons[6].AnnounceQuest", "Icons[7].AnnounceQuest", "Icons[8].AnnounceQuest", "Icons[9].AnnounceQuest", "Icons[0].AnnounceQuestLocked", "Icons[1].AnnounceQuestLocked", "Icons[2].AnnounceQuestLocked", "Icons[3].AnnounceQuestLocked", "Icons[4].AnnounceQuestLocked", "Icons[5].AnnounceQuestLocked", "Icons[6].AnnounceQuestLocked", "Icons[7].AnnounceQuestLocked", "Icons[8].AnnounceQuestLocked", "Icons[9].AnnounceQuestLocked", "Icons[0].MapAnnounceQuest1", "Icons[1].MapAnnounceQuest1", "Icons[2].MapAnnounceQuest1", "Icons[3].MapAnnounceQuest1", "Icons[4].MapAnnounceQuest1", "Icons[5].MapAnnounceQuest1", "Icons[6].MapAnnounceQuest1", "Icons[7].MapAnnounceQuest1", "Icons[8].MapAnnounceQuest1", "Icons[9].MapAnnounceQuest1", "Icons[0].MapAnnounceQuestLocked", "Icons[1].MapAnnounceQuestLocked", "Icons[2].MapAnnounceQuestLocked", "Icons[3].MapAnnounceQuestLocked", "Icons[4].MapAnnounceQuestLocked", "Icons[5].MapAnnounceQuestLocked", "Icons[6].MapAnnounceQuestLocked", "Icons[7].MapAnnounceQuestLocked", "Icons[8].MapAnnounceQuestLocked", "Icons[9].MapAnnounceQuestLocked", "Icons[0].MapAnnounceQuest2", "Icons[1].MapAnnounceQuest2", "Icons[2].MapAnnounceQuest2", "Icons[3].MapAnnounceQuest2", "Icons[4].MapAnnounceQuest2", "Icons[5].MapAnnounceQuest2", "Icons[6].MapAnnounceQuest2", "Icons[7].MapAnnounceQuest2", "Icons[8].MapAnnounceQuest2", "Icons[9].MapAnnounceQuest2", "Unknown0" };

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
