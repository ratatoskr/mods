//! The game's reflection: names, objects, and where classes keep their supers, fields and sizes.
//! Offsets get worked out from things every game has, like `Vector`'s X, Y and Z, so no version
//! needs a table, and games with their own engine changes still work as long as those hold.

const std = @import("std");

const Mem = @import("Mem.zig");
const names_ = @import("names.zig");
const objects_ = @import("objects.zig");

pub const Names = names_.Names;
pub const FName = names_.FName;
pub const Objects = objects_.Objects;
pub const object = objects_.object;
pub const TArray = Mem.TArray;

const P = Mem.ptr_size;

const Unreal = @This();

mem: *const Mem,
names: Names,
objects: Objects,
layout: Layout,
core: Core = .{},
/// An FName's size: its index and number, and in games built with case preserving names the
/// index it's shown with between them.
name_size: usize = @sizeOf(FName),

/// Offsets that vary between versions.
pub const Layout = struct {
    /// UStruct
    super: usize,
    /// UField list: functions, and properties before 4.25.
    children: usize,
    /// FField list, 4.25 and later.
    child_properties: ?usize,
    /// UStruct's size in bytes.
    struct_size: usize,
    /// UField::Next, and FField's when there's FField.
    field_next: usize,
    ffield_next: usize = 0,
    ffield_name: usize = 0,
    ffield_class: usize = P,
    /// FProperty or UProperty.
    array_dim: usize,
    element_size: usize,
    offset: usize,
    /// Where a struct or object property's struct or class sits, right after the property.
    property_end: usize,
    /// Vectors are doubles, UE5's large worlds.
    doubles: bool,
};

pub const Problem = error{ NoNames, NoObjects, UnusualObjects, MissingCore, UnusualLayout, OutOfMemory };

/// `missing` says what wasn't found, for the log.
pub fn find(mem: *const Mem, data: []const []const usize, missing: *[]const u8) Problem!Unreal {
    const names = for (data) |words| {
        if (Names.find(mem, words)) |n| break n;
    } else {
        missing.* = "the names (FNamePool or GNames)";
        return error.NoNames;
    };
    const objects = for (data) |words| {
        if (Objects.find(mem, words)) |o| break o;
    } else {
        missing.* = "the objects (GUObjectArray)";
        return error.NoObjects;
    };
    var self: Unreal = .{ .mem = mem, .names = names, .objects = objects, .layout = undefined };
    // The first object is always CoreUObject's package
    var buf: [256]u8 = undefined;
    const first = objects.get(0) orelse return error.UnusualObjects;
    // Its number's 0, so a second index the same as the first is the one it's shown with
    const words = mem.read([2]u32, first + object.name) orelse return error.UnusualObjects;
    if (words[0] != 0 and words[1] == words[0]) self.name_size = @sizeOf(FName) + 4;
    if (!std.mem.eql(u8, self.nameOf(first, &buf) orelse "", "/Script/CoreUObject")) {
        missing.* = "/Script/CoreUObject as the first object, so objects aren't laid out the usual way";
        return error.UnusualObjects;
    }
    self.layout = try self.findLayout(missing);
    return self;
}

/// Where UObject keeps its outer, after its name.
pub fn outerAt(self: *const Unreal) usize {
    return std.mem.alignForward(usize, object.name + self.name_size, P);
}

/// Where UObject ends, and UField's Next starts.
pub fn objectSize(self: *const Unreal) usize {
    return self.outerAt() + P;
}

pub fn nameOf(self: *const Unreal, obj: usize, buf: []u8) ?[]const u8 {
    return self.fname(obj + object.name, buf);
}

/// Like `nameOf`, plainly, for an object the game's using now. Game thread only.
pub fn nameOfLive(self: *const Unreal, obj: usize, buf: []u8) ?[]const u8 {
    return self.textOf(self.nameFrom(@as([*]const u8, @ptrFromInt(obj + object.name))[0..self.name_size]), buf, true);
}

