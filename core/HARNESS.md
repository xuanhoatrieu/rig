# Harness

The harness is the operating contract between humans and agents. It defines how
work enters, how it is classified, how it is tracked, and how the harness
itself improves over time.

The app is what users touch. The harness is what agents touch.

> **Reference:** Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/)
> by OpenAI. This is an independent implementation.

## Mental Model

```text
Human intent
    → Feature intake (classify input + risk)
    → Story packet (scoped work unit)
    → Agent work loop
    → Product delta (code, tests, docs)
    → Validation proof
    → Harness delta (improved templates, backlog)
    → Next intent
```

Every task produces two outputs:

1. **Product delta**: app code, tests, API shape, data model, or product docs.
2. **Harness delta**: docs, templates, validation, backlog items, or decision
   records that make the next task easier.

## Task Loop

For every task:

1. Classify the request with `core/FEATURE_INTAKE.md`.
2. Record the classification: `rig intake --type <type> --summary <text> --lane <lane>`.
3. Locate affected product docs and story files.
4. Check proof status: `rig query matrix`.
5. Work only inside the selected lane: tiny, normal, or high-risk.
6. Before finishing, ask whether product truth, validation expectations,
   architecture rules, or next-agent instructions changed.
7. Record a trace: `rig trace --summary <text> --outcome <outcome>`.
8. If harness friction was found, fix it or record it:
   `rig backlog add --title <name> --pain <what was hard>`.

## Source Hierarchy

```text
User-provided spec or prompt
  → input material for work

docs/product/*
  → current product contract

docs/stories/*
  → story-sized work packets

rig query matrix
  → behavior-to-proof control panel

docs/decisions/*
  → why the contract changed
```

## Done Definition

A task is done only when:

- The requested change is completed or the blocker is documented.
- Relevant docs, stories, and test matrix entries remain current.
- Validation commands were run when they exist.
- A trace has been recorded with `rig trace`.
- Missing harness capabilities were recorded with `rig backlog add`.
- The final response says what changed and what was not attempted.

## Growth Rule

The harness grows from friction.

When an agent is confused, repeats manual reasoning, needs a new validation
command, discovers a missing rule, or sees a recurring failure pattern, it must
either improve the harness directly or record the friction:

```bash
rig backlog add --title "<short name>" --pain "<what was hard>"
```

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
