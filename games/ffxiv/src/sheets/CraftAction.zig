//! `CraftAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CraftAction = @This();

pub const sheet_name = "CraftAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6057073b;
pub const Sheet = excel.Typed(CraftAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "AnimationStart", "AnimationEnd", "Icon", "ClassJob", "ClassJobCategory", "ClassJobLevel", "QuestRequirement", "Specialist", "RequiredStatus", "Cost", "CRP", "BSM", "ARM", "GSM", "LTW", "WVR", "ALC", "CUL" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `Quest`.
pub fn questRequirement(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

/// Links to `CraftAction`.
pub fn crp(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 12));
}

/// Links to `CraftAction`.
pub fn bsm(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 16));
}

/// Links to `CraftAction`.
pub fn arm(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 20));
}

/// Links to `CraftAction`.
pub fn gsm(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 24));
}

/// Links to `CraftAction`.
pub fn ltw(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 28));
}

/// Links to `CraftAction`.
pub fn wvr(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 32));
}

/// Links to `CraftAction`.
pub fn alc(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 36));
}

/// Links to `CraftAction`.
pub fn cul(self: @This()) excel.Link(sheets.CraftAction) {
    return .of(self.row.at(i32, 40));
}

/// Links to `ActionTimeline`.
pub fn animationStart(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 44));
}

/// Links to `ActionTimeline`.
pub fn animationEnd(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 46));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 48);
}

/// Links to `Status`.
pub fn requiredStatus(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(u16, 50));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 52));
}

pub fn classJobLevel(self: @This()) u8 {
    return self.row.at(u8, 53);
}

pub fn cost(self: @This()) u8 {
    return self.row.at(u8, 54);
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i8, 55));
}

pub fn specialist(self: @This()) bool {
    return self.row.bitAt(56, 0);
}
