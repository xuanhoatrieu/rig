# Architecture — Rig v5.2.0

## System Overview

Rig được thiết kế theo mô hình 4 tầng decoupled:

```
┌────────────────────────────────────────────────────────┐
│  Layer 1: HARNESS CORE (Source of Truth & Controls)    │
│  - core/HARNESS.md (Task Loop & Quy tắc trung tâm)     │
│  - core/FEATURE_INTAKE.md (Phân loại Risk Lanes)       │
│  - harness.db (SQLite persistent state engine)          │
├────────────────────────────────────────────────────────┤
│  Layer 2: WORKFLOW OVERLAYS (≤5KB each)                │
│  - 15 lightweight overlays tương ứng 15 slash commands │
├────────────────────────────────────────────────────────┤
│  Layer 3: PLUGINS                                      │
│  - Education workflows & custom tools                  │
├────────────────────────────────────────────────────────┤
│  Layer 4: UTILITIES & CLI                              │
│  - Rust CLI binary (rig)                               │
│  - Shell install scripts (install.sh / install.ps1)    │
└────────────────────────────────────────────────────────┘
```

## Tech Stack
- **CLI Engine**: Rust (clap, rusqlite, chrono, serde)
- **Durable Layer**: SQLite WAL mode (`harness.db`)
- **Overlay & Policies**: Markdown (`.gemini/antigravity/`)
- **Distribution**: GitHub Actions CI/CD cross-compile release binary cho Linux, macOS, Windows
