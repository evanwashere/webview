use wry::{
  webview::WebViewBuilder,

  application::{
    event::{Event, WindowEvent},
    window::{Fullscreen, WindowBuilder},
    event_loop::{EventLoop, ControlFlow},
    platform::macos::WindowBuilderExtMacOS,
  },
};

#[derive(serde::Deserialize)] struct Size {
  width: u32,
  height: u32,
}

#[derive(serde::Deserialize)] struct Sizes {
  width: u32,
  height: u32,
  min: Option<Size>,
  max: Option<Size>,
}

#[derive(serde::Deserialize)] struct Options {
  js: Option<String>,
  url: Option<String>,
  size: Option<Sizes>,
  html: Option<String>,
  title: Option<String>,
  visible: Option<bool>,
  titlebar: Option<bool>,
  maximized: Option<bool>,
  resizable: Option<bool>,
  fullscreen: Option<bool>,
  user_agent: Option<String>,
  always_on_top: Option<bool>,
}

fn main() {
  let ev = EventLoop::new();
  let mut window = WindowBuilder::new();
  let opts: Options = serde_json::from_reader(std::io::stdin().lock()).unwrap();

  window = window.with_visible(opts.visible.unwrap_or(true));
  window = window.with_resizable(opts.resizable.unwrap_or(true));
  window = window.with_maximized(opts.maximized.unwrap_or(false));
  window = window.with_titlebar_hidden(!opts.titlebar.unwrap_or(true));
  window = window.with_always_on_top(opts.always_on_top.unwrap_or(false));
  if opts.fullscreen.unwrap_or(false) { window = window.with_fullscreen(Some(Fullscreen::Borderless(None))); }

  window = match opts.title {
    Some(title) => window.with_title(title),
    None => window.with_title("").with_title_hidden(true),
  };

  if let Some(size) = opts.size {
    window = window.with_inner_size(wry::application::dpi::LogicalSize::new(size.width, size.height));
    if let Some(min) = size.min { window = window.with_min_inner_size(wry::application::dpi::LogicalSize::new(min.width, min.height)); }
    if let Some(max) = size.max { window = window.with_max_inner_size(wry::application::dpi::LogicalSize::new(max.width, max.height)); }
  }

  let mut webview = WebViewBuilder::new(window.build(&ev).unwrap()).unwrap();

  if let Some(url) = opts.url { webview = webview.with_url(&url).unwrap(); }
  if let Some(html) = opts.html { webview = webview.with_html(&html).unwrap(); }
  if let Some(js) = opts.js { webview = webview.with_initialization_script(&js); }
  if let Some(user_agent) = opts.user_agent { webview = webview.with_user_agent(&user_agent); }

  std::mem::forget(webview.build().unwrap());

  ev.run(move |e, _, control_flow| {
    *control_flow = ControlFlow::WaitUntil(std::time::Instant::now() + std::time::Duration::from_millis(250));

    return match e {
      Event::MainEventsCleared => if 1 == unsafe { nix::libc::getppid() } { std::process::exit(0); },
      Event::WindowEvent { event: WindowEvent::CloseRequested, .. } => *control_flow = ControlFlow::Exit,

      _ => {},
    };
  });
}