const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {
  const all = b.step("all", "");
  const mode = b.standardReleaseOptions();
  const target = b.standardTargetOptions(.{});

  {
    const lib = b.addSharedLibrary("webview", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = .macos != target.getOsTag();

    lib.linkLibC();
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");

    all.dependOn(&lib.step);
    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"mv", "bin/libwebview.dylib", "bin/t-m-a64.dylib"}).step);

    b.default_step.dependOn(&lib.step);
    b.default_step.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/webview.o"}).step);
  }

  {
    const lib = b.addSharedLibrary("webview", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = true;

    lib.linkLibC();
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");
    lib.setTarget(.{ .os_tag = .linux, .cpu_arch = .x86_64 });

    all.dependOn(&lib.step);
  }

  {
    const lib = b.addSharedLibrary("webview", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = false;

    lib.linkLibC();
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");
    lib.setTarget(.{ .os_tag = .macos, .cpu_arch = .x86_64 });

    all.dependOn(&lib.step);
    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"mv", "bin/libwebview.dylib", "bin/t-m-x64.dylib"}).step);
    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"lipo", "-create", "-arch", "arm64", "bin/t-m-a64.dylib", "-arch", "x86_64", "bin/t-m-x64.dylib", "-output", "bin/libwebview.dylib"}).step);

    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/webview.o", "bin/t-m-a64.dylib", "bin/t-m-x64.dylib"}).step);
  }
}