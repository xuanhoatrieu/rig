# Harness

The harness is the operating contract between humans and agents. It defines how
work enters, how it is classified, how it is tracked, and how the harness
itself improves over time.

The app is what users touch. The harness is what agents touch.

> **Reference:** Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/)
> and [repository-harness](https://github.com/hoangnb24/repository-harness).

## Core Principles

1. **Repository truth wins.** Product documents, decisions, plans, code, tests,
   CI, runtime evidence, and Git history are authoritative.
2. **Load the smallest useful context.** Entrypoints are maps, not encyclopedias.
3. **Process follows work shape.** Bounded work stays bounded; coordinated or
   recoverable work gets one durable plan (`docs/plans/active/` -> `docs/plans/completed/`).
4. **Material choices stay human-owned.** Missing product policy stops mutation.
5. **Behavior proves completion.** Workflow records and self-reports do not
   replace executable or observable evidence.

## Work Shapes & Flows

```text
read-only request
  -> inspect the smallest authoritative surface
  -> answer with evidence

bounded change
  -> inspect authority and affected behavior
  -> implement the smallest coherent change
  -> run relevant proof

multi-session or coordinated change
  -> create docs/plans/active/<plan>.md
  -> keep decisions, progress, recovery, and validation current
  -> move the validated plan to docs/plans/completed/

invariant encoding
  -> find accepted repository authority
  -> add smallest mechanical check (positive & negative proof)
  -> report local / hook / CI / branch protection levels
```

See [WORKFLOW.md](WORKFLOW.md) and [patterns/encoding-invariants.md](patterns/encoding-invariants.md)
for complete details.

## Mental Model

```text
+------------------+
| Human intent     |
+------------------+
         |
         v
+------------------+
| Feature intake   |
+------------------+
         |
         v
+------------------+
| Plan / Story     |
+------------------+
         |
         v
+------------------+
| Agent work loop  |
+------------------+
         |
         v
+------------------+
| Product delta    |
+------------------+
         |
         v
+------------------+
| Validation proof |
+------------------+
         |
         v
+------------------+
| Harness delta    |
+------------------+
         |
         v
+------------------+
| Next intent      |
+------------------+
```

Every task produces two outputs:

1. **Product delta**: app code, tests, API shape, data model, or product docs.
2. **Harness delta**: docs, templates, validation expectations, backlog items, or
   decision records that make the next task easier.

## Durable Layer

Policy documents describe how to work. The durable layer stores what happened.

Operational data — intake classifications, story status, decision outcomes,
backlog items, and execution traces — lives in a SQLite database (`harness.db`)
managed by the `rig` CLI.

Initialize and verify the environment:

```bash
rig init          # Khởi tạo database harness.db
rig doctor        # Kiểm tra tính toàn vẹn của harness & files
rig status        # Xem tổng quan trạng thái
```

Common commands:

```bash
rig intake  --type <type> --summary <text> --lane <lane>
rig plan    create --title <title> --lane <lane>
rig plan    list
rig plan    complete --id <id>
rig story   add --id <id> --title <text> --lane <lane>
rig story   update --id <id> --status <status>
rig story   verify <id>
rig story   verify-all
rig decision add --id <id> --title <text> --doc docs/decisions/<file>.md
rig trace   --summary <text> --outcome <outcome>
rig score-trace --id <id>
rig query   matrix
rig query   backlog
rig query   stats
rig --version
```

## Task Loop

For every task:

1. Classify the request with `core/FEATURE_INTAKE.md` and `core/WORKFLOW.md`.
2. Record the classification: `rig intake --type <type> --summary <text> --lane <lane>`.
3. Locate affected product docs, plans (`docs/plans/active/`), and story files.
4. Check proof status: `rig query matrix`.
5. Work only inside the selected lane: `tiny`, `normal`, or `high-risk`.
6. Before finishing, ask whether product truth, validation expectations,
   architecture rules, repeated failure patterns, or next-agent instructions
   changed.
7. Record a trace with `rig trace`, using `core/TRACE_SPEC.md` for the
   expected trace tier and field depth.
8. Review the trace score printed by `rig trace`.
9. If harness friction was found, fix it or record it:
   `rig backlog add --title <name> --pain <what was hard>`.

## Source Hierarchy

```text
User-provided spec or prompt
  → input material for first buildout or future changes

docs/product/*
  → current product contract derived from accepted input

docs/plans/active/* & docs/stories/*
  → active work packets, plans, and historical evidence

docs/patterns/*
  → architectural patterns & invariant encoding rules

rig query matrix / harness.db
  → behavior-to-proof control panel backed by the durable layer

docs/decisions/*
  → why the contract changed
```

## Growth Rule

The harness grows from friction.

When an agent is confused, repeats manual reasoning, needs a new validation
command, discovers a missing rule, or sees a recurring failure pattern, it must
either improve the harness directly or record the friction:

```bash
rig backlog add --title "<short name>" --pain "<what was hard>"
```

When the user explicitly invokes `$improve-harness`, use `docs/templates/harness-improvement.md`
to preserve the baseline, locate the earliest gap, apply one intervention, and require
a fresh rerun.

## Persistent Data Rules

`.brain/brain.json` stores `infrastructure` and `github` sections.
These sections must **NEVER** be deleted. Only add or update.
Always **ASK** before committing or pushing to GitHub.

All other operational state lives in `harness.db` managed by the `rig` CLI.
