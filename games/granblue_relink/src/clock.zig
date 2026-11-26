//! Frames and time that keep going while the game's paused.

const std = @import("std");

/// Counted by the camera, once a frame.
pub var frame: std.atomic.Value(u32) = .init(1);

extern "kernel32" fn QueryPerformanceCounter(count: *i64) callconv(.winapi) c_int;
extern "kernel32" fn QueryPerformanceFrequency(frequency: *i64) callconv(.winapi) c_int;

pub fn now() i64 {
    var count: i64 = 0;
    _ = QueryPerformanceCounter(&count);
    return count;
}

/// `ns` in the clock's ticks.
pub fn ticks(ns: u64) i64 {
    var frequency: i64 = 0;
    _ = QueryPerformanceFrequency(&frequency);
    return @divTrunc(frequency * @as(i64, @intCast(ns)), std.time.ns_per_s);
}
