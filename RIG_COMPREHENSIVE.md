# 📖 Rig — Harness-Core Workflow Framework v5.0 Comprehensive Specification

Rig is a workflow operating framework designed to govern how AI coding agents collaborate with humans. This document acts as the complete, self-contained specification of Rig v5.0. It details the architecture, file structures, CLI mechanics, SQLite schema, workflows, and release pipeline.

---

## 1. System Architecture & Directory Structure

Rig uses a layered architecture to decouple general process control (Harness Core) from task-specific guides (Workflow Overlays).

### 1.1 Layers Overview
```
┌────────────────────────────────────────────────────────┐
│  Layer 1: HARNESS CORE (Source of Truth & Controls)    │
│  - core/HARNESS.md (The central state machine & rules) │
│  - core/FEATURE_INTAKE.md (Risk lanes classification)   │
│  - harness.db (SQLite persistent state engine)          │
├────────────────────────────────────────────────────────┤
│  Layer 2: WORKFLOW OVERLAYS (≤5KB each)                │
│  - 15 lightweight markdown guides mapped to commands   │
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
* `~/.gemini/GEMINI.md` — Entrypoint configuration (~20 lines). Tells the agent to look for global instructions in `~/.gemini/antigravity/`.
* `~/.gemini/rig_version` — Stores the currently installed version string (e.g., `5.0.0`).
* `~/.gemini/antigravity/core/` — Contains harness rules:
  * [HARNESS.md](file:///mnt/nvme/leaf/rig/core/HARNESS.md): The primary state-machine rules and instructions.
  * [FEATURE_INTAKE.md](file:///mnt/nvme/leaf/rig/core/FEATURE_INTAKE.md): Risk lanes, flags, and hard gates.
  * [communication-style.md](file:///mnt/nvme/leaf/rig/core/communication-style.md): Comm guidelines (Vietnamese primary, error parsing table).
  * `templates/`: Templates for story.md, decision.md, validation-report.md, and high-risk-story/ (overview, design, execplan, validation).
* `~/.gemini/antigravity/workflows/` — Core overlay files corresponding to the 15 slash commands.

#### Local Project Directory: `your-project/`
* [harness.db](file:///mnt/nvme/leaf/harness.db) — SQLite database (ignored via `.gitignore`). Stores active stories, decisions, traces, session state, and backlog items.
* `.brain/brain.json` — Git-committed state containing ONLY `infrastructure` and `github` configuration blocks.
* `docs/` — Human-readable documentation for the project:
  * `docs/product/` — Product specifications and feature details.
  * `docs/stories/` — active story packets.
  * `docs/decisions/` — Architectural decisions.

---

## 2. Harness Core State Machine & Task Loop

### 2.1 The Task Loop
For every user instruction (both natural language and slash commands), the agent must process through this flow:
1. **Intake & Classify**: Check the incoming task against risk criteria in `FEATURE_INTAKE.md`.
2. **Record Classification**: Execute `rig intake --type <type> --summary <summary> --lane <lane>`.
3. **Locate Context**: Read the product specifications in `docs/product/` or stories in `docs/stories/`.
4. **Lane Enforcement**:
   - **Tiny**: Apply code edits directly, keep docs updated, run available tests.
   - **Normal**: Create/update one story file using `templates/story.md`, link to product specs, run tests, and execute `rig story add/update`.
   - **High-Risk**: Create a folder under `docs/stories/` containing `overview.md`, `design.md`, `execplan.md`, and `validation.md`. Acknowledge decisions via `rig decision add`. Require user confirmation before modifying source code.
5. **Execution**: Implement changes incrementally and run verification scripts.
6. **Verify & Trace**: Run validation commands. Record completion in harness database using `rig trace`. Add harness friction, if any, to the backlog using `rig backlog add`.

---

## 3. Risk Lanes & Hard Gates

### 3.1 Risk Flags
Rig monitors 10 distinct risk flags when classifying a feature:
1. **Auth**: Authentication workflows.
2. **Authorization**: RBAC, tenant checks.
3. **Data model**: DB schema updates or migrations.
4. **Audit/security**: Logging access, handling sensitive PII.
5. **External systems**: Integration with payment gateways, email systems, external APIs.
6. **Public contracts**: Modifying API structures, public-facing schemas.
7. **Cross-platform**: Changes affecting mobile web/native/desktop.
8. **Existing behavior**: Overwriting or modifying working systems.
9. **Weak proof**: Lack of unit/integration tests for target code.
10. **Multi-domain**: Changing code in multiple decoupled sub-domains simultaneously.

### 3.2 Risk Classification Rules
* **0-1 flags** $\rightarrow$ **Tiny** or **Normal** (depending on volume of changes).
* **2-3 flags** $\rightarrow$ **Normal** (requires stronger validation criteria).
* **4+ flags** $\rightarrow$ **High-Risk**.

#### Hard Gates (Auto-promoted to High-Risk):
Touching *Auth*, *Authorization*, *Data Loss/Migration*, *Audit/Security*, or *External Providers* automatically forces the **High-Risk** lane.

---

## 4. SQLite Database Engine Schema (`harness.db`)

All transient operational states are managed via SQLite in WAL mode with Foreign Key support.

### 4.1 SQL Schema Statements

```sql
PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

