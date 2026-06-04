# Feature Intake

Every implementation prompt enters the intake gate before code changes.

The human does not need to classify risk. The harness does.

## Intake Flow

```text
User prompt
    → Classify input type
    → Restate as work item
    → Find affected product docs and stories
    → Run risk checklist
    → Choose lane: tiny, normal, or high-risk
    → Record: rig intake --type <type> --summary <text> --lane <lane>
```

## Input Types

| Type | Use when | Typical artifact |
| --- | --- | --- |
| New spec | Turning a spec into harness-ready docs | Product docs, story candidates, decisions |
| Spec slice | Implementing selected behavior from accepted spec | Story packet |
| Change request | Changing, fixing, or refining accepted behavior | Story packet or direct patch |
| New initiative | Larger product area needing multiple stories | Initiative notes + story packets |
| Maintenance | Dependency, architecture, performance, or security work | Story packet or validation report |
| Harness improvement | Improving how humans and agents collaborate | Direct docs update or `rig backlog add` |

## Lanes

### Tiny

Low-risk docs, copy, names, narrow edits, or initial project scaffolding.

Requirements:
- Patch directly.
- Keep affected docs current.
- Run available quick checks.

### Normal

Story-sized behavior with bounded blast radius.

Requirements:
- Create or update one story file from `core/templates/story.md`.
- Link relevant product docs.
- Add or update validation expectations.
- Record proof status: `rig story add` / `rig story update`.

### High-Risk

Work affecting security, data, scope, contracts, or multiple roles/platforms.

Requirements:
- Create a story folder using `core/templates/high-risk-story/`.
- Fill in overview.md, design.md, execplan.md, validation.md.
- Ask human confirmation before implementation.
- Record durable decision: `rig decision add`.

## Risk Checklist

| Risk flag | Applies when the work touches |
| --- | --- |
| Auth | Login, logout, sessions, JWT, password, refresh token |
| Authorization | Roles, permissions, tenant scope |
| Data model | Schema, migrations, uniqueness, deletion, retention |
| Audit/security | Audit logs, privacy, sensitive data |
| External systems | Email, payments, cloud services, webhooks |
| Public contracts | API shape, response envelope, client-visible behavior |
| Cross-platform | Desktop/mobile/browser split, native behavior |
| Existing behavior | Already implemented or test-covered behavior changes |
| Weak proof | Unclear or missing tests around affected area |
| Multi-domain | More than one product domain changes at once |

## Classification

```text
0-1 flags  → tiny or normal (based on code impact)
2-3 flags  → normal with stronger validation
4+ flags   → high-risk
```

Hard gates (auto high-risk):
- Auth
- Authorization
- Data loss or migration
- Audit/security
- External provider behavior

## Output

After intake, the agent states:

```text
Lane: normal
Reason: touches authorization and API contract.
Story: docs/stories/US-014-manager-updates-role.md
Validation: unit, integration.
```
