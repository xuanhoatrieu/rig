# Harness

The harness is the operating contract between humans and agents. It defines how
work enters, how it is classified, how it is tracked, and how the harness
itself improves over time.

The app is what users touch. The harness is what agents touch.

> **Reference:** Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/)
> by OpenAI. This is an independent implementation.

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
| Story packet     |
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
managed by the `rig` CLI. The database is local to each project instance.

This separation keeps policy docs stable and human-readable while giving agents
a structured, queryable record of operational state.

Initialize the database if it does not exist:

```bash
rig init
```

Common commands:

```bash
rig intake  --type <type> --summary <text> --lane <lane>
rig story   add --id <id> --title <text> --lane <lane>
rig story   update --id <id> --status <status>
rig story   update --id <id> --unit 1 --integration 1 --e2e 0 --platform 0
rig story   verify <id>
rig story   verify-all
rig decision add --id <id> --title <text> --doc docs/decisions/<file>.md
rig trace   --summary <text> --outcome <outcome>
rig score-trace
rig score-context <trace-id>
rig audit
rig propose
rig query   matrix
rig query   matrix --numeric
rig query   backlog
rig query   tools --summary
rig query   interventions
rig query   stats
rig --version
```

## Task Loop

For every task:

1. Classify the request with `core/FEATURE_INTAKE.md`.
2. Record the classification: `rig intake --type <type> --summary <text> --lane <lane>`.
3. Locate affected product docs and story files.
4. Check proof status: `rig query matrix`.
5. Work only inside the selected lane: tiny, normal, or high-risk.
6. Before finishing, ask whether product truth, validation expectations,
   architecture rules, repeated failure patterns, or next-agent instructions
   changed.
7. Record a trace with `rig trace`, using `core/TRACE_SPEC.md` for the
   expected trace tier and field depth.
8. Review the trace score printed by `rig trace`; use
   `rig score-trace --id <id>` only when re-checking a specific historical trace.
9. If harness friction was found, fix it or record it:
   `rig backlog add --title <name> --pain <what was hard>`.

## Source Hierarchy

```text
User-provided spec or prompt
  → input material for first buildout or future changes

docs/product/*
  → current product contract derived from accepted input

docs/stories/*
  → story-sized work packets and historical evidence

rig query matrix
  → behavior-to-proof control panel backed by the durable layer

docs/decisions/*
  → why the contract changed
```

Before implementation, product docs describe intent. After implementation,
product docs plus executable tests become the living contract.

## Spec Lifecycle

When the human provides a specification, treat it as input material, not as a
permanent operating manual. Use it to populate product docs, story packets,
architecture decisions, and validation expectations during the first buildout.

After the specification has been decomposed, do not keep extending it as the
living product plan. Ongoing work should update the smaller product docs,
stories, durable proof records, and decision records.

Ongoing work should enter the harness as one of these input types:

- New spec: a project specification that needs to become product docs and
  initial story candidates.
- Spec slice: a selected behavior from the provided spec.
- Change request: a bounded behavior change, bug fix, or product refinement.
- New initiative: a larger product area that needs multiple stories.
- Maintenance request: dependency, architecture, performance, security, or
  operational work.
- Harness improvement: a process, template, proof, or agent-instruction change.

The spec-to-work loop is:

```text
human intent or supplied spec
  -> classify input type
  -> update or create product contract
  -> create story packet or initiative notes when needed
  -> define validation proof
  -> implement or document the blocker
  -> update product docs, stories, durable proof records, and decisions
  -> capture harness friction
```

Large product areas should use scoped initiative notes instead of a second
monolithic specification. An initiative should explain the goal, affected
product docs, candidate stories, validation shape, open decisions, and exit
criteria.

## Story Verification

Stories may carry a mechanical proof command:

```bash
rig story add --id US-012 --title "Story verification" --lane normal --verify "npm test"
rig story update --id US-012 --verify "npm test"
rig story verify US-012
```

