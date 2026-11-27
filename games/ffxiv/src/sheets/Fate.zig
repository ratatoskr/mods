//! `Fate`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Fate = @This();

pub const sheet_name = "Fate";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfa504de6;
pub const Sheet = excel.Typed(Fate);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "Objective", "StatusText[0]", "StatusText[1]", "StatusText[2]", "FateMode", "Rule", "FateRuleEx", "Location", "ClassJobLevel", "ClassJobLevelMax", "EventItem", "StatusValue[0]", "StatusValue[1]", "StatusValue[2]", "Icon", "MapIcon", "InactiveMapIcon", "Music", "LGBGuardNPCLocation", "ScreenImageAccept", "ScreenImageComplete", "ScreenImageFailed", "Unknown6", "RequiredQuest", "SpecialFate", "Unknown8", "GivenStatus", "Unknown15", "Unknown4", "AdventEvent", "MoonFaireEvent", "Unknown9", "FATEChain", "RequiredClassJobCategory", "RequiredQuest2", "OccupiedPermission", "ArrayEventHandler", "Unknown1", "Unknown14", "ReqEventItem", "TurnInEventItem", "Unknown2[0]", "Unknown2[1]", "Unknown2[2]", "Unknown10", "Unknown11", "Unknown12", "ObjectiveIcon[0].LayoutId", "ObjectiveIcon[1].LayoutId", "ObjectiveIcon[2].LayoutId", "ObjectiveIcon[3].LayoutId", "ObjectiveIcon[4].LayoutId", "ObjectiveIcon[5].LayoutId", "ObjectiveIcon[6].LayoutId", "ObjectiveIcon[7].LayoutId", "ObjectiveIcon[8].LayoutId", "ObjectiveIcon[9].LayoutId", "ObjectiveIcon[10].LayoutId", "ObjectiveIcon[11].LayoutId", "ObjectiveIcon[12].LayoutId", "ObjectiveIcon[13].LayoutId", "ObjectiveIcon[14].LayoutId", "ObjectiveIcon[15].LayoutId", "ObjectiveIcon[16].LayoutId", "ObjectiveIcon[17].LayoutId", "ObjectiveIcon[18].LayoutId", "ObjectiveIcon[19].LayoutId", "ObjectiveIcon[20].LayoutId", "ObjectiveIcon[21].LayoutId", "ObjectiveIcon[22].LayoutId", "ObjectiveIcon[23].LayoutId", "ObjectiveIcon[24].LayoutId", "ObjectiveIcon[25].LayoutId", "ObjectiveIcon[26].LayoutId", "ObjectiveIcon[27].LayoutId", "ObjectiveIcon[28].LayoutId", "ObjectiveIcon[29].LayoutId", "ObjectiveIcon[30].LayoutId", "ObjectiveIcon[31].LayoutId", "ObjectiveIcon[0].Icon", "ObjectiveIcon[1].Icon", "ObjectiveIcon[2].Icon", "ObjectiveIcon[3].Icon", "ObjectiveIcon[4].Icon", "ObjectiveIcon[5].Icon", "ObjectiveIcon[6].Icon", "ObjectiveIcon[7].Icon", "ObjectiveIcon[8].Icon", "ObjectiveIcon[9].Icon", "ObjectiveIcon[10].Icon", "ObjectiveIcon[11].Icon", "ObjectiveIcon[12].Icon", "ObjectiveIcon[13].Icon", "ObjectiveIcon[14].Icon", "ObjectiveIcon[15].Icon", "ObjectiveIcon[16].Icon", "ObjectiveIcon[17].Icon", "ObjectiveIcon[18].Icon", "ObjectiveIcon[19].Icon", "ObjectiveIcon[20].Icon", "ObjectiveIcon[21].Icon", "ObjectiveIcon[22].Icon", "ObjectiveIcon[23].Icon", "ObjectiveIcon[24].Icon", "ObjectiveIcon[25].Icon", "ObjectiveIcon[26].Icon", "ObjectiveIcon[27].Icon", "ObjectiveIcon[28].Icon", "ObjectiveIcon[29].Icon", "ObjectiveIcon[30].Icon", "ObjectiveIcon[31].Icon" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn objective(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub const status_text_len = 3;
pub fn statusText(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_1[n0]);
}

