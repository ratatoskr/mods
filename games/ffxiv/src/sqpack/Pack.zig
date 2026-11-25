//! FFXIV's game files, from the `sqpack` folder in its `game` folder. Opening it maps every index
//! and opens every dat, which is quick. Nothing changes after, so any number of threads can find and
//! read files at once, with nothing locked.

const Pack = @This();

const std = @import("std");

const Chunk = @import("Chunk.zig");
const Path = @import("Path.zig");
const Category = Path.Category;

/// By id, 0 for the base game and N for `exN`. One that isn't installed has no chunks.
repos: []Repo,

pub const Repo = struct {
    version_buf: [32]u8 = undefined,
    version_len: u8 = 0,
    chunks: std.EnumArray(Category, []Chunk) = .initFill(&.{}),

    /// Like `2026.11.03.0000.0000`, or empty if it has no `.ver`.
    pub fn version(self: *const Repo) []const u8 {
        return self.version_buf[0..self.version_len];
    }

    fn close(self: *Repo, io: std.Io, gpa: std.mem.Allocator) void {
        for (&self.chunks.values) |chunks| {
            for (chunks) |*c| c.close(io, gpa);
            gpa.free(chunks);
        }
        self.* = .{};
    }
};

/// A file that's been found, to read.
pub const Location = struct {
    chunk: *const Chunk,
    data: u32,

    /// Unpacked. Free it with `gpa`.
    pub fn read(self: Location, io: std.Io, gpa: std.mem.Allocator) ![]u8 {
        return self.chunk.read(io, gpa, self.data);
    }
};

/// `game_dir` is the `game` folder, where `ffxiv_dx11.exe` is.
pub fn open(io: std.Io, gpa: std.mem.Allocator, game_dir: []const u8) !Pack {
    var game = try std.Io.Dir.cwd().openDir(io, game_dir, .{});
    defer game.close(io);
    var sqpack = try game.openDir(io, "sqpack", .{ .iterate = true });
    defer sqpack.close(io);

    var last: ?u8 = null;
    var it = sqpack.iterate();
    while (try it.next(io)) |entry| {
        if (entry.kind != .directory) continue;
        const id = repoId(entry.name) orelse continue;
        last = @max(last orelse id, id);
    }
    const repos = try gpa.alloc(Repo, @as(usize, last orelse return error.NoRepos) + 1);
    @memset(repos, .{});
    var self: Pack = .{ .repos = repos };
    errdefer self.close(io, gpa);
    for (repos, 0..) |*repo, id| try openRepo(io, gpa, game, sqpack, @intCast(id), repo);
    return self;
}

pub fn close(self: *Pack, io: std.Io, gpa: std.mem.Allocator) void {
    for (self.repos) |*r| r.close(io, gpa);
    gpa.free(self.repos);
    self.* = undefined;
}

pub fn find(self: *const Pack, path: *const Path) ?Location {
    if (path.repo >= self.repos.len) return null;
    for (self.repos[path.repo].chunks.get(path.category)) |*c| {
        if (c.find(path)) |data| return .{ .chunk = c, .data = data };
    }
    return null;
}

/// The file at a path like `exd/root.exl`, unpacked. Free it with `gpa`.
pub fn read(self: *const Pack, io: std.Io, gpa: std.mem.Allocator, path: []const u8) ![]u8 {
    const parsed: Path = try .parse(path);
    const location = self.find(&parsed) orelse return error.FileNotFound;
    return location.read(io, gpa);
}

pub fn exists(self: *const Pack, path: []const u8) bool {
    const parsed = Path.parse(path) catch return false;
    return self.find(&parsed) != null;
}

/// `ffxiv` is 0, `exN` is N.
fn repoId(name: []const u8) ?u8 {
    if (std.mem.eql(u8, name, "ffxiv")) return 0;
    if (!std.mem.startsWith(u8, name, "ex")) return null;
    return std.fmt.parseInt(u8, name[2..], 10) catch null;
}

