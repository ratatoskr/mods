//! `BannerPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BannerPreset = @This();

pub const sheet_name = "BannerPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeeca93f7;
pub const Sheet = excel.Typed(BannerPreset);

row: excel.Row,

pub fn cameraPositionX(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn cameraPositionY(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn cameraPositionZ(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn cameraTargetX(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn cameraTargetY(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn cameraTargetZ(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn animationProgress(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn headDirectionX(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn headDirectionY(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn eyeDirectionX(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn eyeDirectionY(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn expression(self: @This()) i32 {
    return self.row.at(i32, 44);
}

pub fn bannerTimeline(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn imageRotation(self: @This()) i16 {
    return self.row.at(i16, 50);
}

pub fn directionalLightingVerticalAngle(self: @This()) i16 {
    return self.row.at(i16, 52);
}

pub fn directionalLightingHorizontalAngle(self: @This()) i16 {
    return self.row.at(i16, 54);
}

pub fn cameraZoom(self: @This()) u8 {
    return self.row.at(u8, 56);
}

/// Links to `BannerDesignPreset`.
pub fn bannerDesignPreset(self: @This()) excel.Link(sheets.BannerDesignPreset) {
    return .of(self.row.at(u8, 57));
}

pub fn directionalLightingColorRed(self: @This()) u8 {
    return self.row.at(u8, 58);
}

pub fn directionalLightingColorGreen(self: @This()) u8 {
    return self.row.at(u8, 59);
}

pub fn directionalLightingColorBlue(self: @This()) u8 {
    return self.row.at(u8, 60);
}

pub fn directionalLightingBrightness(self: @This()) u8 {
    return self.row.at(u8, 61);
}

pub fn ambientLightingColorRed(self: @This()) u8 {
    return self.row.at(u8, 62);
}

pub fn ambientLightingColorGreen(self: @This()) u8 {
    return self.row.at(u8, 63);
}

pub fn ambientLightingColorBlue(self: @This()) u8 {
    return self.row.at(u8, 64);
}

pub fn ambientLightingBrightness(self: @This()) u8 {
    return self.row.at(u8, 65);
}
