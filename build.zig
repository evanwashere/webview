const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {
  const mode = b.standardReleaseOptions();
  const target = b.standardTargetOptions(.{});

  const lib = b.addSharedLibrary("webview", "src/webview.zig", .unversioned);

  lib.strip = true;
  lib.want_lto = .macos != target.getOsTag();

  lib.linkLibC();
  lib.setTarget(target);
  lib.setBuildMode(mode);
  lib.setOutputDir("bin/");

  b.default_step.dependOn(&lib.step);
  b.default_step.dependOn(&b.addSystemCommand(&[_][]const u8 {"rm", "bin/webview.o"}).step);
}