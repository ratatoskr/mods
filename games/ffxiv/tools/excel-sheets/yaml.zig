//! Just enough YAML for EXDSchema: block maps and lists, one line `[a, b]` lists, plain, quoted and
//! `|` scalars, and `#` comments. Anything else is an error, rather than read wrong.

const std = @import("std");

pub const Node = union(enum) {
    scalar: []const u8,
    list: []const Node,
    map: []const Pair,

    pub const Pair = struct { key: []const u8, value: Node };

    pub fn get(self: Node, key: []const u8) ?Node {
        if (self != .map) return null;
        for (self.map) |p| if (std.mem.eql(u8, p.key, key)) return p.value;
        return null;
    }

    pub fn string(self: Node, key: []const u8) ?[]const u8 {
        const v = self.get(key) orelse return null;
        return if (v == .scalar) v.scalar else null;
    }

    pub fn items(self: ?Node) []const Node {
        const n = self orelse return &.{};
        return if (n == .list) n.list else &.{};
    }
};

pub const Error = error{ BadYaml, OutOfMemory };

/// Everything it returns is in `arena`, and points into `text`.
pub fn parse(arena: std.mem.Allocator, text: []const u8) Error!Node {
    var lines: std.ArrayList(Line) = .empty;
    var it = std.mem.splitScalar(u8, text, '\n');
    while (it.next()) |raw| {
        const l = std.mem.trimEnd(u8, raw, "\r");
        if (std.mem.indexOfScalar(u8, l, '\t') != null) return error.BadYaml;
        const content = std.mem.trimStart(u8, l, " ");
        try lines.append(arena, .{ .indent = l.len - content.len, .text = content, .raw = l });
    }
    var p: Parser = .{ .arena = arena, .lines = lines.items };
    p.skipBlank();
    if (p.at >= p.lines.len) return .{ .map = &.{} };
    const node = try p.block(p.lines[p.at].indent);
    p.skipBlank();
    if (p.at < p.lines.len) return error.BadYaml;
    return node;
}

const Line = struct {
    indent: usize,
    text: []const u8,
    /// The whole line, for `|` blocks.
    raw: []const u8,
};

const Parser = struct {
    arena: std.mem.Allocator,
    lines: []Line,
    at: usize = 0,

    fn skipBlank(self: *Parser) void {
        while (self.at < self.lines.len) : (self.at += 1) {
            if (stripComment(self.lines[self.at].text).len != 0) return;
        }
    }

    fn block(self: *Parser, indent: usize) Error!Node {
        const first = self.lines[self.at];
        if (first.indent != indent) return error.BadYaml;
        return if (isItem(first.text)) self.list(indent) else self.map(indent);
    }

    fn list(self: *Parser, indent: usize) Error!Node {
        var out: std.ArrayList(Node) = .empty;
        while (true) {
            self.skipBlank();
            if (self.at >= self.lines.len) break;
            const line = &self.lines[self.at];
            if (line.indent < indent) break;
            if (line.indent > indent or !isItem(line.text)) return error.BadYaml;
            const rest = std.mem.trimStart(u8, line.text[1..], " ");
            if (stripComment(rest).len == 0) {
                self.at += 1;
                self.skipBlank();
                if (self.at >= self.lines.len or self.lines[self.at].indent <= indent) return error.BadYaml;
                try out.append(self.arena, try self.block(self.lines[self.at].indent));
            } else if (keyOf(rest) != null) {
                // `- key: value` starts a map, whose keys line up with `key`
                const inner = indent + (line.text.len - rest.len);
                line.indent = inner;
                line.text = rest;
                try out.append(self.arena, try self.map(inner));
            } else {
                try out.append(self.arena, try scalarOf(self.arena, stripComment(rest)));
                self.at += 1;
            }
        }
        return .{ .list = out.items };
    }

    fn map(self: *Parser, indent: usize) Error!Node {
        var out: std.ArrayList(Node.Pair) = .empty;
        while (true) {
            self.skipBlank();
            if (self.at >= self.lines.len) break;
            const line = self.lines[self.at];
            if (line.indent < indent) break;
            // A list can sit at its parent key's indent, which ends this map
            if (line.indent == indent and isItem(line.text)) break;
            if (line.indent > indent) return error.BadYaml;
            const key = keyOf(line.text) orelse return error.BadYaml;
            const value = stripComment(std.mem.trim(u8, line.text[key.len + 1 ..], " "));
            self.at += 1;
            const node: Node = if (std.mem.eql(u8, value, "|") or std.mem.eql(u8, value, "|-"))
                .{ .scalar = try self.literal(indent) }
            else if (value.len != 0)
                try scalarOf(self.arena, value)
            else nested: {
                self.skipBlank();
                if (self.at < self.lines.len) {
                    const next = self.lines[self.at];
                    if (next.indent > indent or (next.indent == indent and isItem(next.text))) break :nested try self.block(next.indent);
                }
                break :nested .{ .scalar = "" };
            };
            for (out.items) |p| if (std.mem.eql(u8, p.key, key)) return error.BadYaml;
            try out.append(self.arena, .{ .key = key, .value = node });
        }
        return .{ .map = out.items };
    }

    /// The lines after a `|`, indented more than its key, with that indent taken off.
    fn literal(self: *Parser, indent: usize) Error![]const u8 {
        var out: std.ArrayList(u8) = .empty;
        var block_indent: ?usize = null;
        while (self.at < self.lines.len) : (self.at += 1) {
            const line = self.lines[self.at];
            if (line.text.len != 0) {
                if (line.indent <= indent) break;
                if (block_indent == null) block_indent = line.indent;
                if (line.indent < block_indent.?) return error.BadYaml;
            }
            if (out.items.len != 0) try out.append(self.arena, '\n');
            if (line.text.len != 0) try out.appendSlice(self.arena, line.raw[block_indent.?..]);
        }
        return std.mem.trimEnd(u8, out.items, "\n");
    }
};

