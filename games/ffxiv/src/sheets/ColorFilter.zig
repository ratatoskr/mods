//! `ColorFilter`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ColorFilter = @This();

pub const sheet_name = "ColorFilter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7f9db367;
pub const Sheet = excel.Typed(ColorFilter);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "SortOrder", "Hue", "Saturation", "UseNonlinearBrightnessContrast", "Brightness", "Contrast", "MonochromeStrength", "SepiaStrength", "TintStrength", "TintRed", "TintGreen", "TintBlue", "InvertStrength", "ToneCurveLowThreshold", "ToneCurveHighThreshold" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn hue(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn saturation(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn brightness(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn contrast(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn monochromeStrength(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn sepiaStrength(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn tintStrength(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn tintRed(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn tintGreen(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn tintBlue(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn invertStrength(self: @This()) f32 {
    return self.row.at(f32, 44);
}

pub fn toneCurveLowThreshold(self: @This()) f32 {
    return self.row.at(f32, 48);
}

pub fn toneCurveHighThreshold(self: @This()) f32 {
    return self.row.at(f32, 52);
}

pub fn sortOrder(self: @This()) u8 {
    return self.row.at(u8, 56);
}

pub fn useNonlinearBrightnessContrast(self: @This()) bool {
    return self.row.bitAt(57, 0);
}
