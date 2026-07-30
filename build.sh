#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="$SCRIPT_DIR/docs"
CONTENT_DIR="$SCRIPT_DIR/content"
IMAGES_DIR="$SCRIPT_DIR/images"

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

if [[ -d "$IMAGES_DIR" ]]; then
  cp -r "$IMAGES_DIR" "$DIST_DIR/images"
  echo "Copied images to docs/images/"
fi

NAV_ITEMS=("__SEC__" "USAGE_SETUP" "IDM_UPDATE" "USAGE_CALIBRATE" "ACCELEROMETER" "MULTI_Z_LEVELING" "USAGE_ADVANCED" "__SEC__" "INDEX" "INSTALL" "MOONRAKER" "CAN_FLASH" "USB_FLASH" "DFU_FLASH")

NAV_LABELS_ZH=(
  "使用教程"
  "安装与配置"
  "自动更新配置"
  "校准"
  "加速度计"
  "多 Z 轴调平"
  "高级功能"
  "刷写指南"
  "概览"
  "安装指南"
  "Moonraker 集成"
  "CAN 模式刷写"
  "USB 模式刷写"
  "DFU 模式刷写"
)

NAV_LABELS_EN=(
  "Usage Tutorial"
  "Setup & Config"
  "Auto-Update"
  "Calibration"
  "Accelerometer"
  "Multi-Z Leveling"
  "Advanced Features"
  "Flashing Guide"
  "Overview"
  "Installation Guide"
  "Moonraker Integration"
  "CAN Mode Flashing"
  "USB Mode Flashing"
  "DFU Mode Flashing"
)

python3 - "$DIST_DIR" "$CONTENT_DIR" \
  "${NAV_ITEMS[@]}" \
  "|||" \
  "${NAV_LABELS_ZH[@]}" \
  "|||" \
  "${NAV_LABELS_EN[@]}" << 'PYEOF'
import sys
import re
import os
import json

dist_dir = sys.argv[1]
content_dir = sys.argv[2]

separator_idx = sys.argv.index("|||")
nav_items = sys.argv[3:separator_idx]
rest = sys.argv[separator_idx+1:]
sep2 = rest.index("|||")
nav_labels_zh = rest[:sep2]
nav_labels_en = rest[sep2+1:]

