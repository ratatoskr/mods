//! Writes `src/sheets` from EXDSchema: a file per sheet, a struct of its row with a function per
//! column, and `root.zig` with them all. Its `.github/columns.yml` has every sheet's columns, so the
//! game isn't needed.
//!
//!     excel-sheets <EXDSchema folder> <out folder>
//!
//! Fields go with columns in order of offset, then bit for packed bools, the same as EXDTools.

const std = @import("std");

const yaml = @import("yaml.zig");
const Node = yaml.Node;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len != 3) {
        std.debug.print("usage: excel-sheets <EXDSchema folder> <out folder>\n", .{});
        std.process.exit(2);
    }
    var schema_dir = try std.Io.Dir.cwd().openDir(io, args[1], .{ .iterate = true });
    defer schema_dir.close(io);
    try std.Io.Dir.cwd().createDirPath(io, args[2]);
    var out_dir = try std.Io.Dir.cwd().openDir(io, args[2], .{ .iterate = true });
    defer out_dir.close(io);

    const columns_text = try schema_dir.readFileAlloc(io, ".github/columns.yml", arena, .limited(64 << 20));
    const columns = try readColumns(arena, try yaml.parse(arena, columns_text));

    // The sheets with both a schema and columns, by name
    var names: std.ArrayList([]const u8) = .empty;
    var it = schema_dir.iterate();
    while (try it.next(io)) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.name, ".yml")) continue;
        const name = entry.name[0 .. entry.name.len - 4];
        if (columns.get(name) == null) {
            std.debug.print("{s} has a schema but no columns, so it's left out\n", .{name});
            continue;
        }
        try names.append(arena, try arena.dupe(u8, name));
    }
    std.mem.sort([]const u8, names.items, {}, lessThan);
    var known: std.StringHashMapUnmanaged(void) = .empty;
    for (names.items) |n| try known.put(arena, n, {});

    // Everything in it is made here, so what's left from before goes
    var old = out_dir.iterate();
    var stale: std.ArrayList([]const u8) = .empty;
    while (try old.next(io)) |entry| {
        if (entry.kind == .file and std.mem.endsWith(u8, entry.name, ".zig")) try stale.append(arena, try arena.dupe(u8, entry.name));
    }
    for (stale.items) |name| try out_dir.deleteFile(io, name);

    var root: std.Io.Writer.Allocating = .init(arena);
    const r = &root.writer;
    try r.writeAll(
        \\//! Every sheet EXDSchema has a schema for, made by tools/excel-sheets from the commit of it in
        \\//! build.zig.zon, with `zig build excel-sheets`. Don't edit this or the files beside it.
        \\
        \\
    );
    for (names.items) |name| {
        const text = try schema_dir.readFileAlloc(io, try std.fmt.allocPrint(arena, "{s}.yml", .{name}), arena, .limited(16 << 20));
        const schema = yaml.parse(arena, text) catch |err| return fail(name, "its YAML", err);
        var gen: Gen = .{ .arena = arena, .sheet = name, .known = &known };
        const code = gen.sheetFile(schema, columns.get(name).?) catch |err| return fail(name, gen.problem, err);
        try out_dir.writeFile(io, .{ .sub_path = try std.fmt.allocPrint(arena, "{s}.zig", .{name}), .data = code });
        try r.print("pub const {f} = @import(\"{s}.zig\");\n", .{ std.zig.fmtId(name), name });
    }
    try r.writeAll("\n/// Every one of them, for tests.\npub const all = .{\n");
    for (names.items) |name| try r.print("    {f},\n", .{std.zig.fmtId(name)});
    try r.writeAll("};\n");
    try r.writeAll(
        \\
        \\/// A sheet's column names, for tools that read sheets raw.
        \\pub const Named = struct { name: []const u8, columns_hash: u32, column_names: []const []const u8 };
        \\
        \\/// Every one's, by name.
        \\pub const named = [_]Named{
        \\
    );
    for (names.items) |name| try r.print("    .{{ .name = \"{s}\", .columns_hash = {f}.columns_hash, .column_names = &{f}.column_names }},\n", .{ name, std.zig.fmtId(name), std.zig.fmtId(name) });
    try r.writeAll(
        \\};
        \\
        \\/// By its name exactly, like `Item`.
        \\pub fn namedFor(name: []const u8) ?*const Named {
        \\    const std = @import("std");
        \\    const i = std.sort.binarySearch(Named, &named, name, struct {
        \\        fn order(key: []const u8, n: Named) std.math.Order {
        \\            return std.mem.order(u8, key, n.name);
        \\        }
        \\    }.order) orelse return null;
        \\    return &named[i];
        \\}
        \\
    );
    try out_dir.writeFile(io, .{ .sub_path = "root.zig", .data = root.written() });
    std.debug.print("Wrote {d} sheets\n", .{names.items.len});
}

