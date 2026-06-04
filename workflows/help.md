---
description: ❓ Trợ giúp & Hướng dẫn
---

# /help — Help & Guidance

## Available Commands

### Planning & Design
| Command | Chức năng |
|---|---|
| `/init` | Khởi tạo dự án mới |
| `/plan` | Lên kế hoạch tính năng |
| `/design` | Thiết kế kỹ thuật (DB, API, Flow) |
| `/visualize` | Thiết kế UI/UX mockup |
| `/brainstorm` | Nghiên cứu & brainstorm ý tưởng |

### Development
| Command | Chức năng |
|---|---|
| `/code` | Viết code theo spec |
| `/debug` | Sửa lỗi + rollback |
| `/refactor` | Tái cấu trúc code |
| `/verify` | Chạy app + kiểm thử |

### Operations
| Command | Chức năng |
|---|---|
| `/health` | Review & audit toàn diện |
| `/deploy` | Deploy production |
| `/status` | Xem tình trạng + bước tiếp theo |
| `/save-brain` | Lưu kiến thức |
| `/customize` | Tùy chỉnh preferences |

## Harness CLI (`rig`)

```bash
rig init                    # Khởi tạo database
rig intake --type ... --summary ... --lane ...   # Phân loại task
rig story add/update/verify # Quản lý stories
rig query stats/matrix/session/backlog/friction  # Query trạng thái
rig trace --summary ... --outcome ...            # Ghi nhận task
rig backlog add --title ... --pain ...           # Ghi friction
```

## Quick Start

```
1. /init     → Khởi tạo dự án
2. /plan     → Lên kế hoạch
3. /code     → Viết code
4. /verify   → Test
5. /deploy   → Đưa lên production
```

## Tips

- Dùng `/status` khi không biết đang ở đâu.
- Dùng `/save-brain` trước khi nghỉ.
- Không cần nhớ lệnh `rig` — agent tự chạy khi cần.