CSS = """
:root {
  --sidebar-bg: #1a237e;
  --sidebar-text: #c5cae9;
  --sidebar-hover: #ffffff;
  --sidebar-active-bg: rgba(255,255,255,0.15);
  --bg: #ffffff;
  --text: #333333;
  --text-muted: #666666;
  --link: #1a73e8;
  --link-hover: #1557b0;
  --border: #e0e0e0;
  --code-bg: #f5f5f5;
  --code-border: #e0e0e0;
  --accent: #1a237e;
  --heading: #222222;
  --table-row-alt: #fafafa;
  --table-header-bg: #1a237e;
  --table-header-text: #ffffff;
  --search-bg: rgba(255,255,255,0.12);
  --search-focus: rgba(255,255,255,0.2);
  --search-text: #ffffff;
  --search-placeholder: #9fa8da;
  --result-bg: #ffffff;
  --result-text: #333;
  --result-hover: #f0f5ff;
  --result-border: #e0e0e0;
}
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  background: var(--bg);
  color: var(--text);
  display: flex;
  min-height: 100vh;
  line-height: 1.7;
  font-size: 15px;
}
.sidebar {
  width: 280px;
  min-width: 280px;
  background: var(--sidebar-bg);
  padding: 0;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  overflow-y: auto;
  z-index: 10;
}
.sidebar-header {
  padding: 24px 20px 20px 20px;
  border-bottom: 1px solid rgba(255,255,255,0.12);
}
.sidebar-header a {
  color: #ffffff;
  text-decoration: none;
  font-size: 20px;
  font-weight: 700;
  letter-spacing: 0.3px;
}
.sidebar-header span {
  display: block;
  color: #9fa8da;
  font-size: 12px;
  font-weight: 400;
  margin-top: 2px;
}
.sidebar-search {
  padding: 12px 16px;
}
.sidebar-search input {
  width: 100%;
  padding: 8px 12px 8px 32px;
  background: var(--search-bg);
  color: var(--search-text);
  border: 1px solid transparent;
  border-radius: 4px;
  font-size: 13px;
  outline: none;
  transition: all 0.2s;
}
.sidebar-search input::placeholder {
  color: var(--search-placeholder);
}
.sidebar-search input:focus {
  background: var(--search-focus);
  border-color: rgba(255,255,255,0.3);
}
.sidebar-search {
  position: relative;
}
.sidebar-search::before {
  content: "\\1F50D";
  position: absolute;
  left: 26px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 12px;
  opacity: 0.6;
  pointer-events: none;
  z-index: 1;
}
.search-backdrop {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.3);
  z-index: 5;
}
.search-backdrop.show {
  display: block;
}
.search-results {
  display: none;
  position: fixed;
  top: 0;
  left: 280px;
  right: 0;
  bottom: 0;
  z-index: 11;
}
.search-results.show { display: block; }
.search-results-inner {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  max-height: 80vh;
  background: var(--result-bg);
  box-shadow: 0 4px 24px rgba(0,0,0,0.15);
  overflow-y: auto;
  border-bottom: 1px solid var(--result-border);
}
.search-result-item {
  display: block;
  padding: 12px 24px;
  border-bottom: 1px solid var(--result-border);
  color: var(--result-text);
  text-decoration: none;
  transition: background 0.1s;
}
.search-result-item:hover, .search-result-item.focus {
  background: var(--result-hover);
}
.search-result-item .title {
  font-weight: 600;
  font-size: 15px;
  color: var(--accent);
}
.search-result-item .snippet {
  font-size: 13px;
  color: var(--text-muted);
  margin-top: 4px;
}
.search-result-item mark {
  background: #fff3cd;
  color: #333;
  padding: 1px 2px;
  border-radius: 2px;
}
.search-empty {
  padding: 24px;
  text-align: center;
  color: var(--text-muted);
  font-size: 14px;
}
.sidebar-nav {
  padding: 12px 0;
}
.sidebar .sec-header {
  color: #7986cb;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  padding: 16px 20px 6px 20px;
}
.sidebar a.nav-link {
  display: block;
  color: var(--sidebar-text);
  text-decoration: none;
  padding: 6px 20px 6px 28px;
  font-size: 14px;
  transition: all 0.15s;
  border-left: 3px solid transparent;
}
.sidebar a.nav-link:hover {
  color: var(--sidebar-hover);
  background: rgba(255,255,255,0.08);
  border-left-color: rgba(255,255,255,0.3);
}
.sidebar a.nav-link.active {
  color: #ffffff;
  background: rgba(255,255,255,0.12);
  border-left-color: #ffffff;
  font-weight: 600;
}
.sidebar .lang {
  padding: 16px 20px;
  border-top: 1px solid rgba(255,255,255,0.1);
  margin-top: 8px;
}
.sidebar .lang select {
  width: 100%;
  padding: 7px 10px;
  background: rgba(255,255,255,0.1);
  color: #ffffff;
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
}
.sidebar .lang select option {
  color: #333;
  background: #fff;
}
.main {
  margin-left: 280px;
  padding: 40px 56px;
  max-width: 900px;
  width: 100%;
}
h1 { color: var(--heading); font-size: 30px; margin-bottom: 4px; font-weight: 700; border-bottom: 2px solid var(--accent); padding-bottom: 10px; }
h2 { color: var(--heading); font-size: 22px; margin-top: 36px; margin-bottom: 12px; font-weight: 600; border-bottom: 1px solid var(--border); padding-bottom: 6px; }
h3 { color: var(--heading); font-size: 18px; margin-top: 28px; margin-bottom: 10px; font-weight: 600; }
h4 { color: var(--text); font-size: 16px; margin-top: 20px; margin-bottom: 8px; }
p { margin-bottom: 18px; }
ul, ol { margin-bottom: 18px; padding-left: 28px; }
li { margin-bottom: 6px; }
a { color: var(--link); text-decoration: none; }
a:hover { color: var(--link-hover); text-decoration: underline; }
code {
  background: var(--code-bg);
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 13px;
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
  border: 1px solid var(--code-border);
}
.code-block {
  position: relative;
  margin-bottom: 20px;
}
pre {
  background: var(--code-bg);
  padding: 48px 20px 16px;
  border-radius: 6px;
  overflow-x: auto;
  margin-bottom: 0;
  font-size: 13px;
  line-height: 1.55;
  border: 1px solid var(--code-border);
}
pre code {
  background: none;
  padding: 0;
  border-radius: 0;
  border: none;
}
.copy-code {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 30px;
  height: 30px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  color: var(--text-muted);
  background: #ffffff;
  border: 1px solid var(--code-border);
  border-radius: 4px;
  font: inherit;
  font-size: 12px;
  line-height: 1.2;
  cursor: pointer;
}
.copy-code svg {
  width: 16px;
  height: 16px;
  fill: none;
  stroke: currentColor;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 1.8;
}
.copy-code:hover,
.copy-code:focus-visible {
  color: var(--link);
  border-color: var(--link);
  outline: none;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}
th, td {
  padding: 10px 14px;
  text-align: left;
  border: 1px solid var(--border);
}
th {
  background: var(--table-header-bg);
  font-weight: 600;
  color: var(--table-header-text);
  font-size: 13px;
}
tr:nth-child(even) td {
  background: var(--table-row-alt);
}
strong { color: var(--heading); font-weight: 600; }
em { color: #555; font-style: italic; }
img { max-width: 100%; border-radius: 6px; border: 1px solid var(--border); margin: 12px 0 20px 0; display: block; }
hr { border: none; border-top: 1px solid var(--border); margin: 32px 0; }
@media (max-width: 768px) {
  body { flex-direction: column; }
  .sidebar {
    position: relative; width: 100%; min-width: 100%;
  }
  .main { margin-left: 0; padding: 24px; }
  .search-results { left: 0; }
  .search-results-inner { top: var(--search-results-top, 144px); }
}
"""

