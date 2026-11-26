//! One sheet in one language. Its pages are read the first time a row in them is wanted, then kept,
//! so it's cheap to open. Pages never change once they're read, so any number of threads can read
//! rows at once, with nothing locked.

const Sheet = @This();

const std = @import("std");
const sqpack = @import("sqpack");

const Header = @import("Header.zig");
const Language = Header.Language;
const Row = @import("Row.zig");

gpa: std.mem.Allocator,
pack: *const sqpack.Pack,
/// As it was opened with, like `Item` or `quest/000/ClsHrv001_00003`.
name: []const u8,
header: Header,
/// What was asked for, or `none` if the sheet isn't translated.
language: Language,
/// One per `header.pages`, null till it's read.
pages: []std.atomic.Value(?*Page),

const Page = struct {
    bytes: []u8,
    /// By row id, which are big endian.
    entries: []align(1) const Entry,

    const Entry = extern struct {
        id: u32,
        offset: u32,
    };
};

/// `language` falls back to `none` for sheets that aren't translated, like the game does.
pub fn open(io: std.Io, gpa: std.mem.Allocator, pack: *const sqpack.Pack, name: []const u8, language: Language) !Sheet {
    var path_buf: [sqpack.Path.max_len]u8 = undefined;
    const path = std.fmt.bufPrint(&path_buf, "exd/{s}.exh", .{name}) catch return error.PathTooLong;
    const bytes = try pack.read(io, gpa, path);
    defer gpa.free(bytes);
    var header: Header = try .parse(gpa, bytes);
    errdefer header.deinit(gpa);

    const chosen: Language = if (header.has(language)) language else if (header.has(.none)) .none else return error.NoLanguage;
    if (chosen.suffix() == null) return error.NoLanguage;
    const owned_name = try gpa.dupe(u8, name);
    errdefer gpa.free(owned_name);
    const pages = try gpa.alloc(std.atomic.Value(?*Page), header.pages.len);
    @memset(pages, .init(null));
    return .{ .gpa = gpa, .pack = pack, .name = owned_name, .header = header, .language = chosen, .pages = pages };
}

pub fn close(self: *Sheet) void {
    for (self.pages) |*slot| if (slot.load(.acquire)) |p| freePage(self.gpa, p);
    self.gpa.free(self.pages);
    self.gpa.free(self.name);
    self.header.deinit(self.gpa);
    self.* = undefined;
}

/// The row with this id, or null if there isn't one. For a sheet of subrows it's the first one.
pub fn row(self: *const Sheet, io: std.Io, id: u32) !?Row {
    return self.subrow(io, id, 0);
}

pub fn subrow(self: *const Sheet, io: std.Io, id: u32, sub: u16) !?Row {
    const page = try self.pageOf(io, id) orelse return null;
    const entry = find(page, id) orelse return null;
    return try self.rowAt(page.page, entry, sub);
}

/// How many subrows a row has, 1 for plain rows, or null if there's no such row.
pub fn subrowCount(self: *const Sheet, io: std.Io, id: u32) !?u16 {
    const page = try self.pageOf(io, id) orelse return null;
    const entry = find(page, id) orelse return null;
    return (try block(page.page, entry)).count;
}

/// Every row, and every subrow in a sheet of them, in id order.
pub fn rows(self: *const Sheet) Iterator {
    return .{ .sheet = self };
}

pub const Iterator = struct {
    sheet: *const Sheet,
    page: usize = 0,
    entry: usize = 0,
    sub: u16 = 0,

    pub fn next(self: *Iterator, io: std.Io) !?Row {
        const s = self.sheet;
        while (self.page < s.pages.len) {
            const page = try s.loadPage(io, self.page);
            if (self.entry >= page.entries.len) {
                self.page += 1;
                self.entry = 0;
                continue;
            }
            const entry = swap(page.entries[self.entry]);
            const count = (try block(page, entry)).count;
            if (self.sub >= count) {
                self.entry += 1;
                self.sub = 0;
                continue;
            }
            const r = try s.rowAt(page, entry, self.sub);
            self.sub += 1;
            return r;
        }
        return null;
    }
};

const Found = struct { page: *const Page, start: u32 };

