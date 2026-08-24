#!/usr/bin/env python3
"""Validate the repository-owned invariants of Rig's Codex bundle."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REFERENCE_ROOT = ROOT / "skills" / "rig-harness" / "references"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compare_tree(source: Path, generated: Path, errors: list[str]) -> None:
    source_files = {
        item.relative_to(source)
        for item in source.rglob("*")
        if item.is_file()
    }
    generated_files = {
        item.relative_to(generated)
        for item in generated.rglob("*")
        if item.is_file()
    }
    if source_files != generated_files:
        errors.append(f"Generated file set is stale: {generated.relative_to(ROOT)}")
        return
    for relative_path in sorted(source_files):
        if digest(source / relative_path) != digest(generated / relative_path):
            errors.append(f"Generated copy is stale: {(generated / relative_path).relative_to(ROOT)}")


def require_equal(source: Path, generated: Path, errors: list[str]) -> None:
    if not generated.is_file() or digest(source) != digest(generated):
        errors.append(f"Generated copy is stale: {generated.relative_to(ROOT)}")


def main() -> int:
    errors: list[str] = []

    manifest_path = ROOT / ".codex-plugin" / "plugin.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        errors.append(f"Invalid plugin manifest: {error}")
    else:
        if manifest.get("name") != "rig":
            errors.append("Plugin manifest name must be 'rig'.")
        if manifest.get("skills") != "./skills/":
            errors.append("Plugin manifest must expose ./skills/.")

    agents_template = (ROOT / "codex" / "AGENTS.md").read_text(encoding="utf-8")
    if agents_template.count("<!-- RIG_CODEX:BEGIN -->") != 1 or agents_template.count(
        "<!-- RIG_CODEX:END -->"
    ) != 1:
        errors.append("codex/AGENTS.md must contain one managed Rig block.")

    compare_tree(ROOT / "core", REFERENCE_ROOT / "core", errors)
    compare_tree(ROOT / "workflows", REFERENCE_ROOT / "workflows", errors)

    ebook_skill = ROOT / "skills" / "create-ebook"
    require_equal(
        ROOT / "plugins" / "education" / "guides" / "academic_textbook_style_guide.md",
        ebook_skill / "references" / "academic_textbook_style_guide.md",
        errors,
    )
    for script_name in ("lint_textbook.py", "export_docx.py"):
        require_equal(
            ROOT / "plugins" / "education" / "tools" / script_name,
            ebook_skill / "scripts" / script_name,
            errors,
        )

    for skill_file in sorted((ROOT / "skills").glob("*/SKILL.md")):
        text = skill_file.read_text(encoding="utf-8")
        if not text.startswith("---\n") and not text.startswith("---\r\n"):
            errors.append(f"Missing skill frontmatter: {skill_file.relative_to(ROOT)}")
        if "name:" not in text or "description:" not in text:
            errors.append(f"Incomplete skill frontmatter: {skill_file.relative_to(ROOT)}")
        if "~/.gemini/antigravity" in text:
            errors.append(f"Codex skill contains an Antigravity-only path: {skill_file.relative_to(ROOT)}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print("Codex bundle validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
