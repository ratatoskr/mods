//! `UObject::ProcessEvent`, which calls any UFunction by its reflection, Blueprint or native. It's
//! found in UObject's vtable by what it does first: test the function's flags for `FUNC_Native` and
//! `FUNC_HasOutParms`, at the offset reflection says `FunctionFlags` is.

const std = @import("std");

const Unreal = @import("Unreal.zig");

pub const ProcessEventFn = fn (object: usize, function: usize, params: ?*anyopaque) callconv(.c) void;

const func_native = 0x400;
const func_has_out_parms = 0x400000;
/// UObject has a few dozen virtuals, UE5 more
const max_slots = 0x100;

/// Its address, from the CoreUObject package's vtable, which doesn't override it, unlike actors.
pub fn find(ue: *const Unreal) ?usize {
    const flags_at = ue.functionFlagsOffset() orelse return null;
    const package = ue.objects.get(0) orelse return null;
    const vtable = ue.mem.ptr(package) orelse return null;
    var code: [0x800]u8 = undefined;
    for (0..max_slots) |i| {
        var f = ue.mem.read(usize, vtable + i * 8) orelse return null;
        // Some builds go through a jump first
        if (ue.mem.read(u8, f) == 0xE9) {
            const rel = ue.mem.read(i32, f + 1) orelse continue;
            f = @intCast(@as(isize, @intCast(f + 5)) + rel);
        }
        const len = readCode(ue, f, &code) orelse continue;
        if (isProcessEvent(code[0..len], flags_at)) return f;
    }
    return null;
}

fn readCode(ue: *const Unreal, at: usize, buf: []u8) ?usize {
    var len = buf.len;
    while (len >= 0x100) : (len /= 2) {
        if (ue.mem.bytes(at, buf[0..len])) return len;
    }
    return null;
}

/// It reads the flags a few times, and tests for both flags, straight from memory or once they're
/// loaded into a register.
pub fn isProcessEvent(code: []const u8, flags_at: usize) bool {
    if (flagReads(code, flags_at) < 2) return false;
    const native = testsFlag(code[0..@min(code.len, 0x400)], flags_at, func_native) or testsRegister(code, func_native);
    return native and (testsFlag(code, flags_at, func_has_out_parms) or testsRegister(code, func_has_out_parms));
}

/// `[reg+flags_at]` with a 32-bit displacement, however it's used.
fn flagReads(code: []const u8, flags_at: usize) usize {
    var n: usize = 0;
    var i: usize = 1;
    while (i + 4 <= code.len) : (i += 1) {
        if (std.mem.readInt(u32, code[i..][0..4], .little) != flags_at) continue;
        // The ModRM before it, or a SIB byte between them
        const direct = code[i - 1] & 0xC0 == 0x80 and code[i - 1] & 7 != 4;
        const sib = i >= 2 and code[i - 2] & 0xC0 == 0x80 and code[i - 2] & 7 == 4;
        if (direct or sib) n += 1;
    }
    return n;
}

/// `bt reg, bit` or `test reg, flag`, for flags already in a register.
fn testsRegister(code: []const u8, flag: u32) bool {
    const bit: u8 = @ctz(flag);
    var i: usize = 0;
    while (i + 3 <= code.len) : (i += 1) {
        // bt r32, imm8 is 0F BA /4
        if (code[i] == 0x0F and i + 4 <= code.len and code[i + 1] == 0xBA and code[i + 2] & 0xF8 == 0xE0 and code[i + 3] == bit) return true;
        if (i + 6 <= code.len) {
            // test r32, imm32 is F7 /0, or A9 for eax
            if (code[i] == 0xF7 and code[i + 1] & 0xF8 == 0xC0 and std.mem.readInt(u32, code[i + 2 ..][0..4], .little) == flag) return true;
            if (code[i] == 0xA9 and std.mem.readInt(u32, code[i + 1 ..][0..4], .little) == flag) return true;
        }
    }
    return false;
}

/// `test dword [reg+flags_at], flag`, or the byte form compilers pick for a flag in one byte.
pub fn testsFlag(code: []const u8, flags_at: usize, flag: u32) bool {
    const byte_at = flags_at + @ctz(flag) / 8;
    const byte_flag: u8 = @truncate(flag >> @intCast(@ctz(flag) / 8 * 8));
    var i: usize = 0;
    while (i + 7 <= code.len) : (i += 1) {
        const op = code[i];
        if (op != 0xF7 and op != 0xF6) continue;
        const modrm = code[i + 1];
        // mod 10 is a 32-bit displacement, reg 000 is test
        if (modrm & 0xF8 != 0x80) continue;
        var at = i + 2;
        if (modrm & 7 == 4) at += 1;
        if (op == 0xF7) {
            if (at + 8 > code.len) continue;
            const disp = std.mem.readInt(u32, code[at..][0..4], .little);
            const imm = std.mem.readInt(u32, code[at + 4 ..][0..4], .little);
            if (disp == flags_at and imm == flag) return true;
        } else {
            if (at + 5 > code.len) continue;
            const disp = std.mem.readInt(u32, code[at..][0..4], .little);
            if (disp == byte_at and code[at + 4] == byte_flag) return true;
        }
    }
    return false;
}

test "flags loaded into a register first" {
    const testing = std.testing;
    // mov ecx, [rbx+0xB0]; bt ecx, 10; ... mov eax, [rbx+0xB0]; bt eax, 22
    const code = [_]u8{ 0x8B, 0x8B, 0xB0, 0, 0, 0, 0x0F, 0xBA, 0xE1, 0x0A, 0x90, 0x8B, 0x83, 0xB0, 0, 0, 0, 0x0F, 0xBA, 0xE0, 0x16 };
    try testing.expect(isProcessEvent(&code, 0xB0));
    // sub rsp, 0xB0 isn't a read of the flags
    try testing.expect(!isProcessEvent(&.{ 0x48, 0x81, 0xEC, 0xB0, 0, 0, 0, 0x0F, 0xBA, 0xE1, 0x0A, 0x0F, 0xBA, 0xE0, 0x16 }, 0xB0));
}

test "flag tests, as dword and byte" {
    const testing = std.testing;
    // test dword [rdi+0xB0], 0x400
    try testing.expect(testsFlag(&.{ 0x90, 0xF7, 0x87, 0xB0, 0, 0, 0, 0x00, 0x04, 0, 0 }, 0xB0, 0x400));
    // test byte [rdi+0xB1], 4
    try testing.expect(testsFlag(&.{ 0xF6, 0x87, 0xB1, 0, 0, 0, 0x04 }, 0xB0, 0x400));
    // test byte [rsp+...] with a SIB byte, 0x400000 is in the third byte
    try testing.expect(testsFlag(&.{ 0xF6, 0x84, 0x24, 0xB2, 0, 0, 0, 0x40 }, 0xB0, 0x400000));
    // Another offset or flag isn't it
    try testing.expect(!testsFlag(&.{ 0xF7, 0x87, 0xB8, 0, 0, 0, 0x00, 0x04, 0, 0 }, 0xB0, 0x400));
    try testing.expect(!testsFlag(&.{ 0xF6, 0x87, 0xB1, 0, 0, 0, 0x08 }, 0xB0, 0x400));
}