/// Its pages are in id order, so it's a binary search.
fn pageOf(self: *const Sheet, io: std.Io, id: u32) !?Found {
    const index = std.sort.binarySearch(Header.Page, self.header.pages, id, struct {
        fn order(key: u32, p: Header.Page) std.math.Order {
            if (key < p.start) return .lt;
            if (key - p.start >= p.count) return .gt;
            return .eq;
        }
    }.order) orelse return null;
    return .{ .page = try self.loadPage(io, index), .start = self.header.pages[index].start };
}

/// Ids usually go up by one from the page's first, so that's tried before a search.
fn find(found: Found, id: u32) ?Page.Entry {
    const entries = found.page.entries;
    const nth = id - found.start;
    if (nth < entries.len) {
        const e = swap(entries[nth]);
        if (e.id == id) return e;
    }
    var lo: usize = 0;
    var hi: usize = entries.len;
    while (lo < hi) {
        const mid = lo + (hi - lo) / 2;
        const e = swap(entries[mid]);
        if (e.id < id) lo = mid + 1 else if (e.id > id) hi = mid else return e;
    }
    return null;
}

fn swap(e: Page.Entry) Page.Entry {
    return .{ .id = std.mem.bigToNative(u32, e.id), .offset = std.mem.bigToNative(u32, e.offset) };
}

/// A row's bytes start with their size and how many subrows there are.
const Block = struct { bytes: []const u8, count: u16 };

fn block(page: *const Page, entry: Page.Entry) error{Corrupt}!Block {
    const at: usize = entry.offset;
    if (at > page.bytes.len or page.bytes.len - at < 6) return error.Corrupt;
    const size = std.mem.readInt(u32, page.bytes[at..][0..4], .big);
    const count = std.mem.readInt(u16, page.bytes[at + 4 ..][0..2], .big);
    if (page.bytes.len - at - 6 < size) return error.Corrupt;
    return .{ .bytes = page.bytes[at + 6 ..][0..size], .count = count };
}

fn rowAt(self: *const Sheet, page: *const Page, entry: Page.Entry, sub: u16) error{Corrupt}!?Row {
    const b = try block(page, entry);
    if (sub >= b.count) return null;
    // Each subrow is its u16 id, then its columns, and the strings come after them all
    const stride = @as(usize, self.header.row_size) + 2;
    const base: usize, const strings: usize = switch (self.header.kind) {
        .subrows => .{ @as(usize, sub) * stride + 2, @as(usize, b.count) * stride },
        else => if (sub == 0) .{ 0, self.header.row_size } else return null,
    };
    return .{ .header = &self.header, .id = entry.id, .subrow = sub, .bytes = b.bytes, .base = base, .strings = strings };
}

/// Read once. If two threads race to read it, the one that loses frees its copy.
fn loadPage(self: *const Sheet, io: std.Io, index: usize) !*const Page {
    const slot = &self.pages[index];
    if (slot.load(.acquire)) |p| return p;
    const p = try self.readPage(io, index);
    if (slot.cmpxchgStrong(null, p, .acq_rel, .acquire)) |won| {
        freePage(self.gpa, p);
        return won.?;
    }
    return p;
}

fn readPage(self: *const Sheet, io: std.Io, index: usize) !*Page {
    var path_buf: [sqpack.Path.max_len]u8 = undefined;
    const start = self.header.pages[index].start;
    const path = std.fmt.bufPrint(&path_buf, "exd/{s}_{d}{s}.exd", .{ self.name, start, self.language.suffix().? }) catch return error.PathTooLong;
    const bytes = try self.pack.read(io, self.gpa, path);
    errdefer self.gpa.free(bytes);

    // EXDF, a version, then how big the index after the 32 byte header is
    if (bytes.len < 32 or !std.mem.eql(u8, bytes[0..4], "EXDF")) return error.Corrupt;
    const index_size = std.mem.readInt(u32, bytes[8..12], .big);
    if (bytes.len - 32 < index_size) return error.Corrupt;
    const page = try self.gpa.create(Page);
    page.* = .{ .bytes = bytes, .entries = std.mem.bytesAsSlice(Page.Entry, bytes[32..][0 .. index_size - index_size % @sizeOf(Page.Entry)]) };
    return page;
}

fn freePage(gpa: std.mem.Allocator, page: *Page) void {
    gpa.free(page.bytes);
    gpa.destroy(page);
}
