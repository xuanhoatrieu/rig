---
description: ⚙️ Tùy chỉnh preferences
---

# /customize — Preferences

## Settings

### 1. Technical Level

- **Result only** — Ẩn chi tiết kỹ thuật
- **Simple** — Giải thích đơn giản (default)
- **Learning** — Giải thích code đã viết + lý do
- **Full technical** — Thuật ngữ chuyên ngành

### 2. Autonomy

- **Ask often** — Hỏi trước mỗi quyết định lớn (default)
- **Balanced** — Việc nhỏ tự quyết, việc lớn hỏi
- **Autonomous** — Chỉ hỏi khi thực sự cần

### 3. Quality Target

- **MVP** — Nhanh, đủ test ý tưởng
- **Production** — Hoàn thiện, có thể launch (default)
- **Enterprise** — Full tests + docs

### 4. Custom Rules

User có thể thêm rules riêng:
- "Luôn dùng TypeScript"
- "Ưu tiên performance"
- "Không dùng thư viện X"

## Storage

Lưu vào `.brain/preferences.json`:

```json
{
  "technical_level": "simple",
  "autonomy": "ask_often",
  "quality": "production",
  "custom_rules": []
}
```
