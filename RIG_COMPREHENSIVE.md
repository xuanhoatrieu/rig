# 📖 Rig — Harness-Core Workflow Framework v5.1.0 Comprehensive Specification

Rig is a workflow operating framework designed to govern how AI coding agents collaborate with humans. This document acts as the complete, self-contained specification of Rig v5.1.0. It details the architecture, file structures, CLI mechanics, SQLite schema, workflows, skills, and release pipeline.

---

## 1. System Architecture & Directory Structure

Rig uses a layered architecture to decouple general process control (Harness Core) from task-specific guides (Workflow Overlays) and specialized domain skills.

### 1.1 Layers Overview
```
┌────────────────────────────────────────────────────────┐
│  Layer 1: HARNESS CORE (Source of Truth & Controls)    │
│  - core/HARNESS.md (Central state machine & rules)     │
│  - core/WORKFLOW.md (4 Work shapes & workflows)        │
│  - core/FEATURE_INTAKE.md (Risk lanes classification)   │
│  - core/patterns/encoding-invariants.md (Guards)       │
│  - harness.db (SQLite persistent state engine)          │
├────────────────────────────────────────────────────────┤
│  Layer 2: WORKFLOW OVERLAYS & AGENT SKILLS             │
│  - 15 lightweight markdown guides mapped to commands   │
│  - 5 specialized agent skills ($skill)                 │
├────────────────────────────────────────────────────────┤
│  Layer 3: PLUGINS                                      │
│  - Education workflows & custom tools                  │
├────────────────────────────────────────────────────────┤
│  Layer 4: UTILITIES & SYSTEM                           │
│  - Rust CLI binary (rig)                               │
│  - Shell install scripts (install.sh / install.ps1)    │
└────────────────────────────────────────────────────────┘
```

### 1.2 File Tree & Paths Mapping

When installed, files are organized into a global directory (shared across all projects) and a local directory (per-project state and documentation).

#### Global Directory: `~/.gemini/`
* `~/.gemini/GEMINI.md` — Entrypoint configuration (~25 lines). Tells the agent to look for global instructions in `~/.gemini/antigravity/`.
* `~/.gemini/rig_version` — Stores the currently installed version string (e.g., `5.1.0`).
* `~/.gemini/antigravity/core/` — Contains harness rules:
  * `HARNESS.md`: The primary state-machine rules and instructions.
  * `WORKFLOW.md`: 4 Work shapes and repository flows.
  * `FEATURE_INTAKE.md`: Risk lanes, flags, and hard gates.
  * `patterns/encoding-invariants.md`: Invariant encoding specifications.
  * `communication-style.md`: Comm guidelines (Vietnamese primary, error parsing table).
  * `templates/`: Templates for `exec-plan.md`, `application-runbook.md`, `harness-improvement.md`, `decision.md`, `story.md`.
* `~/.gemini/antigravity/skills/` — 5 specialized agent skills:
  * `encode-invariant/`
  * `onboard-repository/`
  * `audit-onboarding-proposal/`
  * `improve-harness/`
  * `engineering-wisdom/`
* `~/.gemini/antigravity/workflows/` — Core overlay files corresponding to the 15 slash commands.

#### Local Project Directory: `your-project/`
* `harness.db` — SQLite database (ignored via `.gitignore`). Stores active plans, stories, decisions, traces, session state, and backlog items.
* `.brain/brain.json` — Git-committed state containing ONLY `infrastructure` and `github` configuration blocks.
* `docs/` — Human-readable documentation for the project:
  * `docs/product/` — Product specifications and feature details.
  * `docs/plans/` — Durable plans (`active/` and `completed/`).
  * `docs/patterns/` — Architectural & invariant patterns.
  * `docs/stories/` — Active story packets.
  * `docs/decisions/` — Architectural decisions (ADR).

---

## 2. Harness Core State Machine & Task Loop

### 2.1 The 4 Work Shapes
1. **Read-Only Request**: Inspection only; no file or harness state mutations.
2. **Bounded Change**: Small, coherent change with relevant unit/integration tests.
3. **Durable Planned Change**: Multi-session, coordinated, or high-risk change tracked via `docs/plans/active/<name>.md` and `rig plan`.
4. **Invariant Encoding**: Translate accepted rules into 2-way verified mechanical checks (Positive & Negative proof) using `$encode-invariant`.

### 2.2 The Task Loop
For every user instruction (both natural language, slash commands, and $ skills):
1. **Intake & Classify**: Check the incoming task against risk criteria in `FEATURE_INTAKE.md` and `WORKFLOW.md`.
2. **Record Classification**: Execute `rig intake --type <type> --summary <summary> --lane <lane>`.
3. **Locate Context**: Read product specifications in `docs/product/`, active plans in `docs/plans/active/`, or stories in `docs/stories/`.
4. **Lane Enforcement**:
   - **Tiny**: Apply code edits directly, keep docs updated, run available tests.
   - **Normal**: Create/update plan with `rig plan create` or story file, link to product specs, run tests.
   - **High-Risk**: Require human confirmation before modifying source code; record ADR via `rig decision add`.
