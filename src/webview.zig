const std = @import("std");
const allocator = std.heap.c_allocator;

const env_map = std.process.EnvMap.init(allocator);
const Handle = struct { process: std.ChildProcess };

export fn wv_wait(handle: *Handle) void {
  _ = handle.process.wait() catch {}; allocator.destroy(handle);
}

export fn wv_kill(handle: *Handle) void {
  _ = handle.process.kill() catch {}; allocator.destroy(handle);
}

export fn wv_new(path: [*]const u8, path_len: u32, options: [*]const u8, options_len: u32) ?*Handle {
  return _new(path[0..path_len], options[0..options_len]) catch null;
}

fn _new(path: []const u8, options: []const u8) !*Handle {
  const handle = try allocator.create(Handle);
  handle.process = std.ChildProcess.init(&[_][]const u8 {path}, allocator);

  handle.process.env_map = &env_map;
  errdefer allocator.destroy(handle);
  handle.process.stdin_behavior = .Pipe;
  handle.process.stderr_behavior = .Close;
  handle.process.stdout_behavior = .Close;

  try handle.process.spawn();
  try handle.process.stdin.?.writer().writeAll(options);
  handle.process.stdin.?.close(); handle.process.stdin = null;

  return handle;
}