fn isItem(text: []const u8) bool {
    return std.mem.eql(u8, text, "-") or std.mem.startsWith(u8, text, "- ");
}

/// `key` in `key: value` or `key:`. Keys aren't quoted in EXDSchema.
fn keyOf(text: []const u8) ?[]const u8 {
    if (text.len == 0 or text[0] == '"' or text[0] == '\'' or text[0] == '[') return null;
    for (text, 0..) |c, i| {
        if (c == ':' and (i + 1 == text.len or text[i + 1] == ' ')) return if (i == 0) null else text[0..i];
        if (c == ' ' and i + 1 < text.len and text[i + 1] == '#') return null;
    }
    return null;
}

/// Drops a ` # comment`, outside quotes.
fn stripComment(text: []const u8) []const u8 {
    var quote: ?u8 = null;
    for (text, 0..) |c, i| {
        if (quote) |q| {
            if (c == q) quote = null;
        } else if (c == '"' or c == '\'') {
            // Only at the start of a scalar, so apostrophes in plain text don't count
            if (i == 0 or text[i - 1] == ' ' or text[i - 1] == '[' or text[i - 1] == ',') quote = c;
        } else if (c == '#' and (i == 0 or text[i - 1] == ' ')) {
            return std.mem.trimEnd(u8, text[0..i], " ");
        }
    }
    return text;
}

fn scalarOf(arena: std.mem.Allocator, text: []const u8) Error!Node {
    if (text.len == 0) return .{ .scalar = "" };
    switch (text[0]) {
        '[' => {
            if (text[text.len - 1] != ']') return error.BadYaml;
            var out: std.ArrayList(Node) = .empty;
            const inner = std.mem.trim(u8, text[1 .. text.len - 1], " ");
            if (inner.len == 0) return .{ .list = &.{} };
            var parts = std.mem.splitScalar(u8, inner, ',');
            while (parts.next()) |part| {
                const t = std.mem.trim(u8, part, " ");
                if (t.len == 0) return error.BadYaml;
                try out.append(arena, try scalarOf(arena, t));
            }
            return .{ .list = out.items };
        },
        '"' => {
            if (text.len < 2 or text[text.len - 1] != '"') return error.BadYaml;
            const inner = text[1 .. text.len - 1];
            if (std.mem.indexOfScalar(u8, inner, '\\') != null) return error.BadYaml;
            return .{ .scalar = inner };
        },
        '\'' => {
            if (text.len < 2 or text[text.len - 1] != '\'') return error.BadYaml;
            return .{ .scalar = try std.mem.replaceOwned(u8, arena, text[1 .. text.len - 1], "''", "'") };
        },
        '{', '&', '*', '!', '>', '|', '%', '@', '`' => return error.BadYaml,
        else => return .{ .scalar = text },
    }
}

test "reads what EXDSchema writes" {
    var a: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer a.deinit();
    const t = std.testing;
    const root = try parse(a.allocator(),
        \\name: Thing # a comment
        \\displayField: Name
        \\fields:
        \\  - name: Name
        \\  - name: Items
        \\    type: array
        \\    count: 3
        \\    fields:
        \\      - type: link
        \\        targets: [Item, Quest]
        \\  - name: Location
        \\    comment: |
        \\      1 = one
        \\        2 = two
        \\    condition:
        \\      switch: Key
        \\      cases:
        \\        1: [PlaceName] # Unlocked
        \\  - name: Quoted
        \\    comment: "It's #1"
        \\other:
        \\- 'it''s'
        \\
    );
    try t.expectEqualStrings("Thing", root.string("name").?);
    const fields = Node.items(root.get("fields"));
    try t.expectEqual(4, fields.len);
    try t.expectEqualStrings("3", fields[1].string("count").?);
    const link = Node.items(fields[1].get("fields"))[0];
    try t.expectEqualStrings("Quest", Node.items(link.get("targets"))[1].scalar);
    try t.expectEqualStrings("1 = one\n  2 = two", fields[2].string("comment").?);
    const cases = fields[2].get("condition").?.get("cases").?;
    try t.expectEqualStrings("PlaceName", Node.items(cases.get("1"))[0].scalar);
    try t.expectEqualStrings("It's #1", fields[3].string("comment").?);
    try t.expectEqualStrings("it's", Node.items(root.get("other"))[0].scalar);
}

test "won't guess at what it doesn't know" {
    var a: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer a.deinit();
    for ([_][]const u8{ "a: &x 1", "a: {b: 1}", "a: >\n  x", "a: 1\na: 2", "a:\n\tb: 1", "a: [b, c", "  - a\n- b", "a: \"x\\ny\"" }) |text| {
        try std.testing.expectError(error.BadYaml, parse(a.allocator(), text));
    }
}
