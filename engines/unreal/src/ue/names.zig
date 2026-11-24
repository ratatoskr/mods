//! FName text. UE 4.23 and later keep names in a pool of blocks, older ones in an array of chunks.
//! Both get found by what's always first in them, `None` then `ByteProperty`, so no game needs a
//! signature.

const std = @import("std");

const Mem = @import("Mem.zig");

const P = Mem.ptr_size;

pub const Names = struct {
    mem: *const Mem,
    kind: Kind,
    /// The pool's `Blocks`, or the array's `Chunks`.
    table: usize,
    /// For the array, where an entry's text starts.
    text_at: usize = 2 * P,

    pub const Kind = enum { pool, array };

    /// Pool blocks hold 64K entries of 2 byte steps, array chunks 16K entries.
    const pool_block_bits = 16;
    const array_chunk = 16384;
    const max_len = 1024;

    /// Looks through `words`, the game's data, for the pool or array. Only pointers out of it get
    /// read, since reading safely costs a system call.
    pub fn find(mem: *const Mem, words: []const usize) ?Names {
        for (words, 0..) |v, i| {
            if (v % 2 != 0 or !mem.readable(v, 16)) continue;
            const at = @intFromPtr(&words[i]);
            if (i >= 8 / P and isPool(mem, words, i)) return .{ .mem = mem, .kind = .pool, .table = at };
            if (v % P != 0) continue;
            // The array's in the data in some games, a pointer to it in others
            if (arrayText(mem, v)) |t| return .{ .mem = mem, .kind = .array, .table = at, .text_at = t };
            if (mem.ptr(v)) |chunk0| if (arrayText(mem, chunk0)) |t| return .{ .mem = mem, .kind = .array, .table = v, .text_at = t };
        }
        return null;
    }

    /// `words[i]` as `Blocks[0]`.
    fn isPool(mem: *const Mem, words: []const usize, i: usize) bool {
        const block0 = words[i];
        if (!entryIs(mem, block0, "None")) return false;
        if (!entryIs(mem, block0 + 6, "ByteProperty")) return false;
        // Before Blocks, after a pointer-sized lock, how many there are beyond the first
        const current = @as(*const u32, @ptrFromInt(@intFromPtr(&words[i]) - 8)).*;
        if (current >= 8192) return false;
        for (1..@min(current, 4) + 1) |b| {
            if (i + b >= words.len or !mem.readable(words[i + b], 8)) return false;
        }
        return true;
    }

    fn entryIs(mem: *const Mem, entry: usize, want: []const u8) bool {
        var buf: [16]u8 = undefined;
        const n = 2 + want.len;
        if (!mem.bytes(entry, buf[0..n])) return false;
        const header = std.mem.readInt(u16, buf[0..2], .little);
        return header & 1 == 0 and header >> 6 == want.len and std.mem.eql(u8, buf[2..n], want);
    }

    /// Where the text sits in the array's entries, if `chunk0` is its first chunk.
    fn arrayText(mem: *const Mem, chunk0: usize) ?usize {
        var first: [2]usize = undefined;
        if (!mem.bytes(chunk0, std.mem.asBytes(&first))) return null;
        const none = first[0];
        const byte = first[1];
        if (none % P != 0 or byte % P != 0 or !mem.readable(none, 0x18) or !mem.readable(byte, 0x18)) return null;
        // After the index and hash link, either way round
        const at = if (P == 8) [_]usize{ 0x10, 0xC } else [_]usize{0x8};
        for (at) |t| {
            if (cstrIs(mem, none + t, "None") and cstrIs(mem, byte + t, "ByteProperty")) return t;
        }
        return null;
    }

    fn cstrIs(mem: *const Mem, at: usize, want: []const u8) bool {
        var buf: [16]u8 = undefined;
        const n = want.len + 1;
        return mem.bytes(at, buf[0..n]) and std.mem.eql(u8, buf[0..want.len], want) and buf[want.len] == 0;
    }

    /// The text for an FName's comparison index, in `buf`. Null if it can't be read.
    pub fn text(self: *const Names, index: u32, buf: []u8) ?[]const u8 {
        return switch (self.kind) {
            .pool => self.poolText(index, buf),
            .array => self.arrayEntryText(index, buf),
        };
    }

    fn poolText(self: *const Names, index: u32, buf: []u8) ?[]const u8 {
        const block = self.mem.ptr(self.table + (index >> pool_block_bits) * P) orelse return null;
        const entry = block + (index & 0xFFFF) * 2;
        const header = self.mem.read(u16, entry) orelse return null;
        const len: usize = header >> 6;
        if (header & 1 == 0) {
            if (len > buf.len or !self.mem.bytes(entry + 2, buf[0..len])) return null;
            return buf[0..len];
        }
        var wide: [max_len]u16 = undefined;
        if (len > wide.len or !self.mem.bytes(entry + 2, std.mem.sliceAsBytes(wide[0..len]))) return null;
        return utf8(wide[0..len], buf);
    }

    fn arrayEntryText(self: *const Names, index: u32, buf: []u8) ?[]const u8 {
        const chunk = self.mem.ptr(self.table + (index / array_chunk) * P) orelse return null;
        const entry = self.mem.ptr(chunk + (index % array_chunk) * P) orelse return null;
        const flags = self.mem.read(i32, entry) orelse return null;
        const at = entry + self.text_at;
        if (flags & 1 == 0) {
            var n: usize = 0;
            while (n < buf.len) : (n += 1) {
                const c = self.mem.read(u8, at + n) orelse return null;
                if (c == 0) break;
                buf[n] = c;
            }
            return buf[0..n];
        }
        var wide: [max_len]u16 = undefined;
        var n: usize = 0;
        while (n < wide.len) : (n += 1) {
            const c = self.mem.read(u16, at + n * 2) orelse return null;
            if (c == 0) break;
            wide[n] = c;
        }
        return utf8(wide[0..n], buf);
    }

    fn utf8(wide: []const u16, buf: []u8) ?[]const u8 {
        var n: usize = 0;
        var it = std.unicode.Utf16LeIterator.init(wide);
        while (it.nextCodepoint() catch null) |c| {
            const len = std.unicode.utf8CodepointSequenceLength(c) catch return null;
            if (n + len > buf.len) return null;
            n += std.unicode.utf8Encode(c, buf[n..]) catch return null;
        }
        return buf[0..n];
    }
};