`story verify` runs the command from the repository root, records
`last_verified_at` and `last_verified_result`, and exits 0 on pass or 1 on fail.

Use `story verify-all` before merges, maturity claims, and benchmark runs.

Record proof booleans with `story update`, using numeric values: `1` means yes
and `0` means no.

## Growth Rule

The harness grows from friction.

When an agent is confused, repeats manual reasoning, needs a new validation
command, discovers a missing rule, or sees a recurring failure pattern, it must
either improve the harness directly or record the friction:

```bash
rig backlog add --title "<short name>" --pain "<what was hard>"
```

Use the backlog outcome loop for improvements:

1. When creating the backlog item, fill `--predicted` with the measurable
   impact expected from the improvement.
2. When closing the item, fill `--outcome` with the actual measured result.
3. Use `rig query backlog --open` to review proposed and accepted items, and
   `rig query backlog --closed` to compare predictions with outcomes.

The `harness_friction` field on traces also captures per-task friction:

```bash
rig query friction
```

Backlog risk uses the same lane vocabulary: `tiny`, `normal`, or `high-risk`.

## Evolution Commands

Tool discovery:

```bash
rig query tools --summary
rig query tools --json
rig tool register --name <name> --command <cmd> --description <text> --responsibility Verification
```

Context and drift checks:

```bash
rig score-context <trace-id>
rig audit
```

Interventions:

```bash
rig intervention add --trace <id> --type correction --description <text> --source human
rig query interventions --story US-024
```

Record an intervention when a human, reviewer, CI system, or another agent
corrects, overrides, escalates, or approves work.

Improvement proposals:

```bash
rig propose
rig propose --commit
```

## Decision Records

High-risk work needs durable decisions when it changes behavior or architecture.

1. Add a markdown file under `docs/decisions/` from
   `core/templates/decision.md`.
2. Add or refresh the durable record:

```bash
rig decision add \
  --id 0008-auth-boundary \
  --title "Auth Boundary" \
  --doc docs/decisions/0008-auth-boundary.md \
  --notes "Accepted during T4 authentication work."
```

## Done Definition

A task is done only when:

- The requested change is completed or the blocker is documented.
- Relevant docs, stories, and test matrix entries remain current.
- Validation commands were run when they exist.
- A trace has been recorded with `rig trace`.
- Missing harness capabilities were recorded with `rig backlog add`.
- The final response says what changed and what was not attempted.

## Harness Change Policy

Agents may update directly:

- Story status and evidence via `rig story update`.
- Test matrix rows via `rig story add` and `rig story update`.
- Links from story packets to product docs.
- Validation notes and reports.
- Small clarifications tied to the current task.
- Intake records, traces, and backlog items via `rig`.

Agents should ask for human confirmation before:

- Changing architecture direction.
- Removing validation requirements.
- Changing the source-of-truth hierarchy.
- Changing risk classification rules.
- Replacing the feature workflow.
- Committing or pushing to Git.

## Graphify Integration

When `graphify-out/` exists in the project, agents should:

- **Before work**: `graphify query "<topic>" --graph graphify-out/graph.json`
- **After work**: `graphify update .`
- **For refactor**: `graphify explain "<symbol>"` to check blast radius

Graphify is optional. If not installed, skip these steps silently.

## Persistent Data Rules

`.brain/brain.json` stores `infrastructure` and `github` sections.
These sections must **NEVER** be deleted. Only add or update.
Always **ASK** before committing or pushing to GitHub.

All other operational state lives in `harness.db` managed by the `rig` CLI.

## Future Validation Ladder

When implementation begins, the expected ladder is:

```text
validate:quick
  format, lint, typecheck, unit tests, architecture check

test:integration
  backend, database, provider, or service checks as the stack requires

test:e2e
  user-visible end-to-end flows

test:platform
  shell, mobile, desktop, or deployment smoke checks as the stack requires

test:release
  full suite, log checks, and performance smoke
```

Agents must not claim these commands pass until they exist and have been run.