fn fail(sheet: []const u8, what: []const u8, err: anyerror) anyerror {
    std.debug.print("{s}: {s} ({t})\n", .{ sheet, what, err });
    return err;
}

fn lessThan(_: void, a: []const u8, b: []const u8) bool {
    return std.mem.lessThan(u8, a, b);
}

const ColumnType = enum(u16) {
    string = 0x0,
    bool = 0x1,
    int8 = 0x2,
    uint8 = 0x3,
    int16 = 0x4,
    uint16 = 0x5,
    int32 = 0x6,
    uint32 = 0x7,
    float32 = 0x9,
    int64 = 0xA,
    uint64 = 0xB,
    packedbool0 = 0x19,
    packedbool1 = 0x1A,
    packedbool2 = 0x1B,
    packedbool3 = 0x1C,
    packedbool4 = 0x1D,
    packedbool5 = 0x1E,
    packedbool6 = 0x1F,
    packedbool7 = 0x20,

    fn bit(self: ColumnType) ?u3 {
        const n = @backingInt(self);
        return if (n >= 0x19) @intCast(n - 0x19) else null;
    }

    fn zigType(self: ColumnType) []const u8 {
        return switch (self) {
            .string => "[]const u8",
            .bool => "bool",
            .int8 => "i8",
            .uint8 => "u8",
            .int16 => "i16",
            .uint16 => "u16",
            .int32 => "i32",
            .uint32 => "u32",
            .float32 => "f32",
            .int64 => "i64",
            .uint64 => "u64",
            else => "bool",
        };
    }

    fn isInt(self: ColumnType) bool {
        return switch (self) {
            .int8, .uint8, .int16, .uint16, .int32, .uint32, .int64, .uint64 => true,
            else => false,
        };
    }

    /// Packed bools are all one kind here, as an array's can be at different bits.
    fn same(a: ColumnType, b: ColumnType) bool {
        return a == b or (a.bit() != null and b.bit() != null);
    }
};

const Column = struct { type: ColumnType, offset: u16 };

const Columns = struct {
    subrows: bool,
    /// As the header has them, for the hash.
    header: []const Column,
    /// By offset then bit, which is the order fields are in.
    sorted: []const Column,
};

fn readColumns(arena: std.mem.Allocator, root: Node) !std.StringHashMapUnmanaged(Columns) {
    var out: std.StringHashMapUnmanaged(Columns) = .empty;
    if (root != .map) return error.BadColumns;
    for (root.map) |pair| {
        const subrows = std.mem.endsWith(u8, pair.key, "@Subrow");
        const name = if (subrows) pair.key[0 .. pair.key.len - 7] else pair.key;
        const list = Node.items(pair.value);
        const header = try arena.alloc(Column, list.len);
        for (list, header) |c, *col| col.* = .{
            .type = std.meta.stringToEnum(ColumnType, c.string("type") orelse return error.BadColumns) orelse return error.BadColumns,
            .offset = try std.fmt.parseInt(u16, c.string("offset") orelse return error.BadColumns, 10),
        };
        const sorted = try arena.dupe(Column, header);
        std.mem.sort(Column, sorted, {}, struct {
            fn less(_: void, a: Column, b: Column) bool {
                if (a.offset != b.offset) return a.offset < b.offset;
                return @backingInt(a.type) < @backingInt(b.type);
            }
        }.less);
        try out.put(arena, name, .{ .subrows = subrows, .header = header, .sorted = sorted });
    }
    return out;
}

/// The same hash the game's headers give, and `excel.Header.columnsHash`.
fn columnsHash(columns: []const Column) u32 {
    var crc: std.hash.crc.@"CRC-32/JAMCRC" = .init();
    for (columns) |c| {
        var buf: [4]u8 = undefined;
        std.mem.writeInt(u16, buf[0..2], @backingInt(c.type), .big);
        std.mem.writeInt(u16, buf[2..4], c.offset, .big);
        crc.update(&buf);
    }
    return crc.final();
}

