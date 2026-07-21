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

NAV_ITEMS=("__SEC__" "INDEX" "INSTALL" "CAN_FLASH" "USB_FLASH" "DFU_FLASH" "MOONRAKER" "__SEC__" "USAGE_SETUP" "USAGE_CALIBRATE" "USAGE_ADVANCED")

NAV_LABELS_ZH=(
  "刷写指南"
  "概览"
  "安装指南"
  "CAN 模式刷写"
  "USB 模式刷写"
  "DFU 模式刷写"
  "Moonraker 集成"
  "使用教程"
  "安装与配置"
  "校准"
  "高级功能"
)

NAV_LABELS_EN=(
  "Flashing Guide"
  "Overview"
  "Installation Guide"
  "CAN Mode Flashing"
  "USB Mode Flashing"
  "DFU Mode Flashing"
  "Moonraker Integration"
  "Usage Tutorial"
  "Setup & Config"
  "Calibration"
  "Advanced Features"
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
  --bg: #0d1117;
  --bg-sidebar: #161b22;
  --text: #c9d1d9;
  --text-muted: #8b949e;
  --link: #58a6ff;
  --link-hover: #79c0ff;
  --border: #30363d;
  --code-bg: #1c2128;
  --accent: #f78166;
  --heading: #f0f6fc;
  --table-row-alt: #161b22;
}
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
  background: var(--bg);
  color: var(--text);
  display: flex;
  min-height: 100vh;
  line-height: 1.6;
}
.sidebar {
  width: 260px;
  min-width: 260px;
  background: var(--bg-sidebar);
  border-right: 1px solid var(--border);
  padding: 24px 16px;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  overflow-y: auto;
}
.sidebar h2 {
  color: var(--accent);
  font-size: 16px;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}
.sidebar a {
  display: block;
  color: var(--text-muted);
  text-decoration: none;
  padding: 8px 12px;
  border-radius: 6px;
  font-size: 14px;
  margin-bottom: 2px;
  transition: all 0.15s;
}
.sidebar a:hover {
  color: var(--text);
  background: rgba(255,255,255,0.04);
}
.sidebar a.active {
  color: var(--link);
  background: rgba(88,166,255,0.1);
  font-weight: 600;
}
.sidebar .sec-header {
  color: var(--text-muted);
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 16px 12px 4px 12px;
  margin-top: 4px;
}
.sidebar .lang {
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px solid var(--border);
}
.sidebar .lang select {
  width: 100%;
  padding: 6px 10px;
  background: var(--bg);
  color: var(--text);
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
}
.main {
  margin-left: 260px;
  padding: 32px 48px;
  max-width: 860px;
  width: 100%;
}
h1 { color: var(--heading); font-size: 28px; margin-bottom: 8px; font-weight: 700; border-bottom: 1px solid var(--border); padding-bottom: 10px; }
h2 { color: var(--heading); font-size: 22px; margin-top: 32px; margin-bottom: 12px; font-weight: 600; border-bottom: 1px solid var(--border); padding-bottom: 6px; }
h3 { color: var(--heading); font-size: 18px; margin-top: 24px; margin-bottom: 8px; font-weight: 600; }
h4 { color: var(--heading); font-size: 16px; margin-top: 20px; margin-bottom: 6px; }
p { margin-bottom: 16px; }
ul, ol { margin-bottom: 16px; padding-left: 24px; }
li { margin-bottom: 4px; }
a { color: var(--link); text-decoration: none; }
a:hover { color: var(--link-hover); text-decoration: underline; }
code {
  background: var(--code-bg);
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 13px;
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
}
pre {
  background: var(--code-bg);
  padding: 16px;
  border-radius: 8px;
  overflow-x: auto;
  margin-bottom: 16px;
  font-size: 13px;
  line-height: 1.5;
  border: 1px solid var(--border);
}
pre code {
  background: none;
  padding: 0;
  border-radius: 0;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 16px;
}
th, td {
  padding: 8px 12px;
  text-align: left;
  border: 1px solid var(--border);
}
th {
  background: var(--bg-sidebar);
  font-weight: 600;
  color: var(--heading);
}
tr:nth-child(even) td {
  background: var(--table-row-alt);
}
strong { color: var(--heading); font-weight: 600; }
em { color: var(--accent); font-style: italic; }
img { max-width: 100%; border-radius: 8px; border: 1px solid var(--border); margin: 8px 0 16px 0; display: block; }
hr { border: none; border-top: 1px solid var(--border); margin: 24px 0; }
@media (max-width: 768px) {
  body { flex-direction: column; }
  .sidebar {
    position: relative; width: 100%; min-width: 100%;
    padding: 16px; border-right: none; border-bottom: 1px solid var(--border);
  }
  .main { margin-left: 0; padding: 20px; }
}
"""

def md_to_html(text):
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
                result.append(f'<pre><code{lang_attr}>{joined}</code></pre>')
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
            active = ' class="active"' if item == page_name else ''
            sidebar_items.append(f'      <a href="{href}"{active}>{label}</a>')

    lang_opts = []
    for lc, lname in [("zh", "中文"), ("en", "English")]:
        sel = ' selected' if lc == lang else ''
        lang_opts.append(f'        <option value="{lc}"{sel}>{lname}</option>')

    raw_title = page_title.strip('#').strip()

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
  <h2>IDM Wiki</h2>
{chr(10).join(sidebar_items)}
  <div class="lang">
    <select onchange="if(this.value) window.location.href='../' + this.value + '/' + '{page_name}.html'">
{chr(10).join(lang_opts)}
    </select>
  </div>
</nav>
<main class="main">
{md_to_html(md_content)}
</main>
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

# Generate root index.html redirect
index_html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="refresh" content="0;url=zh/INDEX.html">
<title>IDM Wiki</title>
</head>
<body>
<p>Redirecting to <a href="zh/INDEX.html">IDM Wiki</a>...</p>
</body>
</html>"""
with open(os.path.join(dist_dir, 'index.html'), 'w', encoding='utf-8') as f:
    f.write(index_html)
print("Generated: docs/index.html (redirect)")

print("\nBuild complete! docs/ directory is ready for deployment.")
PYEOF

echo "Build finished successfully."
