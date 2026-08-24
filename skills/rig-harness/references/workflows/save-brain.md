---
description: 💾 Lưu kiến thức
extends: core/HARNESS.md
tools: rig
---

# /save-brain — Knowledge Persistence

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Work

### 1. Save Session State

```bash
rig session set --key "last_saved" --value "<timestamp>"
rig session set --key "working_on" --value "<current task>"
rig session set --key "next_steps" --value "<what to do next>"
```

### 2. Record Infrastructure (if changed)

Update `.brain/brain.json` — only `infrastructure` and `github` sections.
**NEVER delete existing data in these sections.**

```json
{
  "infrastructure": {
    "server": { "ip": "...", "user": "...", "os": "..." },
    "database": { "type": "...", "host": "...", "port": "..." },
    "services": { "dev_server": "...", "ports": [] }
  },
  "github": {
    "repo_url": "...",
    "rules": "Always ask before commit/push"
  }
}
```

### 3. Record Trace

```bash
rig trace --summary "Session saved: <summary of work>" --outcome success
```

### 4. Harness Maintenance

- Close any in-progress stories if work is complete
- Record friction if encountered during session
- Check for stale stories (open > 7 days)

### 5. Re-index (if Graphify available)

```bash
graphify update .
```

### 6. Proactive Handover

Tóm tắt cho agent kế tiếp:
- "Đang làm gì"
- "Đã xong gì"
- "Cần làm tiếp gì"
- "Lưu ý gì đặc biệt"

## Next Steps

```
1️⃣ Tiếp tục làm? Nói cho em biết task tiếp
2️⃣ Nghỉ? Context đã được lưu, lần sau gõ /status
```
