//! The structs in index and dat files, as the PC client has them. Little endian, and read with
//! `std.mem.bytesToValue`, so alignment doesn't matter.

const std = @import("std");

/// At the start of every index and dat file. Its `size` is where the next header starts.
pub const Header = extern struct {
    magic: [8]u8,
    platform: u8,
    _pad: [3]u8,
    size: u32,
    version: u32,
    kind: u32,

    pub const magic_value = "SqPack\x00\x00";
};

/// Just the bits of an index's header that are needed. It goes on with hashes and padding.
pub const IndexHeader = extern struct {
    size: u32,
    version: u32,
    entries_offset: u32,
    entries_size: u32,
    entries_hash: [64]u8,
    dat_count: u32,
    synonyms_offset: u32,
    synonyms_size: u32,
};

/// A `.index` entry, by the folder's hash and the file name's.
pub const Entry1 = extern struct {
    hash: u64,
    data: u32,
    _pad: u32,
};

/// A `.index2` entry, by the whole path's hash.
pub const Entry2 = extern struct {
    hash: u32,
    data: u32,
};

/// For paths whose hashes clash. Their entries have the synonym bit set and the full path picks
/// which. The list ends with a hash of all ones.
pub const Synonym = extern struct {
    /// An index2's is the u32 hash then zeroes, so it's the same number either way.
    hash: u64,
    data: u32,
    index: u32,
    path: [0xF0]u8,

    pub const end: u64 = std.math.maxInt(u64);
};

/// Where an entry's file is. The low bit is the synonym flag, then the dat, and the rest is the
/// offset in 128 byte steps.
pub fn isSynonym(data: u32) bool {
    return data & 1 != 0;
}

pub fn datOf(data: u32) u8 {
    return @intCast((data >> 1) & 0b111);
}

pub fn offsetOf(data: u32) u64 {
    return @as(u64, data & ~@as(u32, 0xF)) * 8;
}

pub const FileKind = enum(u32) {
    empty = 1,
    standard = 2,
    model = 3,
    texture = 4,
    _,
};

/// Where a file starts in its dat. Its blocks come after `size` bytes.
pub const FileHeader = extern struct {
    size: u32,
    kind: FileKind,
    raw_size: u32,
};

/// After `FileHeader`, for standard files and textures.
pub const BlockCount = extern struct {
    _unknown: [2]u32,
    count: u32,
};

/// A standard file's blocks, after `BlockCount`.
pub const StandardBlock = extern struct {
    offset: u32,
    compressed_size: u16,
    raw_size: u16,
};

/// A texture's mip levels, after `BlockCount`. Then the u16 sizes of all their blocks, in a row.
pub const TextureLod = extern struct {
    compressed_offset: u32,
    compressed_size: u32,
    raw_size: u32,
    first_block: u32,
    block_count: u32,
};

pub const lod_count = 3;

/// One number per part of a model, in file order.
pub fn ModelParts(comptime T: type) type {
    return extern struct {
        stack: T,
        runtime: T,
        vertex: [lod_count]T,
        edge: [lod_count]T,
        index: [lod_count]T,

        pub fn sum(self: @This()) usize {
            var total: usize = @as(usize, self.stack) + self.runtime;
            for (self.vertex, self.edge, self.index) |v, e, i| total += @as(usize, v) + e + i;
            return total;
        }
    };
}

/// After `FileHeader`, for models. Then the u16 sizes of all their blocks, in a row.
pub const ModelInfo = extern struct {
    block_count: u32,
    used_block_count: u32,
    version: u32,
    raw_size: ModelParts(u32),
    compressed_size: ModelParts(u32),
    offset: ModelParts(u32),
    first_block: ModelParts(u16),
    block_count_of: ModelParts(u16),
    vertex_declaration_count: u16,
    material_count: u16,
    lod_count: u8,
    index_streaming: bool,
    edge_geometry: bool,
    _pad: u8,
};

/// What an unpacked model starts with, rebuilt from `ModelInfo`. Its stack comes next.
pub const ModelHeader = extern struct {
    version: u32,
    stack_size: u32,
    runtime_size: u32,
    vertex_declaration_count: u16,
    material_count: u16,
    vertex_offset: [lod_count]u32,
    index_offset: [lod_count]u32,
    vertex_size: [lod_count]u32,
    index_size: [lod_count]u32,
    lod_count: u8,
    index_streaming: u8,
    edge_geometry: u8,
    _pad: u8,
};

/// Every block of every kind starts with this.
pub const BlockHeader = extern struct {
    size: u32,
    _unknown: u32,
    compressed_size: u32,
    raw_size: u32,

    /// In `compressed_size`, for a block that's stored as it is.
    pub const stored: u32 = 32000;
};

pub fn bytesAt(bytes: []const u8, offset: usize, len: usize) error{Truncated}![]const u8 {
    if (offset > bytes.len or bytes.len - offset < len) return error.Truncated;
    return bytes[offset..][0..len];
}

pub fn valueAt(comptime T: type, bytes: []const u8, offset: usize) error{Truncated}!T {
    return std.mem.bytesToValue(T, (try bytesAt(bytes, offset, @sizeOf(T)))[0..@sizeOf(T)]);
}

pub fn sliceAt(comptime T: type, bytes: []const u8, offset: usize, count: usize) error{Truncated}![]align(1) const T {
    const size = std.math.mul(usize, count, @sizeOf(T)) catch return error.Truncated;
    return std.mem.bytesAsSlice(T, try bytesAt(bytes, offset, size));
}

comptime {
    std.debug.assert(@sizeOf(Header) == 24);
    std.debug.assert(@sizeOf(Entry1) == 16);
    std.debug.assert(@sizeOf(Entry2) == 8);
    std.debug.assert(@sizeOf(Synonym) == 0x100);
    std.debug.assert(@sizeOf(FileHeader) == 12);
    std.debug.assert(@sizeOf(StandardBlock) == 8);
    std.debug.assert(@sizeOf(TextureLod) == 20);
    std.debug.assert(@sizeOf(ModelInfo) == 196);
    std.debug.assert(@sizeOf(ModelHeader) == 0x44);
    std.debug.assert(@sizeOf(BlockHeader) == 16);
}