fn openRepo(io: std.Io, gpa: std.mem.Allocator, game: std.Io.Dir, sqpack: std.Io.Dir, id: u8, repo: *Repo) !void {
    var name_buf: [16]u8 = undefined;
    const name = if (id == 0) "ffxiv" else try std.fmt.bufPrint(&name_buf, "ex{d}", .{id});
    var dir = sqpack.openDir(io, name, .{ .iterate = true }) catch |err| switch (err) {
        error.FileNotFound => return,
        else => return err,
    };
    defer dir.close(io);
    errdefer repo.close(io, gpa);

    // The base game's is beside the exe, the rest are in their folders
    var ver_buf: [32]u8 = undefined;
    const ver_dir, const ver_name = if (id == 0) .{ game, "ffxivgame.ver" } else .{ dir, try std.fmt.bufPrint(&ver_buf, "{s}.ver", .{name}) };
    if (ver_dir.readFile(io, ver_name, &repo.version_buf)) |text| {
        repo.version_len = @intCast(std.mem.trimEnd(u8, text, &std.ascii.whitespace).len);
    } else |_| {}

    // Chunk numbers can skip some, so it's whichever indexes are there
    var found: std.ArrayList(u16) = .empty;
    defer found.deinit(gpa);
    var it = dir.iterate();
    while (try it.next(io)) |entry| {
        if (entry.kind != .file) continue;
        const name_of = parseIndexName(entry.name) orelse continue;
        if (name_of.repo != id) continue;
        const key = (@as(u16, @backingInt(name_of.category)) << 8) | name_of.chunk;
        if (std.mem.indexOfScalar(u16, found.items, key) == null) try found.append(gpa, key);
    }
    std.mem.sort(u16, found.items, {}, std.sort.asc(u16));

    var rest = found.items;
    while (rest.len > 0) {
        const category: Category = @fromBackingInt(@intCast(rest[0] >> 8));
        var n: usize = 1;
        while (n < rest.len and rest[n] >> 8 == rest[0] >> 8) n += 1;
        const chunks = try gpa.alloc(Chunk, n);
        var opened: usize = 0;
        errdefer {
            for (chunks[0..opened]) |*c| c.close(io, gpa);
            gpa.free(chunks);
        }
        for (chunks, rest[0..n]) |*c, key| {
            var stem_buf: [16]u8 = undefined;
            const stem = try std.fmt.bufPrint(&stem_buf, "{x:0>2}{x:0>2}{x:0>2}.win32", .{ key >> 8, id, key & 0xFF });
            c.* = try .open(io, gpa, dir, @intCast(key & 0xFF), stem);
            opened += 1;
        }
        repo.chunks.set(category, chunks);
        rest = rest[n..];
    }
}

const IndexName = struct { category: Category, repo: u8, chunk: u8 };

/// `ccrrkk.win32.index` or `.index2`, in hex.
fn parseIndexName(name: []const u8) ?IndexName {
    const rest = if (name.len > 6) name[6..] else return null;
    if (!std.mem.eql(u8, rest, ".win32.index") and !std.mem.eql(u8, rest, ".win32.index2")) return null;
    const category = std.fmt.parseInt(u8, name[0..2], 16) catch return null;
    return .{
        .category = std.enums.fromInt(Category, category) orelse return null,
        .repo = std.fmt.parseInt(u8, name[2..4], 16) catch return null,
        .chunk = std.fmt.parseInt(u8, name[4..6], 16) catch return null,
    };
}

test "index names" {
    const t = std.testing;
    try t.expectEqual(IndexName{ .category = .chara, .repo = 6, .chunk = 2 }, parseIndexName("040602.win32.index").?);
    try t.expectEqual(IndexName{ .category = .exd, .repo = 0, .chunk = 0 }, parseIndexName("0a0000.win32.index2").?);
    try t.expectEqual(null, parseIndexName("040602.win32.dat0"));
    try t.expectEqual(null, parseIndexName("040602.ps5.index"));
    try t.expectEqual(null, parseIndexName("0d0000.win32.index"));
    try t.expectEqual(null, parseIndexName("ffxiv.ver"));
}
