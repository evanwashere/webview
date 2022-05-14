<h1 align=center>@evan/webview</h1>
<div align=center>webview bindings for bun runtime</div>

<br />

### Install
`bun add @evan/webview`


<br />

## Examples

```js
import { Window } from '@evan/webview';

// window is bound to bun's lifetime
// window will not prevent bun from exiting
const window = new Window({
  titlebar: true, // enable/disable titlebar (default: true)
  resizable: true, // enable/disable resizing window (default: true)
  maximized: false, // start window maximized (default: false)
  fullscreen: false, // start window in fullscreen mode (default: false)
  title: 'Hello World', // window title (default: none)
  always_on_top: false, // keep window always on top (default: false)
  user_agent: 'bun!!!!', // set user agent (default: webkit's user agent)

  js: 'console.log(1)', // inject js code before loading url/html (default: none)
  url: 'https://www.google.com', // start window with url (default: blank)
  // or html: '<h1>Hello World</h1>', // start window with html (default: "")

  size: {
    width: 800, height: 600, // default window size
    min: { width: 400, height: 300 }, // min window size
    max: { width: 1024, height: 768 }, // max window size
  },
});

window.close(); // close window
window.wait(); // wait for window to close (blocks main thread)
```

## License

Apache-2.0 © [Evan](https://github.com/evanwashere)