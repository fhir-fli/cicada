/// The page's one element and the few ways both parts of the page write
/// to it. Small and loaded first, with the sign-in.
library;

import 'package:web/web.dart' as web;

web.HTMLElement get root =>
    web.document.getElementById('cicada')! as web.HTMLElement;

/// An element with [text] as its text, never as markup: everything shown
/// comes from the chart or the engine.
web.HTMLElement el(String tag, {String? text, String? className}) {
  final e = web.document.createElement(tag) as web.HTMLElement;
  if (text != null) e.textContent = text;
  if (className != null) e.className = className;
  return e;
}

void status(String text) {
  root
    ..textContent = ''
    ..append(el('p', text: text, className: 'status'));
}

void message(String title, String detail) {
  root
    ..textContent = ''
    ..append(el('h1', text: title))
    ..append(el('p', text: detail, className: 'detail'));
}
