//! `TerritoryIntendedUse`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryIntendedUse = @This();

pub const sheet_name = "TerritoryIntendedUse";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5345f16d;
pub const Sheet = excel.Typed(TerritoryIntendedUse);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EnableCrafting", "EnableGathering", "EnableRepairs", "EnableClassJobChange", "EnableClassJobChangeCombatJobCheck", "EnableJobChangeToLimitedJob", "EnableCompanion", "EnablePets", "EnableRidePillion", "DisableLogoutTimer", "EnableTeleport", "EnableReturn", "EnableMinions", "EnableOrnaments", "EnableRevive", "EnableRecommendedDuties", "Unknown20", "DisableMapDiscovery", "DisableFieldMarkers", "Unknown0", "GayaSoundId", "Unknown23", "EnableActions", "EnableConsumableItems", "Unknown26", "EnableTripleTriadMatches", "EnableTripleTriadMatchesAnywhere", "Unknown29", "Unknown30", "EnableIdleCamLineOfSightCheck", "CanPauseTimeWeather", "Unknown33", "EnablePvPQuickChat", "ChatRule", "Unknown35", "EnablePerform", "Unknown3", "CanApplyGlamourPlatesAnywhere", "Unknown38", "EnableFieldMarkerPresets", "IgnoreCombatFlagForMarkers", "Unknown41", "Unknown42" };

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

/// Ambient noise of people talking in a crowd. Values: 0 = None, 1 = sound/strm/GAYA_LestArea_01.scd, 2 = sound/strm/GAYA_Village_01.scd
pub fn gayaSoundId(self: @This()) u8 {
    return self.row.at(u8, 2);
}

/// Links to `TerritoryChatRule`.
pub fn chatRule(self: @This()) excel.Link(sheets.TerritoryChatRule) {
    return .of(self.row.at(u8, 3));
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn enableCrafting(self: @This()) bool {
    return self.row.bitAt(5, 0);
}

pub fn enableGathering(self: @This()) bool {
    return self.row.bitAt(5, 1);
}

pub fn enableRepairs(self: @This()) bool {
    return self.row.bitAt(5, 2);
}

pub fn enableClassJobChange(self: @This()) bool {
    return self.row.bitAt(5, 3);
}

/// When true, requires that the target ClassJob is a combat job
pub fn enableClassJobChangeCombatJobCheck(self: @This()) bool {
    return self.row.bitAt(5, 4);
}

pub fn enableJobChangeToLimitedJob(self: @This()) bool {
    return self.row.bitAt(5, 5);
}

/// Enables summoning Chocobo Companion
pub fn enableCompanion(self: @This()) bool {
    return self.row.bitAt(5, 6);
}

/// Enables summoning Summoner/Scholar pets
pub fn enablePets(self: @This()) bool {
    return self.row.bitAt(5, 7);
}

pub fn enableRidePillion(self: @This()) bool {
    return self.row.bitAt(6, 0);
}

pub fn disableLogoutTimer(self: @This()) bool {
    return self.row.bitAt(6, 1);
}

pub fn enableTeleport(self: @This()) bool {
    return self.row.bitAt(6, 2);
}

pub fn enableReturn(self: @This()) bool {
    return self.row.bitAt(6, 3);
}

pub fn enableMinions(self: @This()) bool {
    return self.row.bitAt(6, 4);
}

pub fn enableOrnaments(self: @This()) bool {
    return self.row.bitAt(6, 5);
}

/// Can return to the starting point when dead. Do not confuse with Raise.
pub fn enableRevive(self: @This()) bool {
    return self.row.bitAt(6, 6);
}

/// Opens the Recommended Duties window upon login or area change
pub fn enableRecommendedDuties(self: @This()) bool {
    return self.row.bitAt(6, 7);
}

pub fn unknown20(self: @This()) bool {
    return self.row.bitAt(7, 0);
}

pub fn disableMapDiscovery(self: @This()) bool {
    return self.row.bitAt(7, 1);
}

pub fn disableFieldMarkers(self: @This()) bool {
    return self.row.bitAt(7, 2);
}

pub fn unknown23(self: @This()) bool {
    return self.row.bitAt(7, 3);
}

pub fn enableActions(self: @This()) bool {
    return self.row.bitAt(7, 4);
}

pub fn enableConsumableItems(self: @This()) bool {
    return self.row.bitAt(7, 5);
}

pub fn unknown26(self: @This()) bool {
    return self.row.bitAt(7, 6);
}

pub fn enableTripleTriadMatches(self: @This()) bool {
    return self.row.bitAt(7, 7);
}

pub fn enableTripleTriadMatchesAnywhere(self: @This()) bool {
    return self.row.bitAt(8, 0);
}

pub fn unknown29(self: @This()) bool {
    return self.row.bitAt(8, 1);
}

pub fn unknown30(self: @This()) bool {
    return self.row.bitAt(8, 2);
}

/// Only entities in line of sight will be shown.
pub fn enableIdleCamLineOfSightCheck(self: @This()) bool {
    return self.row.bitAt(8, 3);
}

pub fn canPauseTimeWeather(self: @This()) bool {
    return self.row.bitAt(8, 4);
}

pub fn unknown33(self: @This()) bool {
    return self.row.bitAt(8, 5);
}

pub fn enablePvPQuickChat(self: @This()) bool {
    return self.row.bitAt(8, 6);
}

pub fn unknown35(self: @This()) bool {
    return self.row.bitAt(8, 7);
}

pub fn enablePerform(self: @This()) bool {
    return self.row.bitAt(9, 0);
}

pub fn canApplyGlamourPlatesAnywhere(self: @This()) bool {
    return self.row.bitAt(9, 1);
}

/// Related to idle timer
pub fn unknown38(self: @This()) bool {
    return self.row.bitAt(9, 2);
}

pub fn enableFieldMarkerPresets(self: @This()) bool {
    return self.row.bitAt(9, 3);
}

pub fn ignoreCombatFlagForMarkers(self: @This()) bool {
    return self.row.bitAt(9, 4);
}

/// Related to blocking Say/Yell/Shout of a muted player in Eureka/Bozja/OccultCrescent
pub fn unknown41(self: @This()) bool {
    return self.row.bitAt(9, 5);
}

pub fn unknown42(self: @This()) bool {
    return self.row.bitAt(9, 6);
}
