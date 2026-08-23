---
description: 🚀 Khởi tạo dự án mới với Harness Core v5.1.0
extends: core/HARNESS.md
tools: rig, git
---

# /init — Project Bootstrap

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Khi nào dùng

- Dự án mới chưa có `docs/` hoặc `harness.db`.
- Dự án cũ muốn tích hợp Harness lần đầu.

## Flow

### 1. Detect Project State

```
if harness.db exists:
    → "Dự án đã có Harness. Chạy rig doctor để kiểm tra trạng thái."
    → rig doctor
    → EXIT

if docs/ exists but no harness.db:
    → "Có docs/ nhưng chưa có Harness DB. Khởi tạo DB."
    → rig init
    → EXIT

else:
    → Full init (step 2-6)
```

### 2. Initialize Harness DB

```bash
rig init
```

### 3. Create Project Docs Structure

```
docs/
├── product/README.md        # Product contract
├── plans/                   # Durable plans
│   ├── active/              # Plans đang thực thi
│   └── completed/           # Plans đã hoàn tất & kiểm chứng
├── stories/README.md        # Story index
├── decisions/README.md      # Architecture Decision Records (ADR)
├── patterns/                # Architectural & invariant patterns
├── FEATURE_INTAKE.md        # Copy from core/FEATURE_INTAKE.md
├── WORKFLOW.md              # Copy from core/WORKFLOW.md
├── ARCHITECTURE.md          # Copy from core/ARCHITECTURE.md
├── GLOSSARY.md              # Copy from core/GLOSSARY.md
└── TEST_MATRIX.md           # Test matrix
```

### 4. Create .brain/brain.json (if not exists)

```json
{
  "infrastructure": {},
  "github": {}
}
```

### 5. Quick Interview

Hỏi ngắn gọn:
- "Dự án này làm gì?" → Ghi vào docs/product/README.md
- "Tech stack?" → Ghi vào docs/ARCHITECTURE.md
- "Repo GitHub?" → Ghi vào .brain/brain.json

### 6. Git Setup & Verification

```
if .git not exists AND user agrees:
    git init
    echo "harness.db" >> .gitignore
    echo "graphify-out/" >> .gitignore
    echo ".brain/" >> .gitignore

rig doctor
```

## Next Steps

```
1️⃣ Có ý tưởng mới? → /brainstorm
2️⃣ Đã biết cần làm gì? → /plan
3️⃣ Muốn mã hóa invariant kiến trúc? → $encode-invariant
4️⃣ Muốn tùy chỉnh? → /customize
```
