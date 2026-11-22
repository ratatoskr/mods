//! Unity's engine calls the plugin uses, found by name. They're the same functions under Mono and
//! IL2CPP, since they're Unity's own. Only call them on the game's main thread.

const std = @import("std");
const sdk = @import("wraith_sdk");

const W = sdk.api.wraith;
const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;

/// A C# object, like a `Camera` or a `Transform`.
pub const Object = opaque {};

pub const Engine = struct {
    main_camera: *const fn () callconv(.c) ?*Object,
    transform: *const fn (*Object) callconv(.c) ?*Object,
    get_position: *const fn (*Object, *Vec3) callconv(.c) void,
    set_position: *const fn (*Object, *const Vec3) callconv(.c) void,
    get_rotation: *const fn (*Object, *Quat) callconv(.c) void,
    set_rotation: *const fn (*Object, *const Quat) callconv(.c) void,
    /// Vertical, in degrees
    get_fov: *const fn (*Object) callconv(.c) f32,
    set_fov: *const fn (*Object, f32) callconv(.c) void,
    frame_count: *const fn () callconv(.c) i32,

    /// Each one's class, then its names, newest first. Unity before 2019 had `INTERNAL_` ones.
    const names = .{
        .main_camera = .{ "UnityEngine.Camera", "get_main" },
        .transform = .{ "UnityEngine.Component", "get_transform" },
        .get_position = .{ "UnityEngine.Transform", "get_position_Injected", "INTERNAL_get_position" },
        .set_position = .{ "UnityEngine.Transform", "set_position_Injected", "INTERNAL_set_position" },
        .get_rotation = .{ "UnityEngine.Transform", "get_rotation_Injected", "INTERNAL_get_rotation" },
        .set_rotation = .{ "UnityEngine.Transform", "set_rotation_Injected", "INTERNAL_set_rotation" },
        .get_fov = .{ "UnityEngine.Camera", "get_fieldOfView" },
        .set_fov = .{ "UnityEngine.Camera", "set_fieldOfView" },
        .frame_count = .{ "UnityEngine.Time", "get_frameCount" },
    };

    /// Blocks while the game's runtime looks, so not on the render thread.
    pub fn find(managed: W.Managed, missing: *[]const u8) !Engine {
        return findCalls(Engine, names, managed, missing);
    }
};

/// Fills each of `T`'s function pointer fields from `names`, which has the same fields, each the
/// class then its names, newest first. `missing` says which wasn't there.
pub fn findCalls(comptime T: type, comptime names: anytype, managed: W.Managed, missing: *[]const u8) !T {
    var out: T = undefined;
    const info = @typeInfo(T).@"struct";
    inline for (info.field_names, info.field_types) |field, F| {
        const want = @field(names, field);
        @field(out, field) = inline for (1..want.len) |i| {
            if (managed.icall(want[0], want[i])) |at| break @as(F, @ptrFromInt(at)) else |_| {}
        } else {
            missing.* = want[0] ++ "::" ++ want[1];
            return error.MissingEngineCall;
        };
    }
    return out;
}