def md_to_html(text, copy_label):
    lines = text.split('\n')
    result = []
    i = 0
    in_code_block = False
    code_lang = ""
    code_lines = []
    in_table = False
    table_lines = []
    in_list = False
    list_type = None

    def flush_table():
        nonlocal in_table, result
        if not in_table or not table_lines:
            return
        out = ['<table>']
        for row_idx, row in enumerate(table_lines):
            cells = [c.strip() for c in row.split('|')]
            cells = [c for c in cells if c or (row_idx == 0 and table_lines)]
            if not cells:
                continue
            cells = cells[1:-1] if len(cells) > 2 and not cells[0] and not cells[-1] else cells
            cells = [c for c in cells if not re.match(r'^:?-{3,}:?$', c)]
            if not cells:
                continue
            tag = 'th' if row_idx == 0 else 'td'
            out.append('<tr>')
            for c in cells:
                out.append(f'<{tag}>{inline_md(c)}</{tag}>')
            out.append('</tr>')
        out.append('</table>')
        result.append('\n'.join(out))
        table_lines.clear()
        in_table = False

    def flush_list():
        nonlocal in_list, list_type, result
        if in_list and list_type:
            result.append(f'</{list_type}>')
        in_list = False
        list_type = None

    def inline_md(text):
        text = re.sub(r'!\[([^\]]*)\]\(([^)]+)\)', r'<img src="\2" alt="\1">', text)
        text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
        text = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', text)
        text = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', text)
        text = re.sub(r'\*(.+?)\*', r'<em>\1</em>', text)
        return text

    while i < len(lines):
        line = lines[i]

        if line.startswith('```'):
            if not in_code_block:
                flush_table()
                in_code_block = True
                code_lang = line[3:].strip()
                code_lines = []
            else:
                lang_attr = f' class="language-{code_lang}"' if code_lang else ''
                joined = "\n".join(code_lines)
                result.append(f'<div class="code-block"><button class="copy-code" type="button" title="{copy_label}" aria-label="{copy_label}"><svg aria-hidden="true" viewBox="0 0 24 24"><rect x="9" y="9" width="11" height="11" rx="2"></rect><path d="M15 9V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h4"></path></svg></button><pre><code{lang_attr}>{joined}</code></pre></div>')
                in_code_block = False
                code_lang = ""
                code_lines = []
                flush_list()
            i += 1
            continue

        if in_code_block:
            code_lines.append(line)
            i += 1
            continue

        if line.startswith('#'):
            flush_table()
            flush_list()
            level = len(line) - len(line.lstrip('#'))
            heading_text = line[level:].strip()
            heading_id = re.sub(r'[^a-z0-9-]', '', heading_text.lower().replace(' ', '-'))
            result.append(f'<h{level} id="{heading_id}">{inline_md(heading_text)}</h{level}>')
            i += 1
            continue

        if line.startswith('---'):
            flush_table()
            flush_list()
            result.append('<hr>')
            i += 1
            continue

        if line.startswith('|') and line.rstrip().endswith('|'):
            flush_list()
            if not in_table:
                in_table = True
                table_lines = []
            table_lines.append(line)
            i += 1
            continue
        else:
            flush_table()

        if line.startswith('- ') or line.startswith('* ') or line.startswith('+ '):
            if not in_list or list_type != 'ul':
                flush_list()
                result.append('<ul>')
                list_type = 'ul'
                in_list = True
            content = line[2:].strip()
            result.append(f'<li>{inline_md(content)}</li>')
            i += 1
            continue

        if re.match(r'^\d+\.\s', line):
            if not in_list or list_type != 'ol':
                flush_list()
                result.append('<ol>')
                list_type = 'ol'
                in_list = True
            content = re.sub(r'^\d+\.\s', '', line).strip()
            result.append(f'<li>{inline_md(content)}</li>')
            i += 1
            continue

        flush_list()

        if line == '':
            if i > 0 and result and result[-1] == '<br>':
                pass
            else:
                result.append('<br>')
            i += 1
            continue

        result.append(f'<p>{inline_md(line)}</p>')
        i += 1

    flush_table()
    if in_list:
        result.append(f'</{list_type}>')
        flush_list()

    raw = '\n'.join(result)
    raw = re.sub(r'(<br>\s*)+', '<br>', raw)
    raw = re.sub(r'<br>\s*(</?(?:h[1-6]|table|ul|ol|pre|hr))', r'\1', raw)
    raw = re.sub(r'(</?(?:h[1-6]|table|ul|ol|pre|hr))\s*<br>', r'\1', raw)
    raw = re.sub(r'<p>\s*</p>', '', raw)
    raw = raw.replace('<br>', '')
    return raw

