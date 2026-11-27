//! `CharaMakeName`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CharaMakeName = @This();

pub const sheet_name = "CharaMakeName";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6fbe744d;
pub const Sheet = excel.Typed(CharaMakeName);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "HyurMidlanderMale", "HyurMidlanderFemale", "HyurMidlanderLastName", "HyurHighlanderMale", "HyurHighlanderFemale", "HyurHighlanderLastName", "ElezenMale", "ElezenFemale", "ElezenWildwoodLastName", "ElezenDuskwightLastName", "MiqoteSunMale", "MiqoteSunFemale", "MiqoteSunMaleLastName", "MiqoteSunFemaleLastName", "MiqoteMoonMale", "MiqoteMoonFemale", "MiqoteMoonLastname", "LalafellPlainsfolkFirstNameStart", "LalafellPlainsfolkLastNameStart", "LalafellPlainsfolkEndOfNames", "LalafellDunesfolkMale", "LalafellDunesfolkMaleLastName", "LalafellDunesfolkFemale", "LalafellDunesfolkFemaleLastName", "RoegadynSeaWolfMale", "RoegadynSeaWolfMaleLastName", "RoegadynSeaWolfFemale", "RoegadynSeaWolfFemaleLastName", "RoegadynHellsguardFirstName", "RoegadynHellsguardMaleLastName", "RoegadynHellsguardFemaleLastName", "AuRaRaenMale", "AuRaRaenFemale", "AuRaRaenLastName", "AuRaXaelaMale", "AuRaXaelaFemale", "AuRaXaelaLastName", "HrothgarHellionsFirstName", "HrothgarHellionsLastName", "HrothgarLostFirstName", "HrothgarLostLastName", "Unknown0", "Unknown1", "Unknown2", "VieraFirstName", "VieraRavaLastName", "VieraVeenaLastName", "Unknown_70_1", "Unknown_70_2", "Unknown_70_3" };

pub fn hyurMidlanderMale(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn hyurMidlanderFemale(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn hyurMidlanderLastName(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn hyurHighlanderMale(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn hyurHighlanderFemale(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn hyurHighlanderLastName(self: @This()) []const u8 {
    return self.row.stringAt(20);
}

pub fn elezenMale(self: @This()) []const u8 {
    return self.row.stringAt(24);
}

pub fn elezenFemale(self: @This()) []const u8 {
    return self.row.stringAt(28);
}

pub fn elezenWildwoodLastName(self: @This()) []const u8 {
    return self.row.stringAt(32);
}

pub fn elezenDuskwightLastName(self: @This()) []const u8 {
    return self.row.stringAt(36);
}

pub fn miqoteSunMale(self: @This()) []const u8 {
    return self.row.stringAt(40);
}

pub fn miqoteSunFemale(self: @This()) []const u8 {
    return self.row.stringAt(44);
}

pub fn miqoteSunMaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(48);
}

pub fn miqoteSunFemaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(52);
}

pub fn miqoteMoonMale(self: @This()) []const u8 {
    return self.row.stringAt(56);
}

pub fn miqoteMoonFemale(self: @This()) []const u8 {
    return self.row.stringAt(60);
}

pub fn miqoteMoonLastname(self: @This()) []const u8 {
    return self.row.stringAt(64);
}

pub fn lalafellPlainsfolkFirstNameStart(self: @This()) []const u8 {
    return self.row.stringAt(68);
}

pub fn lalafellPlainsfolkLastNameStart(self: @This()) []const u8 {
    return self.row.stringAt(72);
}

pub fn lalafellPlainsfolkEndOfNames(self: @This()) []const u8 {
    return self.row.stringAt(76);
}

pub fn lalafellDunesfolkMale(self: @This()) []const u8 {
    return self.row.stringAt(80);
}

pub fn lalafellDunesfolkMaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(84);
}

pub fn lalafellDunesfolkFemale(self: @This()) []const u8 {
    return self.row.stringAt(88);
}

pub fn lalafellDunesfolkFemaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(92);
}

pub fn roegadynSeaWolfMale(self: @This()) []const u8 {
    return self.row.stringAt(96);
}

pub fn roegadynSeaWolfMaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(100);
}

pub fn roegadynSeaWolfFemale(self: @This()) []const u8 {
    return self.row.stringAt(104);
}

pub fn roegadynSeaWolfFemaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(108);
}

pub fn roegadynHellsguardFirstName(self: @This()) []const u8 {
    return self.row.stringAt(112);
}

pub fn roegadynHellsguardMaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(116);
}

pub fn roegadynHellsguardFemaleLastName(self: @This()) []const u8 {
    return self.row.stringAt(120);
}

pub fn auRaRaenMale(self: @This()) []const u8 {
    return self.row.stringAt(124);
}

pub fn auRaRaenFemale(self: @This()) []const u8 {
    return self.row.stringAt(128);
}

pub fn auRaRaenLastName(self: @This()) []const u8 {
    return self.row.stringAt(132);
}

pub fn auRaXaelaMale(self: @This()) []const u8 {
    return self.row.stringAt(136);
}

pub fn auRaXaelaFemale(self: @This()) []const u8 {
    return self.row.stringAt(140);
}

pub fn auRaXaelaLastName(self: @This()) []const u8 {
    return self.row.stringAt(144);
}

pub fn hrothgarHellionsFirstName(self: @This()) []const u8 {
    return self.row.stringAt(148);
}

pub fn hrothgarHellionsLastName(self: @This()) []const u8 {
    return self.row.stringAt(152);
}

pub fn hrothgarLostFirstName(self: @This()) []const u8 {
    return self.row.stringAt(156);
}

pub fn hrothgarLostLastName(self: @This()) []const u8 {
    return self.row.stringAt(160);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(164);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(168);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(172);
}

pub fn vieraFirstName(self: @This()) []const u8 {
    return self.row.stringAt(176);
}

pub fn vieraRavaLastName(self: @This()) []const u8 {
    return self.row.stringAt(180);
}

pub fn vieraVeenaLastName(self: @This()) []const u8 {
    return self.row.stringAt(184);
}

pub fn unknown_70_1(self: @This()) []const u8 {
    return self.row.stringAt(188);
}

pub fn unknown_70_2(self: @This()) []const u8 {
    return self.row.stringAt(192);
}

pub fn unknown_70_3(self: @This()) []const u8 {
    return self.row.stringAt(196);
}
