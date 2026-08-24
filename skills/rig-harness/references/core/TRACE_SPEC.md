# Trace Specification

The `trace` table records what happened during a Harness task. This document
defines the expected depth and format for each field so traces are useful for
review, benchmark scoring, failure attribution, and future harness evolution.

## Field Reference

| Field | Type | Required | Format | Example |
| --- | --- | --- | --- | --- |
| `id` | INTEGER | Automatic | SQLite autoincrement primary key. Do not set manually. | `42` |
| `created_at` | TEXT | Automatic | SQLite `datetime('now')`. Do not set manually. | `2026-05-27 09:24:37` |
| `task_summary` | TEXT | Yes | One sentence, at least 10 characters, naming the outcome. | `Completed Phase 2 docs-only observability specification` |
| `intake_id` | INTEGER | Standard+ when an intake was recorded | Integer id from the related `intake` row. | `36` |
| `story_id` | TEXT | Standard+ when work maps to one story | Story id from the `story` table. | `US-004` |
| `agent` | TEXT | Optional for minimal; Standard+ expected | Short agent/tool name. | `codex` |
| `actions_taken` | TEXT | Standard+ | JSON array text. Pass a comma-separated list. | `["read spec","drafted schema","updated docs"]` |
| `files_read` | TEXT | Standard+ | JSON array text of paths or command names. | `["pl.md","docs/HARNESS.md","rig query matrix"]` |
| `files_changed` | TEXT | Standard+ | JSON array text of changed file paths. | `["docs/TRACE_SPEC.md","docs/HARNESS.md"]` |
| `decisions_made` | TEXT | Detailed | JSON array text of decision strings. | `["Kept Phase 2 docs-only"]` |
| `errors` | TEXT | Standard+ if errors occurred; Detailed always | JSON array text. Use `none` when no errors. | `["git diff --check failed"]` |
| `outcome` | TEXT | Yes before final response | One of `completed`, `blocked`, `partial`, or `failed`. | `completed` |
| `duration_seconds` | INTEGER | Detailed when available | Positive integer. Leave null if unknown. | `1800` |
| `token_estimate` | INTEGER | Detailed when available | Positive integer. Leave null if unknown. | `24000` |
| `harness_friction` | TEXT | Standard+ when friction exists; Detailed always | Free text naming what was hard. Use `none` only when checked. | `Missing permission docs; added backlog item.` |
| `notes` | TEXT | Optional | Free text for review context. | `Trace covers US-003, US-004, US-005.` |

## Quality Tiers

### Minimal (score: 1)

Minimum fields:

- `task_summary` is filled and at least 10 characters.
- `outcome` is filled before the final response.

Acceptable for:

- Tiny-lane tasks with no file changes or only low-risk copy/doc edits.

Not acceptable for:

- Normal or high-risk work.
- Any work that discovered friction, errors, or a missing validation path.

### Standard (score: 2)

Minimum fields:

- All Minimal fields.
- `intake_id` when an intake was recorded.
- `story_id` when the work maps cleanly to one story.
- `agent`.
- `actions_taken` as JSON array text.
- `files_read` as JSON array text.
- `files_changed` as JSON array text.
- At least one of `errors` or `harness_friction`.

Required for:

- Normal-lane tasks.
- Tiny tasks that changed Harness instructions, validation expectations, or
  durable records.

### Detailed (score: 3)

Minimum fields:

- All Standard fields.
- `decisions_made` as JSON array text.
- `errors` as JSON array text, using `none` when no errors occurred.
- `harness_friction`, using `none` only after checking for friction.
- `duration_seconds` or a note explaining why duration is unavailable.
- `token_estimate` or a note explaining why token estimate is unavailable.
- `notes` when one trace covers multiple stories or skipped validation.

Required for:

- High-risk tasks.
- Changes touching architecture direction, source-of-truth hierarchy,
  validation requirements, auth, authorization, data loss, audit/security.

## Lane Mapping

| Lane | Expected Tier | Minimum Trace Behavior |
| --- | --- | --- |
| Tiny | Minimal | Record summary and outcome; use Standard if friction or Harness docs changed. |
| Normal | Standard | Record intake, actions, files read, files changed, outcome, and friction/errors. |
| High-risk | Detailed | Record all fields or explicitly explain unavailable duration/token estimates. |

## Friction Capture Protocol

Populate `harness_friction` when any of these occur:

- The agent had to infer a missing rule or source of truth.
- Required validation was unclear, unavailable, or too expensive to run.
- A document, durable record, or story packet was stale or contradictory.
- The task revealed a repeated manual step that should become a template.
- A requested change was out of scope but likely important later.

How to write friction:

- Name the concrete pain, not a vague mood.
- Include the missing capability or contradiction.
- If the friction should become work, also add a backlog item with
  `rig backlog add`.

Good friction:

```text
New Phase 2 docs are not copied by installer, but installer propagation
is out of scope for docs-only Phase 2.
```

Weak friction:

```text
docs confusing
```

## Examples

### Good Trace (Detailed)

```bash
rig trace \
  --summary "Completed high-risk auth role migration with audit proof" \
  --intake 51 \
  --story US-014 \
  --agent codex \
  --outcome completed \
  --duration 4200 \
  --tokens 52000 \
  --actions "read access-control docs,created migration,updated audit tests,ran integration suite" \
  --read "docs/product/permissions.md,docs/decisions/0008-auth-boundary.md,src/auth/roles.ts" \
  --changed "src/auth/roles.ts,src/audit/events.ts,tests/auth-roles.test.ts" \
  --decisions "kept manager role scoped to workspace,recorded audit event on every role change" \
  --errors "none" \
  --friction "Existing permission docs did not define delegated admin; added backlog item for role glossary." \
  --notes "Detailed trace required because the task touched authorization and audit behavior."
```

### Adequate Trace (Standard)

```bash
rig trace \
  --summary "Added Phase 2 trace specification and Harness reference" \
  --intake 36 \
  --story US-004 \
  --agent codex \
  --outcome completed \
  --actions "read PHASE2.md,drafted TRACE_SPEC.md,updated HARNESS.md,ran rg checks" \
  --read "PHASE2.md,docs/HARNESS.md" \
  --changed "docs/TRACE_SPEC.md,docs/HARNESS.md" \
  --friction "none"
```

### Insufficient Trace

```bash
rig trace \
  --summary "did phase 2" \
  --outcome completed
```

Why this is insufficient for normal-lane work:

- It does not identify actions.
- It does not list files read or changed.
- It does not connect to intake or stories.
- It gives no friction or error signal.

## Review Checklist

Before the final response, check:

- The trace tier matches the lane.
- Review the score printed automatically by `rig trace`.
- `files_changed` matches the actual changed-file set.
- `errors` names real blockers or is `none` for Detailed traces.
- `harness_friction` either names a concrete issue or is intentionally `none`.
- Any friction that should become future work is recorded in the backlog.
