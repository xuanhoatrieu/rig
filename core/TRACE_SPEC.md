# Trace Spec

Traces record what happened during a task for future review and scoring.

## When to Trace

Record a trace at the end of every task that changes code or docs.
Use `rig trace --summary <text> --outcome <outcome>`.

## Trace Tiers

| Tier | When | Required fields |
|---|---|---|
| Minimal | Tiny lane, trivial changes | summary, outcome |
| Standard | Normal lane | summary, outcome, files_changed, story_id |
| Detailed | High-risk lane | summary, outcome, files_changed, story_id, decisions, errors, harness_friction |

## Outcome Values

- `success` — Task completed as requested.
- `partial` — Some work done, blockers remain.
- `blocked` — Cannot proceed, documented why.
- `failed` — Attempted but unsuccessful.

## Scoring

Traces are auto-scored when recorded. Score reflects:
- Completeness of required fields for the tier.
- Whether linked story verification passed.
- Whether harness friction was captured.

Re-score a specific trace: `rig score-trace --id <id>`.
