const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const screen_width = 1200;
const screen_height = 700;

const eql = std.meta.eql;

const c = @import("c.zig").c;

const m = @import("raymath.zig");

const block_width = 32;
const block_height = block_width / 2;
const block_depth = block_height / 2;

const view_size = 16;

const DrawCall = std.meta.Tuple(&[_]type{ c.Texture, c.Rectangle, c.Rectangle, c.Vector2, f32, c.Color });

fn drawCallLt(comptime _: type, lhs: anytype, rhs: anytype) bool {
    const lhs_pos = .{ .x = lhs.@"2".x, .y = lhs.@"2".y };
    const rhs_pos = .{ .x = rhs.@"2".x, .y = rhs.@"2".y };
    return lhs_pos.y < rhs_pos.y;
}

const SpriteSheet = struct {
    texture: c.Texture,
    frames: usize,

    const Self = @This();
    fn width(self: Self) f32 {
        return @intToFloat(f32, self.texture.width) / @intToFloat(f32, self.frames);
    }

    fn frameRect(self: Self, i: usize) c.Rectangle {
        return c.Rectangle{
            .x = self.width() * @intToFloat(f32, i),
            .y = 0,
            .width = self.width(),
            .height = @intToFloat(f32, self.texture.height),
        };
    }

    /// rotation is in degrees
    fn drawFrameEx(self: Self, pos: m.Vector2, rotation: f32, i: usize, alpha: f32, fliph: bool) DrawCall {
        var r = self.frameRect(i);
        if (fliph) {
            r.width = -r.width;
        }
        return DrawCall{
            self.texture,
            r,
            c.Rectangle{
                .x = pos.x,
                .y = pos.y,
                .width = self.width(),
                .height = @intToFloat(f32, self.texture.height),
            },
            m.Vector2{
                .x = self.width() / 2 - block_width / 2,
                .y = @intToFloat(f32, self.texture.height),
            },
            rotation,
            c.Color{ .r = 255, .g = 255, .b = 255, .a = @floatToInt(u8, 255 * alpha) },
        };
    }

    fn drawFrameIsoTile(self: Self, pos: m.Vector2, i: usize) DrawCall {
        return self.drawFrameEx(m.Vector2Add(xyToIso(.{
            .x = @mod(pos.x, view_size),
            .y = @mod(pos.y, view_size),
        }), .{ .x = 0, .y = block_height / 2 }), 0, i, 1, false);
    }

    fn drawFrameIso(self: Self, pos: m.Vector2, i: usize, fliph: bool) DrawCall {
        return self.drawFrameEx(xyToIso(.{
            .x = @mod(pos.x, view_size),
            .y = @mod(pos.y, view_size),
        }), 0, i, 1, fliph);
    }
};

pub fn v2i(v: m.Vector2) m.Vector2i {
    return m.Vector2i{ .x = @floatToInt(i32, v.x), .y = @floatToInt(i32, v.y) };
}

pub fn xyToIso(v: m.Vector2) m.Vector2 {
    return .{ .x = (v.x - v.y) * block_height, .y = ((v.x + v.y) / 2) * block_height };
}

pub fn xyToIsoTile(v: m.Vector2) m.Vector2 {
    return m.Vector2Add(xyToIso(wrapAround(v)), .{ .x = block_width / 2, .y = 0 });
}

pub fn isoToXy(v: m.Vector2) m.Vector2 {
    var v1 = m.Vector2{ .x = v.x / block_height, .y = v.y / block_height };
    return .{
        .x = (2 * v1.y + v1.x) / 2,
        .y = (2 * v1.y - v1.x) / 2,
    };
}

pub fn wrapAround(v: m.Vector2) m.Vector2 {
    // TODO: ensure wraparound is valid for chunk
    return .{ .x = @mod(v.x, view_size), .y = @mod(v.y, view_size) };
}

pub fn drawGridTile(tex: c.Texture, x: i32, y: i32) DrawCall {
    return drawGridTileTinted(tex, x, y, c.WHITE);
}

