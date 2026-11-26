//! `Mount`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Mount = @This();

pub const sheet_name = "Mount";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5b89058f;
pub const Sheet = excel.Typed(Mount);

row: excel.Row,

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn whistlePath(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(20);
}

pub fn dismountSCDPath(self: @This()) []const u8 {
    return self.row.stringAt(24);
}

/// Links to `ModelChara`.
pub fn modelChara(self: @This()) excel.Link(sheets.ModelChara) {
    return .of(self.row.at(i32, 28));
}

pub fn equipHead(self: @This()) i32 {
    return self.row.at(i32, 32);
}

pub fn equipBody(self: @This()) i32 {
    return self.row.at(i32, 36);
}

pub fn equipLeg(self: @This()) i32 {
    return self.row.at(i32, 40);
}

pub fn equipFoot(self: @This()) i32 {
    return self.row.at(i32, 44);
}

/// Links to `MoveControl`.
pub fn moveControl(self: @This()) excel.Link(sheets.MoveControl) {
    return .of(self.row.at(u16, 48));
}

/// Links to `BGM`.
pub fn rideBGM(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 50));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn uiPriority(self: @This()) u16 {
    return self.row.at(u16, 54);
}

/// Links to `MountAction`.
pub fn mountAction(self: @This()) excel.Link(sheets.MountAction) {
    return .of(self.row.at(u16, 56));
}

/// Links to `TiltParam`.
pub fn groundTiltParam(self: @This()) excel.Link(sheets.TiltParam) {
    return .of(self.row.at(u16, 58));
}

/// Links to `TiltParam`.
pub fn flightSwimTiltParam(self: @This()) excel.Link(sheets.TiltParam) {
    return .of(self.row.at(u16, 60));
}

/// Links to `TiltParam`.
pub fn riderGroundTiltParam(self: @This()) excel.Link(sheets.TiltParam) {
    return .of(self.row.at(u16, 62));
}

/// Links to `TiltParam`.
pub fn riderFlightSwimTiltParam(self: @This()) excel.Link(sheets.TiltParam) {
    return .of(self.row.at(u16, 64));
}

pub fn order(self: @This()) i16 {
    return self.row.at(i16, 66);
}

/// Links to `MountFlyingCondition`.
pub fn flyingCondition(self: @This()) excel.Link(sheets.MountFlyingCondition) {
    return .of(self.row.at(u8, 68));
}

pub fn flyUpDownAngle(self: @This()) u8 {
    return self.row.at(u8, 69);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 70);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 71);
}

/// Links to `MoveVfx`.
pub fn flyingMoveVfx(self: @This()) excel.Link(sheets.MoveVfx) {
    return .of(self.row.at(u8, 72));
}

/// Links to `MoveVfx`.
pub fn glideVFX(self: @This()) excel.Link(sheets.MoveVfx) {
    return .of(self.row.at(u8, 73));
}

/// Links to `MountCustomize`.
pub fn mountCustomize(self: @This()) excel.Link(sheets.MountCustomize) {
    return .of(self.row.at(u8, 74));
}

pub fn exitMoveDist(self: @This()) u8 {
    return self.row.at(u8, 75);
}

pub fn exitMoveSpeed(self: @This()) u8 {
    return self.row.at(u8, 76);
}

pub fn radiusRate(self: @This()) u8 {
    return self.row.at(u8, 77);
}

pub fn baseMotionSpeed_Run(self: @This()) u8 {
    return self.row.at(u8, 78);
}

pub fn baseMotionSpeed_Walk(self: @This()) u8 {
    return self.row.at(u8, 79);
}

pub fn baseMotionSpeed_Swim(self: @This()) u8 {
    return self.row.at(u8, 80);
}

pub fn extraSeats(self: @This()) u8 {
    return self.row.at(u8, 81);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 82);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 83);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(84, 0);
}

pub fn isEmote(self: @This()) bool {
    return self.row.bitAt(84, 1);
}

pub fn unknown20(self: @This()) bool {
    return self.row.bitAt(84, 2);
}

pub fn isAirborne(self: @This()) bool {
    return self.row.bitAt(84, 3);
}

pub fn exHotbarEnableConfig(self: @This()) bool {
    return self.row.bitAt(84, 4);
}

pub fn useEP(self: @This()) bool {
    return self.row.bitAt(84, 5);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(84, 6);
}

pub fn isImmobile(self: @This()) bool {
    return self.row.bitAt(84, 7);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(85, 0);
}

pub fn hideHeadgear(self: @This()) bool {
    return self.row.bitAt(85, 1);
}

pub fn ownerGroundTiltEnable(self: @This()) bool {
    return self.row.bitAt(85, 2);
}

pub fn ownerGroundFlySwimEnable(self: @This()) bool {
    return self.row.bitAt(85, 3);
}
