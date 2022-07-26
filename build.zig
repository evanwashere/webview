const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {
  const all = b.step("all", "");
  const mode = b.standardReleaseOptions();
  const target = b.standardTargetOptions(.{});

  {
    const lib = b.addSharedLibrary("debug", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = .macos != target.getOsTag();

    lib.linkLibC();
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");

    b.default_step.dependOn(&lib.step);
    b.default_step.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/debug.o"}).step);
  }

  {
    const lib = b.addSharedLibrary("linux.x64", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = true;

    lib.linkLibC();
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");
    lib.setTarget(.{ .os_tag = .linux, .cpu_arch = .x86_64 });

    all.dependOn(&lib.step);
    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/linux.x64.o"}).step);
  }

  {
    const lib = b.addSharedLibrary("darwin.x64", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = false;

    lib.linkLibC();
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");
    lib.setTarget(.{ .os_tag = .macos, .cpu_arch = .x86_64 });

    all.dependOn(&lib.step);
    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/darwin.x64.o"}).step);
  }

    {
    const lib = b.addSharedLibrary("darwin.arm64", "src/webview.zig", .unversioned);

    lib.strip = true;
    lib.want_lto = false;

    lib.linkLibC();
    lib.setBuildMode(mode);
    lib.setOutputDir("bin/");
    lib.setTarget(.{ .os_tag = .macos, .cpu_arch = .aarch64 });

    all.dependOn(&lib.step);
    all.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/darwin.arm64.o"}).step);
  }
}