pub fn drawGridTileTinted(tex: c.Texture, x: i32, y: i32, color: c.Color) DrawCall {
    var v = xyToIso(.{ .x = @intToFloat(f32, x), .y = @intToFloat(f32, y) });
    v.y += block_height / 2 - @intToFloat(f32, tex.height);
    const w = @intToFloat(f32, tex.width);
    const h = @intToFloat(f32, tex.height);
    var d = DrawCall{
        tex,
        c.Rectangle{ .x = 0, .y = 0, .width = w, .height = h },
        c.Rectangle{ .x = v.x, .y = v.y, .width = w, .height = h },
        m.Vector2Zero(),
        0,
        color,
    };
    //@call(.{}, c.DrawTexturePro, d);
    return d;
}

const Map = struct {
    const TileType = enum {
        nothing,
        floor,
        fire,
    };

    const start_marker = c.Color{ .r = 255, .g = 0, .b = 255, .a = 255 };
    const fire_element = c.Color{ .r = 255, .g = 0, .b = 0, .a = 255 };
    const floor_marker = c.Color{ .r = 0, .g = 0, .b = 0, .a = 255 };

    pixels: []c.Color,
    width: usize,
    height: usize,

    const Self = @This();

    fn getTile(self: Self, pos: m.Vector2i) TileType {
        if (!(0 <= pos.x and pos.x < self.width and 0 <= pos.y and pos.y < self.height)) {
            return .nothing;
        }
        const pixel = self.pixels[
            @intCast(usize, pos.y) *
                self.width +
                @intCast(usize, pos.x)
        ];

        if (eql(pixel, floor_marker) or eql(pixel, start_marker)) {
            return .floor;
        } else if (eql(pixel, fire_element)) {
            return .fire;
        } else {
            return .nothing;
        }
    }

    fn inSameChunk(pos1: m.Vector2i, pos2: m.Vector2i) bool {
        const chunk_off_x = @divTrunc(pos1.x, view_size) * view_size;
        const chunk_off_y = @divTrunc(pos1.y, view_size) * view_size;
        return (chunk_off_x <= pos2.x and
            pos2.x < chunk_off_x + view_size and
            chunk_off_y <= pos2.y and
            pos2.y < chunk_off_y + view_size);
    }
};

var camera = c.Camera2D{
    .offset = .{ .x = screen_width / 2, .y = screen_height / 2 - 160 },
    .target = .{ .x = 0, .y = 0 },
    .rotation = 0,
    .zoom = 2,
};

const QueueValue = std.meta.Tuple(&[_]type{ m.Vector2i, f32 });
fn compareQueueValues(_: void, a: QueueValue, b: QueueValue) std.math.Order {
    return std.math.order(a.@"1", b.@"1");
}

fn findPath(allocator: std.mem.Allocator, map: Map, start: m.Vector2i, goal: m.Vector2i) !?std.ArrayList(m.Vector2i) {
    var queue = std.PriorityQueue(QueueValue, void, compareQueueValues).init(allocator, {});
    defer queue.deinit();

    var came_from = std.AutoHashMap(m.Vector2i, ?m.Vector2i).init(allocator);
    defer came_from.deinit();

    var cost_so_far = std.AutoHashMap(m.Vector2i, f32).init(allocator);
    defer cost_so_far.deinit();

    try queue.add(.{ start, 0 });
    try came_from.put(start, null);
    try cost_so_far.put(start, 0);

    while (queue.len != 0) {
        const current = queue.remove().@"0";

        if (eql(current, goal)) {
            break;
        }

        const neighbors = [_]m.Vector2i{
            .{ .x = current.x - 1, .y = current.y },
            .{ .x = current.x, .y = current.y - 1 },
            .{ .x = current.x + 1, .y = current.y },
            .{ .x = current.x, .y = current.y + 1 },
        };

        for (neighbors) |n| {
            if (map.getTile(n) == .floor) {
                // NOTE: could use a cost function here
                const new_cost = cost_so_far.get(current).? + 1;
                if (!cost_so_far.contains(n) or new_cost < cost_so_far.get(n).?) {
                    try cost_so_far.put(n, new_cost);
                    try queue.add(.{ n, new_cost });
                    try came_from.put(n, current);
                }
            }
        }
    }

    if (came_from.get(goal) == null) {
        return null;
    }

    var path = std.ArrayList(m.Vector2i).init(allocator);

    // reconstruct path
    var current = goal;
    while (!eql(current, start)) {
        try path.append(current);
        current = came_from.get(current).?.?;
    }

    std.mem.reverse(m.Vector2i, path.items);

    return path;
}