/// How many columns a field takes.
fn columnCount(field: Node) !usize {
    if (!std.mem.eql(u8, field.string("type") orelse "scalar", "array")) return 1;
    const count = try countOf(field);
    const fields = Node.items(field.get("fields"));
    if (fields.len == 0) return count;
    var per: usize = 0;
    for (fields) |f| per += try columnCount(f);
    return per * count;
}

fn countOf(field: Node) !usize {
    return std.fmt.parseInt(usize, field.string("count") orelse return error.ArrayWithoutCount, 10);
}

/// One sheet's file.
const Gen = struct {
    arena: std.mem.Allocator,
    sheet: []const u8,
    known: *const std.StringHashMapUnmanaged(void),
    out: std.Io.Writer.Allocating = undefined,
    tables: std.Io.Writer.Allocating = undefined,
    table_count: usize = 0,
    /// Entry types, by name across the file.
    entries: Names = undefined,
    problem: []const u8 = "",

    fn sheetFile(self: *Gen, schema: Node, columns: Columns) ![]const u8 {
        self.out = .init(self.arena);
        self.tables = .init(self.arena);
        self.entries = .{ .arena = self.arena };
        try self.entries.reserve(self.sheet);
        const w = &self.out.writer;
        const fields = Node.items(schema.get("fields"));
        var total: usize = 0;
        for (fields) |f| total += try columnCount(f);
        if (total != columns.sorted.len) {
            self.problem = try std.fmt.allocPrint(self.arena, "its fields take {d} columns, but it has {d}", .{ total, columns.sorted.len });
            return error.ColumnCountMismatch;
        }

        try w.print("//! `{s}`, made from EXDSchema by tools/excel-sheets. Don't edit it.\n", .{self.sheet});
        if (schema.string("displayField")) |d| try w.print("//! Its column shown for a link to it is `{s}`.\n", .{d});
        try w.print(
            \\
            \\const std = @import("std");
            \\const excel = @import("excel");
            \\const sheets = @import("root.zig");
            \\
            \\const {f} = @This();
            \\
            \\pub const sheet_name = "{s}";
            \\pub const kind: excel.Header.Kind = .{s};
            \\pub const columns_hash: u32 = 0x{x:0>8};
            \\pub const Sheet = excel.Typed({f});
            \\
            \\row: excel.Row,
            \\
        , .{ std.zig.fmtId(self.sheet), self.sheet, if (columns.subrows) "subrows" else "rows", columnsHash(columns.header), std.zig.fmtId(self.sheet) });

        // EXDSchema's names go by offset, but the header's order is what readers index by
        var sorted_names: std.ArrayList([]const u8) = .empty;
        try columnNames(self.arena, &sorted_names, fields, "");
        try w.writeAll("\n/// Each column's name, in the header's order, like `Item[2].Count`.\npub const column_names = [_][]const u8{");
        for (columns.header, 0..) |h, i| {
            const j = for (columns.sorted, 0..) |c, j| {
                if (c.offset == h.offset and c.type == h.type) break j;
            } else unreachable;
            try w.print("{s}\"{f}\"", .{ if (i == 0) " " else ", ", std.zig.fmtString(sorted_names.items[j]) });
        }
        try w.writeAll(" };\n");

        const instance: []const Column = columns.sorted;
        try self.fieldsOf(w, fields, &.{}, &.{instance}, 0, self.sheet);
        if (self.tables.written().len != 0) {
            try w.writeAll("\n");
            try w.writeAll(self.tables.written());
        }
        return self.out.written();
    }

    /// `fields` of a struct, `dims` deep in arrays, with each of its `instances`' columns.
    fn fieldsOf(self: *Gen, w: *std.Io.Writer, fields: []const Node, dims: []const usize, instances: []const []const Column, indent: usize, self_type: []const u8) anyerror!void {
        var names: Names = .{ .arena = self.arena };
        try names.reserve(self_type);
        var pos: usize = 0;
        var unnamed: usize = 0;
        for (fields) |field| {
            const n = try columnCount(field);
            const parts = try self.arena.alloc([]const Column, instances.len);
            for (instances, parts) |inst, *p| p.* = inst[pos..][0..n];
            pos += n;

            // Arrays of one unnamed field are arrays of it, so they just take more indexes
            var own: std.ArrayList(usize) = .empty;
            var elem = field;
            var leaf = true;
            while (std.mem.eql(u8, elem.string("type") orelse "scalar", "array")) {
                try own.append(self.arena, try countOf(elem));
                const inner = Node.items(elem.get("fields"));
                if (inner.len == 0) {
                    elem = .{ .map = &.{} };
                    break;
                }
                if (inner.len == 1 and inner[0].string("name") == null) {
                    elem = inner[0];
                    continue;
                }
                leaf = false;
                break;
            }
            var split: usize = 1;
            for (own.items) |c| split *= c;
            const chunks = try self.arena.alloc([]const Column, parts.len * split);
            for (parts, 0..) |p, i| {
                const size = p.len / split;
                for (0..split) |j| chunks[i * split + j] = p[j * size ..][0..size];
            }
            const all_dims = try std.mem.concat(self.arena, usize, &.{ dims, own.items });

            const raw_name = field.string("name") orelse blk: {
                unnamed += 1;
                break :blk try std.fmt.allocPrint(self.arena, "Unnamed{d}", .{unnamed});
            };
            const fn_name = try names.take(try camel(self.arena, raw_name));
            try w.writeAll("\n");
            if (own.items.len != 0) try lenConst(w, indent, try names.take(try std.fmt.allocPrint(self.arena, "{s}_len", .{try snake(self.arena, fn_name)})), own.items);
            try docComment(w, indent, field.string("comment"));
            if (leaf) {
                try self.leafFn(w, fn_name, elem, dims.len, own.items, all_dims, chunks, indent);
            } else {
                // Unique in the whole file, so a nested one can't shadow another
                const want = try std.fmt.allocPrint(self.arena, "{s}Entry", .{try pascal(self.arena, raw_name)});
                const entry = try self.entries.take(want);
                try names.reserve(entry);
                try self.entryFn(w, fn_name, entry, elem, dims.len, own.items, all_dims, chunks, indent);
            }
        }
    }

    fn leafFn(self: *Gen, w: *std.Io.Writer, name: []const u8, field: Node, depth: usize, own: []const usize, all_dims: []const usize, chunks: []const []const Column, indent: usize) !void {
        const t = chunks[0][0].type;
        for (chunks) |c| if (c.len != 1 or !ColumnType.same(c[0].type, t)) {
            self.problem = try std.fmt.allocPrint(self.arena, "{s}'s columns aren't all the same type", .{name});
            return error.MixedArray;
        };
        const kind = field.string("type") orelse "scalar";

        // A link to one sheet that has a schema too gets that sheet's type
        var link_to: ?[]const u8 = null;
        const targets = Node.items(field.get("targets"));
        if (std.mem.eql(u8, kind, "link")) {
            try linkDoc(w, indent, field);
            if (targets.len == 1 and field.get("condition") == null and t.isInt() and self.known.contains(targets[0].scalar)) link_to = targets[0].scalar;
        } else if (std.mem.eql(u8, kind, "icon")) {
            try line(w, indent, "/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.");
        } else if (std.mem.eql(u8, kind, "modelId")) {
            try line(w, indent, "/// A model id, packed.");
        } else if (std.mem.eql(u8, kind, "color")) {
            try line(w, indent, "/// An RGB color, 0xRRGGBB.");
        }

        const ret = if (link_to) |s| try std.fmt.allocPrint(self.arena, "excel.Link(sheets.{f})", .{std.zig.fmtId(s)}) else t.zigType();
        try pad(w, indent);
        try w.print("pub fn {f}(self: @This()", .{std.zig.fmtId(name)});
        for (own, 0..) |_, i| try w.print(", n{d}: usize", .{depth + i});
        try w.print(") {s} {{\n", .{ret});

        // One offset, or a table of them by index
        const where = if (all_dims.len == 0)
            try std.fmt.allocPrint(self.arena, "{d}", .{encode(chunks[0][0])})
        else
            try self.table(all_dims, chunks, depth, own.len);
        const expr = if (t.bit()) |bit| (if (all_dims.len == 0)
            try std.fmt.allocPrint(self.arena, "self.row.bitAt({d}, {d})", .{ chunks[0][0].offset, bit })
        else
            try std.fmt.allocPrint(self.arena, "self.row.bitAt(@intCast({s} >> 3), @intCast({s} & 7))", .{ where, where })) else switch (t) {
            .string => try std.fmt.allocPrint(self.arena, "self.row.stringAt({s})", .{where}),
            .bool => try std.fmt.allocPrint(self.arena, "self.row.at(u8, {s}) != 0", .{where}),
            else => try std.fmt.allocPrint(self.arena, "self.row.at({s}, {s})", .{ t.zigType(), where }),
        };
        try pad(w, indent + 4);
        if (link_to != null) try w.print("return .of({s});\n", .{expr}) else try w.print("return {s};\n", .{expr});
        try pad(w, indent);
        try w.writeAll("}\n");
    }

    fn entryFn(self: *Gen, w: *std.Io.Writer, name: []const u8, entry: []const u8, field: Node, depth: usize, own: []const usize, all_dims: []const usize, chunks: []const []const Column, indent: usize) !void {
        try pad(w, indent);
        try w.print("pub fn {f}(self: @This()", .{std.zig.fmtId(name)});
        for (own, 0..) |_, i| try w.print(", n{d}: usize", .{depth + i});
        try w.print(") {f} {{\n", .{std.zig.fmtId(entry)});
        for (own, 0..) |c, i| {
            try pad(w, indent + 4);
            try w.print("std.debug.assert(n{d} < {d});\n", .{ depth + i, c });
        }
        try pad(w, indent + 4);
        try w.writeAll("return .{ .row = self.row, .at = .{");
        for (0..depth) |i| try w.print(" self.at[{d}],", .{i});
        for (own, 0..) |_, i| try w.print(" @intCast(n{d}),", .{depth + i});
        try w.writeAll(" } };\n");
        try pad(w, indent);
        try w.writeAll("}\n\n");

        try pad(w, indent);
        try w.print("pub const {f} = struct {{\n", .{std.zig.fmtId(entry)});
        try pad(w, indent + 4);
        try w.writeAll("row: excel.Row,\n");
        try pad(w, indent + 4);
        try w.print("at: [{d}]u16,\n", .{all_dims.len});
        try self.fieldsOf(w, Node.items(field.get("fields")), all_dims, chunks, indent + 4, entry);
        try pad(w, indent);
        try w.writeAll("};\n");
    }

    /// A table of offsets by every index, named `offsets_N`. `depth` of them come from the entry's
    /// `at`, the rest are the function's own.
    fn table(self: *Gen, dims: []const usize, chunks: []const []const Column, depth: usize, own: usize) ![]const u8 {
        self.table_count += 1;
        const name = try std.fmt.allocPrint(self.arena, "offsets_{d}", .{self.table_count});
        const tw = &self.tables.writer;
        const elem_type = if (chunks[0][0].type.bit() != null) "u32" else "u16";
        try tw.print("const {s} = [", .{name});
        for (dims, 0..) |d, i| try tw.print("{d}{s}", .{ d, if (i + 1 < dims.len) "][" else "" });
        try tw.print("]{s}{{", .{elem_type});
        var at: usize = 0;
        try self.tableLevel(tw, dims, chunks, &at);
        try tw.writeAll("};\n");

        var index: std.Io.Writer.Allocating = .init(self.arena);
        try index.writer.writeAll(name);
        for (0..depth) |i| try index.writer.print("[self.at[{d}]]", .{i});
        for (0..own) |i| try index.writer.print("[n{d}]", .{depth + i});
        return index.written();
    }

    fn tableLevel(self: *Gen, tw: *std.Io.Writer, dims: []const usize, chunks: []const []const Column, at: *usize) !void {
        for (0..dims[0]) |i| {
            if (i != 0) try tw.writeAll(", ");
            if (dims.len == 1) {
                try tw.print("{d}", .{encode(chunks[at.*][0])});
                at.* += 1;
            } else {
                try tw.writeAll(".{ ");
                try self.tableLevel(tw, dims[1..], chunks, at);
                try tw.writeAll(" }");
            }
        }
    }
};