/// The text of an FName the engine's just handed over, with its number, plainly. Game thread only.
pub fn nameText(self: *const Unreal, name: FName, buf: []u8) ?[]const u8 {
    return self.textOf(name, buf, true);
}

fn textOf(self: *const Unreal, name: FName, buf: []u8, comptime plain: bool) ?[]const u8 {
    const text = (if (plain) self.names.textPlain(name.index, buf) else self.names.text(name.index, buf)) orelse return null;
    if (name.number == 0) return text;
    const suffix = std.fmt.bufPrint(buf[text.len..], "_{d}", .{name.number - 1}) catch return text;
    return buf[0 .. text.len + suffix.len];
}

/// The FName at `at`.
pub fn readName(self: *const Unreal, at: usize) ?FName {
    var bytes: [@sizeOf(FName) + 4]u8 = undefined;
    if (!self.mem.bytes(at, bytes[0..self.name_size])) return null;
    return self.nameFrom(&bytes);
}

/// The FName in `bytes`, like a UFunction's params.
pub fn nameFrom(self: *const Unreal, bytes: []const u8) FName {
    return .{
        .index = std.mem.readInt(u32, bytes[0..4], .little),
        .number = std.mem.readInt(u32, bytes[self.name_size - 4 ..][0..4], .little),
    };
}

/// `name` into `out`, `name_size` of it. It's shown with its own index.
pub fn putName(self: *const Unreal, out: []u8, name: FName) void {
    std.mem.writeInt(u32, out[0..4], name.index, .little);
    if (self.name_size > @sizeOf(FName)) std.mem.writeInt(u32, out[4..8], name.index, .little);
    std.mem.writeInt(u32, out[self.name_size - 4 ..][0..4], name.number, .little);
}

/// The text of the FName at `at`, with its number.
pub fn fname(self: *const Unreal, at: usize, buf: []u8) ?[]const u8 {
    return self.textOf(self.readName(at) orelse return null, buf, false);
}

pub fn classOf(self: *const Unreal, obj: usize) ?usize {
    return self.mem.ptr(obj + object.class);
}

pub fn outerOf(self: *const Unreal, obj: usize) ?usize {
    return self.mem.ptr(obj + self.outerAt());
}

pub fn classNameOf(self: *const Unreal, obj: usize, buf: []u8) ?[]const u8 {
    return self.nameOf(self.classOf(obj) orelse return null, buf);
}

fn nameIs(self: *const Unreal, obj: usize, text: []const u8) bool {
    var buf: [256]u8 = undefined;
    return std.mem.eql(u8, self.nameOf(obj, &buf) orelse return false, text);
}

/// Core things the layout's worked out from.
pub const Core = struct {
    object: usize = 0,
    field: usize = 0,
    @"struct": usize = 0,
    class: usize = 0,
    vector: usize = 0,
    vector2d: usize = 0,
    transform: usize = 0,
    quat: usize = 0,

    const wanted = .{
        .{ "object", "Object" },       .{ "field", "Field" },   .{ "struct", "Struct" },
        .{ "class", "Class" },         .{ "vector", "Vector" }, .{ "vector2d", "Vector2D" },
        .{ "transform", "Transform" }, .{ "quat", "Quat" },
    };
};

/// Everything in /Script/CoreUObject we need, in one pass over the objects.
fn findCore(self: *const Unreal) Core {
    var core: Core = .{};
    const package = self.objects.get(0).?;
    var buf: [256]u8 = undefined;
    for (0..self.objects.count()) |i| {
        const obj = self.objects.get(i) orelse continue;
        if (self.outerOf(obj) != package) continue;
        const name = self.nameOf(obj, &buf) orelse continue;
        inline for (Core.wanted) |w| {
            if (@field(core, w[0]) == 0 and std.mem.eql(u8, name, w[1])) @field(core, w[0]) = obj;
        }
    }
    return core;
}

