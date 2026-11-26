//! The base of the sheets in `src/sheets`, which are made from EXDSchema: a sheet whose rows are `T`,
//! a struct of its row with a function per column. `T` has its `sheet_name`, `kind` and the
//! `columns_hash` it was made for.

const std = @import("std");

const Header = @import("Header.zig");
const Row = @import("Row.zig");
const Sheet = @import("Sheet.zig");
const Sheets = @import("Sheets.zig");

pub fn Typed(comptime T: type) type {
    return struct {
        const Self = @This();

        sheet: *const Sheet,

        /// Fails with `error.SheetChanged` if a patch changed its columns since `T` was made. Its
        /// raw `Sheet` still reads, with columns by index.
        pub fn open(sheets: *Sheets, io: std.Io) !Self {
            const sheet = try sheets.get(io, T.sheet_name);
            if (sheet.header.kind != T.kind or sheet.header.columnsHash() != T.columns_hash) return error.SheetChanged;
            return .{ .sheet = sheet };
        }

        /// For a sheet of subrows, its first.
        pub fn row(self: Self, io: std.Io, id: u32) !?T {
            return wrap(try self.sheet.row(io, id));
        }

        pub fn subrow(self: Self, io: std.Io, id: u32, sub: u16) !?T {
            return wrap(try self.sheet.subrow(io, id, sub));
        }

        pub fn subrowCount(self: Self, io: std.Io, id: u32) !?u16 {
            return self.sheet.subrowCount(io, id);
        }

        /// Every row, and every subrow in a sheet of them, in id order.
        pub fn rows(self: Self) Iterator {
            return .{ .inner = self.sheet.rows() };
        }

        pub const Iterator = struct {
            inner: Sheet.Iterator,

            pub fn next(self: *Iterator, io: std.Io) !?T {
                return wrap(try self.inner.next(io));
            }
        };

        fn wrap(r: ?Row) error{Corrupt}!?T {
            const got = r orelse return null;
            if (!got.fits()) return error.Corrupt;
            return .{ .row = got };
        }
    };
}

/// A column holding the id of a row in another sheet.
pub fn Link(comptime T: type) type {
    return struct {
        const Self = @This();

        id: u32,

        /// Negative ids go nowhere.
        pub fn of(value: anytype) Self {
            return .{ .id = std.math.cast(u32, value) orelse std.math.maxInt(u32) };
        }

        /// The row it points at, or null if there isn't one. Opens its sheet if it isn't yet.
        pub fn get(self: Self, sheets: *Sheets, io: std.Io) !?T {
            return (try Typed(T).open(sheets, io)).row(io, self.id);
        }
    };
}
