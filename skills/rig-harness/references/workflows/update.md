---
description: 🔄 Cập nhật Rig Framework & CLI lên phiên bản mới nhất
---

# /update — Rig Framework Self-Update

> Khi người dùng gõ `/update` hoặc `rig update` trong chat:
> - Agent KHÔNG thực hiện intake feature hay đọc code dự án.
> - Agent KHÔNG sinh báo cáo trạng thái dự án (project trace/curriculum summary).
> - Agent thực thi trực tiếp việc cập nhật/cài đặt Rig trong terminal.

## Flow

### 1. Execute Update

Thực hiện theo thứ tự ưu tiên:
1. Thử chạy `rig update` (hoặc `rig update --dry-run` nếu kiểm tra).
2. Nếu terminal báo `The term 'rig' is not recognized` hoặc `command not found`:
   - **Trên Windows (PowerShell)**: Chạy lệnh installer:
     ```powershell
     iex "& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }"
     ```
   - **Trên Linux / macOS**: Chạy lệnh installer:
     ```bash
     curl -fsSL https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.sh | bash
     ```

### 2. Report Result

- Báo cáo kết quả cập nhật phiên bản mới.
- Không in các nội dung tóm tắt dự án hay task trace không liên quan.
