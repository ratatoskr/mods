//! `MoveControl`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MoveControl = @This();

pub const sheet_name = "MoveControl";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4369f348;
pub const Sheet = excel.Typed(MoveControl);

row: excel.Row,

pub fn acceleration(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn groundSpeed(self: @This()) f32 {
    return self.row.at(f32, 8);
}

/// Left/Right for the turn control scheme
pub fn rpWalkTurnSpeed(self: @This()) f32 {
    return self.row.at(f32, 12);
}

/// Forwards/backwards
pub fn rpWalkSpeed(self: @This()) f32 {
    return self.row.at(f32, 16);
}

/// Left/Right for the strafe control scheme
pub fn rpWalkStrafeSpeed(self: @This()) f32 {
    return self.row.at(f32, 20);
}

/// Standard controls backwards or legacy back+strafe
pub fn backpedalSpeed(self: @This()) f32 {
    return self.row.at(f32, 24);
}

/// Angle in degrees per step when turning
pub fn rotationStep(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 30);
}
