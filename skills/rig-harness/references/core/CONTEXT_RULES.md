# Context Engineering Rules

Context rules help agents decide what to read, when to read it, and when to
stop reading. They are additive to the stable reading list.

The goal is not to maximize context. The goal is to put the right information
in the model for the current task phase and risk lane.

## Context Phases

### Intake Phase

Read to classify the request, find the affected surface, and choose a lane.

| Document Or Source | Tiny | Normal | High-Risk |
| --- | --- | --- | --- |
| `core/FEATURE_INTAKE.md` | Must | Must | Must |
| `rig query matrix` | Must | Must | Must |
| `README.md` | Should | Must | Must |
| `core/HARNESS.md` | Should | Must | Must |
| `core/ARCHITECTURE.md` | Skip | Should | Must |
| Relevant `docs/product/*` | Skip if unrelated | Must if product behavior changes | Must |
| Relevant `docs/stories/*` | Skip if unrelated | Must if a story exists | Must |
| `docs/decisions/*` | Skip | Should if architecture or durable rules are touched | Must |

### Planning Phase

Read to decide the smallest safe approach and expected proof.

| Document Or Source | Tiny | Normal | High-Risk |
| --- | --- | --- | --- |
| Current files to edit | Must | Must | Must |
| `core/templates/story.md` | Skip | Must when creating/updating a story | Should |
| `core/templates/high-risk-story/*` | Skip | Skip unless risk escalates | Must |
| `core/ARCHITECTURE.md` | Skip | Should for code or boundary changes | Must |
| `rig query matrix` | Should | Must | Must |
| Relevant decisions | Skip | Should | Must |

### Implementation Phase

Read while making the change. Keep this phase scoped to files that directly
affect the selected story.

| Document Or Source | Tiny | Normal | High-Risk |
| --- | --- | --- | --- |
| Files being changed | Must | Must | Must |
| Adjacent files with same pattern | Should | Must | Must |
| Relevant product docs | Skip if copy-only | Must if behavior changes | Must |
| Relevant story packet | Skip if no story needed | Must | Must |
| `core/ARCHITECTURE.md` | Skip | Should for structural changes | Must |
| Unrelated docs and historical traces | Skip | Skip | Should only if they affect decisions |

### Validation Phase

Read to prove the change and avoid claiming unsupported completion.

| Document Or Source | Tiny | Normal | High-Risk |
| --- | --- | --- | --- |
| Story acceptance criteria | Should | Must | Must |
| `rig query matrix` | Should | Must | Must |
| Validation section of story packet | Skip if no story | Must | Must |
| `core/templates/validation-report.md` | Skip | Should for notable proof | Must for high-risk proof |
| Relevant commands from README/package docs | Should | Must | Must |

### Trace Phase

Read to leave useful evidence for the next agent and for benchmark scoring.

| Document Or Source | Tiny | Normal | High-Risk |
| --- | --- | --- | --- |
| `core/TRACE_SPEC.md` | Should | Must | Must |
| `rig query matrix` | Should | Must | Must |
| `rig query backlog` | Skip | Should if friction occurred | Must |
| Changed-file list from `git status --short` | Must | Must | Must |
| Validation command output | Should | Must | Must |
| Story packet or progress log | Skip if no story | Must | Must |

## Retrieval Triggers

| Trigger Condition | Action |
| --- | --- |
| Task touches database schema or migrations | Read relevant decisions and schema files before planning. |
| Task touches auth, authorization, audit/security, data loss, or external providers | Treat as high-risk, read `core/templates/high-risk-story/*`, and check prior decisions. |
| Task changes public API shape, product behavior, or user-visible workflow | Read relevant `docs/product/*`, story packets, and validation expectations. |
| Task changes Harness policy, source hierarchy, risk classification, or validation requirements | Read `core/HARNESS.md`, `core/FEATURE_INTAKE.md`, `core/ARCHITECTURE.md`, and `docs/decisions/*`. |
| Task discovers repeated confusion, stale docs, or missing proof | Record `harness_friction` and add a backlog item. |
| Task is normal or high-risk and spans multiple iterations | Create or update a story/progress file under `docs/stories/`. |
| Final response is being prepared | Re-read validation evidence, `git status --short`, and `core/TRACE_SPEC.md` before recording the trace. |

## Token Budget Guidance

| Lane | Target Context Budget | Reasoning |
| --- | --- | --- |
| Tiny | About 2K tokens of Harness context | Tiny work should not spend more context on policy than on the edit. |
| Normal | About 5K tokens of Harness context | Normal work needs enough context to preserve contracts and record proof. |
| High-risk | About 10K tokens of Harness context | High-risk work needs source hierarchy, prior decisions, and proof expectations. |

Budget rules:

- Prefer targeted `rg` searches over bulk reading.
- Read the smallest section that answers the current phase question.
- Escalate context when a retrieval trigger fires.
- Do not keep reading unrelated history after the lane, affected files, and
  validation path are clear.

## Review Checklist

Before implementation:

- Lane is chosen from `core/FEATURE_INTAKE.md`.
- Relevant product docs or story packets are identified.
- Any high-risk trigger has been handled.

Before final response:

- Validation evidence has been read.
- `core/TRACE_SPEC.md` has been read for normal/high-risk tasks.
- The final trace includes files read, files changed, outcome, and friction.
