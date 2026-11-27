//! `CutsceneMotion`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CutsceneMotion = @This();

pub const sheet_name = "CutsceneMotion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d86ce33;
pub const Sheet = excel.Typed(CutsceneMotion);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "WALK_LOOP_SPEED", "RUN_LOOP_SPEED", "SLOWWALK_LOOP_SPEED", "SLOWRUN_LOOP_SPEED", "BATTLEWALK_LOOP_SPEED", "BATTLERUN_LOOP_SPEED", "DASH_LOOP_SPEED", "TURN_CW90_FRAME", "TURN_CCW90_FRAME", "TURN_CW180_FRAME", "TURN_CCW180_FRAME" };

pub fn walk_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn run_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn slowwalk_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn slowrun_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn battlewalk_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn battlerun_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn dash_LOOP_SPEED(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn turn_CW90_FRAME(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn turn_CCW90_FRAME(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn turn_CW180_FRAME(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn turn_CCW180_FRAME(self: @This()) u8 {
    return self.row.at(u8, 31);
}
