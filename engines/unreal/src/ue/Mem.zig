//! Reads the game's memory without crashing on bad pointers. A snapshot of the readable pages
//! answers "is this a pointer" without asking Windows each time, and reads still go through a safe
//! copy, since memory can go away after the snapshot.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Mem = @This();

const memory: sdk.mem.Memory = .local;

allocator: std.mem.Allocator,
ranges: std.ArrayList(Range) = .empty,

const Range = struct { start: usize, end: usize };

/// Lowest and highest addresses user code gets on x64 Windows.
const lowest = 0x10000;
const highest = 0x7FFF_FFFF_FFFF;

pub fn init(allocator: std.mem.Allocator) !Mem {
    var self: Mem = .{ .allocator = allocator };
    try self.refresh();
    return self;
}

pub fn deinit(self: *Mem) void {
    self.ranges.deinit(self.allocator);
}

/// Takes the snapshot again, for memory the game's made since.
pub fn refresh(self: *Mem) !void {
    self.ranges.clearRetainingCapacity();
    var at: usize = lowest;
    while (memory.regionFrom(at)) |r| {
        const end = r.start + r.len;
        if (r.readable) {
            // Neighbours merge, which keeps lookups short
            if (self.ranges.items.len > 0 and self.ranges.items[self.ranges.items.len - 1].end == r.start) {
                self.ranges.items[self.ranges.items.len - 1].end = end;
            } else try self.ranges.append(self.allocator, .{ .start = r.start, .end = end });
        }
        if (end <= at) break;
        at = end;
    }
}

pub fn readable(self: *const Mem, address: usize, len: usize) bool {
    if (address < lowest or address > highest) return false;
    const items = self.ranges.items;
    // The last range starting at or before it
    var lo: usize = 0;
    var hi: usize = items.len;
    while (lo < hi) {
        const mid = (lo + hi) / 2;
        if (items[mid].start <= address) lo = mid + 1 else hi = mid;
    }
    if (lo == 0) return false;
    return address + len <= items[lo - 1].end;
}

/// `readable`, or failing that Windows says so, for memory made since the snapshot. Costs a system
/// call when it's not in the snapshot, so scans check `readable` first.
pub fn readableNow(self: *const Mem, address: usize, len: usize) bool {
    if (self.readable(address, len)) return true;
    if (address < lowest or address > highest) return false;
    const r = memory.regionFrom(address) orelse return false;
    return r.start <= address and address + len <= r.start + r.len;
}

pub fn read(self: *const Mem, comptime T: type, address: usize) ?T {
    if (!self.readableNow(address, @sizeOf(T))) return null;
    var value: T = undefined;
    memory.readInRegion(address, std.mem.asBytes(&value)) catch return null;
    return value;
}

/// A non-null, aligned pointer to somewhere readable.
pub fn ptr(self: *const Mem, address: usize) ?usize {
    const p = self.read(usize, address) orelse return null;
    if (p % 8 != 0 or !self.readableNow(p, 8)) return null;
    return p;
}

pub fn bytes(self: *const Mem, address: usize, out: []u8) bool {
    if (!self.readableNow(address, out.len)) return false;
    memory.readInRegion(address, out) catch return false;
    return true;
}

/// Plain values in objects the game's using, like a float in its world settings. Ignores page
/// protection, like every write through `sdk.mem`.
pub fn write(self: *const Mem, comptime T: type, address: usize, value: T) bool {
    if (!self.readableNow(address, @sizeOf(T))) return false;
    memory.store(T, address, value) catch return false;
    return true;
}

/// Game thread only, in an object the game's using right now, so it's there. No checks, where
/// `read` asks Windows about anything newer than the snapshot and copies through it too, which is
/// far too slow for every mesh every frame.
pub fn live(_: *const Mem, comptime T: type, address: usize) T {
    return @as(*align(1) const T, @ptrFromInt(address)).*;
}

/// The same for writing a plain value, without `write`'s change of page protection.
pub fn setLive(_: *const Mem, comptime T: type, address: usize, value: T) void {
    @as(*align(1) T, @ptrFromInt(address)).* = value;
}

test "pointers into our own memory" {
    var mem = try Mem.init(std.testing.allocator);
    defer mem.deinit();
    var target: u64 = 42;
    var holder: usize = @intFromPtr(&target);
    try std.testing.expectEqual(42, mem.read(u64, @intFromPtr(&target)).?);
    try std.testing.expectEqual(@intFromPtr(&target), mem.ptr(@intFromPtr(&holder)).?);
    holder = 0x1234;
    try std.testing.expectEqual(null, mem.ptr(@intFromPtr(&holder)));
    try std.testing.expect(!mem.readable(0, 8));
    // The exe's own data, high up
    try std.testing.expect(mem.readable(@intFromPtr(&global), 8));

    // Made after the snapshot
    const later = try std.testing.allocator.alloc(u64, 1 << 16);
    defer std.testing.allocator.free(later);
    later[0] = 9;
    try std.testing.expectEqual(9, mem.read(u64, @intFromPtr(later.ptr)).?);
    try std.testing.expect(mem.write(u64, @intFromPtr(later.ptr), 10));
    try std.testing.expectEqual(10, later[0]);
}

var global: u64 = 7;