def build_page(lang, lang_attr, nav_labels, page_name, page_title, md_content):
    sidebar_items = []
    for j, item in enumerate(nav_items):
        label = nav_labels[j]
        if item == "__SEC__":
            sidebar_items.append(f'      <div class="sec-header">{label}</div>')
        else:
            href = f"{item}.html"
            active = ' active' if item == page_name else ''
            sidebar_items.append(f'      <a href="{href}" class="nav-link{active}">{label}</a>')

    lang_opts = []
    for lc, lname in [("zh", "中文"), ("en", "English")]:
        sel = ' selected' if lc == lang else ''
        lang_opts.append(f'        <option value="{lc}"{sel}>{lname}</option>')

    raw_title = page_title.strip('#').strip()
    subtitle = 'IDM 使用文档' if lang == 'zh' else 'IDM User Guide'

    return f"""<!DOCTYPE html>
<html lang="{lang_attr}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{raw_title} - IDM Wiki</title>
<style>
{CSS}
</style>
</head>
<body>
<nav class="sidebar">
  <div class="sidebar-header">
    <a href="INDEX.html">IDM Wiki</a>
    <span>{subtitle}</span>
  </div>
  <div class="sidebar-search">
    <input type="text" id="search-input" placeholder="Search docs..." autocomplete="off">
  </div>
  <div class="sidebar-nav">
{chr(10).join(sidebar_items)}
  </div>
  <div class="lang">
    <select onchange="if(this.value) window.location.href='../' + this.value + '/' + '{page_name}.html'">
{chr(10).join(lang_opts)}
    </select>
  </div>
</nav>
<div class="search-backdrop" id="search-backdrop"></div>
<div class="search-results" id="search-results">
  <div class="search-results-inner" id="search-results-inner"></div>
</div>
<main class="main">
 {md_to_html(md_content, "复制" if lang == "zh" else "Copy")}
</main>
<script>
(function() {{
  var idx = null;
  var input = document.getElementById('search-input');
  var backdrop = document.getElementById('search-backdrop');
  var results = document.getElementById('search-results');
  var inner = document.getElementById('search-results-inner');
  var focusIdx = -1;
  var langDir = '{lang}';
  var copyLabel = '{"复制" if lang == "zh" else "Copy"}';
  var copiedLabel = '{"已复制" if lang == "zh" else "Copied"}';
  var copyIcon = '<svg aria-hidden="true" viewBox="0 0 24 24"><rect x="9" y="9" width="11" height="11" rx="2"></rect><path d="M15 9V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h4"></path></svg>';
  var copiedIcon = '<svg aria-hidden="true" viewBox="0 0 24 24"><path d="m5 12 4 4L19 6"></path></svg>';

  function copyText(text) {{
    if (navigator.clipboard && navigator.clipboard.writeText) {{
      return navigator.clipboard.writeText(text);
    }}
    var textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.setAttribute('readonly', '');
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    return Promise.resolve();
  }}

  document.querySelectorAll('.copy-code').forEach(function(button) {{
    button.addEventListener('click', function() {{
      var code = button.parentElement.querySelector('code');
      copyText(code.textContent).then(function() {{
        button.innerHTML = copiedIcon;
        button.title = copiedLabel;
        button.setAttribute('aria-label', copiedLabel);
        window.setTimeout(function() {{
          button.innerHTML = copyIcon;
          button.title = copyLabel;
          button.setAttribute('aria-label', copyLabel);
        }}, 1600);
      }});
    }});
  }});

  function loadIndex() {{
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '../' + langDir + '/search_index.json', true);
    xhr.onload = function() {{
      if (xhr.status === 200) {{
        idx = JSON.parse(xhr.responseText);
      }}
    }};
    xhr.send();
  }}

  function escapeHtml(s) {{
    var d = document.createElement('div');
    d.appendChild(document.createTextNode(s));
    return d.innerHTML;
  }}

  function highlight(text, query) {{
    var words = query.toLowerCase().split(/\\s+/).filter(function(w) {{ return w.length > 0; }});
    var re = new RegExp('(' + words.map(function(w) {{ return w.replace(/[.*+?^${{}}()|[\\]\\\\]/g, '\\\\$&'); }}).join('|') + ')', 'gi');
    return escapeHtml(text).replace(re, '<mark>$1</mark>');
  }}

  function search() {{
    var q = input.value.trim();
    if (!q || !idx) {{
      closeResults();
      return;
    }}
    var words = q.toLowerCase().split(/\\s+/).filter(function(w) {{ return w.length > 0; }});
    var matches = [];
    for (var i = 0; i < idx.length; i++) {{
      var page = idx[i];
      var score = 0;
      var ti = page.t.toLowerCase();
      var ci = page.c.toLowerCase();
      for (var j = 0; j < words.length; j++) {{
        if (ti.indexOf(words[j]) >= 0) score += 10;
        if (ci.indexOf(words[j]) >= 0) score += 1;
      }}
      if (score > 0) {{
        page._score = score;
        matches.push(page);
      }}
    }}
    matches.sort(function(a, b) {{ return b._score - a._score; }});
    var html = '';
    if (matches.length === 0) {{
      html = '<div class="search-empty">No results found for "' + escapeHtml(q) + '"</div>';
    }} else {{
      for (var k = 0; k < Math.min(matches.length, 20); k++) {{
        var m = matches[k];
        var snippet = m.c.length > 200 ? m.c.substring(0, 200) + '...' : m.c;
        html += '<a class="search-result-item" href="' + m.u + '">';
        html += '<div class="title">' + highlight(m.t, q) + '</div>';
        html += '<div class="snippet">' + highlight(snippet, q) + '</div>';
        html += '</a>';
      }}
    }}
    inner.innerHTML = html;
    if (window.matchMedia('(max-width: 768px)').matches) {{
      results.style.setProperty('--search-results-top', input.getBoundingClientRect().bottom + 'px');
    }}
    backdrop.classList.add('show');
    results.classList.add('show');
    focusIdx = -1;
  }}

  function closeResults() {{
    backdrop.classList.remove('show');
    results.classList.remove('show');
  }}

  input.addEventListener('input', search);
  input.addEventListener('focus', function() {{ if (input.value.trim()) search(); }});
  input.addEventListener('keydown', function(e) {{
    var items = inner.querySelectorAll('.search-result-item');
    if (e.key === 'ArrowDown') {{
      e.preventDefault();
      focusIdx = Math.min(focusIdx + 1, items.length - 1);
      for (var i = 0; i < items.length; i++) items[i].classList.remove('focus');
      if (items[focusIdx]) items[focusIdx].classList.add('focus');
    }} else if (e.key === 'ArrowUp') {{
      e.preventDefault();
      focusIdx = Math.max(focusIdx - 1, 0);
      for (var i = 0; i < items.length; i++) items[i].classList.remove('focus');
      if (items[focusIdx]) items[focusIdx].classList.add('focus');
    }} else if (e.key === 'Enter') {{
      e.preventDefault();
      if (items[focusIdx]) items[focusIdx].click();
    }} else if (e.key === 'Escape') {{
      closeResults();
    }}
  }});
  backdrop.addEventListener('click', closeResults);
  document.addEventListener('click', function(e) {{
    if (!results.contains(e.target) && e.target !== input) {{
      closeResults();
    }}
  }});

  loadIndex();
}})();
</script>
</body>
</html>"""

