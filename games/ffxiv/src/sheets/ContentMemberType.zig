//! `ContentMemberType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentMemberType = @This();

pub const sheet_name = "ContentMemberType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x44ea3aee;
pub const Sheet = excel.Typed(ContentMemberType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown7", "Unknown0", "AllowAllianceRegistration", "Unknown10", "Unknown1", "AllianceRegistrationMinPlayers", "Unknown3", "MembersPerParty", "PartyCount", "AlliancePartyCount", "Unknown6", "TanksPerParty", "HealersPerParty", "MeleesPerParty", "RangedPerParty", "SeparatedDpsRoles", "RoleIndependent", "Unknown16", "Unknown12", "OnlyPvPTeamMembers", "AllowLimitedJobs" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}

/// Used as parameter for Addon#16461.
pub fn allianceRegistrationMinPlayers(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn membersPerParty(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn partyCount(self: @This()) u8 {
    return self.row.at(u8, 5);
}

/// For example, used for The Occult Crescent: South Horn, to allow queuing with alliance parties. If 0, use PartyCount.
pub fn alliancePartyCount(self: @This()) u8 {
    return self.row.at(u8, 6);
}

/// Unknown party count. If 0, use PartyCount.
pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn tanksPerParty(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn healersPerParty(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn meleesPerParty(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn rangedPerParty(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(13, 0);
}

/// Displays Addon#10826.
pub fn allowAllianceRegistration(self: @This()) bool {
    return self.row.bitAt(13, 1);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(13, 2);
}

/// If true, displays MeleesPerParty and RangedPerParty separately (Addon#102593) instead of combining them (Addon#2513).
pub fn separatedDpsRoles(self: @This()) bool {
    return self.row.bitAt(13, 3);
}

/// If true, displays Addon#102599 instead of Addon#2513 or Addon#102593.
pub fn roleIndependent(self: @This()) bool {
    return self.row.bitAt(13, 4);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(13, 5);
}

/// Displays Addon#102617.
pub fn onlyPvPTeamMembers(self: @This()) bool {
    return self.row.bitAt(13, 6);
}

/// Displays Addon#10829.
pub fn allowLimitedJobs(self: @This()) bool {
    return self.row.bitAt(13, 7);
}