/// Names in the order fields take columns, as `Gen.fieldsOf` walks them.
fn columnNames(arena: std.mem.Allocator, out: *std.ArrayList([]const u8), fields: []const Node, prefix: []const u8) anyerror!void {
    var unnamed: usize = 0;
    for (fields) |field| {
        const name = field.string("name") orelse blk: {
            unnamed += 1;
            break :blk try std.fmt.allocPrint(arena, "Unnamed{d}", .{unnamed});
        };
        try fieldNames(arena, out, field, try std.fmt.allocPrint(arena, "{s}{s}", .{ prefix, name }));
    }
}

fn fieldNames(arena: std.mem.Allocator, out: *std.ArrayList([]const u8), field: Node, label: []const u8) !void {
    if (!std.mem.eql(u8, field.string("type") orelse "scalar", "array")) return out.append(arena, label);
    const inner = Node.items(field.get("fields"));
    for (0..try countOf(field)) |i| {
        const at = try std.fmt.allocPrint(arena, "{s}[{d}]", .{ label, i });
        if (inner.len == 0) {
            try out.append(arena, at);
        } else if (inner.len == 1 and inner[0].string("name") == null) {
            try fieldNames(arena, out, inner[0], at);
        } else {
            try columnNames(arena, out, inner, try std.fmt.allocPrint(arena, "{s}.", .{at}));
        }
    }
}

