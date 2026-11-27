//! The FFXIV tab's Sheets: every Excel sheet, and the picked one's rows in a table, with
//! EXDSchema's column names where they still fit. It all runs on the Workbench's thread, which never
//! touches the game, reading the game's files a few milliseconds a frame.

const std = @import("std");
const sdk = @import("wraith_sdk");
const sqpack = @import("sqpack");
const excel = @import("excel");
const ffxiv_sheets = @import("sheets");

const ui = sdk.ui;
const gpa = std.heap.smp_allocator;

/// Reading rows stops for the frame after this long
const budget_ns = 6 * std.time.ns_per_ms;
/// ImGui's most a table, less the id
const max_columns = 511;
/// Unscaled. Strings start this wide, as some are paragraphs.
const string_width = 220;

const languages = [_]excel.Language{ .english, .japanese, .german, .french, .chinese_simplified, .korean, .chinese_traditional };
const language_names = [_][:0]const u8{ "English", "Japanese", "German", "French", "Chinese (Simplified)", "Korean", "Chinese (Traditional)" };

pub const Explorer = struct {
    pack: *const sqpack.Pack = undefined,
    io: std.Io = undefined,
    /// Set once `pack` is.
    ready: std.atomic.Value(bool) = .init(false),

    // The Workbench's thread from here down

    list: ?excel.List = null,
    language: usize = 0,
    split: ui.Split = .{ .ratio = 0.25 },
    filter: [64]u8 = @splat(0),
    filter_for: [64]u8 = @splat(0),
    /// Into `list.by_name`, the ones `filter` lets through.
    matches: std.ArrayList(u32) = .empty,
    matches_stale: bool = true,

    /// The picked one, and its name for messages if it wouldn't open.
    sheet: ?excel.Sheet = null,
    name_buf: [sqpack.Path.max_len]u8 = undefined,
    name_len: usize = 0,
    problem: ?anyerror = null,
    /// EXDSchema's, if they're for the columns it has.
    names: ?[]const []const u8 = null,
    reading: ?excel.Sheet.Iterator = null,
    rows: std.ArrayList(excel.Row) = .empty,
    find: [64]u8 = @splat(0),
    find_for: [64]u8 = @splat(0),
    /// Into `rows`, the ones `find` matches, out of the first `checked`.
    found: std.ArrayList(u32) = .empty,
    checked: usize = 0,
    /// Into `rows`.
    picked: ?u32 = null,

    /// `pack` has to outlive it.
    pub fn start(self: *Explorer, pack: *const sqpack.Pack, io: std.Io) void {
        self.pack = pack;
        self.io = io;
        self.ready.store(true, .release);
    }

    /// Once nothing's drawing it.
    pub fn stop(self: *Explorer) void {
        self.ready.store(false, .release);
        self.closeSheet();
        if (self.list) |*l| l.deinit(gpa);
        self.list = null;
        self.matches.deinit(gpa);
        self.rows.deinit(gpa);
        self.found.deinit(gpa);
    }

    pub fn draw(self: *Explorer) void {
        if (!self.ready.load(.acquire)) return ui.textDisabled("Opening the game's files...", .{});
        if (self.list == null) {
            const text = self.pack.read(self.io, gpa, "exd/root.exl") catch |err| return ui.textDisabled("Can't read the list of sheets: {t}", .{err});
            self.list = excel.List.parse(gpa, text) catch |err| {
                gpa.free(text);
                return ui.textDisabled("Can't read the list of sheets: {t}", .{err});
            };
        }
        if (self.split.first("sheets")) |part| {
            defer part.end();
            self.drawList();
        }
        if (self.split.second("rows")) |part| {
            defer part.end();
            self.drawSheet();
        }
    }

    fn drawList(self: *Explorer) void {
        const list = &self.list.?;
        ui.setNextItemWidth(ui.fill);
        var language = self.language;
        if (ui.combo("##language", &language, &language_names) and language != self.language) {
            self.language = language;
            if (self.name_len > 0) self.open(self.name_buf[0..self.name_len]);
        }
        ui.setNextItemWidth(ui.fill);
        _ = ui.inputTextHint("##filter", "Filter by name", &self.filter);
        if (!std.mem.eql(u8, &self.filter, &self.filter_for)) {
            self.filter_for = self.filter;
            self.matches_stale = true;
        }
        if (self.matches_stale) {
            self.matches_stale = false;
            self.matches.clearRetainingCapacity();
            const text = trimmed(&self.filter);
            for (list.by_name, 0..) |e, i| {
                if (text.len == 0 or std.ascii.findIgnoreCase(e.name, text) != null) self.matches.append(gpa, @intCast(i)) catch break;
            }
        }
        if (ui.child("names", .{ 0, 0 }, .{})) |names| {
            defer names.end();
            if (self.matches.items.len == 0) ui.textDisabled("Nothing's called that.", .{});
            const current = self.name_buf[0..self.name_len];
            var clip = ui.clip(self.matches.items.len);
            while (clip.next()) |i| {
                const name = list.by_name[self.matches.items[i]].name;
                const picked = std.mem.eql(u8, name, current);
                if (ui.selectable(ui.format("{s}###{s}", .{ name, name }), picked) and !picked) self.open(name);
            }
        }
    }

    /// Opens `name` in the chosen language, in place of what's open.
    fn open(self: *Explorer, name: []const u8) void {
        // `name` can be the old one's, so it's copied before that goes
        const len = @min(name.len, self.name_buf.len);
        @memmove(self.name_buf[0..len], name[0..len]);
        self.name_len = len;
        self.closeSheet();
        self.problem = null;
        self.sheet = excel.Sheet.open(self.io, gpa, self.pack, self.name_buf[0..len], languages[self.language]) catch |err| {
            self.problem = err;
            return;
        };
        const sheet = &self.sheet.?;
        self.reading = sheet.rows();
        if (ffxiv_sheets.namedFor(sheet.name)) |n| {
            if (n.columns_hash == sheet.header.columnsHash()) self.names = n.column_names;
        }
    }

    /// Rows point into it, so they go first.
    fn closeSheet(self: *Explorer) void {
        self.rows.clearRetainingCapacity();
        self.found.clearRetainingCapacity();
        self.checked = 0;
        self.picked = null;
        self.reading = null;
        self.names = null;
        if (self.sheet) |*s| s.close();
        self.sheet = null;
    }

    /// Till it's read them all or the frame's budget is spent.
    fn readSome(self: *Explorer) void {
        const it = if (self.reading) |*r| r else return;
        const began = std.Io.Clock.awake.now(self.io);
        while (true) {
            const next = it.next(self.io) catch |err| {
                self.problem = err;
                self.reading = null;
                return;
            };
            const row = next orelse {
                self.reading = null;
                return;
            };
            self.rows.append(gpa, row) catch |err| {
                self.problem = err;
                self.reading = null;
                return;
            };
            if (self.rows.items.len % 64 == 0 and began.durationTo(std.Io.Clock.awake.now(self.io)).nanoseconds > budget_ns) return;
        }
    }

    fn drawSheet(self: *Explorer) void {
        const sheet = if (self.sheet) |*s| s else {
            if (self.problem) |err| return ui.textDisabled("Can't open {s}: {t}", .{ self.name_buf[0..self.name_len], err });
            return ui.textDisabled("Pick a sheet to see its rows.", .{});
        };
        self.readSome();
        const h = &sheet.header;
        ui.text("{s}", .{sheet.name});
        ui.sameLine();
        ui.textDisabled("{d} {s}, {d} columns, {s}", .{ self.rows.items.len, if (h.kind == .subrows) "subrows" else "rows", h.columns.len, languageName(sheet.language) });
        if (self.reading != null) {
            ui.sameLine();
            ui.textDisabled("Reading...", .{});
        }
        if (self.problem) |err| {
            ui.sameLine();
            ui.textDisabled("Stopped reading: {t}", .{err});
        }
        if (self.names == null) {
            ui.sameLine();
            ui.textDisabled("{s}", .{if (ffxiv_sheets.namedFor(sheet.name) != null) "(EXDSchema's names are for other columns)" else "(No names from EXDSchema)"});
        }

        ui.setNextItemWidth(260);
        _ = ui.inputTextHint("##find", "Find by id or text", &self.find);
        if (!std.mem.eql(u8, &self.find, &self.find_for)) {
            self.find_for = self.find;
            self.found.clearRetainingCapacity();
            self.checked = 0;
        }
        const text = trimmed(&self.find);
        if (text.len > 0) self.findMore(text);
        const count = if (text.len > 0) self.found.items.len else self.rows.items.len;

        const shown_columns = @min(h.columns.len, max_columns);
        if (ui.table("rows", @intCast(shown_columns + 1), .{ .borders = true, .row_background = true, .resizable = true, .scroll_x = true, .scroll_y = true, .frozen_columns = 1 })) |table| {
            ui.tableColumnWith("ID", .{ .fixed = true });
            for (h.columns[0..shown_columns], 0..) |c, i| {
                const label = if (self.names) |n| ui.format("{d} {s}", .{ i, n[i] }) else ui.format("{d} {s}", .{ i, typeName(c.type) });
                ui.tableColumnWith(label, .{ .fixed = true, .width = if (c.type == .string) string_width else 0 });
            }
            ui.tableHeaders();
            var clip = ui.clip(count);
            while (clip.next()) |i| {
                const index: u32 = if (text.len > 0) self.found.items[i] else @intCast(i);
                const row = self.rows.items[index];
                ui.tableNextRow();
                _ = ui.tableNextColumn();
                const label = if (h.kind == .subrows) ui.format("{d}.{d}###{d}", .{ row.id, row.subrow, index }) else ui.format("{d}###{d}", .{ row.id, index });
                if (ui.selectableWith(label, self.picked == index, .{ .span_columns = true })) self.picked = index;
                for (0..shown_columns) |c| if (ui.tableNextColumn()) drawCell(row, c);
            }
            table.end();
        }
        self.commands(text.len > 0);
    }

    /// Looks through what's been read since it last did.
    fn findMore(self: *Explorer, text: []const u8) void {
        const id = std.fmt.parseInt(u32, text, 10) catch null;
        for (self.rows.items[self.checked..], self.checked..) |row, i| {
            if (matches(row, text, id)) self.found.append(gpa, @intCast(i)) catch break;
            self.checked = i + 1;
        }
    }

    fn commands(self: *Explorer, finding: bool) void {
        var menu = ui.commands("rows", .{});
        defer menu.end();
        if (menu.item(.{ .label = "Copy row", .chord = ui.copy_chord, .enabled = self.picked != null, .tooltip = "A line per column: its index, name and value" })) self.copyRow(self.rows.items[self.picked.?]);
        if (menu.item(.{ .label = "Copy every row shown", .tooltip = "Tab-separated with the columns first, to paste into a spreadsheet" })) self.copyShown(finding);
    }

    fn copyRow(self: *Explorer, row: excel.Row) void {
        var out: std.Io.Writer.Allocating = .init(gpa);
        defer out.deinit();
        const w = &out.writer;
        for (row.header.columns, 0..) |c, i| {
            const name = if (self.names) |n| n[i] else typeName(c.type);
            w.print("{d}\t{s}\t{f}\n", .{ i, name, Cell{ .row = row, .column = i } }) catch return;
        }
        setClipboard(&out);
    }

    fn copyShown(self: *Explorer, finding: bool) void {
        var out: std.Io.Writer.Allocating = .init(gpa);
        defer out.deinit();
        const w = &out.writer;
        const h = &self.sheet.?.header;
        w.writeAll("ID") catch return;
        for (h.columns, 0..) |c, i| w.print("\t{s}", .{if (self.names) |n| n[i] else typeName(c.type)}) catch return;
        w.writeByte('\n') catch return;
        const count = if (finding) self.found.items.len else self.rows.items.len;
        for (0..count) |i| {
            const row = self.rows.items[if (finding) self.found.items[i] else i];
            if (h.kind == .subrows) w.print("{d}.{d}", .{ row.id, row.subrow }) catch return else w.print("{d}", .{row.id}) catch return;
            for (0..h.columns.len) |c| w.print("\t{f}", .{Cell{ .row = row, .column = c }}) catch return;
            w.writeByte('\n') catch return;
        }
        setClipboard(&out);
    }
};

