---
description: 🐛 Sửa lỗi + Rollback
extends: core/HARNESS.md
tools: rig, graphify, git
---

# /debug — Bug Investigation & Fix

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. `rig query session` → current context
2. If `graphify-out/` exists → `graphify query "<error topic>"` for call chain

## Work

### Hypothesis-Based Debugging

1. **Thu thập bằng chứng**: Error message, stack trace, reproduction steps
2. **Giả thuyết**: "Bug có thể do [X] vì [Y]"
3. **Kiểm chứng**: Kiểm tra code tại vị trí nghi ngờ
4. **Sửa hoặc loại trừ**: Nếu đúng → sửa. Nếu sai → giả thuyết mới.
5. **Tối đa 5 giả thuyết** → nếu vẫn chưa tìm ra → hỏi user thêm context.

### Fix Rules

- Sửa root cause, không patch symptoms.
- Giải thích BUG Ở ĐÂU và TẠI SAO.
- Test lại sau khi sửa.

### Rollback (nếu cần)

Khi sửa không được hoặc user muốn quay lại:

```
Rollback options:
A) Rollback file cụ thể → git checkout -- <file>
B) Rollback toàn bộ session → git stash
C) Tiếp tục sửa → thử approach khác
```

## Post-work

```bash
rig trace --summary "Fixed: <bug description>" --outcome success --files-changed "<files>"
```

## Next Steps

```
1️⃣ Chạy lại? → /verify
2️⃣ Code tiếp? → /code
3️⃣ Lưu lại? → /save-brain
```