/// Packed bools are their offset and bit together.
fn encode(c: Column) u32 {
    return if (c.type.bit()) |b| @as(u32, c.offset) * 8 + b else c.offset;
}

fn linkDoc(w: *std.Io.Writer, indent: usize, field: Node) !void {
    if (field.get("condition")) |cond| {
        try pad(w, indent);
        try w.print("/// Links by `{s}`:", .{camelOrRaw(cond.string("switch") orelse "?")});
        for (cond.get("cases").?.map, 0..) |case, i| {
            try w.print("{s} {s} to ", .{ if (i == 0) "" else ",", case.key });
            try targetList(w, Node.items(case.value));
        }
        try w.writeAll(".\n");
        return;
    }
    try pad(w, indent);
    try w.writeAll("/// Links to ");
    const targets = Node.items(field.get("targets"));
    try targetList(w, targets);
    try w.writeAll(if (targets.len > 1) ", whichever has the row.\n" else ".\n");
}

fn targetList(w: *std.Io.Writer, targets: []const Node) !void {
    for (targets, 0..) |t, i| {
        if (i != 0) try w.writeAll(if (i + 1 == targets.len) " or " else ", ");
        try w.print("`{s}`", .{t.scalar});
    }
}

fn camelOrRaw(name: []const u8) []const u8 {
    return name;
}

