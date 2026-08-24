---
description: 🧭 Tình trạng & Bước tiếp theo
extends: core/HARNESS.md
tools: rig
---

# /status — Project Status & Navigation

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Work — Tự động, KHÔNG hỏi user

### 1. Load State

```bash
rig query stats       # Overall project health
rig plan list         # Active plans
rig query session     # Current task context
rig query matrix      # Test coverage
```

### 2. Load Context

- `.brain/brain.json` → infrastructure, github
- `docs/product/README.md` → product description
- `git log -5` → recent commits (if git exists)

### 3. Generate Report

```
🧭 PROJECT STATUS: [Tên dự án]
─────────────────────────────────
📋 Plans:    A/B active
📊 Stories:  X/Y done (Z open)
📝 Traces:   N recorded (avg score: M/10)
📌 Backlog:  P open items
🔍 Coverage: [matrix summary]

📍 Đang làm: [current session task / active plan]
📝 Commit gần nhất: [last commit message]

➡️ BƯỚC TIẾP THEO:
[Smart suggestion based on state]
```

### 4. Smart Suggestion Logic

```
Nếu chưa có docs/ hoặc DB lỗi → /init hoặc rig doctor
Nếu chưa có plan → /brainstorm hoặc /plan
Nếu có active plan, chưa code → /code
Nếu đang code → tiếp tục /code hoặc /verify
Nếu có lỗi → /debug
Nếu test pass → /deploy
Cuối session → /save-brain
```