/// What an object's or field's name holds. `number` above 0 is `_` and number - 1 on the end.
pub const FName = extern struct {
    index: u32,
    number: u32,
};

const tests = struct {
    /// A pool's first block, with "None", "ByteProperty" and a wide name.
    fn poolBlock(buf: []align(8) u8) void {
        @memset(buf, 0);
        var at: usize = 0;
        for ([_][]const u8{ "None", "ByteProperty", "Kai" }) |s| {
            std.mem.writeInt(u16, buf[at..][0..2], @intCast(s.len << 6), .little);
            @memcpy(buf[at + 2 ..][0..s.len], s);
            at += std.mem.alignForward(usize, 2 + s.len, 2);
        }
        // "Füße", wide
        const wide = [_]u16{ 'F', 0xFC, 0xDF, 'e' };
        std.mem.writeInt(u16, buf[at..][0..2], @intCast((wide.len << 6) | 1), .little);
        @memcpy(buf[at + 2 ..][0..8], std.mem.sliceAsBytes(&wide));
    }

    test "the pool" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var block: [64]u8 align(8) = undefined;
        poolBlock(&block);
        // Some data, then the pool: lock, current block and cursor, the blocks
        var data = [_]usize{ 7, 0x1234, 0, 0, @intFromPtr(&block), 0, 0 };
        try mem.refresh();

        const names = Names.find(&mem, &data).?;
        try std.testing.expectEqual(.pool, names.kind);
        var buf: [64]u8 = undefined;
        try std.testing.expectEqualStrings("None", names.text(0, &buf).?);
        try std.testing.expectEqualStrings("ByteProperty", names.text(3, &buf).?);
        try std.testing.expectEqualStrings("Kai", names.text(10, &buf).?);
        try std.testing.expectEqualStrings("Füße", names.text(13, &buf).?);
    }

    const Entry = extern struct {
        index: i32,
        next: usize = 0,
        text: [16]u8,
    };

    fn entry(s: []const u8) Entry {
        var e: Entry = .{ .index = 0, .text = @splat(0) };
        @memcpy(e.text[0..s.len], s);
        return e;
    }

    test "the old array, through a pointer" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var none = entry("None");
        var byte = entry("ByteProperty");
        var kai = entry("Kai");
        var chunk = [_]usize{ @intFromPtr(&none), @intFromPtr(&byte), @intFromPtr(&kai) };
        var array = [_]usize{ @intFromPtr(&chunk), 0 };
        var data = [_]usize{ 3, @intFromPtr(&array) };
        try mem.refresh();

        const names = Names.find(&mem, &data).?;
        try std.testing.expectEqual(.array, names.kind);
        try std.testing.expectEqual(@intFromPtr(&array), names.table);
        var buf: [64]u8 = undefined;
        try std.testing.expectEqualStrings("Kai", names.text(2, &buf).?);
    }
};

test {
    _ = tests;
}
