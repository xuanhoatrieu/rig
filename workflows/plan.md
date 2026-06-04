---
description: 📋 Lên kế hoạch tính năng
extends: core/HARNESS.md
tools: rig, graphify
---

# /plan — Feature Planning

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. Load context: `rig query stats` + `rig query session`
2. If `graphify-out/` exists → `graphify query "<topic>"` for codebase context
3. Read `docs/product/README.md` for current product state

## Work

### 1. Understand Request

Hỏi user:
- "Tính năng cần làm là gì?"
- "Ai sẽ dùng tính năng này?"
- "Có ảnh hưởng gì đến tính năng hiện có không?"

### 2. Risk Classification

Chạy `core/FEATURE_INTAKE.md` checklist:
- Classify input type
- Run risk flags
- Determine lane

```bash
rig intake --type "<type>" --summary "<summary>" --lane <lane>
```

### 3. Create Plan

Tạo plan với cấu trúc:

```markdown
# Plan: [Tên tính năng]

## Mục tiêu
[Mô tả ngắn]

## Phạm vi
- Bao gồm: [X]
- Không bao gồm: [Y]

## Các bước thực hiện
| Phase | Task | Ước tính |
|-------|------|----------|
| 1 | Setup | ... |
| 2 | Core logic | ... |
| 3 | UI | ... |
| 4 | Testing | ... |

## Technical Design
- Database changes: [nếu có]
- API changes: [nếu có]
- Dependencies: [nếu có]
```

### 4. Create Story (Normal+)

Nếu lane ≥ normal:
```bash
rig story add --id "US-XXX" --title "<title>" --lane <lane>
```

Tạo story file từ `core/templates/story.md` hoặc `core/templates/high-risk-story/`.

## Post-work

```bash
rig session set --key "current_plan" --value "<plan_name>"
rig trace --summary "Planned: <feature>" --outcome success
```

## Next Steps

```
1️⃣ Design kỹ thuật? → /design
2️⃣ Thiết kế UI? → /visualize
3️⃣ Code luôn? → /code
```
