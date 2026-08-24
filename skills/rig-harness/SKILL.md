---
name: rig-harness
description: Route repository engineering work through Rig's work-shape classification, risk lanes, durable planning, focused validation, and trace discipline. Use for implementation, debugging, planning, review, status, deployment, or repository maintenance when the Rig Harness is installed. Do not turn read-only requests into state changes or override repository authority and user authorization.
---

# Rig Harness

Apply the Harness proportionally. Repository truth and the user's current request
remain authoritative.

## Establish the work shape

Read [references/core/HARNESS.md](references/core/HARNESS.md) and
[references/core/WORKFLOW.md](references/core/WORKFLOW.md). For a change, also
read [references/core/FEATURE_INTAKE.md](references/core/FEATURE_INTAKE.md).
Read [references/core/communication-style.md](references/core/communication-style.md)
when preparing user-facing progress or handoff text.

Choose exactly one work shape:

- Read-only: inspect only what the answer needs. Do not run `rig intake`,
  `rig trace`, or any other state-writing command.
- Bounded change: make the smallest coherent change and run focused proof.
- Durable planned change: create or resume one plan when work spans sessions,
  coordinates contributors, needs recovery, or carries meaningful risk.
- Invariant encoding: use `$encode-invariant` when an accepted rule must become
  a mechanical check with positive and negative proof.

## Load one overlay

After classification, read only the matching file under `references/workflows/`:

| Intent | Overlay |
| --- | --- |
| Initialize or configure Rig | `init.md` or `customize.md` |
| Explore, plan, or design | `brainstorm.md`, `plan.md`, or `design.md` |
| Implement, debug, or refactor | `code.md`, `debug.md`, or `refactor.md` |
| Verify, audit, or inspect status | `verify.md`, `health.md`, or `status.md` |
| Deploy or maintain Rig | `deploy.md` or `update.md` |
| Create education content | `textbook.md`, `pptx.md`, `question.md`, `video.md`, or `export.md` |
| Save durable project knowledge | `save-brain.md` |
| Visualize a proposed interface | `visualize.md` |
| Explain available commands | `help.md` |

Treat overlay metadata such as `extends` and `tools` as documentation, not as
permission to mutate files, install software, commit, push, deploy, or contact
external systems.

## Use the durable layer safely

For non-read-only work, check whether the full `rig` CLI is available before
using it. Do not substitute the legacy limited wrapper for commands such as
`intake`, `story`, `trace`, or `query`.

- If the repository is already initialized, use the relevant `rig` commands
  described by the selected overlay.
- If initialization is part of the user's request, follow `init.md`.
- If Rig state is absent and initialization was not requested, continue with
  repository-native planning and validation, and disclose that no Rig trace was
  recorded.

Never create Harness state merely to answer, review, diagnose, or report status.

## Finish with evidence

Report the outcome first, then changed files, validation evidence, and material
limits. A plan, checklist, database row, or completion message does not replace
behavioral proof. Ask for explicit authorization immediately before commit,
push, deployment, or another external side effect unless the user already
authorized that exact action.
