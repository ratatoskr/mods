//! `GUObjectArray`, every UObject. Found by its first few objects holding their own indexes, which
//! also tells the item size. Chunked since about 4.20, one flat array before.

const std = @import("std");

const Mem = @import("Mem.zig");

const P = Mem.ptr_size;

/// Where UObject keeps what everything else is found with. The same from UE4 to UE5, after its
/// vtable, so 8, 0xC, 0x10 and 0x18 in 64-bit games and 4, 8, 0xC and 0x10 in 32-bit. Its outer
/// comes after the name, which games built with case preserving names have 4 bytes bigger, so
/// that's `Unreal.outerAt`.
pub const object = struct {
    pub const flags = P;
    pub const index = P + 4;
    pub const class = P + 8;
    pub const name = 2 * P + 8;
};

pub const Objects = struct {
    mem: *const Mem,
    kind: Kind,
    /// The `TUObjectArray`, `ObjObjects`.
    table: usize,
    /// One `FUObjectItem`.
    stride: usize,
    /// Objects in a chunk. 64K in stock engines, but Tales of Arise has 65K.
    chunk_len: usize = 0,

    pub const Kind = enum { chunked, fixed };

    /// A pointer and three ints, or two in older engines.
    const strides = if (P == 8) [_]usize{ 0x18, 0x10, 0x20, 0x28 } else [_]usize{ 0x10, 0xC, 0x14, 0x18 };
    const stock_len = 64 * 1024;
    const max_objects = 0x400_0000;

    /// The chunked array's words: two pointers, then four counts.
    const chunked_words = 2 + 16 / P;
    /// The fixed one's: a pointer, then two counts.
    const fixed_words = 1 + 8 / P;
    /// Where `NumElements` is in each.
    const chunked_num = 2 * P + 4;
    const fixed_num = P + 4;

    /// Counts come straight from `words`, the game's data. Only likely pointers get read.
    pub fn find(mem: *const Mem, words: []const usize) ?Objects {
        for (words, 0..) |v, i| {
            if (i + chunked_words > words.len or !mem.readable(v, P)) continue;
            if (chunkedAt(mem, words[i..][0..chunked_words])) |c| return .{ .mem = mem, .kind = .chunked, .table = @intFromPtr(&words[i]), .stride = c.stride, .chunk_len = c.len };
        }
        for (words, 0..) |v, i| {
            if (i + fixed_words > words.len or !mem.readable(v, P)) continue;
            if (fixedAt(mem, words[i..][0..fixed_words])) |stride| return .{ .mem = mem, .kind = .fixed, .table = @intFromPtr(&words[i]), .stride = stride };
        }
        return null;
    }

    /// The counts from `at` on, whatever the pointer size.
    fn ints(comptime n: usize, at: *const usize) [n]i32 {
        return @as(*const [n]i32, @ptrCast(at)).*;
    }

    const Chunks = struct { stride: usize, len: usize };

    /// `Objects`, `PreAllocatedObjects`, `MaxElements` and `NumElements`, `MaxChunks` and `NumChunks`.
    /// The engine makes the max whole chunks, so that gives the chunk size.
    fn chunkedAt(mem: *const Mem, w: *const [chunked_words]usize) ?Chunks {
        const max, const num, const max_chunks, const num_chunks = ints(4, &w[2]);
        if (num <= 0 or num > max or max > max_objects) return null;
        if (max_chunks <= 0) return null;
        // 64K rounded up, for any max that isn't whole chunks
        const len = if (@rem(max, max_chunks) == 0) @divExact(max, max_chunks) else stock_len;
        if (len < 1024 or (len == stock_len and max_chunks != @divFloor(max + len - 1, len))) return null;
        if (num_chunks < @divFloor(num + len - 1, len) or num_chunks > max_chunks) return null;
        const chunks = w[0];
        const first = mem.ptr(chunks) orelse return null;
        const stride = strideOf(mem, first) orelse return null;
        if (num_chunks > 1 and !secondChunkStartsAt(mem, chunks, stride, @intCast(len))) return null;
        return .{ .stride = stride, .len = @intCast(len) };
    }

    /// The first live objects in the second chunk say they're `len` on. Its first slots can all be
    /// free, so it looks a fair way in, and only a live object in the wrong place rules it out.
    fn secondChunkStartsAt(mem: *const Mem, chunks: usize, stride: usize, len: usize) bool {
        const second = mem.ptr(chunks + P) orelse return false;
        var checked: usize = 0;
        for (0..@min(len, 4096)) |k| {
            const obj = mem.ptr(second + k * stride) orelse continue;
            const index = mem.read(i32, obj + object.index) orelse return false;
            if (index != @as(i32, @intCast(len + k))) return false;
            checked += 1;
            if (checked == 2) return true;
        }
        return true;
    }

    /// `Objects`, `MaxElements` and `NumElements`.
    fn fixedAt(mem: *const Mem, w: *const [fixed_words]usize) ?usize {
        const max, const num = ints(2, &w[1]);
        if (num <= 0 or num > max or max > max_objects) return null;
        if (w[0] % P != 0) return null;
        return strideOf(mem, w[0]);
    }

    /// The item size where the first objects say they're 0, 1, 2 and 3.
    fn strideOf(mem: *const Mem, items: usize) ?usize {
        stride: for (strides) |stride| {
            for (0..4) |i| {
                const obj = mem.ptr(items + i * stride) orelse continue :stride;
                if (mem.read(i32, obj + object.index) != @as(i32, @intCast(i))) continue :stride;
            }
            return stride;
        }
        return null;
    }

    pub fn count(self: *const Objects) usize {
        const n = self.mem.read(i32, self.table + @as(usize, if (self.kind == .chunked) chunked_num else fixed_num)) orelse return 0;
        return @intCast(@max(n, 0));
    }

    /// Null for a free slot, or an index far past the end.
    pub fn get(self: *const Objects, i: usize) ?usize {
        const items = switch (self.kind) {
            .chunked => blk: {
                const chunks = self.mem.ptr(self.table) orelse return null;
                const chunk = std.math.add(usize, chunks, std.math.mul(usize, i / self.chunk_len, P) catch return null) catch return null;
                break :blk std.math.add(usize, self.mem.ptr(chunk) orelse return null, (i % self.chunk_len) * self.stride) catch return null;
            },
            .fixed => std.math.add(usize, self.mem.ptr(self.table) orelse return null, std.math.mul(usize, i, self.stride) catch return null) catch return null,
        };
        return self.mem.ptr(items);
    }

    /// If `p` is a live object, by it being where its index says.
    pub fn isObject(self: *const Objects, p: usize) bool {
        const i = self.mem.read(i32, p + object.index) orelse return false;
        if (i < 0 or i >= self.count()) return false;
        return self.get(@intCast(i)) == p;
    }

    /// Like `get` with plain reads, 0 for a free slot. Game thread only, where every object in the
    /// array is alive, and quick enough to go through all of them.
    pub fn getPlain(self: *const Objects, i: usize) usize {
        const item = switch (self.kind) {
            .chunked => blk: {
                const chunks = plain(self.table);
                if (chunks == 0) return 0;
                const chunk = plain(chunks + (i / self.chunk_len) * P);
                if (chunk == 0) return 0;
                break :blk chunk + (i % self.chunk_len) * self.stride;
            },
            .fixed => plain(self.table) + i * self.stride,
        };
        return plain(item);
    }

    fn plain(at: usize) usize {
        return @as(*align(1) const usize, @ptrFromInt(at)).*;
    }

    /// Like `isObject`, quick enough for the game thread every frame. `p` can be one kept from an
    /// earlier frame that's been destroyed and freed since, so its index is read safely. The
    /// array's the game's and alive, so that's read plainly.
    pub fn isObjectPlain(self: *const Objects, p: usize) bool {
        const i = self.mem.read(i32, p + object.index) orelse return false;
        const n = @as(*align(1) const i32, @ptrFromInt(self.table + @as(usize, if (self.kind == .chunked) chunked_num else fixed_num))).*;
        if (i < 0 or i >= n) return false;
        return self.getPlain(@intCast(i)) == p;
    }
};