pub fn frameCompleted(frame: anyframe) bool {
    return std.mem.allEqual(u8, @ptrCast([*]const u8, frame)[8..24][0..16], std.math.maxInt(u8));
}

pub fn isoMousePos(state: anytype) m.Vector2i {
    const chunk_off_x = @floatToInt(usize, state.hero.pos.x / view_size) * view_size;
    const chunk_off_y = @floatToInt(usize, state.hero.pos.y / view_size) * view_size;

    const p = c.GetScreenToWorld2D(c.GetMousePosition(), camera);
    return v2i(m.Vector2Add(isoToXy(p), .{ .x = @intToFloat(f32, chunk_off_x), .y = @intToFloat(f32, chunk_off_y) + 1 }));
}

fn lastIndexOf(comptime T: type, haystack: []const T, needle: T) ?usize {
    var i = haystack.len;
    while (i > 0) {
        i -= 1;
        if (eql(needle, haystack[i])) {
            return i;
        }
    }
    return null;
}

test "lastIndexOf" {
    try std.testing.expect(lastIndexOf(u32, &[_]u32{ 1, 2, 3 }, 3).? == 2);
    try std.testing.expect(lastIndexOf(u32, &[_]u32{ 1, 2, 3 }, 1).? == 0);
    try std.testing.expect(lastIndexOf(u32, &[_]u32{ 1, 2, 3, 1 }, 1).? == 3);
}

fn drawCast(allocator: std.mem.Allocator, state: anytype, map: Map) std.BoundedArray(m.Vector2i, 16) {
    var cast_path = std.BoundedArray(m.Vector2i, 16).init(0) catch unreachable;
    while (!c.IsMouseButtonReleased(c.MOUSE_BUTTON_RIGHT)) {
        assert(c.IsMouseButtonDown(c.MOUSE_BUTTON_RIGHT));
        var mouse_tile = isoMousePos(state);
        const prev_index = lastIndexOf(m.Vector2i, cast_path.slice(), mouse_tile);
        if (map.getTile(mouse_tile) == .floor and Map.inSameChunk(v2i(state.hero.pos), mouse_tile) and (prev_index == null or (cast_path.slice().len > 1 and prev_index.? == 0))) {
            cast_path.append(mouse_tile) catch {};
        }

        if (cast_path.len > 0) {
            var i: usize = 0;
            while (i < cast_path.len - 1) : (i += 1) {
                c.DrawLineV(
                    xyToIsoTile(cast_path.get(i).toVector2()),
                    xyToIsoTile(cast_path.get(i + 1).toVector2()),
                    c.RED,
                );
            }
        }
        suspend {}
    }

    var reachable = false;
    if (cast_path.len > 0) {
        var p = findPath(allocator, map, v2i(state.hero.pos), cast_path.slice()[0]) catch unreachable;
        if (p) |d| {
            d.deinit();
            reachable = true;
        }
    }
    if (reachable) {
        print("reachable path\n", .{});
    } else {
        print("unreachable\n", .{});
    }
    return cast_path;
}

fn walkToGoal(allocator: std.mem.Allocator, draw_calls: *std.ArrayList(DrawCall), map: Map, pos: *m.Vector2, goal: m.Vector2, hero: SpriteSheet) void {
    var maybe_path = findPath(allocator, map, v2i(pos.*), v2i(goal)) catch unreachable;
    if (maybe_path == null) {
        return;
    }

    var path = maybe_path.?;
    defer path.deinit();

    var path_i: usize = 0;

    var t: f32 = 0;
    var last_pos = pos.*;
    while (path_i < path.items.len) {
        suspend {}

        // animate/draw
        draw_calls.append(hero.drawFrameIso(pos.*, @floatToInt(usize, @mod(t * 8, 4)), xyToIso(pos.*).x - xyToIso(last_pos).x > 0)) catch @panic("couldn't add draw call");
        t += c.GetFrameTime();

        // move
        {
            const diff = m.Vector2Subtract(path.items[path_i].toVector2(), pos.*);
            last_pos = pos.*;
            if (m.Vector2Length(diff) > 0.1) {
                pos.* = m.Vector2Add(pos.*, m.Vector2Scale(diff, 1 / (m.Vector2Length(diff) * 10)));
            } else {
                pos.* = path.items[path_i].toVector2();
                path_i += 1;
            }
        }
    }
}

