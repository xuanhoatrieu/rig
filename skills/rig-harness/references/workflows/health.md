---
description: 🏥 Review, Audit code & Harness Doctor
extends: core/HARNESS.md
tools: rig, graphify
---

# /health — Project Health & Integrity Check

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Work

### 1. Harness & Repository Integrity (Mới)
Chạy kiểm tra toàn vẹn cấu trúc và cơ sở dữ liệu:
```bash
rig doctor
```

### 2. Scope Selection

- **Quick Scan** — Kiểm tra Harness Doctor + lỗi nghiêm trọng (5 phút)
- **Full Health** — Toàn diện Code Quality + Security + Test Matrix (15-30 phút)
- **Security Focus** — Kiểm tra bảo mật & invariant boundaries
- **Handover** — Tạo tài liệu bàn giao

### 3. Automated Scans

#### Security & Invariant Boundaries
- Passwords hashed? Sessions secure? Rate limiting?
- Input sanitized? SQL injection? XSS?
- API keys in code? .env in .gitignore?
- Invariants kiểm tra 2 chiều (positive & negative proof)

#### Code Quality & Architecture
- Dead code / unused imports
- Dependency layering (`core/ARCHITECTURE.md`)
- Code duplication (>3 times)
- Functions too long (>50 lines)

#### Graphify Intelligence (nếu có)
```bash
graphify query "unused functions" --graph graphify-out/graph.json
graphify query "circular dependencies" --graph graphify-out/graph.json
```

#### Harness Metrics
```bash
rig query stats        # Thống kê tổng quan
rig query matrix       # Ma trận kiểm thử
rig plan list          # Trạng thái các kế hoạch active/completed
rig query backlog --open   # Các friction items chưa xử lý
```

### 4. Report

Tạo `docs/reports/health_[date].md`:
```markdown
# Health Report — [Date]
## Summary: 🔴 X critical | 🟡 Y warnings | 🟢 Z suggestions
## 🩺 Harness Doctor: [Passed / Warnings / Errors]
## 🔴 Critical Issues (phải sửa)
## 🟡 Warnings (nên sửa)
## 🟢 Suggestions (tùy chọn)
## Harness Status & Invariants
## Next Steps
```

## Post-work

```bash
rig trace --summary "Health check: <scope>" --outcome success
```

## Next Steps

```
1️⃣ Sửa vấn đề? → /debug hoặc /refactor
2️⃣ Mã hóa invariant? → $encode-invariant
3️⃣ Cải tiến quy trình? → $improve-harness
```