def get_page_title(md_content):
    for line in md_content.strip().split('\n'):
        if line.startswith('# '):
            return line
    return "# Untitled"

for lang_dir_name in sorted(os.listdir(content_dir)):
    lang_path = os.path.join(content_dir, lang_dir_name)
    if not os.path.isdir(lang_path):
        continue

    lang_attr = lang_dir_name
    nav_labels = nav_labels_zh if lang_dir_name == 'zh' else nav_labels_en
    lang_dist = os.path.join(dist_dir, lang_dir_name)
    os.makedirs(lang_dist, exist_ok=True)

    # Build search index for this language
    search_index = []

    for page_name in nav_items:
        if page_name == "__SEC__":
            continue
        md_file = os.path.join(lang_path, f"{page_name}.md")
        if not os.path.exists(md_file):
            print(f"WARNING: {md_file} not found, skipping")
            continue

        with open(md_file, 'r', encoding='utf-8') as f:
            md_content = f.read()

        page_title = get_page_title(md_content)
        html = build_page(lang_dir_name, lang_attr, nav_labels, page_name, page_title, md_content)

        html_file = os.path.join(lang_dist, f"{page_name}.html")
        with open(html_file, 'w', encoding='utf-8') as f:
            f.write(html)
        print(f"Generated: {html_file}")

        # Preserve code block content so commands and configuration keys are searchable.
        clean_content = re.sub(r'^```[^\n]*\n?', '', md_content, flags=re.MULTILINE)
        clean_content = re.sub(r'#{1,6}\s+', '', clean_content)
        clean_content = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', clean_content)
        clean_content = re.sub(r'[*`~>|]', '', clean_content)
        clean_content = re.sub(r'\n{3,}', '\n\n', clean_content)
        clean_content = clean_content.strip()

        title_clean = re.sub(r'^#\s+', '', page_title).strip()
        search_index.append({
            't': title_clean,
            'c': clean_content,
            'u': f'{page_name}.html'
        })

    index_file = os.path.join(lang_dist, 'search_index.json')
    with open(index_file, 'w', encoding='utf-8') as f:
        json.dump(search_index, f, ensure_ascii=False)
    print(f"Generated search index: {index_file}")

# Generate root index.html redirect
index_html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>IDM Wiki</title>
</head>
<body>
<p>Redirecting to <a id="redirect-link" href="zh/USAGE_SETUP.html">IDM Wiki</a>...</p>
<script>
(function() {
  var path = window.location.pathname;
  var base = path.endsWith('/index.html') ? path.slice(0, -10) : path;
  if (!base.endsWith('/')) base += '/';
  var target = base + 'zh/USAGE_SETUP.html';
  document.getElementById('redirect-link').href = target;
  window.location.replace(target);
})();
</script>
</body>
</html>"""
with open(os.path.join(dist_dir, 'index.html'), 'w', encoding='utf-8') as f:
    f.write(index_html)
print("Generated: docs/index.html (redirect)")

print("\nBuild complete! docs/ directory is ready for deployment.")
PYEOF

echo "Build finished successfully."