fn findLayout(self: *Unreal, missing: *[]const u8) Problem!Layout {
    const core = self.findCore();
    self.core = core;
    inline for (Core.wanted) |w| if (@field(core, w[0]) == 0) {
        missing.* = "CoreUObject's " ++ w[1];
        return error.MissingCore;
    };
    const mem = self.mem;
    var layout: Layout = .{ .super = 0, .children = 0, .child_properties = null, .struct_size = 0, .field_next = self.objectSize(), .array_dim = 0, .element_size = 0, .offset = 0, .property_end = 0, .doubles = false };

    // Class's super is Struct, whose super is Field
    layout.super = for (0..16) |k| {
        const o = self.objectSize() + k * P;
        if (mem.ptr(core.class + o) == core.@"struct" and mem.ptr(core.@"struct" + o) == core.field) break o;
    } else return self.unusual(missing, "UStruct's SuperStruct");

    // Vector's fields: UProperties before 4.25, where native ones come last first, FFields after
    var x: usize = 0;
    layout.child_properties = null;
    layout.children = 0;
    for (1..8) |k| {
        const o = layout.super + k * P;
        const p = mem.ptr(core.vector + o) orelse continue;
        if (self.objects.isObject(p)) {
            if (self.nameIs(p, "X") or self.nameIs(p, "Z")) {
                layout.children = o;
                x = p;
                break;
            }
            continue;
        }
        // Half as far in 32-bit games, since everything before it is pointers
        for ([_]usize{ 0x28, 0x20, 0x30, 0x18 }) |n64| {
            const n = n64 * P / 8;
            if (self.fnameIs(p + n, "X")) {
                layout.child_properties = o;
                layout.ffield_name = n;
                x = p;
                break;
            }
        }
        if (x != 0) break;
    }
    if (x == 0) return self.unusual(missing, "Vector's X");
    if (layout.child_properties) |cp| {
        // Children comes just before ChildProperties
        layout.children = cp - P;
        layout.field_next = self.objectSize();
        layout.ffield_next = for (0..6) |k| {
            const o = 3 * P + k * P;
            if (o == layout.ffield_name) continue;
            const y = mem.ptr(x + o) orelse continue;
            if (self.fnameIs(y + layout.ffield_name, "Y")) break o;
        } else return self.unusual(missing, "FField's Next");
        layout.ffield_class = P;
        const class = mem.ptr(x + layout.ffield_class) orelse return self.unusual(missing, "FField's class");
        var buf: [256]u8 = undefined;
        if (!std.mem.endsWith(u8, self.fname(class, &buf) orelse "", "Property")) return self.unusual(missing, "FField's class");
    } else {
        // Right after UObject in stock engines, further in games that added to it
        layout.field_next = for (0..6) |k| {
            const o = self.objectSize() + k * P;
            const next = mem.ptr(x + o) orelse continue;
            if (self.nameIs(next, "Y")) break o;
        } else return self.unusual(missing, "UField's Next");
    }
    // X, Y and Z sit at 0, s and 2s, each s big
    self.layout = layout;
    x = self.fieldNamed(core.vector, "X") orelse return self.unusual(missing, "Vector's X");
    const y = self.fieldNamed(core.vector, "Y") orelse return self.unusual(missing, "Vector's Y");
    const z = self.fieldNamed(core.vector, "Z") orelse return self.unusual(missing, "Vector's Z");
    const start = if (layout.child_properties != null) layout.ffield_name + self.name_size else layout.field_next + P;
    var size: i32 = 0;
    layout.offset = for (0..24) |k| {
        const o = start + k * 4;
        const a = mem.read(i32, x + o) orelse continue;
        const b = mem.read(i32, y + o) orelse continue;
        const c = mem.read(i32, z + o) orelse continue;
        if (a == 0 and (b == 4 or b == 8) and c == 2 * b) {
            size = b;
            break o;
        }
    } else return self.unusual(missing, "a property's offset");
    layout.doubles = size == 8;
    layout.element_size = for (0..24) |k| {
        const o = start + k * 4;
        if (o == layout.offset) continue;
        if (mem.read(i32, x + o) == size and mem.read(i32, y + o) == size and mem.read(i32, z + o) == size and mem.read(i32, x + o - 4) == 1) break o;
    } else return self.unusual(missing, "a property's size");
    layout.array_dim = layout.element_size - 4;

    // Vector is 3 numbers, Vector2D 2
    layout.struct_size = for (0..12) |k| {
        const o = layout.children + P + k * 4;
        if (mem.read(i32, core.vector + o) == 3 * size and mem.read(i32, core.vector2d + o) == 2 * size) break o;
    } else return self.unusual(missing, "UStruct's size");

    // Transform's Rotation is a struct property holding Quat
    self.layout = layout;
    const r = self.fieldNamed(core.transform, "Rotation") orelse return self.unusual(missing, "Transform's Rotation");
    layout.property_end = for (0..20) |k| {
        const o = layout.offset + 4 + k * 4;
        if (o % P != 0) continue;
        if (mem.ptr(r + o) == core.quat) break o;
    } else return self.unusual(missing, "where a struct property's struct is");
    return layout;
}

