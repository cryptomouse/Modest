// Syntax highlighting for code blocks (highlight.js + custom Modest grammar).
// Pygments has no Modest lexer, so highlighting is done client-side for every
// language; colours come from the docco theme (mkdocs.yml extra_css).
// The theme's own hljs is off (mkdocs.yml: highlightjs: false).

hljs.registerLanguage('modest', function (hljs) {
  return {
    name: 'Modest',
    keywords: {
      keyword:
        'func var let const type record if else while break again return ' +
        'import include pragma public private unsafe module new as and or not __asm',
      literal: 'true false nil',
      built_in:
        'sizeof alignof lengthof offsetof ' +
        '__defined __va_arg __va_copy __va_end __va_start'
    },
    contains: [
      hljs.C_LINE_COMMENT_MODE,
      hljs.C_BLOCK_COMMENT_MODE,
      { scope: 'string', begin: '"', end: '"', contains: [hljs.BACKSLASH_ESCAPE] },
      { scope: 'string', begin: "'", end: "'", contains: [hljs.BACKSLASH_ESCAPE] },
      { scope: 'number', begin: /\b(0[xX][0-9a-fA-F_]+|0[bB][01_]+|\d[\d_]*(\.\d[\d_]*)?([eE][+-]?\d+)?)\b/ },
      { scope: 'meta', begin: /@[a-z_][A-Za-z0-9_]*/ },
      // this match takes `func` out of the keywords list's reach, so it needs
      // its own scope 1, or it is left plain:
      //   func <span class="hljs-title function_">sum</span>   (before)
      { begin: [/\bfunc\s+/, /[a-z_][A-Za-z0-9_]*/], beginScope: { 1: 'keyword', 2: 'title.function' } },
      { scope: 'type', begin: /\b[A-Z][A-Za-z0-9_]*/ }
    ]
  };
});

function highlightCode() {
  // data-highlighted (set by hljs 11) skips blocks already done on an
  // earlier instant-navigation pass
  document.querySelectorAll('pre code[class*="language-"]:not([data-highlighted])').forEach(function (el) {
    hljs.highlightElement(el);
  });
}

// document$ is Material's page-load observable (also fires on instant navigation)
if (typeof document$ !== 'undefined') {
  document$.subscribe(highlightCode);
} else {
  document.addEventListener('DOMContentLoaded', highlightCode);
}
