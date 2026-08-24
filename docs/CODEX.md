# Using Rig with Codex

Rig supports Codex and Gemini Antigravity from the same repository. Shared
Harness policy remains under `core/`; platform adapters only control discovery
and packaging.

## Install

The existing installers configure both platforms.

Windows PowerShell:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }"
```

macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.sh | bash
```

For Codex, installation copies skills to `~/.agents/skills/` and merges a
bounded Rig block into `~/.codex/AGENTS.md`. Existing guidance outside the
managed block is preserved. Restart Codex or start a new task after installing.

For Antigravity, the installer continues to use `~/.gemini/GEMINI.md` and
`~/.gemini/antigravity/`.

## Use

Codex may invoke `$rig-harness` automatically for repository work. Explicit
invocation is also available:

```text
$rig-harness implement this change and run focused validation
$onboard-repository map this repository without editing it
$encode-invariant enforce this accepted architecture rule
```

The old `/code`, `/plan`, and related overlay names remain available to
Antigravity. In Codex, use natural language or `$rig-harness`; it selects one
overlay from its bundled references.

## Plugin packaging

The repository root is a Codex plugin package through
`.codex-plugin/plugin.json`. The plugin exposes every directory under `skills/`.
The same skills can also run standalone from `~/.agents/skills/`.

## Development

After changing shared Core, workflows, or education resources:

```bash
python scripts/sync_codex_bundle.py
python scripts/validate_codex_bundle.py
```

Then run the Codex skill and plugin validators described in the root
`AGENTS.md`.
