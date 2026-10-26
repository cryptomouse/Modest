// The windmill theme bundles an old highlight.js (v9) and arms it on window
// DOMContentLoaded, i.e. after modest-hljs.js has coloured the blocks on
// document. Not knowing `modest`, it auto-detects (usually Haskell) and
// recolours them on top. Must load before hljs 11 replaces window.hljs:
// marking v9's run as already done disables it for good.
if (window.hljs && window.hljs.initHighlighting) {
  window.hljs.initHighlighting.called = true;
}
