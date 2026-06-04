# Context Rules

Rules for what agents should read and when, to minimize context waste.

## Always Read (Every Session)

- `core/HARNESS.md` — Task loop and operating rules.
- `core/communication-style.md` — How to communicate.
- `.brain/brain.json` — Infrastructure and GitHub config (if exists).

## Read When Triggered

| Trigger | Read |
|---|---|
| `/code`, `/debug`, `/refactor` | `core/FEATURE_INTAKE.md` (risk classification) |
| Any `/` command | Corresponding `workflows/<command>.md` |
| Project has `docs/` | Scan `docs/stories/`, `docs/decisions/` for open items |
| Project has `graphify-out/` | `graphify-out/GRAPH_REPORT.md` for codebase overview |
| User mentions architecture | `docs/ARCHITECTURE.md` (if exists in project) |
| Unfamiliar term | `docs/GLOSSARY.md` (if exists in project) |

## Query Instead of Read

Use `rig` CLI to query state instead of parsing files:

| Need | Command |
|---|---|
| Current session state | `rig query session` |
| Project stats | `rig query stats` |
| Test coverage status | `rig query matrix` |
| Open backlog items | `rig query backlog --open` |
| Recent friction | `rig query friction` |

## Do Not Over-Read

- Do NOT read all workflow files at session start.
- Do NOT read templates until you need to create a story/decision.
- Do NOT read TRACE_SPEC.md until you need to record a trace.
- Do NOT load domain knowledge unless the task requires it.