const tests = struct {
    const Obj = extern struct {
        vtable: usize = 0,
        flags: i32 = 0,
        index: i32,
        class: usize = 0,
        name: [2]u32 = .{ 0, 0 },
        outer: usize = 0,
    };

    /// 0x18 in 64-bit games, with padding after, 0x10 in 32-bit.
    const Item = extern struct {
        object: usize,
        flags: i32 = 0,
        cluster: i32 = 0,
        serial: i32 = 0,
    };

    /// The chunked array, as the words it takes in the game's data.
    fn chunked(objects: usize, max: i32, num: i32, max_chunks: i32, num_chunks: i32) [Objects.chunked_words]usize {
        var w: [Objects.chunked_words]usize = undefined;
        w[0] = objects;
        w[1] = 0;
        @as(*[4]i32, @ptrCast(&w[2])).* = .{ max, num, max_chunks, num_chunks };
        return w;
    }

    fn fixed(objects: usize, max: i32, num: i32) [Objects.fixed_words]usize {
        var w: [Objects.fixed_words]usize = undefined;
        w[0] = objects;
        @as(*[2]i32, @ptrCast(&w[1])).* = .{ max, num };
        return w;
    }

    test "chunked" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var objs: [5]Obj = undefined;
        var items: [5]Item = undefined;
        for (&objs, &items, 0..) |*o, *it, i| {
            o.* = .{ .index = @intCast(i) };
            it.* = .{ .object = @intFromPtr(o) };
        }
        var chunks = [_]usize{@intFromPtr(&items)};
        // Some data, then ObjObjects
        var data: [2 + Objects.chunked_words]usize = undefined;
        data[0..2].* = .{ 1, 2 };
        data[2..].* = chunked(@intFromPtr(&chunks), 0x20000, 5, 2, 1);
        try mem.refresh();

        const objects = Objects.find(&mem, &data).?;
        try std.testing.expectEqual(.chunked, objects.kind);
        try std.testing.expectEqual(@sizeOf(Item), objects.stride);
        try std.testing.expectEqual(0x10000, objects.chunk_len);
        try std.testing.expectEqual(5, objects.count());
        try std.testing.expectEqual(@intFromPtr(&objs[4]), objects.get(4).?);
        try std.testing.expect(objects.isObject(@intFromPtr(&objs[2])));
        var stray: Obj = .{ .index = 2 };
        try std.testing.expect(!objects.isObject(@intFromPtr(&stray)));
    }

    test "chunked, with chunks that aren't 64K" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        const len = 0x10400;
        var objs: [8]Obj = undefined;
        var items: [2][4]Item = undefined;
        for (0..2) |c| for (0..4) |k| {
            objs[c * 4 + k] = .{ .index = @intCast(c * len + k) };
            items[c][k] = .{ .object = @intFromPtr(&objs[c * 4 + k]) };
        };
        var chunks = [_]usize{ @intFromPtr(&items[0]), @intFromPtr(&items[1]) };
        // Tales of Arise's, 32 chunks of 0x10400
        var data = chunked(@intFromPtr(&chunks), 0x208000, len + 4, 32, 2);
        try mem.refresh();

        const objects = Objects.find(&mem, &data).?;
        try std.testing.expectEqual(len, objects.chunk_len);
        try std.testing.expectEqual(@intFromPtr(&objs[5]), objects.get(len + 1).?);
        try std.testing.expect(objects.isObject(@intFromPtr(&objs[6])));
        try std.testing.expectEqual(@intFromPtr(&objs[7]), objects.getPlain(len + 3));
    }

    test "a second chunk that doesn't start where the counts say isn't it" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var objs: [8]Obj = undefined;
        var items: [2][4]Item = undefined;
        for (0..2) |c| for (0..4) |k| {
            objs[c * 4 + k] = .{ .index = @intCast(c * 0x10000 + k) };
            items[c][k] = .{ .object = @intFromPtr(&objs[c * 4 + k]) };
        };
        var chunks = [_]usize{ @intFromPtr(&items[0]), @intFromPtr(&items[1]) };
        var data = chunked(@intFromPtr(&chunks), 0x208000, 0x10404, 32, 2);
        try mem.refresh();

        try std.testing.expectEqual(null, Objects.find(&mem, &data));
    }

    test "a second chunk whose first slots are free still counts" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var objs: [6]Obj = undefined;
        var first: [4]Item = undefined;
        for (objs[0..4], &first, 0..) |*o, *it, i| {
            o.* = .{ .index = @intCast(i) };
            it.* = .{ .object = @intFromPtr(o) };
        }
        // Like Rune Factory's, with the second chunk's first 40 free
        var second: [64]Item = @splat(.{ .object = 0 });
        objs[4] = .{ .index = 0x10000 + 40 };
        objs[5] = .{ .index = 0x10000 + 41 };
        second[40] = .{ .object = @intFromPtr(&objs[4]) };
        second[41] = .{ .object = @intFromPtr(&objs[5]) };
        var chunks = [_]usize{ @intFromPtr(&first), @intFromPtr(&second) };
        var data = chunked(@intFromPtr(&chunks), 0x210000, 0x10029, 33, 2);
        try mem.refresh();

        const objects = Objects.find(&mem, &data).?;
        try std.testing.expectEqual(0x10000, objects.chunk_len);
        try std.testing.expectEqual(@intFromPtr(&objs[4]), objects.get(0x10000 + 40).?);
    }

    test "an object that's been freed isn't one, and reading it doesn't fault" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var objs: [4]Obj = undefined;
        var items: [4]Item = undefined;
        for (&objs, &items, 0..) |*o, *it, i| {
            o.* = .{ .index = @intCast(i) };
            it.* = .{ .object = @intFromPtr(o) };
        }
        var chunks = [_]usize{@intFromPtr(&items)};
        var data = chunked(@intFromPtr(&chunks), 0x20000, 4, 2, 1);
        try mem.refresh();
        const objects = Objects.find(&mem, &data).?;
        try std.testing.expect(objects.isObjectPlain(@intFromPtr(&objs[1])));

        // A page of its own, gone once it's freed, like a mesh the game destroyed
        const page = try std.heap.page_allocator.alignedAlloc(u8, .fromByteUnits(std.heap.page_size_min), std.heap.page_size_min);
        const gone = @intFromPtr(page.ptr);
        std.heap.page_allocator.free(page);
        try std.testing.expect(!objects.isObjectPlain(gone));
    }

    test "fixed, with smaller items" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var objs: [4]Obj = undefined;
        // Without the serial number
        const small = Objects.strides[1];
        var items: [4][small / P]usize = undefined;
        for (&objs, &items, 0..) |*o, *it, i| {
            o.* = .{ .index = @intCast(i) };
            it.* = @splat(0);
            it[0] = @intFromPtr(o);
        }
        var data: [1 + Objects.fixed_words]usize = undefined;
        data[0] = 9;
        data[1..].* = fixed(@intFromPtr(&items), 10, 4);
        try mem.refresh();

        const objects = Objects.find(&mem, &data).?;
        try std.testing.expectEqual(.fixed, objects.kind);
        try std.testing.expectEqual(small, objects.stride);
        try std.testing.expectEqual(@intFromPtr(&objs[3]), objects.get(3).?);
    }
};

test {
    _ = tests;
}
