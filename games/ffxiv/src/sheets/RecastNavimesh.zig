//! `RecastNavimesh`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RecastNavimesh = @This();

pub const sheet_name = "RecastNavimesh";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98c040df;
pub const Sheet = excel.Typed(RecastNavimesh);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "TileSize", "CellSize", "CellHeight", "AgentHeight", "AgentRadius", "AgentMaxClimb", "AgentMaxSlope", "Unknown17", "RegionMinSize", "RegionMergedSize", "Unknown18", "MaxEdgeLength", "MaxEdgeError", "VertsPerPoly", "DetailMeshSampleDistance", "DetailMeshMaxSampleError", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown19", "Unknown14", "Unknown15", "Unknown16", "Unknown20" };

/// Corresponds to Name from TerritoryType.
pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn tileSize(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn cellSize(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn cellHeight(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn agentHeight(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn agentRadius(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn agentMaxClimb(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn agentMaxSlope(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn regionMinSize(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn regionMergedSize(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn maxEdgeLength(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn maxEdgeError(self: @This()) f32 {
    return self.row.at(f32, 44);
}

pub fn vertsPerPoly(self: @This()) f32 {
    return self.row.at(f32, 48);
}

pub fn detailMeshSampleDistance(self: @This()) f32 {
    return self.row.at(f32, 52);
}

pub fn detailMeshMaxSampleError(self: @This()) f32 {
    return self.row.at(f32, 56);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 60);
}

pub fn unknown2(self: @This()) f32 {
    return self.row.at(f32, 64);
}

pub fn unknown3(self: @This()) f32 {
    return self.row.at(f32, 68);
}

pub fn unknown4(self: @This()) f32 {
    return self.row.at(f32, 72);
}

pub fn unknown5(self: @This()) f32 {
    return self.row.at(f32, 76);
}

pub fn unknown6(self: @This()) f32 {
    return self.row.at(f32, 80);
}

pub fn unknown7(self: @This()) f32 {
    return self.row.at(f32, 84);
}

pub fn unknown8(self: @This()) f32 {
    return self.row.at(f32, 88);
}

pub fn unknown9(self: @This()) f32 {
    return self.row.at(f32, 92);
}

pub fn unknown10(self: @This()) f32 {
    return self.row.at(f32, 96);
}

pub fn unknown11(self: @This()) f32 {
    return self.row.at(f32, 100);
}

pub fn unknown12(self: @This()) f32 {
    return self.row.at(f32, 104);
}

pub fn unknown13(self: @This()) f32 {
    return self.row.at(f32, 108);
}

pub fn unknown14(self: @This()) f32 {
    return self.row.at(f32, 112);
}

pub fn unknown15(self: @This()) f32 {
    return self.row.at(f32, 116);
}

pub fn unknown16(self: @This()) f32 {
    return self.row.at(f32, 120);
}

pub fn unknown17(self: @This()) bool {
    return self.row.bitAt(124, 0);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(124, 1);
}

pub fn unknown19(self: @This()) bool {
    return self.row.bitAt(124, 2);
}

pub fn unknown20(self: @This()) bool {
    return self.row.bitAt(124, 3);
}