/// How many there are of an array, or of each index of one with more.
fn lenConst(w: *std.Io.Writer, indent: usize, name: []const u8, dims: []const usize) !void {
    try pad(w, indent);
    if (dims.len == 1) return w.print("pub const {f} = {d};\n", .{ std.zig.fmtId(name), dims[0] });
    try w.print("pub const {f} = [_]usize{{ ", .{std.zig.fmtId(name)});
    for (dims, 0..) |d, i| try w.print("{d}{s}", .{ d, if (i + 1 < dims.len) ", " else "" });
    try w.writeAll(" };\n");
}

fn docComment(w: *std.Io.Writer, indent: usize, comment: ?[]const u8) !void {
    const text = comment orelse return;
    var lines = std.mem.splitScalar(u8, std.mem.trim(u8, text, " \n"), '\n');
    while (lines.next()) |l| {
        try pad(w, indent);
        const t = std.mem.trimEnd(u8, l, " ");
        if (t.len == 0) try w.writeAll("///\n") else try w.print("/// {s}\n", .{t});
    }
}

fn line(w: *std.Io.Writer, indent: usize, text: []const u8) !void {
    try pad(w, indent);
    try w.print("{s}\n", .{text});
}

fn pad(w: *std.Io.Writer, indent: usize) !void {
    try w.splatByteAll(' ', indent);
}

/// Names in one struct, kept apart from each other and from what every struct has.
const Names = struct {
    arena: std.mem.Allocator,
    used: std.StringHashMapUnmanaged(void) = .empty,

    const reserved = [_][]const u8{ "row", "at", "self", "std", "excel", "sheets", "sheet_name", "kind", "columns_hash", "column_names", "Sheet" };

    fn reserve(self: *Names, name: []const u8) !void {
        try self.used.put(self.arena, name, {});
    }

    fn take(self: *Names, want: []const u8) ![]const u8 {
        const base = if (isParam(want)) try std.fmt.allocPrint(self.arena, "{s}Field", .{want}) else want;
        var name = base;
        var n: usize = 2;
        while (self.used.contains(name) or isReserved(name)) : (n += 1) {
            name = try std.fmt.allocPrint(self.arena, "{s}{d}", .{ base, n });
        }
        try self.used.put(self.arena, name, {});
        return name;
    }

    fn isReserved(name: []const u8) bool {
        for (reserved) |r| if (std.mem.eql(u8, r, name)) return true;
        return false;
    }

    /// Index parameters are `n0`, `n1` and so on.
    fn isParam(name: []const u8) bool {
        if (name.len < 2 or name[0] != 'n') return false;
        for (name[1..]) |c| if (!std.ascii.isDigit(c)) return false;
        return true;
    }
};