fn unusual(_: *const Unreal, missing: *[]const u8, what: []const u8) Problem {
    missing.* = what;
    return error.UnusualLayout;
}

fn fnameIs(self: *const Unreal, at: usize, text: []const u8) bool {
    var buf: [256]u8 = undefined;
    return std.mem.eql(u8, self.fname(at, &buf) orelse return false, text);
}

fn fieldNameIs(self: *const Unreal, field: usize, text: []const u8) bool {
    var buf: [256]u8 = undefined;
    return std.mem.eql(u8, self.fieldName(field, &buf) orelse return false, text);
}

pub fn fieldNamed(self: *const Unreal, strct: usize, name: []const u8) ?usize {
    var field = self.firstField(strct);
    var n: usize = 0;
    while (field) |f| : (field = self.nextField(f)) {
        n += 1;
        if (n > 4096) return null;
        if (self.fieldNameIs(f, name)) return f;
    }
    return null;
}

/// A struct's first property. Before 4.25 properties sit among its functions.
pub fn firstField(self: *const Unreal, strct: usize) ?usize {
    if (self.layout.child_properties) |cp| return self.mem.ptr(strct + cp);
    return self.mem.ptr(strct + self.layout.children);
}

pub fn nextField(self: *const Unreal, field: usize) ?usize {
    const next = if (self.layout.child_properties != null) self.layout.ffield_next else self.layout.field_next;
    return self.mem.ptr(field + next);
}

pub fn fieldName(self: *const Unreal, field: usize, buf: []u8) ?[]const u8 {
    if (self.layout.child_properties != null) return self.fname(field + self.layout.ffield_name, buf);
    return self.nameOf(field, buf);
}

/// Like `IntProperty` or `Function`.
pub fn fieldKind(self: *const Unreal, field: usize, buf: []u8) ?[]const u8 {
    if (self.layout.child_properties != null) return self.fname(self.mem.ptr(field + self.layout.ffield_class) orelse return null, buf);
    return self.classNameOf(field, buf);
}

/// UFunctions, which stay UFields in every version.
pub fn firstFunction(self: *const Unreal, strct: usize) ?usize {
    return self.mem.ptr(strct + self.layout.children);
}

pub fn superOf(self: *const Unreal, strct: usize) ?usize {
    return self.mem.ptr(strct + self.layout.super);
}

pub fn structSize(self: *const Unreal, strct: usize) ?i32 {
    return self.mem.read(i32, strct + self.layout.struct_size);
}

pub const Property = struct {
    offset: i32,
    size: i32,
    count: i32,
    /// The struct, class or enum it holds, if any.
    type: ?usize,
};

