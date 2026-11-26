//! `PhysicsGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PhysicsGroup = @This();

pub const sheet_name = "PhysicsGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfa594271;
pub const Sheet = excel.Typed(PhysicsGroup);

row: excel.Row,

pub const simulation_time_len = 6;
pub fn simulationTime(self: @This(), n0: usize) f32 {
    return self.row.at(f32, offsets_1[n0]);
}

pub const ps3_simulation_time_len = 6;
pub fn ps3SimulationTime(self: @This(), n0: usize) f32 {
    return self.row.at(f32, offsets_2[n0]);
}

pub fn rootFollowingGame(self: @This()) f32 {
    return self.row.at(f32, 48);
}

pub fn rootFollowingCutScene(self: @This()) f32 {
    return self.row.at(f32, 52);
}

pub const config_switch_len = 3;
pub fn configSwitch(self: @This(), n0: usize) i8 {
    return self.row.at(i8, offsets_3[n0]);
}

pub fn resetByLookAt(self: @This()) bool {
    return self.row.bitAt(59, 0);
}

pub fn forceAttractByPhysicsOff(self: @This()) bool {
    return self.row.bitAt(59, 1);
}

const offsets_1 = [6]u16{ 0, 4, 8, 12, 16, 20 };
const offsets_2 = [6]u16{ 24, 28, 32, 36, 40, 44 };
const offsets_3 = [3]u16{ 56, 57, 58 };