/// `ItemSoulCrystal` to `itemSoulCrystal`, `EXPBonus` to `expBonus`, `HQ` to `hq`.
fn camel(arena: std.mem.Allocator, name: []const u8) ![]const u8 {
    const clean = try identPart(arena, name);
    var run: usize = 0;
    while (run < clean.len and std.ascii.isUpper(clean[run])) run += 1;
    const lower = if (run > 1 and run < clean.len and std.ascii.isLower(clean[run])) run - 1 else run;
    const out = try arena.dupe(u8, clean);
    for (out[0..lower]) |*c| c.* = std.ascii.toLower(c.*);
    return out;
}

/// `receiveCount` to `receive_count`, `maxHQ` to `max_hq`.
fn snake(arena: std.mem.Allocator, name: []const u8) ![]const u8 {
    var out: std.ArrayList(u8) = .empty;
    for (name, 0..) |c, i| {
        if (std.ascii.isUpper(c) and i != 0) {
            const prev = name[i - 1];
            const next_lower = i + 1 < name.len and std.ascii.isLower(name[i + 1]);
            if (!std.ascii.isUpper(prev) or next_lower) try out.append(arena, '_');
        }
        try out.append(arena, std.ascii.toLower(c));
    }
    return out.items;
}

fn pascal(arena: std.mem.Allocator, name: []const u8) ![]const u8 {
    const out = try identPart(arena, name);
    if (out.len != 0) out[0] = std.ascii.toUpper(out[0]);
    return out;
}

/// Just letters, digits and underscores, which is all EXDSchema's names have so far.
fn identPart(arena: std.mem.Allocator, name: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    for (name) |c| if (std.ascii.isAlphanumeric(c) or c == '_') try out.append(arena, c);
    if (out.items.len == 0) try out.appendSlice(arena, "unnamed");
    return out.items;
}

test "names" {
    var a: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer a.deinit();
    const t = std.testing;
    const al = a.allocator();
    try t.expectEqualStrings("itemSoulCrystal", try camel(al, "ItemSoulCrystal"));
    try t.expectEqualStrings("expBonusPercent", try camel(al, "EXPBonusPercent"));
    try t.expectEqualStrings("hq", try camel(al, "HQ"));
    try t.expectEqualStrings("maxHQ", try camel(al, "MaxHQ"));
    try t.expectEqualStrings("unknown0", try camel(al, "Unknown0"));
    try t.expectEqualStrings("receive_count", try snake(al, "receiveCount"));
    try t.expectEqualStrings("max_hq", try snake(al, "maxHQ"));
    try t.expectEqualStrings("exp_bonus_percent", try snake(al, "expBonusPercent"));
    var names: Names = .{ .arena = al };
    try t.expectEqualStrings("row2", try names.take("row"));
    try t.expectEqualStrings("name", try names.take("name"));
    try t.expectEqualStrings("name2", try names.take("name"));
    try t.expectEqualStrings("n0Field", try names.take("n0"));
}

test "packed bools sort by bit after offset" {
    var a: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer a.deinit();
    const root = try yaml.parse(a.allocator(),
        \\Thing:
        \\  - type: packedbool1
        \\    offset: 4
        \\  - type: uint32
        \\    offset: 0
        \\  - type: packedbool0
        \\    offset: 4
        \\Other@Subrow:
        \\  - type: string
        \\    offset: 0
        \\
    );
    const cols = try readColumns(a.allocator(), root);
    const thing = cols.get("Thing").?;
    try std.testing.expectEqual(ColumnType.uint32, thing.sorted[0].type);
    try std.testing.expectEqual(ColumnType.packedbool0, thing.sorted[1].type);
    try std.testing.expectEqual(ColumnType.packedbool1, thing.header[0].type);
    try std.testing.expect(cols.get("Other").?.subrows);
}

test {
    _ = yaml;
}
