//! A chunk's `.index` or `.index2`. They're mapped rather than read, so opening one costs next to
//! nothing and a lookup only touches the pages it needs. Entries are sorted by hash, so finding one
//! is a binary search, with no table to build.

const std = @import("std");
const File = std.Io.File;

const format = @import("format.zig");

pub const Index1 = Index(format.Entry1);
pub const Index2 = Index(format.Entry2);

pub fn Index(comptime Entry: type) type {
    return struct {
        const Self = @This();

        pub const Hash = @FieldType(Entry, "hash");

        file: File,
        map: File.MemoryMap,
        entries: []align(1) const Entry,
        synonyms: []align(1) const format.Synonym,
        /// How many `.datN` files its entries point into.
        dat_count: u32,

        pub fn open(io: std.Io, dir: std.Io.Dir, name: []const u8) !Self {
            const file = try dir.openFile(io, name, .{});
            errdefer file.close(io);
            const len = try file.length(io);
            var map = try file.createMemoryMap(io, .{
                .len = std.math.cast(usize, len) orelse return error.FileTooBig,
                .protection = .{ .read = true },
                .populate = false,
            });
            errdefer map.destroy(io);
            const bytes = map.memory;

            const header = try format.valueAt(format.Header, bytes, 0);
            if (!std.mem.eql(u8, &header.magic, format.Header.magic_value)) return error.NotSqPack;
            const index = try format.valueAt(format.IndexHeader, bytes, header.size);
            return .{
                .file = file,
                .map = map,
                .entries = try format.sliceAt(Entry, bytes, index.entries_offset, index.entries_size / @sizeOf(Entry)),
                .synonyms = try format.sliceAt(format.Synonym, bytes, index.synonyms_offset, index.synonyms_size / @sizeOf(format.Synonym)),
                .dat_count = index.dat_count,
            };
        }

        pub fn close(self: *Self, io: std.Io) void {
            self.map.destroy(io);
            self.file.close(io);
        }

        /// The entry's data, for `format.datOf` and `format.offsetOf`. `path` is only needed when
        /// hashes clash, and it's lowercase.
        pub fn find(self: *const Self, hash: Hash, path: []const u8) ?u32 {
            var lo: usize = 0;
            var hi: usize = self.entries.len;
            while (lo < hi) {
                const mid = lo + (hi - lo) / 2;
                const e = self.entries[mid];
                if (e.hash < hash) {
                    lo = mid + 1;
                } else if (e.hash > hash) {
                    hi = mid;
                } else {
                    return if (format.isSynonym(e.data)) self.findSynonym(hash, path) else e.data;
                }
            }
            return null;
        }

        fn findSynonym(self: *const Self, hash: Hash, path: []const u8) ?u32 {
            for (self.synonyms) |s| {
                if (s.hash == format.Synonym.end) break;
                if (s.hash != hash) continue;
                if (std.mem.eql(u8, std.mem.sliceTo(&s.path, 0), path)) return s.data;
            }
            return null;
        }
    };
}