fn drawCell(row: excel.Row, column: usize) void {
    const value = row.column(column) catch return ui.textDisabled("?", .{});
    switch (value) {
        .string => |s| {
            if (s.len == 0) return;
            ui.text("{f}", .{Plain{ .s = s }});
            // Long ones are cut off by the column, so they're shown whole on hover
            if (s.len > 24 and ui.isItemHovered() and ui.raw("ImGui_BeginTooltip")()) {
                defer ui.raw("ImGui_EndTooltip")();
                ui.raw("ImGui_PushTextWrapPos")(ui.raw("ImGui_GetFontSize")() * 35);
                defer ui.raw("ImGui_PopTextWrapPos")();
                ui.text("{f}", .{Plain{ .s = s }});
            }
        },
        .bool => |b| if (b) ui.text("true", .{}) else ui.textDisabled("false", .{}),
        // Zeroes are most of most sheets, so they're dimmed
        inline else => |n| if (n == 0) ui.textDisabled("0", .{}) else ui.text("{d}", .{n}),
    }
}

fn matches(row: excel.Row, text: []const u8, id: ?u32) bool {
    if (id) |n| if (n == row.id) return true;
    for (row.header.columns) |c| {
        if (c.type != .string) continue;
        const s = row.string(c.offset) catch continue;
        if (std.ascii.findIgnoreCase(s, text) != null) return true;
    }
    return false;
}

