//! `PatchMark`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PatchMark = @This();

pub const sheet_name = "PatchMark";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4b87e076;
pub const Sheet = excel.Typed(PatchMark);

row: excel.Row,

/// Links by `RequirementType`: 3 to `Quest`.
pub fn requirement(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn markID(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn subCategory(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn subCategoryType(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// 1 = Some Housing Permission 1
/// 2 = Some Housing Permission 2
/// 3 = Quest
/// 4 = UnlockLink
/// 5 = InstanceContent 50001 unlocked, but 50003 not
/// 6 = LocalPlayer has a FreeCompanyTag
pub fn requirementType(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn version(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn category(self: @This()) i8 {
    return self.row.at(i8, 15);
}
