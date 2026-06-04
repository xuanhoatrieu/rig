# Architecture Rules

Project-level architecture constraints. This file is a template — each project
customizes it after `/init`.

## Source of Truth

| Layer | Owner | Location |
|---|---|---|
| Product intent | Human | User prompts, specs |
| Product contract | Derived from intent | `docs/product/` |
| Work tracking | Harness | `rig query matrix`, `docs/stories/` |
| Architecture decisions | Human + Agent | `docs/decisions/` |
| Operational state | Harness DB | `harness.db` via `rig` CLI |

## Change Rules

- Schema changes require a decision record.
- API contract changes require human confirmation.
- New external dependencies require justification.
- Security-related changes are always high-risk lane.

## Conventions

- Fill in project-specific conventions here after `/init`.
- Example: "Use TypeScript for all new code."
- Example: "API responses follow { data, error, meta } envelope."
