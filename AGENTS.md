# Rig Repository Guidance

Rig supports both Codex and Gemini Antigravity. Preserve both surfaces when
changing shared Harness behavior.

## Authority and workflow

- Read `core/HARNESS.md` and `core/WORKFLOW.md` before changing Harness policy.
- Keep `gemini.md`, `workflows/`, and `plugins/education/plugin.json` compatible
  with Antigravity.
- Keep `.codex-plugin/plugin.json`, `codex/`, and `skills/rig-harness/`
  compatible with Codex.
- Treat `core/` and `workflows/` as sources. Do not hand-edit their generated
  copies under `skills/rig-harness/references/`.
- After changing `core/`, `workflows/`, or the education guide/tools, run
  `python scripts/sync_codex_bundle.py`.

## Validation

- Run `python scripts/validate_codex_bundle.py`.
- Run the skill validator for every changed skill.
- Run the plugin validator against the repository root.
- Run `cargo test --manifest-path cli/Cargo.toml` when CLI behavior changes.

Do not commit or push unless the user explicitly authorizes it.
