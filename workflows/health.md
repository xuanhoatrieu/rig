---
description: 🏥 Review & Audit code
extends: core/HARNESS.md
tools: rig, graphify
---

# /health — Project Health Check (merged review + audit)

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Work

### 1. Scope Selection

- **Quick Scan** — Chỉ vấn đề nghiêm trọng (5 phút)
- **Full Health** — Toàn diện (15-30 phút)
- **Security Focus** — Chỉ bảo mật
- **Handover** — Tạo tài liệu bàn giao

### 2. Automated Scans

#### Security
- Passwords hashed? Sessions secure? Rate limiting?
- Input sanitized? SQL injection? XSS?
- API keys in code? .env in .gitignore?

#### Code Quality
- Dead code / unused imports
- Code duplication (>3 times)
- Functions too long (>50 lines)
- Meaningless variable names
- Outdated TODOs/FIXMEs

#### Performance
- N+1 queries? Missing DB indexes?
- Unnecessary re-renders? Images optimized?
- API response sizes? Pagination?

#### Graphify Intelligence (if available)
```bash
graphify query "unused functions" --graph graphify-out/graph.json
graphify query "circular dependencies" --graph graphify-out/graph.json
```

#### Harness Compliance
```bash
rig query stats        # Overall project health
rig query matrix       # Test coverage gaps
rig query backlog --open   # Pending friction items
```

### 3. Report

Tạo `docs/reports/health_[date].md`:
```markdown
# Health Report — [Date]
## Summary: 🔴 X critical | 🟡 Y warnings | 🟢 Z suggestions
## 🔴 Critical Issues (phải sửa)
## 🟡 Warnings (nên sửa)
## 🟢 Suggestions (tùy chọn)
## Harness Status
## Next Steps
```

### 4. Fix All Mode (optional)

- ✅ Auto-fixable: dead code, unused imports, formatting
- ⚠️ Need review: secrets exposure, SQL injection
- ❌ Manual only: architecture changes, business logic

## Post-work

```bash
rig trace --summary "Health check: <scope>" --outcome success
```

## Next Steps

```
1️⃣ Sửa vấn đề? → /debug hoặc /refactor
2️⃣ Code tiếp? → /code
3️⃣ Deploy? → /deploy
4️⃣ Lưu? → /save-brain
```