pub fn property(self: *const Unreal, field: usize) ?Property {
    const l = self.layout;
    const t = self.mem.ptr(field + l.property_end);
    return .{
        .offset = self.mem.read(i32, field + l.offset) orelse return null,
        .size = self.mem.read(i32, field + l.element_size) orelse return null,
        .count = self.mem.read(i32, field + l.array_dim) orelse return null,
        .type = if (t) |p| if (self.objects.isObject(p)) p else null else null,
    };
}

/// The object's full path, like `/Script/Engine.Actor`.
pub fn pathOf(self: *const Unreal, obj: usize, buf: []u8) ?[]const u8 {
    var chain: [16]usize = undefined;
    var n: usize = 0;
    var at: ?usize = obj;
    while (at) |o| : (at = self.outerOf(o)) {
        if (n == chain.len) return null;
        chain[n] = o;
        n += 1;
    }
    var len: usize = 0;
    var i = n;
    while (i > 0) {
        i -= 1;
        if (i != n - 1) {
            if (len == buf.len) return null;
            buf[len] = '.';
            len += 1;
        }
        const name = self.nameOf(chain[i], buf[len..]) orelse return null;
        len += name.len;
    }
    return buf[0..len];
}

/// `RF_ClassDefaultObject`, the object a class keeps its defaults in.
pub const class_default = 0x10;

pub fn flagsOf(self: *const Unreal, obj: usize) u32 {
    return self.mem.read(u32, obj + object.flags) orelse 0;
}

/// If the object's class is `class_name` or comes from it.
pub fn isA(self: *const Unreal, obj: usize, class_name: []const u8) bool {
    var at = self.classOf(obj);
    var depth: usize = 0;
    while (at) |c| : (at = self.superOf(c)) {
        depth += 1;
        if (depth > 64) return false;
        if (self.nameIs(c, class_name)) return true;
    }
    return false;
}

/// The objects in `package`, like `/Script/Engine`, named `names`, in one pass. 0 for missing ones.
pub fn findIn(self: *const Unreal, package: []const u8, names: []const []const u8, out: []usize) void {
    @memset(out, 0);
    var pkg: usize = 0;
    for (0..self.objects.count()) |i| {
        const obj = self.objects.get(i) orelse continue;
        if (self.outerOf(obj) == null and self.nameIs(obj, package)) {
            pkg = obj;
            break;
        }
    }
    if (pkg == 0) return;
    var buf: [256]u8 = undefined;
    for (0..self.objects.count()) |i| {
        const obj = self.objects.get(i) orelse continue;
        if (self.outerOf(obj) != pkg) continue;
        const name = self.nameOf(obj, &buf) orelse continue;
        for (names, out) |want, *o| {
            if (o.* == 0 and std.mem.eql(u8, name, want)) o.* = obj;
        }
    }
}

/// The first live object, not a class default, that's a `class_name`.
pub fn findInstance(self: *const Unreal, class_name: []const u8) ?usize {
    for (0..self.objects.count()) |i| {
        const obj = self.objects.get(i) orelse continue;
        if (self.flagsOf(obj) & class_default != 0) continue;
        if (self.isA(obj, class_name)) return obj;
    }
    return null;
}

/// Like `findInstance` but by the class itself, with plain reads, so it's quick enough for the game
/// thread. Game thread only, where every object in the array is alive. Skips templates too.
pub fn liveInstanceOf(self: *const Unreal, class: usize) ?usize {
    return if (self.liveInstance(class)) |l| l.object else null;
}

/// An object and its slot in the object array, for checking it's still there later.
pub const Live = struct { object: usize, slot: u32 };

/// Like `liveInstanceOf`, with its slot. Game thread only.
pub fn liveInstance(self: *const Unreal, class: usize) ?Live {
    for (0..self.objects.countPlain()) |i| {
        const obj = self.objects.getPlain(i);
        if (self.isLive(obj, class)) return .{ .object = obj, .slot = @intCast(i) };
    }
    return null;
}

