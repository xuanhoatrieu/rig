---
description: 📋 Lên kế hoạch tính năng & Durable Plans
extends: core/HARNESS.md
tools: rig, graphify
---

# /plan — Feature Planning & Durable Plans

> Đọc `core/HARNESS.md` và `core/WORKFLOW.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. Load context: `rig status` + `rig plan list`
2. If `graphify-out/` exists → `graphify query "<topic>"` for codebase context
3. Read `docs/product/README.md` for current product state

## Work Shape Decision

Theo `core/WORKFLOW.md`:
- **Read-only**: Không cần plan hay edits.
- **Bounded change**: Kế hoạch trực tiếp hoặc ephemeral plan.
- **Durable planned change** (nhiều session / rủi ro / có dependencies): Tạo `docs/plans/active/<name>.md`.
- **Invariant encoding**: Tuân thủ `core/patterns/encoding-invariants.md` ($encode-invariant).

## Work

### 1. Risk Classification

Chạy `core/FEATURE_INTAKE.md` checklist:
- Classify input type
- Run 10 risk flags & hard gates
- Determine lane (`tiny`, `normal`, `high-risk`)

```bash
rig intake --type "<type>" --summary "<summary>" --lane <lane>
```

### 2. Create Durable Plan (cho công việc span session hoặc ≥ Normal)

Sử dụng lệnh `rig plan create`:
```bash
rig plan create --title "<Tên tính năng>" --lane <lane>
```
File kế hoạch sẽ được tạo tại `docs/plans/active/<slug>.md` dựa trên `core/templates/exec-plan.md`.

### 3. Register Story / Decision (nếu cần)

Nếu lane ≥ normal:
```bash
rig story add --id "US-XXX" --title "<title>" --lane <lane>
```

Nếu có quyết định kiến trúc mới:
```bash
rig decision add --id "000X-title" --title "<title>" --doc "docs/decisions/000X-title.md"
```

## Post-work

```bash
rig session set --key "current_plan" --value "<plan_name>"
rig trace --summary "Planned: <feature>" --outcome success
```

## Next Steps

```
1️⃣ Design kỹ thuật? → /design
2️⃣ Mã hóa invariant? → $encode-invariant
3️⃣ Bắt đầu code? → /code
```
