---
description: ✅ Chạy & Kiểm thử
extends: core/HARNESS.md
tools: rig
---

# /verify — Run & Test (merged)

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Work

### 1. Environment Detection

Auto-detect run method:
- `docker-compose.yml` → Docker mode
- `package.json` with `dev` script → `npm run dev`
- `requirements.txt` → Python mode
- `Makefile` → Read Makefile

### 2. Pre-Run Checks

- Dependencies installed? If not → auto-install.
- Port available? If not → offer to kill or use different port.

### 3. Run App

Start in background, monitor output:
- "Ready on http://..." → SUCCESS
- Error → capture and explain

### 4. Test Strategy

Hỏi user:
- **Quick Check** — Chỉ test cái vừa sửa
- **Full Suite** — `npm test` / `cargo test`
- **Manual Verify** — Hướng dẫn test tay

### 5. Test Execution

1. Find test files (`__tests__/`, `*.test.*`, `*.spec.*`)
2. Run matching tests
3. If no tests exist → create quick verification script

### 6. Result Analysis

- PASS → "Tất cả test đều pass!"
- FAIL → Phân tích lỗi, giải thích nguyên nhân, hỏi muốn `/debug` không

### 7. Update Proof

```bash
rig story update --id "US-XXX" --unit 1 --integration 0
```

## Next Steps

```
1️⃣ Test pass? → /deploy
2️⃣ Test fail? → /debug
3️⃣ Muốn thêm test? → /code
4️⃣ Xong? → /save-brain
```
