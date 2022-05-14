import { Window } from '..';

const w = new Window({
  title: 'bun!',
  url: 'https://bun.sh',
  size: { width: 1920, height: 1080 },
});

new Window({
  title: 'bun 2!',
  url: 'https://bun.sh',
  size: { width: 1920 / 2, height: 1080 / 2 },
});

// block until webview is closed
w.wait();