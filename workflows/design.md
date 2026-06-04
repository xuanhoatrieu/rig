---
description: 🏗️ Thiết kế kỹ thuật
extends: core/HARNESS.md
tools: rig, graphify
---

# /design — Technical Design

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. Read existing plan (if `/plan` was run)
2. `rig query stats` → project state
3. If `graphify-out/` exists → query architecture context

## Work

### Design Deliverables

Tạo `docs/DESIGN.md` (hoặc update):

1. **Data Model**: Tables, relationships, migrations
2. **API Design**: Endpoints, request/response shapes
3. **Component Architecture**: How modules connect
4. **User Flows**: Step-by-step user journeys
5. **Acceptance Criteria**: Measurable done conditions

### Design Rules

- Start from user journey, then derive technical components.
- Each acceptance criterion must be testable.
- Note trade-offs and alternatives considered.

### If High-Risk

Create decision record:
```bash
rig decision add --id "DR-XXXX" --title "<decision>" --doc "docs/decisions/XXXX.md"
```

## Post-work

```bash
rig trace --summary "Designed: <feature>" --outcome success
rig session set --key "design_complete" --value "true"
```

## Next Steps

```
1️⃣ Thiết kế UI? → /visualize
2️⃣ Code luôn? → /code
3️⃣ Cần brainstorm thêm? → /brainstorm
```
