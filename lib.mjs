import { ptr, dlopen, suffix } from 'bun:ffi';

const utf8e = new TextEncoder();

const path = new URL(`./bin/lib${process.platform}.${process.arch}.${suffix}`, import.meta.url).pathname;
const bin_path = new URL(`./bin/webview/bun-webview-${process.platform}_${process.arch}`, import.meta.url).pathname;

const wv = dlopen(path, {
  wv_kill: { args: ['ptr'], returns: 'void' },
  wv_wait: { args: ['ptr'], returns: 'void' },
  wv_new: { args: ['ptr', 'u32', 'ptr', 'u32'], returns: 'ptr' },
}).symbols;

for (const k in wv) wv[k] = wv[k].native || wv[k];

export function wait(w) {
  wv.wv_wait(w);
}

export function kill(w) {
  wv.wv_kill(w);
}

export function open(path, options = {}) {
  path ||= bin_path;
  const path_b = utf8e.encode(path);
  const opts_b = utf8e.encode(JSON.stringify(options));
  return wv.wv_new(ptr(path_b), path_b.length, ptr(opts_b), opts_b.length);
}