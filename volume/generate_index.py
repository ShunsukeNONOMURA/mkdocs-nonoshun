#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re

DOCS_DIR = Path("docs")
OUTPUT = DOCS_DIR / "index.md"

# 表示順を固定したいトップカテゴリ
TOP_ORDER = [
    "overview",
    "dev_guide",
    "requirements",
    "operations",
]

TOP_LABEL = {
    "overview": "全体概要",
    "dev_guide": "開発ガイド",
    "requirements": "要求仕様",
    "operations": "運用操作",
}

IGNORE_FILES = {
    "index.md",
    "README.md",
}

def read_title(md_path: Path) -> str:
    # 先頭付近の最初の H1 をタイトルにする
    try:
        text = md_path.read_text(encoding="utf-8")
    except Exception:
        return md_path.stem

    for line in text.splitlines():
        m = re.match(r"^#\s+(.+?)\s*$", line)
        if m:
            return m.group(1)
    # H1 が無ければファイル名
    return md_path.stem

def sort_key(p: Path) -> tuple:
    # 10_xx のような数値プレフィックスがあれば優先
    name = p.name
    m = re.match(r"^(\d+)[-_].*$", name)
    if m:
        return (0, int(m.group(1)), name.lower())
    return (1, 10**9, name.lower())

def collect_md_files() -> list[Path]:
    files: list[Path] = []
    for p in DOCS_DIR.rglob("*.md"):
        rel = p.relative_to(DOCS_DIR)
        if rel.name in IGNORE_FILES:
            continue
        # docs 配下の index.md 自体は除外
        if rel.as_posix() == "index.md":
            continue
        files.append(rel)
    return files

def group_by_top(files: list[Path]) -> dict[str, list[Path]]:
    grouped: dict[str, list[Path]] = {}
    for rel in files:
        parts = rel.parts
        if not parts:
            continue
        top = parts[0]
        grouped.setdefault(top, []).append(rel)
    # sort
    for top, items in grouped.items():
        grouped[top] = sorted(items, key=sort_key)
    return grouped

def render(grouped: dict[str, list[Path]]) -> str:
    lines: list[str] = []
    lines.append("# ドキュメント一覧")
    lines.append("")
    # 既知カテゴリを先に
    used = set()

    for top in TOP_ORDER:
        if top not in grouped:
            continue
        used.add(top)
        label = TOP_LABEL.get(top, top)
        lines.append(f"## {label}")
        for rel in grouped[top]:
            title = read_title(DOCS_DIR / rel)
            lines.append(f"- [{title}]({rel.as_posix()})")
        lines.append("")

    # それ以外のトップカテゴリも出す
    others = sorted([k for k in grouped.keys() if k not in used], key=str.lower)
    for top in others:
        lines.append(f"## {top}")
        for rel in grouped[top]:
            title = read_title(DOCS_DIR / rel)
            lines.append(f"- [{title}]({rel.as_posix()})")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"

def main() -> None:
    if not DOCS_DIR.exists():
        raise SystemExit("docs directory not found")

    files = collect_md_files()
    grouped = group_by_top(files)
    content = render(grouped)
    OUTPUT.write_text(content, encoding="utf-8")
    print(f"generated {OUTPUT}")

if __name__ == "__main__":
    main()