fn highlightTile(tile: m.Vector2) void {
    var t = c.GetTime();
    while (c.GetTime() - t < 2) {
        var fade = @floatCast(f32, 1 - ((c.GetTime() - t) / 2));
        var p = xyToIso(wrapAround(tile));
        var poly = [_]m.Vector2{
            p, .{ .x = p.x + block_width / 2, .y = p.y - block_height / 2 }, .{ .x = p.x + block_width, .y = p.y }, .{ .x = p.x + block_width / 2, .y = p.y + block_height / 2 }, p,
        };
        c.DrawLineStrip(&poly[0], poly.len, c.Fade(c.YELLOW, fade));
        suspend {}
    }
}

pub fn main() !void {
    c.InitWindow(screen_width, screen_height, "game");
    c.SetTargetFPS(60);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());

    const iso_floor = c.LoadTexture("iso_floor.png");
    const fire_floor = SpriteSheet{ .texture = c.LoadTexture("floor_fire.png"), .frames = 5 };
    //const iso_cube = c.LoadTexture("iso_cube.png");
    const hero = SpriteSheet{ .texture = c.LoadTexture("hero.png"), .frames = 4 };
    const map_image = c.LoadImage("map1.png");
    const map = Map{ .pixels = c.LoadImageColors(map_image)[0..@intCast(usize, map_image.width * map_image.height)], .width = @intCast(usize, map_image.width), .height = @intCast(usize, map_image.height) };
    defer c.UnloadImageColors(map.pixels.ptr);

    const start = lbl: {
        for (map.pixels) |p, i| {
            if (eql(p, Map.start_marker)) {
                break :lbl m.Vector2{ .x = @intToFloat(f32, @mod(i, map.width)), .y = @intToFloat(f32, @divTrunc(i, map.width)) };
            }
        }
        // failed to find start
        assert(false);
        break :lbl m.Vector2{ .x = 0, .y = 0 };
    };

    var state = .{
        .hero = .{
            .pos = m.Vector2{ .x = 0, .y = 0 },
            .goal = m.Vector2i{ .x = 0, .y = 0 },
            //.pos = start, <- BUG: segfaults
        },
    };

    state.hero.pos = start;
    state.hero.goal = v2i(start);

    var highlight_tile: ?anyframe = null;

    var hero_movement: ?anyframe = null;
    // scratch arena
    var hero_movement_arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer hero_movement_arena.deinit();

    var draw_cast: ?anyframe = null;
    var draw_cast_arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer draw_cast_arena.deinit();

    var draw_calls = std.ArrayList(DrawCall).init(gpa.allocator());
    defer draw_calls.deinit();

    var overlay = c.LoadRenderTexture(screen_width, screen_height);

    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        defer c.EndDrawing();

        c.BeginTextureMode(overlay);

        c.BeginMode2D(camera);
        c.ClearBackground(c.BLANK);

        const chunk_off_x = @floatToInt(usize, state.hero.pos.x / view_size) * view_size;
        const chunk_off_y = @floatToInt(usize, state.hero.pos.y / view_size) * view_size;

        { // draw map chunk
            var map_chunk: [view_size][view_size]Map.TileType = undefined;

            {
                var x: usize = 0;
                while (x < view_size) : (x += 1) {
                    var y: usize = 0;
                    while (y < view_size) : (y += 1) {
                        map_chunk[y][x] = map.getTile(.{ .x = @intCast(i32, chunk_off_x + x), .y = @intCast(i32, chunk_off_y + y) });
                    }
                }
            }

            for (map_chunk) |row, y| {
                for (row) |tile, x| {
                    if (tile == .floor) {
                        try draw_calls.append(drawGridTile(iso_floor, @intCast(i32, x), @intCast(i32, y)));
                    } else if (tile == .fire) {
                        try draw_calls.append(fire_floor.drawFrameIsoTile(.{ .x = @intToFloat(f32, x), .y = @intToFloat(f32, y) }, @floatToInt(usize, @mod(c.GetTime(), 5 * 0.1) / 0.1)));
                    }
                }
            }

            {
                var i: i32 = -1;
                while (i < view_size) : (i += 1) {
                    for ([_]m.Vector2i{
                        m.Vector2i{ .x = i, .y = -1 },
                        m.Vector2i{ .x = -1, .y = i },
                        m.Vector2i{ .x = i, .y = view_size },
                        m.Vector2i{ .x = view_size, .y = i },
                    }) |v| {
                        const gx = v.x + @intCast(i32, chunk_off_x);
                        const gy = v.y + @intCast(i32, chunk_off_y);
                        if (map.getTile(.{ .x = gx, .y = gy }) == .floor) {
                            try draw_calls.append(drawGridTileTinted(iso_floor, v.x, v.y, c.GRAY));
                        }
                    }
                }
            }
        }

        {
            assert(map.getTile(v2i(state.hero.pos)) == .floor);
            const orig_pos = state.hero.pos;

            if (c.IsKeyPressed(c.KEY_W)) {
                state.hero.pos.x -= 1;
            }
            if (c.IsKeyPressed(c.KEY_S)) {
                state.hero.pos.x += 1;
            }
            if (c.IsKeyPressed(c.KEY_A)) {
                state.hero.pos.y += 1;
            }
            if (c.IsKeyPressed(c.KEY_D)) {
                state.hero.pos.y -= 1;
            }

            if (map.getTile(v2i(state.hero.pos)) != .floor) {
                state.hero.pos = orig_pos;
            }

            assert(map.getTile(v2i(state.hero.pos)) == .floor);
        }

        {
            if (hero_movement != null and frameCompleted(hero_movement.?)) {
                // free scratch
                hero_movement_arena.deinit();
                hero_movement_arena = std.heap.ArenaAllocator.init(gpa.allocator());
                hero_movement = null;
            }

            if (hero_movement) |frame| {
                resume frame;
            } else {
                try draw_calls.append(hero.drawFrameIso(state.hero.pos, 0, false));
            }
        }

        {
            if (draw_cast != null and frameCompleted(draw_cast.?)) {
                draw_cast_arena.deinit();
                draw_cast_arena = std.heap.ArenaAllocator.init(gpa.allocator());
                draw_cast = null;
            }

            if (draw_cast) |frame| {
                resume frame;
            } else {
                if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_RIGHT)) {
                    draw_cast = &async drawCast(draw_cast_arena.allocator(), state, map);
                }
            }
        }

        {
            if (highlight_tile != null and frameCompleted(highlight_tile.?)) {
                highlight_tile = null;
            }
            if (highlight_tile) |frame| {
                resume frame;
            }
        }

        if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
            const p = isoMousePos(state);

            if (try findPath(gpa.allocator(), map, v2i(state.hero.pos), p)) |path| {
                path.deinit();

                state.hero.goal = p;
                highlight_tile = &async highlightTile(state.hero.goal.toVector2());
                hero_movement = &async walkToGoal(hero_movement_arena.allocator(), &draw_calls, map, &state.hero.pos, state.hero.goal.toVector2(), hero);
                const global_goal = state.hero.goal.toVector2();
                c.DrawCircleV(xyToIso(wrapAround(global_goal)), 3, c.GREEN);
            }
        }

        c.EndMode2D();

        c.EndTextureMode();

        c.ClearBackground(c.GRAY);

        c.BeginMode2D(camera);

        std.sort.sort(DrawCall, draw_calls.items, void, drawCallLt);
        for (draw_calls.items) |args| {
            @call(.{}, c.DrawTexturePro, args);
        }

        c.EndMode2D();

        c.DrawTextureRec(
            overlay.texture,
            .{ .x = 0, .y = 0, .width = @intToFloat(f32, overlay.texture.width), .height = -@intToFloat(f32, overlay.texture.height) },
            .{ .x = 0, .y = 0 },
            c.WHITE,
        );

        draw_calls.clearRetainingCapacity();
    }

    c.UnloadRenderTexture(overlay);

    c.CloseWindow();
}