/// Links to `ArrayEventHandler`.
pub fn arrayEventHandler(self: @This()) excel.Link(sheets.ArrayEventHandler) {
    return .of(self.row.at(u32, 24));
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown14(self: @This()) u32 {
    return self.row.at(u32, 32);
}

/// Links to `EventItem`.
pub fn reqEventItem(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 36));
}

/// Links to `EventItem`.
pub fn turnInEventItem(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 40));
}

pub const unknown2_len = 3;
pub fn unknown2(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_2[n0]);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub const objective_icon_len = 32;
pub fn objectiveIcon(self: @This(), n0: usize) ObjectiveIconEntry {
    std.debug.assert(n0 < 32);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const ObjectiveIconEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn layoutId(self: @This()) u32 {
        return self.row.at(u32, offsets_3[self.at[0]]);
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn icon(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }
};

/// Instance ID of the EventRange where this spawns.
pub fn location(self: @This()) u32 {
    return self.row.at(u32, 324);
}

/// Links to `EventItem`.
pub fn eventItem(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 328));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 332);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn mapIcon(self: @This()) u32 {
    return self.row.at(u32, 336);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn inactiveMapIcon(self: @This()) u32 {
    return self.row.at(u32, 340);
}

pub fn lgbGuardNPCLocation(self: @This()) u32 {
    return self.row.at(u32, 344);
}

/// Links to `Quest`.
pub fn requiredQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 348));
}

pub fn fateChain(self: @This()) u32 {
    return self.row.at(u32, 352);
}

/// Used when Unknown6 is 3
/// Links to `Quest`.
pub fn requiredQuest2(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 356));
}

/// Links to `FateRuleEx`.
pub fn fateRuleEx(self: @This()) excel.Link(sheets.FateRuleEx) {
    return .of(self.row.at(u16, 360));
}

/// Links to `BGM`.
pub fn music(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 362));
}

/// Links to `ScreenImage`.
pub fn screenImageAccept(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u16, 364));
}

/// Links to `ScreenImage`.
pub fn screenImageComplete(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u16, 366));
}

/// Links to `ScreenImage`.
pub fn screenImageFailed(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u16, 368));
}

/// Links to `Status`.
pub fn givenStatus(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(u16, 370));
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 372);
}

/// Links to `Permission`.
pub fn occupiedPermission(self: @This()) excel.Link(sheets.Permission) {
    return .of(self.row.at(u16, 374));
}

/// Links to `FateMode`.
pub fn fateMode(self: @This()) excel.Link(sheets.FateMode) {
    return .of(self.row.at(u8, 376));
}

pub fn rule(self: @This()) u8 {
    return self.row.at(u8, 377);
}

pub fn classJobLevel(self: @This()) u8 {
    return self.row.at(u8, 378);
}

pub fn classJobLevelMax(self: @This()) u8 {
    return self.row.at(u8, 379);
}

pub const status_value_len = 3;
pub fn statusValue(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_5[n0]);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 383);
}

/// Links to `ClassJobCategory`.
pub fn requiredClassJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 384));
}

pub fn specialFate(self: @This()) bool {
    return self.row.bitAt(385, 0);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(385, 1);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(385, 2);
}

pub fn adventEvent(self: @This()) bool {
    return self.row.bitAt(385, 3);
}

pub fn moonFaireEvent(self: @This()) bool {
    return self.row.bitAt(385, 4);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(385, 5);
}

const offsets_1 = [3]u16{ 12, 16, 20 };
const offsets_2 = [3]u16{ 44, 48, 52 };
const offsets_3 = [32]u16{ 68, 76, 84, 92, 100, 108, 116, 124, 132, 140, 148, 156, 164, 172, 180, 188, 196, 204, 212, 220, 228, 236, 244, 252, 260, 268, 276, 284, 292, 300, 308, 316 };
const offsets_4 = [32]u16{ 72, 80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 248, 256, 264, 272, 280, 288, 296, 304, 312, 320 };
const offsets_5 = [3]u16{ 380, 381, 382 };
