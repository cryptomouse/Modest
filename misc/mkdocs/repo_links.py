# MkDocs hook: docs link into the source tree (`../src/parser.py#L12`),
# which is not part of the site — point such links at the file on GitHub.

import os
import re

REPO_BLOB = 'https://github.com/cryptomouse/Modest/blob/main/'

# [text](target) — target without scheme, anchor-only or absolute path
LINK = re.compile(r'(\]\()(?![a-z]+:|#|/)([^)\s]+)(\))')


def on_page_markdown(markdown, page, config, files):
    docs_dir = config['docs_dir']
    repo_dir = os.path.dirname(docs_dir)
    page_dir = os.path.dirname(page.file.abs_src_path)

    def fix(m):
        target = m.group(2)
        path, _, anchor = target.partition('#')
        full = os.path.normpath(os.path.join(page_dir, path))
        if os.path.commonpath([full, docs_dir]) == docs_dir:
            return m.group(0)
        rel = os.path.relpath(full, repo_dir)
        url = REPO_BLOB + rel.replace(os.sep, '/') + ('#' + anchor if anchor else '')
        return m.group(1) + url + m.group(3)

    return LINK.sub(fix, markdown)
