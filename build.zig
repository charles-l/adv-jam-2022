const builds = @import("std").build;
const Builder = builds.Builder;
const builtin = @import("builtin");
const std = @import("std");

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    // setup for raylib wasm build too, but right now zig doesn't fully support
    // the wasm C ABI, so passing structs by value doesn't work. This will be
    // fixed in the 0.10 release.

    // build raylib
    var libraylib = b.addStaticLibrary("raylib", null);

    libraylib.defineCMacro("PLATFORM_DESKTOP", "1");
    libraylib.addIncludeDir("raylib/src/external/glfw/include/");

    if (target.isWindows()) {
        libraylib.linkSystemLibrary("opengl32");
        libraylib.linkSystemLibrary("gdi32");
        libraylib.linkSystemLibrary("winmm");
    } else if (target.isLinux()) {
        libraylib.linkSystemLibrary("X11");
        libraylib.linkSystemLibrary("GL");
        libraylib.linkSystemLibrary("m");
        libraylib.linkSystemLibrary("pthread");
        libraylib.linkSystemLibrary("dl");
        libraylib.linkSystemLibrary("rt");
    }
    libraylib.linkLibC();

    libraylib.addCSourceFile("raylib/src/rglfw.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/rcore.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/rshapes.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/rtextures.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/rtext.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/rmodels.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/utils.c", &.{"-fno-sanitize=undefined"});
    libraylib.addCSourceFile("raylib/src/raudio.c", &.{"-fno-sanitize=undefined"});
    libraylib.addIncludeDir("raylib/src");
    //std.fs.copyFileAbsolute(b.pathFromRoot("raygui/src/raygui.h"), b.pathFromRoot("raygui/src/raygui.c"), .{}) catch unreachable;
    //libraylib.addCSourceFile("raygui/src/raygui.c", &.{ "-fno-sanitize=undefined", "-DRAYGUI_IMPLEMENTATION" });
    libraylib.setTarget(target);
    libraylib.setBuildMode(mode);
    libraylib.install();

    const game = b.addExecutable("game", "game.zig");
    game.addIncludeDir("raylib/src");
    //game.addIncludeDir("raygui/src");
    game.linkLibrary(libraylib);
    //game.linkSystemLibrary("glfw");
    game.linkLibC();
    game.install();

    const run_cmd = game.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
