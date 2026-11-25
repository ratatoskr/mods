//! Unpacking a file from a dat. One read gets its header and the first few KB, which is all of most
//! files, and one more gets the rest of a bigger one. Its blocks then inflate straight into what's
//! returned. Reads are positional, so any number of threads can share a dat's handle.

const std = @import("std");
const File = std.Io.File;

const format = @import("format.zig");
const bytesAt = format.bytesAt;
const valueAt = format.valueAt;
const sliceAt = format.sliceAt;
const Inflater = @import("Inflater.zig");

/// Enough for a file's header and most files whole.
const first_read = 16 * 1024;

/// The file at `offset` in `dat`, unpacked. Free it with `gpa`.
pub fn read(io: std.Io, gpa: std.mem.Allocator, dat: File, offset: u64) ![]u8 {
    var packed_file: Packed = .{ .io = io, .gpa = gpa, .dat = dat, .offset = offset };
    defer packed_file.deinit();
    try packed_file.fill(first_read, false);

    const header = try valueAt(format.FileHeader, packed_file.got(), 0);
    if (header.kind == .empty) return error.FileNotFound;
    try packed_file.fill(header.size, true);
    const span = switch (header.kind) {
        .standard => try standardSpan(packed_file.got()),
        .texture => try textureSpan(packed_file.got()),
        .model => try modelSpan(packed_file.got()),
        else => return error.UnknownKind,
    };
    // Which can move it, so the header's taken after
    try packed_file.fill(header.size + span, true);
    const head = packed_file.got()[0..header.size];
    const data = packed_file.got()[header.size..][0..span];

    var inflater: Inflater = .{};
    var out: Out = .{ .buf = try gpa.alloc(u8, header.raw_size), .inflater = &inflater };
    errdefer gpa.free(out.buf);
    switch (header.kind) {
        .standard => try standard(head, data, &out),
        .texture => try texture(head, data, &out),
        .model => try model(head, data, &out),
        else => unreachable,
    }
    if (out.end != out.buf.len) return error.Corrupt;
    return out.buf;
}

/// The packed bytes read so far, from the file's start.
const Packed = struct {
    io: std.Io,
    gpa: std.mem.Allocator,
    dat: File,
    offset: u64,
    buf: []u8 = &.{},
    len: usize = 0,

    fn deinit(self: *Packed) void {
        self.gpa.free(self.buf);
    }

    fn got(self: *const Packed) []const u8 {
        return self.buf[0..self.len];
    }

    /// Reads up to `n` bytes in, which have to be there if `exact`, or it's cut short.
    fn fill(self: *Packed, n: usize, exact: bool) !void {
        if (n <= self.len) return;
        if (n > self.buf.len) self.buf = try self.gpa.realloc(self.buf, n);
        self.len += try self.dat.readPositionalAll(self.io, self.buf[self.len..n], self.offset + self.len);
        if (exact and self.len < n) return error.Truncated;
    }
};

/// The file as it's unpacked, block by block.
const Out = struct {
    buf: []u8,
    end: usize = 0,
    inflater: *Inflater,

    fn write(self: *Out, bytes: []const u8) !void {
        if (bytes.len > self.buf.len - self.end) return error.Corrupt;
        @memcpy(self.buf[self.end..][0..bytes.len], bytes);
        self.end += bytes.len;
    }

    /// The block at `pos` in `data`. Returns how big it unpacked to.
    fn block(self: *Out, data: []const u8, pos: usize) !usize {
        const h = try valueAt(format.BlockHeader, data, pos);
        const start = pos + h.size;
        if (h.compressed_size == format.BlockHeader.stored) {
            try self.write(try bytesAt(data, start, h.raw_size));
            return h.raw_size;
        }
        if (h.raw_size > self.buf.len - self.end) return error.Corrupt;
        try self.inflater.inflate(try bytesAt(data, start, h.compressed_size), self.buf[self.end..][0..h.raw_size]);
        self.end += h.raw_size;
        return h.raw_size;
    }
};

const blocks_at = @sizeOf(format.FileHeader) + @sizeOf(format.BlockCount);

fn standardBlocks(head: []const u8) ![]align(1) const format.StandardBlock {
    const count = (try valueAt(format.BlockCount, head, @sizeOf(format.FileHeader))).count;
    return sliceAt(format.StandardBlock, head, blocks_at, count);
}

fn standardSpan(head: []const u8) !usize {
    var end: usize = 0;
    for (try standardBlocks(head)) |b| end = @max(end, @as(usize, b.offset) + b.compressed_size);
    return end;
}

fn standard(head: []const u8, data: []const u8, out: *Out) !void {
    for (try standardBlocks(head)) |b| _ = try out.block(data, b.offset);
}

