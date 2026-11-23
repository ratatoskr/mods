//! `GUObjectArray`, every UObject. Found by its first few objects holding their own indexes, which
//! also tells the item size. Chunked since about 4.20, one flat array before.

const std = @import("std");

const Mem = @import("Mem.zig");

/// Where UObject keeps what everything else is found with. The same from UE4 to UE5.
pub const object = struct {
    pub const flags = 0x8;
    pub const index = 0xC;
    pub const class = 0x10;
    pub const name = 0x18;
    pub const outer = 0x20;
};

pub const Objects = struct {
    mem: *const Mem,
    kind: Kind,
    /// The `TUObjectArray`, `ObjObjects`.
    table: usize,
    /// One `FUObjectItem`.
    stride: usize,

    pub const Kind = enum { chunked, fixed };

    pub const chunk_len = 64 * 1024;
    const strides = [_]usize{ 0x18, 0x10, 0x20, 0x28 };
    const max_objects = 0x400_0000;

    /// Counts come straight from `words`, the game's data. Only likely pointers get read.
    pub fn find(mem: *const Mem, words: []const usize) ?Objects {
        for (words, 0..) |v, i| {
            if (i + 3 >= words.len or !mem.readable(v, 8)) continue;
            if (chunkedAt(mem, words[i..][0..4])) |stride| return .{ .mem = mem, .kind = .chunked, .table = @intFromPtr(&words[i]), .stride = stride };
        }
        for (words, 0..) |v, i| {
            if (i + 1 >= words.len or !mem.readable(v, 8)) continue;
            if (fixedAt(mem, words[i..][0..2])) |stride| return .{ .mem = mem, .kind = .fixed, .table = @intFromPtr(&words[i]), .stride = stride };
        }
        return null;
    }

    fn halves(word: usize) [2]i32 {
        const w: u64 = word;
        return .{ @bitCast(@as(u32, @truncate(w))), @bitCast(@as(u32, @truncate(w >> 32))) };
    }

    /// `Objects`, `PreAllocatedObjects`, `MaxElements` and `NumElements`, `MaxChunks` and `NumChunks`.
    fn chunkedAt(mem: *const Mem, w: *const [4]usize) ?usize {
        const max, const num = halves(w[2]);
        if (num <= 0 or num > max or max > max_objects) return null;
        const max_chunks, const num_chunks = halves(w[3]);
        if (max_chunks != @divFloor(max + chunk_len - 1, chunk_len)) return null;
        if (num_chunks < @divFloor(num + chunk_len - 1, chunk_len) or num_chunks > max_chunks) return null;
        const first = mem.ptr(w[0]) orelse return null;
        return strideOf(mem, first);
    }

    /// `Objects`, `MaxElements` and `NumElements`.
    fn fixedAt(mem: *const Mem, w: *const [2]usize) ?usize {
        const max, const num = halves(w[1]);
        if (num <= 0 or num > max or max > max_objects) return null;
        if (w[0] % 8 != 0) return null;
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
        const n = self.mem.read(i32, self.table + @as(usize, if (self.kind == .chunked) 0x14 else 0xC)) orelse return 0;
        return @intCast(@max(n, 0));
    }

    /// Null for a free slot.
    pub fn get(self: *const Objects, i: usize) ?usize {
        const items = switch (self.kind) {
            .chunked => blk: {
                const chunks = self.mem.ptr(self.table) orelse return null;
                break :blk (self.mem.ptr(chunks + (i / chunk_len) * 8) orelse return null) + (i % chunk_len) * self.stride;
            },
            .fixed => (self.mem.ptr(self.table) orelse return null) + i * self.stride,
        };
        return self.mem.ptr(items);
    }

    /// If `p` is a live object, by it being where its index says.
    pub fn isObject(self: *const Objects, p: usize) bool {
        const i = self.mem.read(i32, p + object.index) orelse return false;
        if (i < 0) return false;
        return self.get(@intCast(i)) == p;
    }

    /// Like `get` with plain reads, 0 for a free slot. Game thread only, where every object in the
    /// array is alive, and quick enough to go through all of them.
    pub fn getPlain(self: *const Objects, i: usize) usize {
        const item = switch (self.kind) {
            .chunked => blk: {
                const chunks = plain(self.table);
                if (chunks == 0) return 0;
                const chunk = plain(chunks + (i / chunk_len) * 8);
                if (chunk == 0) return 0;
                break :blk chunk + (i % chunk_len) * self.stride;
            },
            .fixed => plain(self.table) + i * self.stride,
        };
        return plain(item);
    }

    fn plain(at: usize) usize {
        return @as(*align(1) const usize, @ptrFromInt(at)).*;
    }
};

const tests = struct {
    const Obj = extern struct {
        vtable: usize = 0,
        flags: i32 = 0,
        index: i32,
        class: usize = 0,
        name: u64 = 0,
        outer: usize = 0,
    };

    const Item = extern struct {
        object: usize,
        flags: i32 = 0,
        cluster: i32 = 0,
        serial: i32 = 0,
        pad: i32 = 0,
    };

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
        var data = [_]usize{ 1, 2, @intFromPtr(&chunks), 0, (@as(usize, 5) << 32) | 70000, (@as(usize, 1) << 32) | 2 };
        try mem.refresh();

        const objects = Objects.find(&mem, &data).?;
        try std.testing.expectEqual(.chunked, objects.kind);
        try std.testing.expectEqual(0x18, objects.stride);
        try std.testing.expectEqual(5, objects.count());
        try std.testing.expectEqual(@intFromPtr(&objs[4]), objects.get(4).?);
        try std.testing.expect(objects.isObject(@intFromPtr(&objs[2])));
        var stray: Obj = .{ .index = 2 };
        try std.testing.expect(!objects.isObject(@intFromPtr(&stray)));
    }

    test "fixed, with smaller items" {
        var mem = try Mem.init(std.testing.allocator);
        defer mem.deinit();
        var objs: [4]Obj = undefined;
        var items: [4][2]usize = undefined;
        for (&objs, &items, 0..) |*o, *it, i| {
            o.* = .{ .index = @intCast(i) };
            it.* = .{ @intFromPtr(o), 0 };
        }
        var data = [_]usize{ 9, @intFromPtr(&items), (@as(usize, 4) << 32) | 10 };
        try mem.refresh();

        const objects = Objects.find(&mem, &data).?;
        try std.testing.expectEqual(.fixed, objects.kind);
        try std.testing.expectEqual(0x10, objects.stride);
        try std.testing.expectEqual(@intFromPtr(&objs[3]), objects.get(3).?);
    }
};

test {
    _ = tests;
}
