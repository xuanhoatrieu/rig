---
description: 🧭 Tình trạng & Bước tiếp theo
extends: core/HARNESS.md
tools: rig
---

# /status — Project Status & Navigation (merged recap + next)

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Work — Tự động, KHÔNG hỏi user

### 1. Load State

```bash
rig query stats       # Overall project health
rig query session     # Current task context
rig query matrix      # Test coverage
```

### 2. Load Context

- `.brain/brain.json` → infrastructure, github
- `docs/product/README.md` → product description
- `git log -5` → recent commits (if git exists)

### 3. Graphify Overview (if available)

```bash
cat graphify-out/GRAPH_REPORT.md | head -30
```

### 4. Generate Report

```
🧭 PROJECT STATUS: [Tên dự án]
─────────────────────────────────
📊 Stories:  X/Y done (Z open)
📋 Traces:   N recorded (avg score: M/10)
📌 Backlog:  P open items
🔍 Coverage: [matrix summary]

📍 Đang làm: [current session task]
📝 Commit gần nhất: [last commit message]

➡️ BƯỚC TIẾP THEO:
[Smart suggestion based on state]
```

### 5. Smart Suggestion Logic

```
Nếu chưa có docs/ → /init
Nếu chưa có plan → /brainstorm hoặc /plan
Nếu có plan, chưa code → /code
Nếu đang code → tiếp tục /code hoặc /verify
Nếu có lỗi → /debug
Nếu test pass → /deploy
Cuối session → /save-brain
```

## Next Steps

```
[Dynamic based on analysis]
```
