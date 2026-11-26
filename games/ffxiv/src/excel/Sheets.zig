//! Every sheet by name, each opened the first time it's wanted and kept till `close`. Safe to use
//! from any number of threads.

const Sheets = @This();

const std = @import("std");
const sqpack = @import("sqpack");

const Language = @import("Header.zig").Language;
const List = @import("List.zig");
const Sheet = @import("Sheet.zig");
const Typed = @import("typed.zig").Typed;

gpa: std.mem.Allocator,
pack: *const sqpack.Pack,
language: Language,
list: List,
lock: std.Io.Mutex = .init,
/// By their names as the list has them.
open_sheets: std.StringHashMapUnmanaged(*Sheet) = .empty,

/// Reads the list of sheets, from `exd/root.exl`. `pack` has to outlive it.
pub fn open(io: std.Io, gpa: std.mem.Allocator, pack: *const sqpack.Pack, language: Language) !Sheets {
    const text = try pack.read(io, gpa, "exd/root.exl");
    errdefer gpa.free(text);
    return .{ .gpa = gpa, .pack = pack, .language = language, .list = try .parse(gpa, text) };
}

pub fn close(self: *Sheets) void {
    var it = self.open_sheets.valueIterator();
    while (it.next()) |s| {
        s.*.close();
        self.gpa.destroy(s.*);
    }
    self.open_sheets.deinit(self.gpa);
    self.list.deinit(self.gpa);
    self.* = undefined;
}

/// By name, ignoring case, like `item` or `quest/000/ClsHrv001_00003`.
pub fn get(self: *Sheets, io: std.Io, name: []const u8) !*Sheet {
    const entry = self.list.find(name) orelse return error.NoSheet;
    {
        try self.lock.lock(io);
        defer self.lock.unlock(io);
        if (self.open_sheets.get(entry.name)) |s| return s;
    }

    // Opened outside the lock, as it reads its header. If another thread got there first, its wins.
    const sheet = try self.gpa.create(Sheet);
    errdefer self.gpa.destroy(sheet);
    sheet.* = try .open(io, self.gpa, self.pack, entry.name, self.language);
    errdefer sheet.close();

    try self.lock.lock(io);
    defer self.lock.unlock(io);
    const slot = try self.open_sheets.getOrPut(self.gpa, entry.name);
    if (slot.found_existing) {
        sheet.close();
        self.gpa.destroy(sheet);
        return slot.value_ptr.*;
    }
    slot.value_ptr.* = sheet;
    return sheet;
}

/// One of `src/sheets`' typed sheets, like `sheets.typed(io, ffxiv_sheets.Item)`.
pub fn typed(self: *Sheets, io: std.Io, comptime T: type) !Typed(T) {
    return .open(self, io);
}