fn textureLods(head: []const u8) ![]align(1) const format.TextureLod {
    const count = (try valueAt(format.BlockCount, head, @sizeOf(format.FileHeader))).count;
    return sliceAt(format.TextureLod, head, blocks_at, count);
}

fn textureSpan(head: []const u8) !usize {
    var end: usize = 0;
    for (try textureLods(head)) |l| end = @max(end, @as(usize, l.compressed_offset) + l.compressed_size);
    return end;
}

fn texture(head: []const u8, data: []const u8, out: *Out) !void {
    const lods = try textureLods(head);
    if (lods.len == 0) return;
    var total: usize = 0;
    for (lods) |l| total += l.block_count;
    const sizes = try sliceAt(u16, head, blocks_at + lods.len * @sizeOf(format.TextureLod), total);

    // The .tex header's stored as it is, before the first mip
    try out.write(try bytesAt(data, 0, lods[0].compressed_offset));
    var block: usize = 0;
    for (lods) |l| {
        var pos: usize = l.compressed_offset;
        for (0..l.block_count) |_| {
            _ = try out.block(data, pos);
            pos += sizes[block];
            block += 1;
        }
    }
}

const model_info_at = @sizeOf(format.FileHeader);
const model_sizes_at = model_info_at + @sizeOf(format.ModelInfo);

fn modelSpan(head: []const u8) !usize {
    const info = try valueAt(format.ModelInfo, head, model_info_at);
    const Parts = [@sizeOf(@TypeOf(info.offset)) / 4]u32;
    const offsets: *const Parts = @ptrCast(&info.offset);
    const sizes: *const Parts = @ptrCast(&info.compressed_size);
    var end: usize = 0;
    for (offsets, sizes) |o, s| end = @max(end, @as(usize, o) + s);
    return end;
}

/// Its blocks unpack after a header that's rebuilt from what's packed.
fn model(head: []const u8, data: []const u8, out: *Out) !void {
    const info = try valueAt(format.ModelInfo, head, model_info_at);
    const sizes = try sliceAt(u16, head, model_sizes_at, info.block_count_of.sum());
    if (out.buf.len < @sizeOf(format.ModelHeader)) return error.Corrupt;
    out.end = @sizeOf(format.ModelHeader);

    var parts: ModelParts = .{ .data = data, .sizes = sizes, .out = out };
    var header: format.ModelHeader = .{
        .version = info.version,
        .stack_size = try parts.next(info.offset.stack, info.block_count_of.stack),
        .runtime_size = try parts.next(info.offset.runtime, info.block_count_of.runtime),
        .vertex_declaration_count = info.vertex_declaration_count,
        .material_count = info.material_count,
        .vertex_offset = @splat(0),
        .index_offset = @splat(0),
        .vertex_size = @splat(0),
        .index_size = @splat(0),
        .lod_count = info.lod_count,
        .index_streaming = @intFromBool(info.index_streaming),
        .edge_geometry = @intFromBool(info.edge_geometry),
        ._pad = 0,
    };
    for (0..format.lod_count) |lod| {
        try parts.lod(lod, info.offset.vertex[lod], info.block_count_of.vertex[lod], &header.vertex_offset, &header.vertex_size);
        // Nothing points at the edge geometry, it just sits between the two
        _ = try parts.next(info.offset.edge[lod], info.block_count_of.edge[lod]);
        try parts.lod(lod, info.offset.index[lod], info.block_count_of.index[lod], &header.index_offset, &header.index_size);
    }
    @memcpy(out.buf[0..@sizeOf(format.ModelHeader)], std.mem.asBytes(&header));
}

/// A model's parts, one after another, with its block sizes walked in order.
const ModelParts = struct {
    data: []const u8,
    sizes: []align(1) const u16,
    out: *Out,
    block: usize = 0,

    /// How much it unpacked to.
    fn next(self: *ModelParts, offset: u32, count: u16) !u32 {
        var pos: usize = offset;
        var size: usize = 0;
        for (0..count) |_| {
            if (self.block >= self.sizes.len) return error.Corrupt;
            size += try self.out.block(self.data, pos);
            pos += self.sizes[self.block];
            self.block += 1;
        }
        return @intCast(size);
    }

    /// A lod's offset is 0 when it has nothing, or starts where the last one did.
    fn lod(self: *ModelParts, i: usize, offset: u32, count: u16, offsets: *[format.lod_count]u32, sizes: *[format.lod_count]u32) !void {
        if (count == 0) return;
        const at: u32 = @intCast(self.out.end);
        if (i == 0 or at != offsets[i - 1]) offsets[i] = at;
        sizes[i] = try self.next(offset, count);
    }
};