-- Records the history of intake classifications
CREATE TABLE IF NOT EXISTS intake (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    input_type TEXT NOT NULL,
    summary TEXT NOT NULL,
    lane TEXT NOT NULL CHECK(lane IN ('tiny', 'normal', 'high-risk')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Stores project stories, status, and verification metrics
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

-- Architectural or design decisions
CREATE TABLE IF NOT EXISTS decision (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    doc_path TEXT,
    notes TEXT,
    status TEXT NOT NULL DEFAULT 'proposed' CHECK(status IN ('proposed', 'accepted', 'rejected', 'superseded')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Traces recorded at the completion of tasks, scoring completeness
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

-- Backlog of friction items, pain points, or missing features
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

-- Key-value pair configuration/session variables
CREATE TABLE IF NOT EXISTS session (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Knowledge base snippets accumulated during execution
CREATE TABLE IF NOT EXISTS knowledge (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ktype TEXT NOT NULL CHECK(ktype IN ('pattern', 'gotcha', 'convention', 'decision')),
    content TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

### 4.2 Scoring Formula
Traces are scored out of 10 points based on completeness.
* Base Points: **2.0** (always awarded if trace is created with summary & outcome).
* Completeness addition:
  * `story_id` is present $\rightarrow$ **+1.0**
  * `files_changed` is present $\rightarrow$ **+1.0**
  * `decisions` is present $\rightarrow$ **+1.0**
  * `harness_friction` is present $\rightarrow$ **+1.0**
* Calculation: $\text{Score} = \left(\frac{\text{Sum of points}}{6.0}\right) \times 10.0$

---

## 5. Rust CLI API Reference (`rig`)

Compiled into a standalone 1.8MB static binary. Below is the CLI subcommand command map:

| Command | Action | Arguments |
|---|---|---|
| `rig init` | Create SQLite schema in the working directory | None |
| `rig intake` | Register intake classification | `--type <TYPE> --summary <TEXT> --lane <tiny/normal/high-risk>` |
| `rig story add` | Create a new tracked story | `--id <ID> --title <TEXT> --lane <LANE> [--verify <CMD>]` |
| `rig story update` | Update story proof and status | `--id <ID> [--status <planned/in-progress/done/blocked>] [--unit <0/1>] [--integration <0/1>] [--e2e <0/1>] [--platform <0/1>] [--verify <CMD>]` |
| `rig story verify` | Execute story's verify shell script | `<ID>` (Exits with 1 on script failure, saves result) |
| `rig decision add` | Record architectural decision | `--id <ID> --title <TEXT> [--doc <PATH>] [--notes <NOTES>]` |
| `rig trace` | Record a completed task execution | `--summary <TEXT> --outcome <success/partial/blocked/failed> [--story <ID>] [--files-changed <FILES>] [--decisions <DECS>] [--errors <ERRS>] [--harness-friction <TEXT>]` |
| `rig score-trace`| Force recalculation of trace score | `<ID>` |
| `rig query stats` | Output high-level database metrics | None |
| `rig query matrix`| Show test proof coverage matrix | `--numeric` (Optional: displays as `0`/`1` instead of `yes`/`no`) |
| `rig query session`| Display active session parameters | None |
| `rig query backlog`| Display pain points backlog | `--open` or `--closed` |
| `rig query friction`| Display friction log from traces | None |
| `rig query traces` | Show history log of traces | `[LIMIT]` (Default limit is 20) |
| `rig session set` | Save a value to session state | `--key <KEY> --value <VALUE>` |
| `rig backlog add` | File a friction item to the backlog | `--title <TITLE> --pain <TEXT> [--risk <RISK>] [--predicted <TEXT>]` |
| `rig backlog close`| Close a backlog friction item | `--id <ID> --outcome <TEXT>` |

---

## 6. Workflow Overlays Specifications

The core contains 15 workflow files under `workflows/` which correspond directly to `/` commands.

1. **`init.md` (`/init`)**: Run `rig init`, check global files, setup `.gitignore`.
2. **`plan.md` (`/plan`)**: Check product specs, run risk checklist, run `rig intake`, draft story files.
3. **`design.md` (`/design`)**: Document architectural decisions, review APIs, run `rig decision add`.
4. **`visualize.md` (`/visualize`)**: Build layouts, generate image mockups, organize routes.
5. **`brainstorm.md` (`/brainstorm`)**: Perform research, explore files, document patterns.
6. **`code.md` (`/code`)**: Follow test-driven cycles: read stories, write test, edit code, verify.
7. **`debug.md` (`/debug`)**: Read logs, trace variables, apply fix, verify, record in trace.
8. **`refactor.md` (`/refactor`)**: Assess blast radius using graphify, rewrite structure, run tests.
9. **`verify.md` (`/verify`)**: Run automated tests, start local servers, execute `rig story verify`.
10. **`health.md` (`/health`)**: Check dependencies, review security, measure coverage.
11. **`deploy.md` (`/deploy`)**: Deploy to environments, audit staging, push to main.
12. **`status.md` (`/status`)**: Print project stats, check pending stories, outputs next steps.
13. **`save-brain.md` (`/save-brain`)**: Save patterns/gotchas to db, sync `.brain/brain.json`.
14. **`help.md` (`/help`)**: Command cheat-sheet and usage examples.
15. **`customize.md` (`/customize`)**: Configure session parameters and override templates.

### 6.1 Education Plugin Overlays
Located under `plugins/education/workflows/`:
1. **`textbook.md`**: Outlines processes for structured learning material synthesis.
2. **`pptx.md`**: Guide for generating slideshow outlines, content, and visuals.
3. **`question.md`**: Strategy for building question banks, evaluations, and grading metrics.
4. **`video.md`**: Scripting and structural design guide for video lessons.
5. **`export.md`**: Rules for compiling and rendering generated assets to PDF, EPUB, or HTML formats.

---

## 7. Build, Release, & Install Engine

### 7.1 Release Pipeline (`.github/workflows/release.yml`)
Runs automatically on push tags matching `v*`.
* Builds optimized binaries for:
  1. `x86_64-unknown-linux-gnu` (Linux x86_64)
  2. `aarch64-unknown-linux-gnu` (Linux ARM64, cross-compiled via `gcc-aarch64-linux-gnu`)
  3. `x86_64-apple-darwin` (macOS Intel)
  4. `aarch64-apple-darwin` (macOS Apple Silicon)
  5. `x86_64-pc-windows-msvc` (Windows x86_64)
* Publishes renamed binary targets to GitHub Releases.

### 7.2 Installer Engines (`install.sh` / `install.ps1`)
* Resolves platform targets (e.g. `linux-x86_64` vs `darwin-aarch64`).
* Fetches the corresponding pre-compiled binary from GitHub Releases. Falls back to compiling from source using `cargo` if the platform binary is missing or unreachable.
* Copies core files to `~/.gemini/antigravity/core/` and workflow files to `~/.gemini/antigravity/workflows/`.
* Places the `rig` binary in `~/.local/bin/` (Linux/Mac) or adds it to path (Windows).
