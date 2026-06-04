---
description: 🚀 Khởi tạo dự án mới
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
    → "Dự án đã có Harness. Dùng /status để xem trạng thái."
    → EXIT

if docs/ exists but no harness.db:
    → "Có docs/ nhưng chưa có Harness DB. Khởi tạo DB."
    → rig init
    → EXIT

else:
    → Full init (step 2-5)
```

### 2. Initialize Harness DB

```bash
rig init
```

### 3. Create Project Docs Structure

```
docs/
├── product/README.md        # Product contract (empty)
├── stories/README.md        # Story index
├── decisions/README.md      # Decision log
├── FEATURE_INTAKE.md        # Copy from core/FEATURE_INTAKE.md
├── ARCHITECTURE.md          # Copy from core/ARCHITECTURE.md
├── GLOSSARY.md              # Copy from core/GLOSSARY.md
└── TEST_MATRIX.md           # Empty matrix
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

### 6. Git Setup

```
if .git not exists AND user agrees:
    git init
    echo "harness.db" >> .gitignore
    echo "graphify-out/" >> .gitignore
    echo ".brain/" >> .gitignore
```

## Next Steps

```
1️⃣ Có ý tưởng mới? → /brainstorm
2️⃣ Đã biết cần làm gì? → /plan
3️⃣ Muốn tùy chỉnh? → /customize
```