/// Whether `obj` is a live instance of `class` or one from it, not a template, with plain reads.
/// Game thread only, on what's in the object array.
pub fn isLive(self: *const Unreal, obj: usize, class: usize) bool {
    const templates = class_default | 0x20;
    if (obj == 0 or @as(*align(1) const u32, @ptrFromInt(obj + object.flags)).* & templates != 0) return false;
    // Its class and their supers are alive too, so they're read plainly as well
    var at = @as(*align(1) const usize, @ptrFromInt(obj + object.class)).*;
    var depth: usize = 0;
    while (at != 0) : (at = @as(*align(1) const usize, @ptrFromInt(at + self.layout.super)).*) {
        depth += 1;
        if (depth > 64) return false;
        if (at == class) return true;
    }
    return false;
}

/// Where a property sits in a `class`'s objects, looking through its supers too.
pub fn offsetOf(self: *const Unreal, class: usize, name: []const u8) ?usize {
    var at: ?usize = class;
    var depth: usize = 0;
    while (at) |c| : (at = self.superOf(c)) {
        depth += 1;
        if (depth > 64) return null;
        if (self.fieldNamed(c, name)) |f| {
            const p = self.property(f) orelse return null;
            return if (p.offset >= 0) @intCast(p.offset) else null;
        }
    }
    return null;
}

/// A bool kept as a bit in a byte, like most of the engine's.
pub const Bit = struct { offset: usize, mask: u8 };

/// Where a bool property's bit is in a `class`'s objects, looking through its supers too. Its byte
/// and mask follow the property.
pub fn bitOf(self: *const Unreal, class: usize, name: []const u8) ?Bit {
    var at: ?usize = class;
    var depth: usize = 0;
    while (at) |c| : (at = self.superOf(c)) {
        depth += 1;
        if (depth > 64) return null;
        const field = self.fieldNamed(c, name) orelse continue;
        const p = self.property(field) orelse return null;
        const info = self.mem.read([4]u8, field + self.layout.property_end) orelse return null;
        if (p.offset < 0 or info[3] == 0) return null;
        return .{ .offset = @as(usize, @intCast(p.offset)) + info[1], .mask = info[3] };
    }
    return null;
}

/// A class's UFunction, looking through its supers too.
pub fn functionNamed(self: *const Unreal, class: usize, name: []const u8) ?usize {
    var at: ?usize = class;
    var depth: usize = 0;
    while (at) |c| : (at = self.superOf(c)) {
        depth += 1;
        if (depth > 64) return null;
        var func = self.firstFunction(c);
        var n: usize = 0;
        while (func) |f| : (func = self.mem.ptr(f + self.layout.field_next)) {
            n += 1;
            if (n > 8192) break;
            if (self.nameIs(f, name)) return f;
        }
    }
    return null;
}

/// A UFunction, how big its params are, and where the ones asked for are.
pub const Call = struct {
    function: usize,
    size: usize,
    /// In the order they were asked for.
    params: [3]usize = .{ 0, 0, 0 },
};

/// A class's UFunction and where its `params` are, or what's missing.
pub fn callOf(self: *const Unreal, class: usize, comptime name: []const u8, comptime params: []const []const u8, missing: *[]const u8) !Call {
    const f = self.functionNamed(class, name) orelse {
        missing.* = name;
        return error.MissingFunction;
    };
    var out: Call = .{ .function = f, .size = @intCast(self.structSize(f) orelse return error.MissingFunction) };
    inline for (params, 0..) |p, i| out.params[i] = self.offsetOf(f, p) orelse {
        missing.* = name ++ "'s " ++ p;
        return error.MissingProperty;
    };
    return out;
}

/// `UFunction::FunctionFlags`, its first field, right after UStruct's. A native class's size is its
/// C++ type's, so Struct's own size says where UStruct ends.
pub fn functionFlagsOffset(self: *const Unreal) ?usize {
    const size = self.structSize(self.core.@"struct") orelse return null;
    return if (size > 0) @intCast(size) else null;
}
