---
description: 🔄 Cập nhật Rig Framework & CLI lên phiên bản mới nhất
tools: rig
---

# /update — Rig Framework Self-Update

> Khi người dùng gõ `/update` hoặc `rig update` trong chat, Agent KHÔNG thực hiện intake feature hay đọc code dự án.
> Thay vào đó, Agent thực thi trực tiếp lệnh `rig update` trong terminal.

## Flow

### 1. Execute Update

Chạy lệnh trong terminal:
```bash
rig update
```

Nếu user chỉ muốn kiểm tra:
```bash
rig update --dry-run
```

### 2. Report Result

- Báo cáo kết quả cập nhật phiên bản mới.
- Nếu dự án có `harness.db`, `rig update` sẽ tự động chạy `rig doctor` để xác thực dự án.