fn setClipboard(out: *std.Io.Writer.Allocating) void {
    out.writer.writeByte(0) catch return;
    const s = out.written();
    ui.setClipboard(s[0 .. s.len - 1 :0]);
}

fn trimmed(buf: []const u8) []const u8 {
    return std.mem.trim(u8, std.mem.sliceTo(buf, 0), " \t");
}

fn typeName(t: excel.Header.ColumnType) []const u8 {
    return std.enums.tagName(excel.Header.ColumnType, t) orelse "?";
}

fn languageName(l: excel.Language) []const u8 {
    for (languages, language_names) |each, name| if (each == l) return name;
    return if (l == .none) "not translated" else "?";
}

/// A column's value as text, for copying.
const Cell = struct {
    row: excel.Row,
    column: usize,

    pub fn format(self: Cell, w: *std.Io.Writer) std.Io.Writer.Error!void {
        const value = self.row.column(self.column) catch return w.writeAll("?");
        switch (value) {
            .string => |s| try w.print("{f}", .{Plain{ .s = s }}),
            .bool => |b| try w.writeAll(if (b) "true" else "false"),
            inline else => |n| try w.print("{d}", .{n}),
        }
    }
};

/// An SeString as one line of text. Its payloads, which start with 2 and end with 3, are
/// shown as `<kind>` in hex, but for the line break and hyphens.
const Plain = struct {
    s: []const u8,

    pub fn format(self: Plain, w: *std.Io.Writer) std.Io.Writer.Error!void {
        var i: usize = 0;
        while (i < self.s.len) {
            const c = self.s[i];
            if (c == 0x02) if (payload(self.s[i..])) |p| {
                switch (p.kind) {
                    0x10, 0x1D => try w.writeByte(' '),
                    0x16 => {},
                    0x1F => try w.writeByte('-'),
                    else => try w.print("<{x:0>2}>", .{p.kind}),
                }
                i += p.len;
                continue;
            };
            try w.writeByte(if (c < 0x20) ' ' else c);
            i += 1;
        }
    }

    const Payload = struct { kind: u8, len: usize };

    /// Its kind, then its length as an SeString int, then that much, then 3.
    fn payload(s: []const u8) ?Payload {
        if (s.len < 3) return null;
        const n = int(s[2..]) orelse return null;
        const end = std.math.add(usize, 2 + n.used, n.value) catch return null;
        if (end >= s.len or s[end] != 0x03) return null;
        return .{ .kind = s[1], .len = end + 1 };
    }

    /// Small ones are a byte, one more than them. Bigger ones are 0xF0 and up, whose low bits
    /// plus one say which of the next four bytes are there, big end first.
    fn int(s: []const u8) ?struct { value: usize, used: usize } {
        const b = s[0];
        if (b > 0 and b < 0xD0) return .{ .value = b - 1, .used = 1 };
        if (b < 0xF0 or b == 0xFF) return null;
        const flags = b + 1;
        var value: usize = 0;
        var used: usize = 1;
        var bit: u3 = 4;
        while (bit > 0) {
            bit -= 1;
            value <<= 8;
            if (flags & (@as(u8, 1) << bit) == 0) continue;
            if (used >= s.len) return null;
            value |= s[used];
            used += 1;
        }
        return .{ .value = value, .used = used };
    }
};

test "SeStrings as plain text" {
    const t = std.testing;
    var buf: [64]u8 = undefined;
    // A line break, an unknown payload with a two byte length, and a stray control
    const s = "a\x02\x10\x01\x03b\x02\x48\xF2\x00\x02xy\x03c\x01";
    try t.expectEqualStrings("a b<48>c ", try std.fmt.bufPrint(&buf, "{f}", .{Plain{ .s = s }}));
    // Cut short, so its bytes are shown as text
    try t.expectEqualStrings("a   b", try std.fmt.bufPrint(&buf, "{f}", .{Plain{ .s = "a\x02\x10\x05b" }}));
}
