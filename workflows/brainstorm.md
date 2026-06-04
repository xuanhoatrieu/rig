---
description: 💡 Brainstorm & Research ý tưởng
extends: core/HARNESS.md
tools: search_web
---

# /brainstorm — Idea Exploration

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Khi nào dùng

- Ý tưởng còn mơ hồ, cần khám phá.
- Muốn nghiên cứu thị trường / đối thủ.
- Chưa biết MVP cần gì.

Nếu đã biết rõ → dùng `/plan` trực tiếp.

## Work

### 1. Hiểu ý tưởng

- "App này giải quyết vấn đề gì?"
- "Ai sẽ dùng?"
- "Ý tưởng này từ đâu?"

### 2. Market Research (nếu user muốn)

Dùng `search_web` tìm:
- Đối thủ trực tiếp + gián tiếp
- Điểm mạnh/yếu
- Cơ hội & khoảng trống thị trường

### 3. Feature Brainstorm

- Feature dump (không phán xét)
- Nhóm features theo category
- Phân loại: MVP / Nice-to-have / Backlog

### 4. Output — BRIEF

Tạo `docs/BRIEF.md`:
```markdown
# Brief: [Tên App]
## Vấn đề
## Giải pháp
## Đối tượng
## Nghiên cứu thị trường
## Tính năng MVP
## Tính năng Phase 2
## Bước tiếp theo → /plan
```

## Next Steps

```
1️⃣ OK? → /plan để lên kế hoạch
2️⃣ Sửa Brief? Nói chi tiết
3️⃣ Lưu lại suy nghĩ thêm? → /save-brain
```
