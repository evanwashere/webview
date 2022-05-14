import * as lib from './lib.mjs';

export class Window {
  #ptr;

  constructor(options = {}) {
    if ('js' in options) new Function(options.js);
    if ('url' in options) options.url = new URL(options.url).toString();

    if (!(this.#ptr = lib.open(options.path, options))) throw new Error('failed to open webview');
  }

  wait() {
    lib.wait(this.#ptr);
  }

  kill() {
    lib.kill(this.#ptr);
  }
}