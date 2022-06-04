const cimport = @import("c.zig").c;

const acos = @import("std").math.acos;
const asin = @import("std").math.asin;
const atan2 = @import("std").math.atan2;
pub const Vector2 = cimport.Vector2;
pub const Vector2i = struct {
    x: i32,
    y: i32,

    const Self = @This();
    pub fn toVector2(self: Self) Vector2 {
        return .{
            .x = @intToFloat(f32, self.x),
            .y = @intToFloat(f32, self.y),
        };
    }
};
pub const Vector3 = cimport.Vector3;
pub const Vector4 = cimport.Vector4;
pub const Quaternion = Vector4;
pub const Matrix = cimport.Matrix;
pub const float3 = extern struct {
    v: [3]f32,
};
pub const float16 = extern struct {
    v: [16]f32,
};
pub fn Clamp(arg_value: f32, arg_min: f32, arg_max: f32) callconv(.C) f32 {
    var value = arg_value;
    var min = arg_min;
    var max = arg_max;
    var result: f32 = if (value < min) min else value;
    if (result > max) {
        result = max;
    }
    return result;
}
pub fn Lerp(arg_start: f32, arg_end: f32, arg_amount: f32) callconv(.C) f32 {
    var start = arg_start;
    var end = arg_end;
    var amount = arg_amount;
    var result: f32 = start + (amount * (end - start));
    return result;
}
pub fn Normalize(arg_value: f32, arg_start: f32, arg_end: f32) callconv(.C) f32 {
    var value = arg_value;
    var start = arg_start;
    var end = arg_end;
    var result: f32 = (value - start) / (end - start);
    return result;
}
pub fn Remap(arg_value: f32, arg_inputStart: f32, arg_inputEnd: f32, arg_outputStart: f32, arg_outputEnd: f32) callconv(.C) f32 {
    var value = arg_value;
    var inputStart = arg_inputStart;
    var inputEnd = arg_inputEnd;
    var outputStart = arg_outputStart;
    var outputEnd = arg_outputEnd;
    var result: f32 = (((value - inputStart) / (inputEnd - inputStart)) * (outputEnd - outputStart)) + outputStart;
    return result;
}
pub fn FloatEquals(arg_x: f32, arg_y: f32) callconv(.C) c_int {
    var x = arg_x;
    var y = arg_y;
    var result: c_int = @boolToInt(@fabs(x - y) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(x), @fabs(y)))));
    return result;
}
pub fn Vector2Zero() callconv(.C) Vector2 {
    var result: Vector2 = Vector2{
        .x = 0.0,
        .y = 0.0,
    };
    return result;
}
pub fn Vector2One() callconv(.C) Vector2 {
    var result: Vector2 = Vector2{
        .x = 1.0,
        .y = 1.0,
    };
    return result;
}
pub fn Vector2Add(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) Vector2 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector2 = Vector2{
        .x = v1.x + v2.x,
        .y = v1.y + v2.y,
    };
    return result;
}
pub fn Vector2AddValue(arg_v: Vector2, arg_add: f32) callconv(.C) Vector2 {
    var v = arg_v;
    var add = arg_add;
    var result: Vector2 = Vector2{
        .x = v.x + add,
        .y = v.y + add,
    };
    return result;
}
pub fn Vector2Subtract(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) Vector2 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector2 = Vector2{
        .x = v1.x - v2.x,
        .y = v1.y - v2.y,
    };
    return result;
}
pub fn Vector2SubtractValue(arg_v: Vector2, arg_sub: f32) callconv(.C) Vector2 {
    var v = arg_v;
    var sub = arg_sub;
    var result: Vector2 = Vector2{
        .x = v.x - sub,
        .y = v.y - sub,
    };
    return result;
}
pub fn Vector2Length(arg_v: Vector2) callconv(.C) f32 {
    var v = arg_v;
    var result: f32 = @sqrt((v.x * v.x) + (v.y * v.y));
    return result;
}
pub fn Vector2LengthSqr(arg_v: Vector2) callconv(.C) f32 {
    var v = arg_v;
    var result: f32 = (v.x * v.x) + (v.y * v.y);
    return result;
}
pub fn Vector2DotProduct(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = (v1.x * v2.x) + (v1.y * v2.y);
    return result;
}
pub fn Vector2Distance(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = @sqrt(((v1.x - v2.x) * (v1.x - v2.x)) + ((v1.y - v2.y) * (v1.y - v2.y)));
    return result;
}
pub fn Vector2DistanceSqr(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = ((v1.x - v2.x) * (v1.x - v2.x)) + ((v1.y - v2.y) * (v1.y - v2.y));
    return result;
}
pub fn Vector2Angle(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = atan2(f32, v2.y, v2.x) - atan2(f32, v1.y, v1.x);
    return result;
}
pub fn Vector2Scale(arg_v: Vector2, arg_scale: f32) callconv(.C) Vector2 {
    var v = arg_v;
    var scale = arg_scale;
    var result: Vector2 = Vector2{
        .x = v.x * scale,
        .y = v.y * scale,
    };
    return result;
}
pub fn Vector2Multiply(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) Vector2 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector2 = Vector2{
        .x = v1.x * v2.x,
        .y = v1.y * v2.y,
    };
    return result;
}
pub fn Vector2Negate(arg_v: Vector2) callconv(.C) Vector2 {
    var v = arg_v;
    var result: Vector2 = Vector2{
        .x = -v.x,
        .y = -v.y,
    };
    return result;
}
pub fn Vector2Divide(arg_v1: Vector2, arg_v2: Vector2) callconv(.C) Vector2 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector2 = Vector2{
        .x = v1.x / v2.x,
        .y = v1.y / v2.y,
    };
    return result;
}
pub fn Vector2Normalize(arg_v: Vector2) callconv(.C) Vector2 {
    var v = arg_v;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    var length: f32 = @sqrt((v.x * v.x) + (v.y * v.y));
    if (length > @intToFloat(f32, @as(c_int, 0))) {
        var ilength: f32 = 1.0 / length;
        result.x = v.x * ilength;
        result.y = v.y * ilength;
    }
    return result;
}
pub fn Vector2Transform(arg_v: Vector2, arg_mat: Matrix) callconv(.C) Vector2 {
    var v = arg_v;
    var mat = arg_mat;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    var x: f32 = v.x;
    var y: f32 = v.y;
    var z: f32 = 0;
    result.x = (((mat.m0 * x) + (mat.m4 * y)) + (mat.m8 * z)) + mat.m12;
    result.y = (((mat.m1 * x) + (mat.m5 * y)) + (mat.m9 * z)) + mat.m13;
    return result;
}
pub fn Vector2Lerp(arg_v1: Vector2, arg_v2: Vector2, arg_amount: f32) callconv(.C) Vector2 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var amount = arg_amount;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    result.x = v1.x + (amount * (v2.x - v1.x));
    result.y = v1.y + (amount * (v2.y - v1.y));
    return result;
}
pub fn Vector2Reflect(arg_v: Vector2, arg_normal: Vector2) callconv(.C) Vector2 {
    var v = arg_v;
    var normal = arg_normal;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    var dotProduct: f32 = (v.x * normal.x) + (v.y * normal.y);
    result.x = v.x - ((2.0 * normal.x) * dotProduct);
    result.y = v.y - ((2.0 * normal.y) * dotProduct);
    return result;
}
pub fn Vector2Rotate(arg_v: Vector2, arg_angle: f32) callconv(.C) Vector2 {
    var v = arg_v;
    var angle = arg_angle;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    var cosres: f32 = @cos(angle);
    var sinres: f32 = @sin(angle);
    result.x = (v.x * cosres) - (v.y * sinres);
    result.y = (v.x * sinres) + (v.y * cosres);
    return result;
}
pub fn Vector2MoveTowards(arg_v: Vector2, arg_target: Vector2, arg_maxDistance: f32) callconv(.C) Vector2 {
    var v = arg_v;
    var target = arg_target;
    var maxDistance = arg_maxDistance;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    var dx: f32 = target.x - v.x;
    var dy: f32 = target.y - v.y;
    var value: f32 = (dx * dx) + (dy * dy);
    if ((value == @intToFloat(f32, @as(c_int, 0))) or ((maxDistance >= @intToFloat(f32, @as(c_int, 0))) and (value <= (maxDistance * maxDistance)))) return target;
    var dist: f32 = @sqrt(value);
    result.x = v.x + ((dx / dist) * maxDistance);
    result.y = v.y + ((dy / dist) * maxDistance);
    return result;
}
pub fn Vector2Invert(arg_v: Vector2) callconv(.C) Vector2 {
    var v = arg_v;
    var result: Vector2 = Vector2{
        .x = 1.0 / v.x,
        .y = 1.0 / v.y,
    };
    return result;
}
pub fn Vector2Clamp(arg_v: Vector2, arg_min: Vector2, arg_max: Vector2) callconv(.C) Vector2 {
    var v = arg_v;
    var min = arg_min;
    var max = arg_max;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    result.x = @minimum(max.x, @maximum(min.x, v.x));
    result.y = @minimum(max.y, @maximum(min.y, v.y));
    return result;
}
pub fn Vector2ClampValue(arg_v: Vector2, arg_min: f32, arg_max: f32) callconv(.C) Vector2 {
    var v = arg_v;
    var min = arg_min;
    var max = arg_max;
    var result: Vector2 = Vector2{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
    };
    var length: f32 = (v.x * v.x) + (v.y * v.y);
    if (length > 0.0) {
        length = @sqrt(length);
        if (length < min) {
            var scale: f32 = min / length;
            result.x = v.x * scale;
            result.y = v.y * scale;
        } else if (length > max) {
            var scale: f32 = max / length;
            result.x = v.x * scale;
            result.y = v.y * scale;
        }
    }
    return result;
}
pub fn Vector2Equals(arg_p: Vector2, arg_q: Vector2) callconv(.C) c_int {
    var p = arg_p;
    var q = arg_q;
    var result: c_int = @boolToInt((@fabs(p.x - q.x) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.x), @fabs(q.x))))) and (@fabs(p.y - q.y) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.y), @fabs(q.y))))));
    return result;
}
pub fn Vector3Zero() callconv(.C) Vector3 {
    var result: Vector3 = Vector3{
        .x = 0.0,
        .y = 0.0,
        .z = 0.0,
    };
    return result;
}
pub fn Vector3One() callconv(.C) Vector3 {
    var result: Vector3 = Vector3{
        .x = 1.0,
        .y = 1.0,
        .z = 1.0,
    };
    return result;
}
pub fn Vector3Add(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = v1.x + v2.x,
        .y = v1.y + v2.y,
        .z = v1.z + v2.z,
    };
    return result;
}
pub fn Vector3AddValue(arg_v: Vector3, arg_add: f32) callconv(.C) Vector3 {
    var v = arg_v;
    var add = arg_add;
    var result: Vector3 = Vector3{
        .x = v.x + add,
        .y = v.y + add,
        .z = v.z + add,
    };
    return result;
}
pub fn Vector3Subtract(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = v1.x - v2.x,
        .y = v1.y - v2.y,
        .z = v1.z - v2.z,
    };
    return result;
}
pub fn Vector3SubtractValue(arg_v: Vector3, arg_sub: f32) callconv(.C) Vector3 {
    var v = arg_v;
    var sub = arg_sub;
    var result: Vector3 = Vector3{
        .x = v.x - sub,
        .y = v.y - sub,
        .z = v.z - sub,
    };
    return result;
}
pub fn Vector3Scale(arg_v: Vector3, arg_scalar: f32) callconv(.C) Vector3 {
    var v = arg_v;
    var scalar = arg_scalar;
    var result: Vector3 = Vector3{
        .x = v.x * scalar,
        .y = v.y * scalar,
        .z = v.z * scalar,
    };
    return result;
}
pub fn Vector3Multiply(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = v1.x * v2.x,
        .y = v1.y * v2.y,
        .z = v1.z * v2.z,
    };
    return result;
}
pub fn Vector3CrossProduct(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = (v1.y * v2.z) - (v1.z * v2.y),
        .y = (v1.z * v2.x) - (v1.x * v2.z),
        .z = (v1.x * v2.y) - (v1.y * v2.x),
    };
    return result;
}
pub fn Vector3Perpendicular(arg_v: Vector3) callconv(.C) Vector3 {
    var v = arg_v;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var min: f32 = @floatCast(f32, @fabs(@floatCast(f64, v.x)));
    var cardinalAxis: Vector3 = Vector3{
        .x = 1.0,
        .y = 0.0,
        .z = 0.0,
    };
    if (@fabs(v.y) < min) {
        min = @floatCast(f32, @fabs(@floatCast(f64, v.y)));
        var tmp: Vector3 = Vector3{
            .x = 0.0,
            .y = 1.0,
            .z = 0.0,
        };
        cardinalAxis = tmp;
    }
    if (@fabs(v.z) < min) {
        var tmp: Vector3 = Vector3{
            .x = 0.0,
            .y = 0.0,
            .z = 1.0,
        };
        cardinalAxis = tmp;
    }
    result.x = (v.y * cardinalAxis.z) - (v.z * cardinalAxis.y);
    result.y = (v.z * cardinalAxis.x) - (v.x * cardinalAxis.z);
    result.z = (v.x * cardinalAxis.y) - (v.y * cardinalAxis.x);
    return result;
}
pub fn Vector3Length(v: Vector3) callconv(.C) f32 {
    var result: f32 = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
    return result;
}
pub fn Vector3LengthSqr(v: Vector3) callconv(.C) f32 {
    var result: f32 = ((v.x * v.x) + (v.y * v.y)) + (v.z * v.z);
    return result;
}
pub fn Vector3DotProduct(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = ((v1.x * v2.x) + (v1.y * v2.y)) + (v1.z * v2.z);
    return result;
}
pub fn Vector3Distance(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = 0.0;
    var dx: f32 = v2.x - v1.x;
    var dy: f32 = v2.y - v1.y;
    var dz: f32 = v2.z - v1.z;
    result = @sqrt(((dx * dx) + (dy * dy)) + (dz * dz));
    return result;
}
pub fn Vector3DistanceSqr(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = 0.0;
    var dx: f32 = v2.x - v1.x;
    var dy: f32 = v2.y - v1.y;
    var dz: f32 = v2.z - v1.z;
    result = ((dx * dx) + (dy * dy)) + (dz * dz);
    return result;
}
pub fn Vector3Angle(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) f32 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: f32 = 0.0;
    var cross: Vector3 = Vector3{
        .x = (v1.y * v2.z) - (v1.z * v2.y),
        .y = (v1.z * v2.x) - (v1.x * v2.z),
        .z = (v1.x * v2.y) - (v1.y * v2.x),
    };
    var len: f32 = @sqrt(((cross.x * cross.x) + (cross.y * cross.y)) + (cross.z * cross.z));
    var dot: f32 = ((v1.x * v2.x) + (v1.y * v2.y)) + (v1.z * v2.z);
    result = atan2(f32, len, dot);
    return result;
}
pub fn Vector3Negate(arg_v: Vector3) callconv(.C) Vector3 {
    var v = arg_v;
    var result: Vector3 = Vector3{
        .x = -v.x,
        .y = -v.y,
        .z = -v.z,
    };
    return result;
}
pub fn Vector3Divide(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = v1.x / v2.x,
        .y = v1.y / v2.y,
        .z = v1.z / v2.z,
    };
    return result;
}
pub fn Vector3Normalize(arg_v: Vector3) callconv(.C) Vector3 {
    var v = arg_v;
    var result: Vector3 = v;
    var length: f32 = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
    if (length == 0.0) {
        length = 1.0;
    }
    var ilength: f32 = 1.0 / length;
    result.x *= ilength;
    result.y *= ilength;
    result.z *= ilength;
    return result;
}
pub fn Vector3OrthoNormalize(arg_v1: [*c]Vector3, arg_v2: [*c]Vector3) callconv(.C) void {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var length: f32 = 0.0;
    var ilength: f32 = 0.0;
    var v: Vector3 = v1.*;
    length = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
    if (length == 0.0) {
        length = 1.0;
    }
    ilength = 1.0 / length;
    v1.*.x *= ilength;
    v1.*.y *= ilength;
    v1.*.z *= ilength;
    var vn1: Vector3 = Vector3{
        .x = (v1.*.y * v2.*.z) - (v1.*.z * v2.*.y),
        .y = (v1.*.z * v2.*.x) - (v1.*.x * v2.*.z),
        .z = (v1.*.x * v2.*.y) - (v1.*.y * v2.*.x),
    };
    v = vn1;
    length = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
    if (length == 0.0) {
        length = 1.0;
    }
    ilength = 1.0 / length;
    vn1.x *= ilength;
    vn1.y *= ilength;
    vn1.z *= ilength;
    var vn2: Vector3 = Vector3{
        .x = (vn1.y * v1.*.z) - (vn1.z * v1.*.y),
        .y = (vn1.z * v1.*.x) - (vn1.x * v1.*.z),
        .z = (vn1.x * v1.*.y) - (vn1.y * v1.*.x),
    };
    v2.* = vn2;
}
pub fn Vector3Transform(arg_v: Vector3, arg_mat: Matrix) Vector3 {
    var v = arg_v;
    var mat = arg_mat;
    var result: Vector3 = Vector3{
        .x = 0,
        .y = 0,
        .z = 0,
    };
    var x: f32 = v.x;
    var y: f32 = v.y;
    var z: f32 = v.z;
    result.x = (((mat.m0 * x) + (mat.m4 * y)) + (mat.m8 * z)) + mat.m12;
    result.y = (((mat.m1 * x) + (mat.m5 * y)) + (mat.m9 * z)) + mat.m13;
    result.z = (((mat.m2 * x) + (mat.m6 * y)) + (mat.m10 * z)) + mat.m14;
    return result;
}
pub fn Vector3RotateByQuaternion(arg_v: Vector3, arg_q: Quaternion) callconv(.C) Vector3 {
    var v = arg_v;
    var q = arg_q;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    result.x = ((v.x * ((((q.x * q.x) + (q.w * q.w)) - (q.y * q.y)) - (q.z * q.z))) + (v.y * (((@intToFloat(f32, @as(c_int, 2)) * q.x) * q.y) - ((@intToFloat(f32, @as(c_int, 2)) * q.w) * q.z)))) + (v.z * (((@intToFloat(f32, @as(c_int, 2)) * q.x) * q.z) + ((@intToFloat(f32, @as(c_int, 2)) * q.w) * q.y)));
    result.y = ((v.x * (((@intToFloat(f32, @as(c_int, 2)) * q.w) * q.z) + ((@intToFloat(f32, @as(c_int, 2)) * q.x) * q.y))) + (v.y * ((((q.w * q.w) - (q.x * q.x)) + (q.y * q.y)) - (q.z * q.z)))) + (v.z * (((@intToFloat(f32, -@as(c_int, 2)) * q.w) * q.x) + ((@intToFloat(f32, @as(c_int, 2)) * q.y) * q.z)));
    result.z = ((v.x * (((@intToFloat(f32, -@as(c_int, 2)) * q.w) * q.y) + ((@intToFloat(f32, @as(c_int, 2)) * q.x) * q.z))) + (v.y * (((@intToFloat(f32, @as(c_int, 2)) * q.w) * q.x) + ((@intToFloat(f32, @as(c_int, 2)) * q.y) * q.z)))) + (v.z * ((((q.w * q.w) - (q.x * q.x)) - (q.y * q.y)) + (q.z * q.z)));
    return result;
}
pub fn Vector3Lerp(arg_v1: Vector3, arg_v2: Vector3, arg_amount: f32) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var amount = arg_amount;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    result.x = v1.x + (amount * (v2.x - v1.x));
    result.y = v1.y + (amount * (v2.y - v1.y));
    result.z = v1.z + (amount * (v2.z - v1.z));
    return result;
}
pub fn Vector3Reflect(arg_v: Vector3, arg_normal: Vector3) callconv(.C) Vector3 {
    var v = arg_v;
    var normal = arg_normal;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var dotProduct: f32 = ((v.x * normal.x) + (v.y * normal.y)) + (v.z * normal.z);
    result.x = v.x - ((2.0 * normal.x) * dotProduct);
    result.y = v.y - ((2.0 * normal.y) * dotProduct);
    result.z = v.z - ((2.0 * normal.z) * dotProduct);
    return result;
}
pub fn Vector3Min(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    result.x = @minimum(v1.x, v2.x);
    result.y = @minimum(v1.y, v2.y);
    result.z = @minimum(v1.z, v2.z);
    return result;
}
pub fn Vector3Max(arg_v1: Vector3, arg_v2: Vector3) callconv(.C) Vector3 {
    var v1 = arg_v1;
    var v2 = arg_v2;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    result.x = @maximum(v1.x, v2.x);
    result.y = @maximum(v1.y, v2.y);
    result.z = @maximum(v1.z, v2.z);
    return result;
}
pub fn Vector3Barycenter(arg_p: Vector3, arg_a: Vector3, arg_b: Vector3, arg_c: Vector3) callconv(.C) Vector3 {
    var p = arg_p;
    var a = arg_a;
    var b = arg_b;
    var c = arg_c;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var v0: Vector3 = Vector3{
        .x = b.x - a.x,
        .y = b.y - a.y,
        .z = b.z - a.z,
    };
    var v1: Vector3 = Vector3{
        .x = c.x - a.x,
        .y = c.y - a.y,
        .z = c.z - a.z,
    };
    var v2: Vector3 = Vector3{
        .x = p.x - a.x,
        .y = p.y - a.y,
        .z = p.z - a.z,
    };
    var d00: f32 = ((v0.x * v0.x) + (v0.y * v0.y)) + (v0.z * v0.z);
    var d01: f32 = ((v0.x * v1.x) + (v0.y * v1.y)) + (v0.z * v1.z);
    var d11: f32 = ((v1.x * v1.x) + (v1.y * v1.y)) + (v1.z * v1.z);
    var d20: f32 = ((v2.x * v0.x) + (v2.y * v0.y)) + (v2.z * v0.z);
    var d21: f32 = ((v2.x * v1.x) + (v2.y * v1.y)) + (v2.z * v1.z);
    var denom: f32 = (d00 * d11) - (d01 * d01);
    result.y = ((d11 * d20) - (d01 * d21)) / denom;
    result.z = ((d00 * d21) - (d01 * d20)) / denom;
    result.x = 1.0 - (result.z + result.y);
    return result;
}
pub fn Vector3Unproject(arg_source: Vector3, arg_projection: Matrix, arg_view: Matrix) callconv(.C) Vector3 {
    var source = arg_source;
    var projection = arg_projection;
    var view = arg_view;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var matViewProj: Matrix = Matrix{
        .m0 = (((view.m0 * projection.m0) + (view.m1 * projection.m4)) + (view.m2 * projection.m8)) + (view.m3 * projection.m12),
        .m4 = (((view.m0 * projection.m1) + (view.m1 * projection.m5)) + (view.m2 * projection.m9)) + (view.m3 * projection.m13),
        .m8 = (((view.m0 * projection.m2) + (view.m1 * projection.m6)) + (view.m2 * projection.m10)) + (view.m3 * projection.m14),
        .m12 = (((view.m0 * projection.m3) + (view.m1 * projection.m7)) + (view.m2 * projection.m11)) + (view.m3 * projection.m15),
        .m1 = (((view.m4 * projection.m0) + (view.m5 * projection.m4)) + (view.m6 * projection.m8)) + (view.m7 * projection.m12),
        .m5 = (((view.m4 * projection.m1) + (view.m5 * projection.m5)) + (view.m6 * projection.m9)) + (view.m7 * projection.m13),
        .m9 = (((view.m4 * projection.m2) + (view.m5 * projection.m6)) + (view.m6 * projection.m10)) + (view.m7 * projection.m14),
        .m13 = (((view.m4 * projection.m3) + (view.m5 * projection.m7)) + (view.m6 * projection.m11)) + (view.m7 * projection.m15),
        .m2 = (((view.m8 * projection.m0) + (view.m9 * projection.m4)) + (view.m10 * projection.m8)) + (view.m11 * projection.m12),
        .m6 = (((view.m8 * projection.m1) + (view.m9 * projection.m5)) + (view.m10 * projection.m9)) + (view.m11 * projection.m13),
        .m10 = (((view.m8 * projection.m2) + (view.m9 * projection.m6)) + (view.m10 * projection.m10)) + (view.m11 * projection.m14),
        .m14 = (((view.m8 * projection.m3) + (view.m9 * projection.m7)) + (view.m10 * projection.m11)) + (view.m11 * projection.m15),
        .m3 = (((view.m12 * projection.m0) + (view.m13 * projection.m4)) + (view.m14 * projection.m8)) + (view.m15 * projection.m12),
        .m7 = (((view.m12 * projection.m1) + (view.m13 * projection.m5)) + (view.m14 * projection.m9)) + (view.m15 * projection.m13),
        .m11 = (((view.m12 * projection.m2) + (view.m13 * projection.m6)) + (view.m14 * projection.m10)) + (view.m15 * projection.m14),
        .m15 = (((view.m12 * projection.m3) + (view.m13 * projection.m7)) + (view.m14 * projection.m11)) + (view.m15 * projection.m15),
    };
    var a00: f32 = matViewProj.m0;
    var a01: f32 = matViewProj.m1;
    var a02: f32 = matViewProj.m2;
    var a03: f32 = matViewProj.m3;
    var a10: f32 = matViewProj.m4;
    var a11: f32 = matViewProj.m5;
    var a12: f32 = matViewProj.m6;
    var a13: f32 = matViewProj.m7;
    var a20: f32 = matViewProj.m8;
    var a21: f32 = matViewProj.m9;
    var a22: f32 = matViewProj.m10;
    var a23: f32 = matViewProj.m11;
    var a30: f32 = matViewProj.m12;
    var a31: f32 = matViewProj.m13;
    var a32: f32 = matViewProj.m14;
    var a33: f32 = matViewProj.m15;
    var b00: f32 = (a00 * a11) - (a01 * a10);
    var b01: f32 = (a00 * a12) - (a02 * a10);
    var b02: f32 = (a00 * a13) - (a03 * a10);
    var b03: f32 = (a01 * a12) - (a02 * a11);
    var b04: f32 = (a01 * a13) - (a03 * a11);
    var b05: f32 = (a02 * a13) - (a03 * a12);
    var b06: f32 = (a20 * a31) - (a21 * a30);
    var b07: f32 = (a20 * a32) - (a22 * a30);
    var b08: f32 = (a20 * a33) - (a23 * a30);
    var b09: f32 = (a21 * a32) - (a22 * a31);
    var b10: f32 = (a21 * a33) - (a23 * a31);
    var b11: f32 = (a22 * a33) - (a23 * a32);
    var invDet: f32 = 1.0 / ((((((b00 * b11) - (b01 * b10)) + (b02 * b09)) + (b03 * b08)) - (b04 * b07)) + (b05 * b06));
    var matViewProjInv: Matrix = Matrix{
        .m0 = (((a11 * b11) - (a12 * b10)) + (a13 * b09)) * invDet,
        .m4 = (((-a01 * b11) + (a02 * b10)) - (a03 * b09)) * invDet,
        .m8 = (((a31 * b05) - (a32 * b04)) + (a33 * b03)) * invDet,
        .m12 = (((-a21 * b05) + (a22 * b04)) - (a23 * b03)) * invDet,
        .m1 = (((-a10 * b11) + (a12 * b08)) - (a13 * b07)) * invDet,
        .m5 = (((a00 * b11) - (a02 * b08)) + (a03 * b07)) * invDet,
        .m9 = (((-a30 * b05) + (a32 * b02)) - (a33 * b01)) * invDet,
        .m13 = (((a20 * b05) - (a22 * b02)) + (a23 * b01)) * invDet,
        .m2 = (((a10 * b10) - (a11 * b08)) + (a13 * b06)) * invDet,
        .m6 = (((-a00 * b10) + (a01 * b08)) - (a03 * b06)) * invDet,
        .m10 = (((a30 * b04) - (a31 * b02)) + (a33 * b00)) * invDet,
        .m14 = (((-a20 * b04) + (a21 * b02)) - (a23 * b00)) * invDet,
        .m3 = (((-a10 * b09) + (a11 * b07)) - (a12 * b06)) * invDet,
        .m7 = (((a00 * b09) - (a01 * b07)) + (a02 * b06)) * invDet,
        .m11 = (((-a30 * b03) + (a31 * b01)) - (a32 * b00)) * invDet,
        .m15 = (((a20 * b03) - (a21 * b01)) + (a22 * b00)) * invDet,
    };
    var quat: Quaternion = Quaternion{
        .x = source.x,
        .y = source.y,
        .z = source.z,
        .w = 1.0,
    };
    var qtransformed: Quaternion = Quaternion{
        .x = (((matViewProjInv.m0 * quat.x) + (matViewProjInv.m4 * quat.y)) + (matViewProjInv.m8 * quat.z)) + (matViewProjInv.m12 * quat.w),
        .y = (((matViewProjInv.m1 * quat.x) + (matViewProjInv.m5 * quat.y)) + (matViewProjInv.m9 * quat.z)) + (matViewProjInv.m13 * quat.w),
        .z = (((matViewProjInv.m2 * quat.x) + (matViewProjInv.m6 * quat.y)) + (matViewProjInv.m10 * quat.z)) + (matViewProjInv.m14 * quat.w),
        .w = (((matViewProjInv.m3 * quat.x) + (matViewProjInv.m7 * quat.y)) + (matViewProjInv.m11 * quat.z)) + (matViewProjInv.m15 * quat.w),
    };
    result.x = qtransformed.x / qtransformed.w;
    result.y = qtransformed.y / qtransformed.w;
    result.z = qtransformed.z / qtransformed.w;
    return result;
}
pub fn Vector3ToFloatV(arg_v: Vector3) callconv(.C) float3 {
    var v = arg_v;
    var buffer: float3 = float3{
        .v = [1]f32{
            0,
        } ++ [1]f32{0} ** 2,
    };
    buffer.v[@intCast(c_uint, @as(c_int, 0))] = v.x;
    buffer.v[@intCast(c_uint, @as(c_int, 1))] = v.y;
    buffer.v[@intCast(c_uint, @as(c_int, 2))] = v.z;
    return buffer;
}
pub fn Vector3Invert(arg_v: Vector3) callconv(.C) Vector3 {
    var v = arg_v;
    var result: Vector3 = Vector3{
        .x = 1.0 / v.x,
        .y = 1.0 / v.y,
        .z = 1.0 / v.z,
    };
    return result;
}
pub fn Vector3Clamp(arg_v: Vector3, arg_min: Vector3, arg_max: Vector3) callconv(.C) Vector3 {
    var v = arg_v;
    var min = arg_min;
    var max = arg_max;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    result.x = @minimum(max.x, @maximum(min.x, v.x));
    result.y = @minimum(max.y, @maximum(min.y, v.y));
    result.z = @minimum(max.z, @maximum(min.z, v.z));
    return result;
}
pub fn Vector3ClampValue(arg_v: Vector3, arg_min: f32, arg_max: f32) callconv(.C) Vector3 {
    var v = arg_v;
    var min = arg_min;
    var max = arg_max;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var length: f32 = ((v.x * v.x) + (v.y * v.y)) + (v.z * v.z);
    if (length > 0.0) {
        length = @sqrt(length);
        if (length < min) {
            var scale: f32 = min / length;
            result.x = v.x * scale;
            result.y = v.y * scale;
            result.z = v.z * scale;
        } else if (length > max) {
            var scale: f32 = max / length;
            result.x = v.x * scale;
            result.y = v.y * scale;
            result.z = v.z * scale;
        }
    }
    return result;
}
pub fn Vector3Equals(arg_p: Vector3, arg_q: Vector3) callconv(.C) c_int {
    var p = arg_p;
    var q = arg_q;
    var result: c_int = @boolToInt(((@fabs(p.x - q.x) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.x), @fabs(q.x))))) and (@fabs(p.y - q.y) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.y), @fabs(q.y)))))) and (@fabs(p.z - q.z) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.z), @fabs(q.z))))));
    return result;
}
pub fn Vector3Refract(arg_v: Vector3, arg_n: Vector3, arg_r: f32) callconv(.C) Vector3 {
    var v = arg_v;
    var n = arg_n;
    var r = arg_r;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var dot: f32 = ((v.x * n.x) + (v.y * n.y)) + (v.z * n.z);
    var d: f32 = 1.0 - ((r * r) * (1.0 - (dot * dot)));
    if (d >= 0.0) {
        d = @sqrt(d);
        v.x = (r * v.x) - (((r * dot) + d) * n.x);
        v.y = (r * v.y) - (((r * dot) + d) * n.y);
        v.z = (r * v.z) - (((r * dot) + d) * n.z);
        result = v;
    }
    return result;
}
pub fn MatrixDeterminant(arg_mat: Matrix) callconv(.C) f32 {
    var mat = arg_mat;
    var result: f32 = 0.0;
    var a00: f32 = mat.m0;
    var a01: f32 = mat.m1;
    var a02: f32 = mat.m2;
    var a03: f32 = mat.m3;
    var a10: f32 = mat.m4;
    var a11: f32 = mat.m5;
    var a12: f32 = mat.m6;
    var a13: f32 = mat.m7;
    var a20: f32 = mat.m8;
    var a21: f32 = mat.m9;
    var a22: f32 = mat.m10;
    var a23: f32 = mat.m11;
    var a30: f32 = mat.m12;
    var a31: f32 = mat.m13;
    var a32: f32 = mat.m14;
    var a33: f32 = mat.m15;
    result = (((((((((((((((((((((((((a30 * a21) * a12) * a03) - (((a20 * a31) * a12) * a03)) - (((a30 * a11) * a22) * a03)) + (((a10 * a31) * a22) * a03)) + (((a20 * a11) * a32) * a03)) - (((a10 * a21) * a32) * a03)) - (((a30 * a21) * a02) * a13)) + (((a20 * a31) * a02) * a13)) + (((a30 * a01) * a22) * a13)) - (((a00 * a31) * a22) * a13)) - (((a20 * a01) * a32) * a13)) + (((a00 * a21) * a32) * a13)) + (((a30 * a11) * a02) * a23)) - (((a10 * a31) * a02) * a23)) - (((a30 * a01) * a12) * a23)) + (((a00 * a31) * a12) * a23)) + (((a10 * a01) * a32) * a23)) - (((a00 * a11) * a32) * a23)) - (((a20 * a11) * a02) * a33)) + (((a10 * a21) * a02) * a33)) + (((a20 * a01) * a12) * a33)) - (((a00 * a21) * a12) * a33)) - (((a10 * a01) * a22) * a33)) + (((a00 * a11) * a22) * a33);
    return result;
}
pub fn MatrixTrace(arg_mat: Matrix) callconv(.C) f32 {
    var mat = arg_mat;
    var result: f32 = ((mat.m0 + mat.m5) + mat.m10) + mat.m15;
    return result;
}
pub fn MatrixTranspose(arg_mat: Matrix) callconv(.C) Matrix {
    var mat = arg_mat;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    result.m0 = mat.m0;
    result.m1 = mat.m4;
    result.m2 = mat.m8;
    result.m3 = mat.m12;
    result.m4 = mat.m1;
    result.m5 = mat.m5;
    result.m6 = mat.m9;
    result.m7 = mat.m13;
    result.m8 = mat.m2;
    result.m9 = mat.m6;
    result.m10 = mat.m10;
    result.m11 = mat.m14;
    result.m12 = mat.m3;
    result.m13 = mat.m7;
    result.m14 = mat.m11;
    result.m15 = mat.m15;
    return result;
}
pub fn MatrixInvert(arg_mat: Matrix) callconv(.C) Matrix {
    var mat = arg_mat;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var a00: f32 = mat.m0;
    var a01: f32 = mat.m1;
    var a02: f32 = mat.m2;
    var a03: f32 = mat.m3;
    var a10: f32 = mat.m4;
    var a11: f32 = mat.m5;
    var a12: f32 = mat.m6;
    var a13: f32 = mat.m7;
    var a20: f32 = mat.m8;
    var a21: f32 = mat.m9;
    var a22: f32 = mat.m10;
    var a23: f32 = mat.m11;
    var a30: f32 = mat.m12;
    var a31: f32 = mat.m13;
    var a32: f32 = mat.m14;
    var a33: f32 = mat.m15;
    var b00: f32 = (a00 * a11) - (a01 * a10);
    var b01: f32 = (a00 * a12) - (a02 * a10);
    var b02: f32 = (a00 * a13) - (a03 * a10);
    var b03: f32 = (a01 * a12) - (a02 * a11);
    var b04: f32 = (a01 * a13) - (a03 * a11);
    var b05: f32 = (a02 * a13) - (a03 * a12);
    var b06: f32 = (a20 * a31) - (a21 * a30);
    var b07: f32 = (a20 * a32) - (a22 * a30);
    var b08: f32 = (a20 * a33) - (a23 * a30);
    var b09: f32 = (a21 * a32) - (a22 * a31);
    var b10: f32 = (a21 * a33) - (a23 * a31);
    var b11: f32 = (a22 * a33) - (a23 * a32);
    var invDet: f32 = 1.0 / ((((((b00 * b11) - (b01 * b10)) + (b02 * b09)) + (b03 * b08)) - (b04 * b07)) + (b05 * b06));
    result.m0 = (((a11 * b11) - (a12 * b10)) + (a13 * b09)) * invDet;
    result.m1 = (((-a01 * b11) + (a02 * b10)) - (a03 * b09)) * invDet;
    result.m2 = (((a31 * b05) - (a32 * b04)) + (a33 * b03)) * invDet;
    result.m3 = (((-a21 * b05) + (a22 * b04)) - (a23 * b03)) * invDet;
    result.m4 = (((-a10 * b11) + (a12 * b08)) - (a13 * b07)) * invDet;
    result.m5 = (((a00 * b11) - (a02 * b08)) + (a03 * b07)) * invDet;
    result.m6 = (((-a30 * b05) + (a32 * b02)) - (a33 * b01)) * invDet;
    result.m7 = (((a20 * b05) - (a22 * b02)) + (a23 * b01)) * invDet;
    result.m8 = (((a10 * b10) - (a11 * b08)) + (a13 * b06)) * invDet;
    result.m9 = (((-a00 * b10) + (a01 * b08)) - (a03 * b06)) * invDet;
    result.m10 = (((a30 * b04) - (a31 * b02)) + (a33 * b00)) * invDet;
    result.m11 = (((-a20 * b04) + (a21 * b02)) - (a23 * b00)) * invDet;
    result.m12 = (((-a10 * b09) + (a11 * b07)) - (a12 * b06)) * invDet;
    result.m13 = (((a00 * b09) - (a01 * b07)) + (a02 * b06)) * invDet;
    result.m14 = (((-a30 * b03) + (a31 * b01)) - (a32 * b00)) * invDet;
    result.m15 = (((a20 * b03) - (a21 * b01)) + (a22 * b00)) * invDet;
    return result;
}
pub fn MatrixIdentity() callconv(.C) Matrix {
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    return result;
}
pub fn MatrixAdd(arg_left: Matrix, arg_right: Matrix) callconv(.C) Matrix {
    var left = arg_left;
    var right = arg_right;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    result.m0 = left.m0 + right.m0;
    result.m1 = left.m1 + right.m1;
    result.m2 = left.m2 + right.m2;
    result.m3 = left.m3 + right.m3;
    result.m4 = left.m4 + right.m4;
    result.m5 = left.m5 + right.m5;
    result.m6 = left.m6 + right.m6;
    result.m7 = left.m7 + right.m7;
    result.m8 = left.m8 + right.m8;
    result.m9 = left.m9 + right.m9;
    result.m10 = left.m10 + right.m10;
    result.m11 = left.m11 + right.m11;
    result.m12 = left.m12 + right.m12;
    result.m13 = left.m13 + right.m13;
    result.m14 = left.m14 + right.m14;
    result.m15 = left.m15 + right.m15;
    return result;
}
pub fn MatrixSubtract(arg_left: Matrix, arg_right: Matrix) callconv(.C) Matrix {
    var left = arg_left;
    var right = arg_right;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    result.m0 = left.m0 - right.m0;
    result.m1 = left.m1 - right.m1;
    result.m2 = left.m2 - right.m2;
    result.m3 = left.m3 - right.m3;
    result.m4 = left.m4 - right.m4;
    result.m5 = left.m5 - right.m5;
    result.m6 = left.m6 - right.m6;
    result.m7 = left.m7 - right.m7;
    result.m8 = left.m8 - right.m8;
    result.m9 = left.m9 - right.m9;
    result.m10 = left.m10 - right.m10;
    result.m11 = left.m11 - right.m11;
    result.m12 = left.m12 - right.m12;
    result.m13 = left.m13 - right.m13;
    result.m14 = left.m14 - right.m14;
    result.m15 = left.m15 - right.m15;
    return result;
}
pub fn MatrixMultiply(arg_left: Matrix, arg_right: Matrix) callconv(.C) Matrix {
    var left = arg_left;
    var right = arg_right;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    result.m0 = (((left.m0 * right.m0) + (left.m1 * right.m4)) + (left.m2 * right.m8)) + (left.m3 * right.m12);
    result.m1 = (((left.m0 * right.m1) + (left.m1 * right.m5)) + (left.m2 * right.m9)) + (left.m3 * right.m13);
    result.m2 = (((left.m0 * right.m2) + (left.m1 * right.m6)) + (left.m2 * right.m10)) + (left.m3 * right.m14);
    result.m3 = (((left.m0 * right.m3) + (left.m1 * right.m7)) + (left.m2 * right.m11)) + (left.m3 * right.m15);
    result.m4 = (((left.m4 * right.m0) + (left.m5 * right.m4)) + (left.m6 * right.m8)) + (left.m7 * right.m12);
    result.m5 = (((left.m4 * right.m1) + (left.m5 * right.m5)) + (left.m6 * right.m9)) + (left.m7 * right.m13);
    result.m6 = (((left.m4 * right.m2) + (left.m5 * right.m6)) + (left.m6 * right.m10)) + (left.m7 * right.m14);
    result.m7 = (((left.m4 * right.m3) + (left.m5 * right.m7)) + (left.m6 * right.m11)) + (left.m7 * right.m15);
    result.m8 = (((left.m8 * right.m0) + (left.m9 * right.m4)) + (left.m10 * right.m8)) + (left.m11 * right.m12);
    result.m9 = (((left.m8 * right.m1) + (left.m9 * right.m5)) + (left.m10 * right.m9)) + (left.m11 * right.m13);
    result.m10 = (((left.m8 * right.m2) + (left.m9 * right.m6)) + (left.m10 * right.m10)) + (left.m11 * right.m14);
    result.m11 = (((left.m8 * right.m3) + (left.m9 * right.m7)) + (left.m10 * right.m11)) + (left.m11 * right.m15);
    result.m12 = (((left.m12 * right.m0) + (left.m13 * right.m4)) + (left.m14 * right.m8)) + (left.m15 * right.m12);
    result.m13 = (((left.m12 * right.m1) + (left.m13 * right.m5)) + (left.m14 * right.m9)) + (left.m15 * right.m13);
    result.m14 = (((left.m12 * right.m2) + (left.m13 * right.m6)) + (left.m14 * right.m10)) + (left.m15 * right.m14);
    result.m15 = (((left.m12 * right.m3) + (left.m13 * right.m7)) + (left.m14 * right.m11)) + (left.m15 * right.m15);
    return result;
}
pub fn MatrixTranslate(arg_x: f32, arg_y: f32, arg_z: f32) callconv(.C) Matrix {
    var x = arg_x;
    var y = arg_y;
    var z = arg_z;
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = x,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = y,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = z,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    return result;
}
pub fn MatrixRotate(arg_axis: Vector3, arg_angle: f32) callconv(.C) Matrix {
    var axis = arg_axis;
    var angle = arg_angle;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var x: f32 = axis.x;
    var y: f32 = axis.y;
    var z: f32 = axis.z;
    var lengthSquared: f32 = ((x * x) + (y * y)) + (z * z);
    if ((lengthSquared != 1.0) and (lengthSquared != 0.0)) {
        var ilength: f32 = 1.0 / @sqrt(lengthSquared);
        x *= ilength;
        y *= ilength;
        z *= ilength;
    }
    var sinres: f32 = @sin(angle);
    var cosres: f32 = @cos(angle);
    var t: f32 = 1.0 - cosres;
    result.m0 = ((x * x) * t) + cosres;
    result.m1 = ((y * x) * t) + (z * sinres);
    result.m2 = ((z * x) * t) - (y * sinres);
    result.m3 = 0.0;
    result.m4 = ((x * y) * t) - (z * sinres);
    result.m5 = ((y * y) * t) + cosres;
    result.m6 = ((z * y) * t) + (x * sinres);
    result.m7 = 0.0;
    result.m8 = ((x * z) * t) + (y * sinres);
    result.m9 = ((y * z) * t) - (x * sinres);
    result.m10 = ((z * z) * t) + cosres;
    result.m11 = 0.0;
    result.m12 = 0.0;
    result.m13 = 0.0;
    result.m14 = 0.0;
    result.m15 = 1.0;
    return result;
}
pub fn MatrixRotateX(arg_angle: f32) callconv(.C) Matrix {
    var angle = arg_angle;
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    var cosres: f32 = @cos(angle);
    var sinres: f32 = @sin(angle);
    result.m5 = cosres;
    result.m6 = -sinres;
    result.m9 = sinres;
    result.m10 = cosres;
    return result;
}
pub fn MatrixRotateY(arg_angle: f32) callconv(.C) Matrix {
    var angle = arg_angle;
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    var cosres: f32 = @cos(angle);
    var sinres: f32 = @sin(angle);
    result.m0 = cosres;
    result.m2 = sinres;
    result.m8 = -sinres;
    result.m10 = cosres;
    return result;
}
pub fn MatrixRotateZ(arg_angle: f32) callconv(.C) Matrix {
    var angle = arg_angle;
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    var cosres: f32 = @cos(angle);
    var sinres: f32 = @sin(angle);
    result.m0 = cosres;
    result.m1 = -sinres;
    result.m4 = sinres;
    result.m5 = cosres;
    return result;
}
pub fn MatrixRotateXYZ(arg_ang: Vector3) callconv(.C) Matrix {
    var ang = arg_ang;
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    var cosz: f32 = @cos(-ang.z);
    var sinz: f32 = @sin(-ang.z);
    var cosy: f32 = @cos(-ang.y);
    var siny: f32 = @sin(-ang.y);
    var cosx: f32 = @cos(-ang.x);
    var sinx: f32 = @sin(-ang.x);
    result.m0 = cosz * cosy;
    result.m4 = ((cosz * siny) * sinx) - (sinz * cosx);
    result.m8 = ((cosz * siny) * cosx) + (sinz * sinx);
    result.m1 = sinz * cosy;
    result.m5 = ((sinz * siny) * sinx) + (cosz * cosx);
    result.m9 = ((sinz * siny) * cosx) - (cosz * sinx);
    result.m2 = -siny;
    result.m6 = cosy * sinx;
    result.m10 = cosy * cosx;
    return result;
}
pub fn MatrixRotateZYX(arg_ang: Vector3) callconv(.C) Matrix {
    var ang = arg_ang;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var cz: f32 = @cos(ang.z);
    var sz: f32 = @sin(ang.z);
    var cy: f32 = @cos(ang.y);
    var sy: f32 = @sin(ang.y);
    var cx: f32 = @cos(ang.x);
    var sx: f32 = @sin(ang.x);
    result.m0 = cz * cy;
    result.m1 = ((cz * sy) * sx) - (cx * sz);
    result.m2 = (sz * sx) + ((cz * cx) * sy);
    result.m3 = 0;
    result.m4 = cy * sz;
    result.m5 = (cz * cx) + ((sz * sy) * sx);
    result.m6 = ((cx * sz) * sy) - (cz * sx);
    result.m7 = 0;
    result.m8 = -sy;
    result.m9 = cy * sx;
    result.m10 = cy * cx;
    result.m11 = 0;
    result.m12 = 0;
    result.m13 = 0;
    result.m14 = 0;
    result.m15 = 1;
    return result;
}
pub fn MatrixScale(arg_x: f32, arg_y: f32, arg_z: f32) callconv(.C) Matrix {
    var x = arg_x;
    var y = arg_y;
    var z = arg_z;
    var result: Matrix = Matrix{
        .m0 = x,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = y,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = z,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    return result;
}
pub fn MatrixFrustum(arg_left: f64, arg_right: f64, arg_bottom: f64, arg_top: f64, arg_near: f64, arg_far: f64) callconv(.C) Matrix {
    var left = arg_left;
    var right = arg_right;
    var bottom = arg_bottom;
    var top = arg_top;
    var near = arg_near;
    var far = arg_far;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var rl: f32 = @floatCast(f32, right - left);
    var tb: f32 = @floatCast(f32, top - bottom);
    var @"fn": f32 = @floatCast(f32, far - near);
    result.m0 = (@floatCast(f32, near) * 2.0) / rl;
    result.m1 = 0.0;
    result.m2 = 0.0;
    result.m3 = 0.0;
    result.m4 = 0.0;
    result.m5 = (@floatCast(f32, near) * 2.0) / tb;
    result.m6 = 0.0;
    result.m7 = 0.0;
    result.m8 = (@floatCast(f32, right) + @floatCast(f32, left)) / rl;
    result.m9 = (@floatCast(f32, top) + @floatCast(f32, bottom)) / tb;
    result.m10 = -(@floatCast(f32, far) + @floatCast(f32, near)) / @"fn";
    result.m11 = -1.0;
    result.m12 = 0.0;
    result.m13 = 0.0;
    result.m14 = -((@floatCast(f32, far) * @floatCast(f32, near)) * 2.0) / @"fn";
    result.m15 = 0.0;
    return result;
}
pub fn MatrixPerspective(arg_fovy: f64, arg_aspect: f64, arg_near: f64, arg_far: f64) callconv(.C) Matrix {
    var fovy = arg_fovy;
    var aspect = arg_aspect;
    var near = arg_near;
    var far = arg_far;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var top: f64 = near * @tan(fovy * 0.5);
    var bottom: f64 = -top;
    var right: f64 = top * aspect;
    var left: f64 = -right;
    var rl: f32 = @floatCast(f32, right - left);
    var tb: f32 = @floatCast(f32, top - bottom);
    var @"fn": f32 = @floatCast(f32, far - near);
    result.m0 = (@floatCast(f32, near) * 2.0) / rl;
    result.m5 = (@floatCast(f32, near) * 2.0) / tb;
    result.m8 = (@floatCast(f32, right) + @floatCast(f32, left)) / rl;
    result.m9 = (@floatCast(f32, top) + @floatCast(f32, bottom)) / tb;
    result.m10 = -(@floatCast(f32, far) + @floatCast(f32, near)) / @"fn";
    result.m11 = -1.0;
    result.m14 = -((@floatCast(f32, far) * @floatCast(f32, near)) * 2.0) / @"fn";
    return result;
}
pub fn MatrixOrtho(arg_left: f64, arg_right: f64, arg_bottom: f64, arg_top: f64, arg_near: f64, arg_far: f64) callconv(.C) Matrix {
    var left = arg_left;
    var right = arg_right;
    var bottom = arg_bottom;
    var top = arg_top;
    var near = arg_near;
    var far = arg_far;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var rl: f32 = @floatCast(f32, right - left);
    var tb: f32 = @floatCast(f32, top - bottom);
    var @"fn": f32 = @floatCast(f32, far - near);
    result.m0 = 2.0 / rl;
    result.m1 = 0.0;
    result.m2 = 0.0;
    result.m3 = 0.0;
    result.m4 = 0.0;
    result.m5 = 2.0 / tb;
    result.m6 = 0.0;
    result.m7 = 0.0;
    result.m8 = 0.0;
    result.m9 = 0.0;
    result.m10 = -2.0 / @"fn";
    result.m11 = 0.0;
    result.m12 = -(@floatCast(f32, left) + @floatCast(f32, right)) / rl;
    result.m13 = -(@floatCast(f32, top) + @floatCast(f32, bottom)) / tb;
    result.m14 = -(@floatCast(f32, far) + @floatCast(f32, near)) / @"fn";
    result.m15 = 1.0;
    return result;
}
pub fn MatrixLookAt(arg_eye: Vector3, arg_target: Vector3, arg_up: Vector3) callconv(.C) Matrix {
    var eye = arg_eye;
    var target = arg_target;
    var up = arg_up;
    var result: Matrix = Matrix{
        .m0 = @intToFloat(f32, @as(c_int, 0)),
        .m4 = 0,
        .m8 = 0,
        .m12 = 0,
        .m1 = 0,
        .m5 = 0,
        .m9 = 0,
        .m13 = 0,
        .m2 = 0,
        .m6 = 0,
        .m10 = 0,
        .m14 = 0,
        .m3 = 0,
        .m7 = 0,
        .m11 = 0,
        .m15 = 0,
    };
    var length: f32 = 0.0;
    var ilength: f32 = 0.0;
    var vz: Vector3 = Vector3{
        .x = eye.x - target.x,
        .y = eye.y - target.y,
        .z = eye.z - target.z,
    };
    var v: Vector3 = vz;
    length = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
    if (length == 0.0) {
        length = 1.0;
    }
    ilength = 1.0 / length;
    vz.x *= ilength;
    vz.y *= ilength;
    vz.z *= ilength;
    var vx: Vector3 = Vector3{
        .x = (up.y * vz.z) - (up.z * vz.y),
        .y = (up.z * vz.x) - (up.x * vz.z),
        .z = (up.x * vz.y) - (up.y * vz.x),
    };
    v = vx;
    length = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
    if (length == 0.0) {
        length = 1.0;
    }
    ilength = 1.0 / length;
    vx.x *= ilength;
    vx.y *= ilength;
    vx.z *= ilength;
    var vy: Vector3 = Vector3{
        .x = (vz.y * vx.z) - (vz.z * vx.y),
        .y = (vz.z * vx.x) - (vz.x * vx.z),
        .z = (vz.x * vx.y) - (vz.y * vx.x),
    };
    result.m0 = vx.x;
    result.m1 = vy.x;
    result.m2 = vz.x;
    result.m3 = 0.0;
    result.m4 = vx.y;
    result.m5 = vy.y;
    result.m6 = vz.y;
    result.m7 = 0.0;
    result.m8 = vx.z;
    result.m9 = vy.z;
    result.m10 = vz.z;
    result.m11 = 0.0;
    result.m12 = -(((vx.x * eye.x) + (vx.y * eye.y)) + (vx.z * eye.z));
    result.m13 = -(((vy.x * eye.x) + (vy.y * eye.y)) + (vy.z * eye.z));
    result.m14 = -(((vz.x * eye.x) + (vz.y * eye.y)) + (vz.z * eye.z));
    result.m15 = 1.0;
    return result;
}
pub fn MatrixToFloatV(arg_mat: Matrix) callconv(.C) float16 {
    var mat = arg_mat;
    var result: float16 = float16{
        .v = [1]f32{
            0,
        } ++ [1]f32{0} ** 15,
    };
    result.v[@intCast(c_uint, @as(c_int, 0))] = mat.m0;
    result.v[@intCast(c_uint, @as(c_int, 1))] = mat.m1;
    result.v[@intCast(c_uint, @as(c_int, 2))] = mat.m2;
    result.v[@intCast(c_uint, @as(c_int, 3))] = mat.m3;
    result.v[@intCast(c_uint, @as(c_int, 4))] = mat.m4;
    result.v[@intCast(c_uint, @as(c_int, 5))] = mat.m5;
    result.v[@intCast(c_uint, @as(c_int, 6))] = mat.m6;
    result.v[@intCast(c_uint, @as(c_int, 7))] = mat.m7;
    result.v[@intCast(c_uint, @as(c_int, 8))] = mat.m8;
    result.v[@intCast(c_uint, @as(c_int, 9))] = mat.m9;
    result.v[@intCast(c_uint, @as(c_int, 10))] = mat.m10;
    result.v[@intCast(c_uint, @as(c_int, 11))] = mat.m11;
    result.v[@intCast(c_uint, @as(c_int, 12))] = mat.m12;
    result.v[@intCast(c_uint, @as(c_int, 13))] = mat.m13;
    result.v[@intCast(c_uint, @as(c_int, 14))] = mat.m14;
    result.v[@intCast(c_uint, @as(c_int, 15))] = mat.m15;
    return result;
}
pub fn QuaternionAdd(arg_q1: Quaternion, arg_q2: Quaternion) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var result: Quaternion = Quaternion{
        .x = q1.x + q2.x,
        .y = q1.y + q2.y,
        .z = q1.z + q2.z,
        .w = q1.w + q2.w,
    };
    return result;
}
pub fn QuaternionAddValue(arg_q: Quaternion, arg_add: f32) callconv(.C) Quaternion {
    var q = arg_q;
    var add = arg_add;
    var result: Quaternion = Quaternion{
        .x = q.x + add,
        .y = q.y + add,
        .z = q.z + add,
        .w = q.w + add,
    };
    return result;
}
pub fn QuaternionSubtract(arg_q1: Quaternion, arg_q2: Quaternion) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var result: Quaternion = Quaternion{
        .x = q1.x - q2.x,
        .y = q1.y - q2.y,
        .z = q1.z - q2.z,
        .w = q1.w - q2.w,
    };
    return result;
}
pub fn QuaternionSubtractValue(arg_q: Quaternion, arg_sub: f32) callconv(.C) Quaternion {
    var q = arg_q;
    var sub = arg_sub;
    var result: Quaternion = Quaternion{
        .x = q.x - sub,
        .y = q.y - sub,
        .z = q.z - sub,
        .w = q.w - sub,
    };
    return result;
}
pub fn QuaternionIdentity() callconv(.C) Quaternion {
    var result: Quaternion = Quaternion{
        .x = 0.0,
        .y = 0.0,
        .z = 0.0,
        .w = 1.0,
    };
    return result;
}
pub fn QuaternionLength(arg_q: Quaternion) callconv(.C) f32 {
    var q = arg_q;
    var result: f32 = @sqrt((((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w));
    return result;
}
pub fn QuaternionNormalize(arg_q: Quaternion) callconv(.C) Quaternion {
    var q = arg_q;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    var length: f32 = @sqrt((((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w));
    if (length == 0.0) {
        length = 1.0;
    }
    var ilength: f32 = 1.0 / length;
    result.x = q.x * ilength;
    result.y = q.y * ilength;
    result.z = q.z * ilength;
    result.w = q.w * ilength;
    return result;
}
pub fn QuaternionInvert(arg_q: Quaternion) callconv(.C) Quaternion {
    var q = arg_q;
    var result: Quaternion = q;
    var lengthSq: f32 = (((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w);
    if (lengthSq != 0.0) {
        var invLength: f32 = 1.0 / lengthSq;
        result.x *= -invLength;
        result.y *= -invLength;
        result.z *= -invLength;
        result.w *= invLength;
    }
    return result;
}
pub fn QuaternionMultiply(arg_q1: Quaternion, arg_q2: Quaternion) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    var qax: f32 = q1.x;
    var qay: f32 = q1.y;
    var qaz: f32 = q1.z;
    var qaw: f32 = q1.w;
    var qbx: f32 = q2.x;
    var qby: f32 = q2.y;
    var qbz: f32 = q2.z;
    var qbw: f32 = q2.w;
    result.x = (((qax * qbw) + (qaw * qbx)) + (qay * qbz)) - (qaz * qby);
    result.y = (((qay * qbw) + (qaw * qby)) + (qaz * qbx)) - (qax * qbz);
    result.z = (((qaz * qbw) + (qaw * qbz)) + (qax * qby)) - (qay * qbx);
    result.w = (((qaw * qbw) - (qax * qbx)) - (qay * qby)) - (qaz * qbz);
    return result;
}
pub fn QuaternionScale(arg_q: Quaternion, arg_mul: f32) callconv(.C) Quaternion {
    var q = arg_q;
    var mul = arg_mul;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    result.x = q.x * mul;
    result.y = q.y * mul;
    result.z = q.z * mul;
    result.w = q.w * mul;
    return result;
}
pub fn QuaternionDivide(arg_q1: Quaternion, arg_q2: Quaternion) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var result: Quaternion = Quaternion{
        .x = q1.x / q2.x,
        .y = q1.y / q2.y,
        .z = q1.z / q2.z,
        .w = q1.w / q2.w,
    };
    return result;
}
pub fn QuaternionLerp(arg_q1: Quaternion, arg_q2: Quaternion, arg_amount: f32) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var amount = arg_amount;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    result.x = q1.x + (amount * (q2.x - q1.x));
    result.y = q1.y + (amount * (q2.y - q1.y));
    result.z = q1.z + (amount * (q2.z - q1.z));
    result.w = q1.w + (amount * (q2.w - q1.w));
    return result;
}
pub fn QuaternionNlerp(arg_q1: Quaternion, arg_q2: Quaternion, arg_amount: f32) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var amount = arg_amount;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    result.x = q1.x + (amount * (q2.x - q1.x));
    result.y = q1.y + (amount * (q2.y - q1.y));
    result.z = q1.z + (amount * (q2.z - q1.z));
    result.w = q1.w + (amount * (q2.w - q1.w));
    var q: Quaternion = result;
    var length: f32 = @sqrt((((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w));
    if (length == 0.0) {
        length = 1.0;
    }
    var ilength: f32 = 1.0 / length;
    result.x = q.x * ilength;
    result.y = q.y * ilength;
    result.z = q.z * ilength;
    result.w = q.w * ilength;
    return result;
}
pub fn QuaternionSlerp(arg_q1: Quaternion, arg_q2: Quaternion, arg_amount: f32) callconv(.C) Quaternion {
    var q1 = arg_q1;
    var q2 = arg_q2;
    var amount = arg_amount;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    var cosHalfTheta: f32 = (((q1.x * q2.x) + (q1.y * q2.y)) + (q1.z * q2.z)) + (q1.w * q2.w);
    if (cosHalfTheta < @intToFloat(f32, @as(c_int, 0))) {
        q2.x = -q2.x;
        q2.y = -q2.y;
        q2.z = -q2.z;
        q2.w = -q2.w;
        cosHalfTheta = -cosHalfTheta;
    }
    if (@fabs(cosHalfTheta) >= 1.0) {
        result = q1;
    } else if (cosHalfTheta > 0.949999988079071) {
        result = QuaternionNlerp(q1, q2, amount);
    } else {
        var halfTheta: f32 = acos(f32, cosHalfTheta);
        var sinHalfTheta: f32 = @sqrt(1.0 - (cosHalfTheta * cosHalfTheta));
        if (@fabs(sinHalfTheta) < 0.0010000000474974513) {
            result.x = (q1.x * 0.5) + (q2.x * 0.5);
            result.y = (q1.y * 0.5) + (q2.y * 0.5);
            result.z = (q1.z * 0.5) + (q2.z * 0.5);
            result.w = (q1.w * 0.5) + (q2.w * 0.5);
        } else {
            var ratioA: f32 = @sin((@intToFloat(f32, @as(c_int, 1)) - amount) * halfTheta) / sinHalfTheta;
            var ratioB: f32 = @sin(amount * halfTheta) / sinHalfTheta;
            result.x = (q1.x * ratioA) + (q2.x * ratioB);
            result.y = (q1.y * ratioA) + (q2.y * ratioB);
            result.z = (q1.z * ratioA) + (q2.z * ratioB);
            result.w = (q1.w * ratioA) + (q2.w * ratioB);
        }
    }
    return result;
}
pub fn QuaternionFromVector3ToVector3(arg_from: Vector3, arg_to: Vector3) callconv(.C) Quaternion {
    var from = arg_from;
    var to = arg_to;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    var cos2Theta: f32 = ((from.x * to.x) + (from.y * to.y)) + (from.z * to.z);
    var cross: Vector3 = Vector3{
        .x = (from.y * to.z) - (from.z * to.y),
        .y = (from.z * to.x) - (from.x * to.z),
        .z = (from.x * to.y) - (from.y * to.x),
    };
    result.x = cross.x;
    result.y = cross.y;
    result.z = cross.z;
    result.w = 1.0 + cos2Theta;
    var q: Quaternion = result;
    var length: f32 = @sqrt((((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w));
    if (length == 0.0) {
        length = 1.0;
    }
    var ilength: f32 = 1.0 / length;
    result.x = q.x * ilength;
    result.y = q.y * ilength;
    result.z = q.z * ilength;
    result.w = q.w * ilength;
    return result;
}
pub fn QuaternionFromMatrix(arg_mat: Matrix) callconv(.C) Quaternion {
    var mat = arg_mat;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    if ((mat.m0 > mat.m5) and (mat.m0 > mat.m10)) {
        var s: f32 = @sqrt(((1.0 + mat.m0) - mat.m5) - mat.m10) * @intToFloat(f32, @as(c_int, 2));
        result.x = 0.25 * s;
        result.y = (mat.m4 + mat.m1) / s;
        result.z = (mat.m2 + mat.m8) / s;
        result.w = (mat.m9 - mat.m6) / s;
    } else if (mat.m5 > mat.m10) {
        var s: f32 = @sqrt(((1.0 + mat.m5) - mat.m0) - mat.m10) * @intToFloat(f32, @as(c_int, 2));
        result.x = (mat.m4 + mat.m1) / s;
        result.y = 0.25 * s;
        result.z = (mat.m9 + mat.m6) / s;
        result.w = (mat.m2 - mat.m8) / s;
    } else {
        var s: f32 = @sqrt(((1.0 + mat.m10) - mat.m0) - mat.m5) * @intToFloat(f32, @as(c_int, 2));
        result.x = (mat.m2 + mat.m8) / s;
        result.y = (mat.m9 + mat.m6) / s;
        result.z = 0.25 * s;
        result.w = (mat.m4 - mat.m1) / s;
    }
    return result;
}
pub fn QuaternionToMatrix(arg_q: Quaternion) callconv(.C) Matrix {
    var q = arg_q;
    var result: Matrix = Matrix{
        .m0 = 1.0,
        .m4 = 0.0,
        .m8 = 0.0,
        .m12 = 0.0,
        .m1 = 0.0,
        .m5 = 1.0,
        .m9 = 0.0,
        .m13 = 0.0,
        .m2 = 0.0,
        .m6 = 0.0,
        .m10 = 1.0,
        .m14 = 0.0,
        .m3 = 0.0,
        .m7 = 0.0,
        .m11 = 0.0,
        .m15 = 1.0,
    };
    var a2: f32 = q.x * q.x;
    var b2: f32 = q.y * q.y;
    var c2: f32 = q.z * q.z;
    var ac: f32 = q.x * q.z;
    var ab: f32 = q.x * q.y;
    var bc: f32 = q.y * q.z;
    var ad: f32 = q.w * q.x;
    var bd: f32 = q.w * q.y;
    var cd: f32 = q.w * q.z;
    result.m0 = @intToFloat(f32, @as(c_int, 1)) - (@intToFloat(f32, @as(c_int, 2)) * (b2 + c2));
    result.m1 = @intToFloat(f32, @as(c_int, 2)) * (ab + cd);
    result.m2 = @intToFloat(f32, @as(c_int, 2)) * (ac - bd);
    result.m4 = @intToFloat(f32, @as(c_int, 2)) * (ab - cd);
    result.m5 = @intToFloat(f32, @as(c_int, 1)) - (@intToFloat(f32, @as(c_int, 2)) * (a2 + c2));
    result.m6 = @intToFloat(f32, @as(c_int, 2)) * (bc + ad);
    result.m8 = @intToFloat(f32, @as(c_int, 2)) * (ac + bd);
    result.m9 = @intToFloat(f32, @as(c_int, 2)) * (bc - ad);
    result.m10 = @intToFloat(f32, @as(c_int, 1)) - (@intToFloat(f32, @as(c_int, 2)) * (a2 + b2));
    return result;
}
pub fn QuaternionFromAxisAngle(arg_axis: Vector3, arg_angle: f32) callconv(.C) Quaternion {
    var axis = arg_axis;
    var angle = arg_angle;
    var result: Quaternion = Quaternion{
        .x = 0.0,
        .y = 0.0,
        .z = 0.0,
        .w = 1.0,
    };
    var axisLength: f32 = @sqrt(((axis.x * axis.x) + (axis.y * axis.y)) + (axis.z * axis.z));
    if (axisLength != 0.0) {
        angle *= 0.5;
        var length: f32 = 0.0;
        var ilength: f32 = 0.0;
        var v: Vector3 = axis;
        length = @sqrt(((v.x * v.x) + (v.y * v.y)) + (v.z * v.z));
        if (length == 0.0) {
            length = 1.0;
        }
        ilength = 1.0 / length;
        axis.x *= ilength;
        axis.y *= ilength;
        axis.z *= ilength;
        var sinres: f32 = @sin(angle);
        var cosres: f32 = @cos(angle);
        result.x = axis.x * sinres;
        result.y = axis.y * sinres;
        result.z = axis.z * sinres;
        result.w = cosres;
        var q: Quaternion = result;
        length = @sqrt((((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w));
        if (length == 0.0) {
            length = 1.0;
        }
        ilength = 1.0 / length;
        result.x = q.x * ilength;
        result.y = q.y * ilength;
        result.z = q.z * ilength;
        result.w = q.w * ilength;
    }
    return result;
}
pub fn QuaternionToAxisAngle(arg_q: Quaternion, arg_outAxis: [*c]Vector3, arg_outAngle: [*c]f32) callconv(.C) void {
    var q = arg_q;
    var outAxis = arg_outAxis;
    var outAngle = arg_outAngle;
    if (@fabs(q.w) > 1.0) {
        var length: f32 = @sqrt((((q.x * q.x) + (q.y * q.y)) + (q.z * q.z)) + (q.w * q.w));
        if (length == 0.0) {
            length = 1.0;
        }
        var ilength: f32 = 1.0 / length;
        q.x = q.x * ilength;
        q.y = q.y * ilength;
        q.z = q.z * ilength;
        q.w = q.w * ilength;
    }
    var resAxis: Vector3 = Vector3{
        .x = 0.0,
        .y = 0.0,
        .z = 0.0,
    };
    var resAngle: f32 = 2.0 * acos(f32, q.w);
    var den: f32 = @sqrt(1.0 - (q.w * q.w));
    if (den > 0.00009999999747378752) {
        resAxis.x = q.x / den;
        resAxis.y = q.y / den;
        resAxis.z = q.z / den;
    } else {
        resAxis.x = 1.0;
    }
    outAxis.* = resAxis;
    outAngle.* = resAngle;
}
pub fn QuaternionFromEuler(arg_pitch: f32, arg_yaw: f32, arg_roll: f32) callconv(.C) Quaternion {
    var pitch = arg_pitch;
    var yaw = arg_yaw;
    var roll = arg_roll;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    var x0: f32 = @cos(pitch * 0.5);
    var x1: f32 = @sin(pitch * 0.5);
    var y0: f32 = @cos(yaw * 0.5);
    var y1: f32 = @sin(yaw * 0.5);
    var z0: f32 = @cos(roll * 0.5);
    var z1: f32 = @sin(roll * 0.5);
    result.x = ((x1 * y0) * z0) - ((x0 * y1) * z1);
    result.y = ((x0 * y1) * z0) + ((x1 * y0) * z1);
    result.z = ((x0 * y0) * z1) - ((x1 * y1) * z0);
    result.w = ((x0 * y0) * z0) + ((x1 * y1) * z1);
    return result;
}
pub fn QuaternionToEuler(arg_q: Quaternion) callconv(.C) Vector3 {
    var q = arg_q;
    var result: Vector3 = Vector3{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
    };
    var x0: f32 = 2.0 * ((q.w * q.x) + (q.y * q.z));
    var x1: f32 = 1.0 - (2.0 * ((q.x * q.x) + (q.y * q.y)));
    result.x = atan2(f32, x0, x1);
    var y0: f32 = 2.0 * ((q.w * q.y) - (q.z * q.x));
    y0 = if (y0 > 1.0) 1.0 else y0;
    y0 = if (y0 < -1.0) -1.0 else y0;
    result.y = asin(f32, y0);
    var z0: f32 = 2.0 * ((q.w * q.z) + (q.x * q.y));
    var z1: f32 = 1.0 - (2.0 * ((q.y * q.y) + (q.z * q.z)));
    result.z = atan2(f32, z0, z1);
    return result;
}
pub fn QuaternionTransform(arg_q: Quaternion, arg_mat: Matrix) callconv(.C) Quaternion {
    var q = arg_q;
    var mat = arg_mat;
    var result: Quaternion = Quaternion{
        .x = @intToFloat(f32, @as(c_int, 0)),
        .y = 0,
        .z = 0,
        .w = 0,
    };
    result.x = (((mat.m0 * q.x) + (mat.m4 * q.y)) + (mat.m8 * q.z)) + (mat.m12 * q.w);
    result.y = (((mat.m1 * q.x) + (mat.m5 * q.y)) + (mat.m9 * q.z)) + (mat.m13 * q.w);
    result.z = (((mat.m2 * q.x) + (mat.m6 * q.y)) + (mat.m10 * q.z)) + (mat.m14 * q.w);
    result.w = (((mat.m3 * q.x) + (mat.m7 * q.y)) + (mat.m11 * q.z)) + (mat.m15 * q.w);
    return result;
}
pub fn QuaternionEquals(arg_p: Quaternion, arg_q: Quaternion) callconv(.C) c_int {
    var p = arg_p;
    var q = arg_q;
    var result: c_int = @boolToInt((((@fabs(p.x - q.x) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.x), @fabs(q.x))))) and (@fabs(p.y - q.y) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.y), @fabs(q.y)))))) and (@fabs(p.z - q.z) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.z), @fabs(q.z)))))) and (@fabs(p.w - q.w) <= (0.0000009999999974752427 * @maximum(1.0, @maximum(@fabs(p.w), @fabs(q.w))))));
    return result;
}
pub const PI = @as(f32, 3.14159265358979323846);
pub const EPSILON = @as(f32, 0.000001);
pub const DEG2RAD = PI / @as(f32, 180.0);
pub const RAD2DEG = @as(f32, 180.0) / PI;
pub inline fn MatrixToFloat(mat: anytype) @TypeOf(MatrixToFloatV(mat).v) {
    return MatrixToFloatV(mat).v;
}
pub inline fn Vector3ToFloat(vec: anytype) @TypeOf(Vector3ToFloatV(vec).v) {
    return Vector3ToFloatV(vec).v;
}
