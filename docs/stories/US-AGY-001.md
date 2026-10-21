# Story: US-AGY-001 — Upgrade Rig to run natively on AGY CLI (Antigravity CLI / 2.0)

**Lane:** normal
**Status:** done
**Created:** 2026-10-21

## Context

`agy` CLI (Antigravity CLI / Antigravity 2.0) discovers global customizations under `~/.gemini/config/` (`skills/`, `rules/`, `plugins/`, `GEMINI.md`) and workspace customizations under `.agents/` (`skills.json`, `rules/*.md` with mandatory `trigger` YAML frontmatter), and validates plugins via `.antigravity-plugin/plugin.json` (with a 24,000-byte per-skill body limit). Additionally, legacy Markdown workflows (`workflows/*.md`) are deprecated in `agy` CLI in favor of first-class skills (`skills/<name>/SKILL.md`), which provide slash command (`/init`, `/code`, `/plan`, etc.) and semantic discovery support.

Affects `docs/product/README.md`, `AGENTS.md`, `gemini.md`, `install.sh`, `install.ps1`, `cli/`, `workflows/`, `skills/`, and `plugins/education/`.

## Acceptance Criteria

- [x] Workspace rules in `.agents/rules/*.md` include valid YAML frontmatter (`trigger` + `description`) and load without `CORTEX_MEMORY_TRIGGER_UNSPECIFIED` errors in `agy` CLI.
- [x] `.agents/skills.json` registers `skills` so workspace skills load automatically in `agy` CLI.
- [x] `.antigravity-plugin/plugin.json` and `plugins/education/plugin.json` + `plugins/education/skills.json` pass `agy plugin validate`.
- [x] `skills/onboard-repository/SKILL.md` fits within the 24,000-byte `agy` CLI skill body limit without truncation.
- [x] All 21 `workflows/*.md` files include `name:` and `description:` frontmatter and are installed by `install.sh` / `install.ps1` into `~/.gemini/config/skills/<name>/SKILL.md` alongside the 11 core/education skills.
- [x] `rig` CLI supports `rig session get --key <key>`, `rig session list`, `rig story verify-all`, UTF-8-safe Vietnamese string truncation, and `agy` CLI readiness checks in `rig doctor`.

## Validation

| Type | Status | Command |
|---|---|---|
| Unit | ✅ | `cargo test --manifest-path cli/Cargo.toml` |
| Integration | ✅ | `python3 scripts/validate_codex_bundle.py && agy plugin validate . && agy plugin validate plugins/education` |
| E2E | ✅ | `./install.sh && rig doctor && rig session get --key active_feature` |

## Files Changed

- `.antigravity-plugin/plugin.json` — Root Antigravity plugin manifest
- `.agents/skills.json` — Workspace skill registration for `agy` CLI
- `.agents/rules/*.md` — Added `trigger` and `description` frontmatter for `agy` CLI rule loader
- `workflows/*.md` — Added `name:` frontmatter for skill/slash-command conversion
- `skills/onboard-repository/SKILL.md` — Trimmed body under 24,000-byte `agy` CLI limit
- `plugins/education/plugin.json` & `plugins/education/skills.json` — Updated to valid Antigravity plugin schema
- `install.sh` & `install.ps1` — Installed skills, workflow slash-command skills, and rules to `~/.gemini/config/`
- `cli/src/main.rs` & `cli/src/db.rs` — Added `session get/list`, `story verify-all`, UTF-8-safe `truncate`, `agy` CLI doctor check, and unit tests
- `scripts/sync_codex_bundle.py` & `scripts/validate_codex_bundle.py` — Added `agy` CLI bundle sync and invariant checks