5. **Execution**: Implement changes incrementally and run verification scripts.
6. **Verify & Trace**: Run validation commands. Record completion in harness database using `rig trace`. Add harness friction, if any, to the backlog using `rig backlog add`.

---

## 3. SQLite Database Engine Schema (`harness.db`)

All transient operational states are managed via SQLite in WAL mode with Foreign Key support.

```sql
PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

CREATE TABLE IF NOT EXISTS intake (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    input_type TEXT NOT NULL,
    summary TEXT NOT NULL,
    lane TEXT NOT NULL CHECK(lane IN ('tiny', 'normal', 'high-risk')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS plan (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    lane TEXT NOT NULL DEFAULT 'normal' CHECK(lane IN ('tiny', 'normal', 'high-risk')),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active', 'completed', 'cancelled')),
    file_path TEXT,
    outcome TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS story (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    lane TEXT NOT NULL CHECK(lane IN ('tiny', 'normal', 'high-risk')),
    status TEXT NOT NULL DEFAULT 'planned' CHECK(status IN ('planned', 'in-progress', 'done', 'blocked')),
    unit_proof INTEGER DEFAULT 0,
    integration_proof INTEGER DEFAULT 0,
    e2e_proof INTEGER DEFAULT 0,
    platform_proof INTEGER DEFAULT 0,
    verify_command TEXT,
    last_verified_at TEXT,
    last_verified_result TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS decision (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    doc_path TEXT,
    notes TEXT,
    status TEXT NOT NULL DEFAULT 'proposed' CHECK(status IN ('proposed', 'accepted', 'rejected', 'superseded')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS trace (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    summary TEXT NOT NULL,
    outcome TEXT NOT NULL CHECK(outcome IN ('success', 'partial', 'blocked', 'failed')),
    story_id TEXT,
    files_changed TEXT,
    decisions TEXT,
    errors TEXT,
    harness_friction TEXT,
    score REAL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (story_id) REFERENCES story(id)
);

CREATE TABLE IF NOT EXISTS backlog (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    pain TEXT NOT NULL,
    risk TEXT DEFAULT 'tiny' CHECK(risk IN ('tiny', 'normal', 'high-risk')),
    predicted TEXT,
    outcome TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open', 'closed')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_at TEXT
);

CREATE TABLE IF NOT EXISTS session (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS knowledge (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ktype TEXT NOT NULL CHECK(ktype IN ('pattern', 'gotcha', 'convention', 'decision')),
    content TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

---

## 4. Rust CLI API Reference (`rig`)

| Command | Action | Arguments |
|---|---|---|
| `rig init` | Create SQLite schema in the working directory | None |
| `rig doctor` | Health check on database, file structure, and Git ignore | None |
| `rig status` | High level project stats overview | None |
| `rig plan create` | Create a durable plan in `docs/plans/active/` | `--title <TITLE> [--lane <LANE>]` |
| `rig plan list` | List active (or all) execution plans | `[--all]` |
| `rig plan complete`| Move plan to `completed/` and record outcome | `--id <ID> [--outcome <TEXT>]` |
| `rig intake` | Register intake classification | `--type <TYPE> --summary <TEXT> --lane <LANE>` |
| `rig story add` | Create a new tracked story | `--id <ID> --title <TEXT> --lane <LANE> [--verify <CMD>]` |
| `rig story update` | Update story proof and status | `--id <ID> [--status <STATUS>] [--unit <0/1>] ...` |
| `rig story verify` | Execute story's verify shell script | `<ID>` |
| `rig decision add` | Record architectural decision | `--id <ID> --title <TEXT> [--doc <PATH>] [--notes <NOTES>]` |
| `rig trace` | Record a completed task execution | `--summary <TEXT> --outcome <OUTCOME> ...` |
| `rig score-trace`| Force recalculation of trace score | `--id <ID>` |
| `rig query stats` | Output database metrics | None |
| `rig query matrix`| Show test proof coverage matrix | `[--numeric]` |
| `rig query session`| Display active session parameters | None |
| `rig query backlog`| Display pain points backlog | `[--open/--closed]` |
| `rig query friction`| Display friction log from traces | None |
| `rig query traces` | Show history log of traces | `[--limit <N>]` |
| `rig session set` | Save a value to session state | `--key <KEY> --value <VALUE>` |
| `rig backlog add` | File a friction item to the backlog | `--title <TITLE> --pain <TEXT> ...` |
| `rig backlog close`| Close a backlog friction item | `--id <ID> --outcome <TEXT>` |

---

## 5. Agent Skills Specifications

1. **`encode-invariant`**: Converts accepted repository rules into mechanical checks with positive and negative proof.
2. **`onboard-repository`**: Inspects brownfield repositories and emits machine-authenticated evidence capsules (v2).
3. **`audit-onboarding-proposal`**: Audits onboarding transcripts and verifies capsule SHA-256 digests.
4. **`improve-harness`**: Executes evidence-backed harness improvements with fresh agent rerun validation.
5. **`engineering-wisdom`**: Evaluates code and architecture against solid engineering heuristics.
