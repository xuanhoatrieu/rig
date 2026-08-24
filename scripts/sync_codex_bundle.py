#!/usr/bin/env python3
"""Synchronize Codex skill resources from Rig's maintained sources."""

from __future__ import annotations

import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REFERENCE_ROOT = ROOT / "skills" / "rig-harness" / "references"


def ensure_bounded(path: Path, parent: Path) -> None:
    path.resolve().relative_to(parent.resolve())


def sync_tree(source: Path, destination: Path) -> None:
    ensure_bounded(destination, REFERENCE_ROOT)
    destination.mkdir(parents=True, exist_ok=True)

    source_files = {
        item.relative_to(source)
        for item in source.rglob("*")
        if item.is_file()
    }
    for existing in sorted(destination.rglob("*"), reverse=True):
        if existing.is_file() and existing.relative_to(destination) not in source_files:
            existing.unlink()
        elif existing.is_dir() and not any(existing.iterdir()):
            existing.rmdir()

    for relative_path in sorted(source_files):
        target = destination / relative_path
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source / relative_path, target)


def sync_file(source: Path, destination: Path, allowed_parent: Path) -> None:
    ensure_bounded(destination, allowed_parent)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)


def main() -> None:
    sync_tree(ROOT / "core", REFERENCE_ROOT / "core")
    sync_tree(ROOT / "workflows", REFERENCE_ROOT / "workflows")

    ebook_skill = ROOT / "skills" / "create-ebook"
    sync_file(
        ROOT / "plugins" / "education" / "guides" / "academic_textbook_style_guide.md",
        ebook_skill / "references" / "academic_textbook_style_guide.md",
        ebook_skill,
    )
    for script_name in ("lint_textbook.py", "export_docx.py"):
        sync_file(
            ROOT / "plugins" / "education" / "tools" / script_name,
            ebook_skill / "scripts" / script_name,
            ebook_skill,
        )

    print("Codex skill resources synchronized.")


if __name__ == "__main__":
    main()
