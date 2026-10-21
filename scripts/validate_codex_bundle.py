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

    agy_manifest_path = ROOT / ".antigravity-plugin" / "plugin.json"
    try:
        agy_manifest = json.loads(agy_manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        errors.append(f"Invalid Antigravity plugin manifest: {error}")
    else:
        if agy_manifest.get("name") != "rig":
            errors.append("Antigravity plugin manifest name must be 'rig'.")

    agy_skills_path = ROOT / ".agents" / "skills.json"
    try:
        agy_skills = json.loads(agy_skills_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        errors.append(f"Invalid .agents/skills.json: {error}")
    else:
        entries = agy_skills.get("entries", [])
        if not any(isinstance(e, dict) and e.get("path") == "skills" for e in entries):
            errors.append(".agents/skills.json must register 'skills'.")

    for rule_file in sorted((ROOT / ".agents" / "rules").glob("*.md")):
        rule_text = rule_file.read_text(encoding="utf-8")
        if not (rule_text.startswith("---\n") or rule_text.startswith("---\r\n")) or "trigger:" not in rule_text:
            errors.append(f"Missing trigger frontmatter in workspace rule: {rule_file.relative_to(ROOT)}")

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
    for wf_name in ("textbook.md", "pptx.md", "question.md", "video.md", "export.md"):
        require_equal(
            ROOT / "workflows" / wf_name,
            ROOT / "plugins" / "education" / "workflows" / wf_name,
            errors,
        )

    for wf_file in sorted((ROOT / "workflows").glob("*.md")):
        wf_text = wf_file.read_text(encoding="utf-8")
        if not wf_text.startswith("---\n") and not wf_text.startswith("---\r\n"):
            errors.append(f"Missing workflow frontmatter: {wf_file.relative_to(ROOT)}")
        if "name:" not in wf_text or "description:" not in wf_text:
            errors.append(f"Workflow frontmatter must have name and description for AGY CLI skill conversion: {wf_file.relative_to(ROOT)}")

    for skill_file in sorted((ROOT / "skills").glob("*/SKILL.md")):
        text = skill_file.read_text(encoding="utf-8")
        if not text.startswith("---\n") and not text.startswith("---\r\n"):
            errors.append(f"Missing skill frontmatter: {skill_file.relative_to(ROOT)}")
        if "name:" not in text or "description:" not in text:
            errors.append(f"Incomplete skill frontmatter: {skill_file.relative_to(ROOT)}")
        if "~/.gemini/antigravity" in text:
            errors.append(f"Codex skill contains an Antigravity-only path: {skill_file.relative_to(ROOT)}")
        parts = text.split("---", 2)
        if len(parts) == 3 and len(parts[2].encode("utf-8")) > 24000:
            errors.append(f"Skill body exceeds AGY CLI 24,000-byte limit: {skill_file.relative_to(ROOT)}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print("Codex bundle validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
