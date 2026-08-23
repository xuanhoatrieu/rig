---
description: ❓ Trợ giúp & Hướng dẫn Rig v5.1.0
---

# /help — Help & Guidance

## Available Commands

### Planning & Design
| Command | Chức năng |
|---|---|
| `/init` | Khởi tạo dự án mới + docs/plans |
| `/plan` | Lên kế hoạch tính năng & Durable Plans |
| `/design` | Thiết kế kỹ thuật (DB, API, Flow, ADR) |
| `/visualize` | Thiết kế UI/UX mockup |
| `/brainstorm` | Nghiên cứu & brainstorm ý tưởng |

### Development
| Command | Chức năng |
|---|---|
| `/code` | Viết code theo spec |
| `/debug` | Sửa lỗi + rollback |
| `/refactor` | Tái cấu trúc code |
| `/verify` | Chạy app + kiểm thử |

### Operations & Diagnostics
| Command | Chức năng |
|---|---|
| `/health` | Review & audit toàn diện + `rig doctor` |
| `/update` | Cập nhật Rig Framework & CLI lên bản mới nhất |
| `/deploy` | Deploy production |
| `/status` | Xem tình trạng + bước tiếp theo |
| `/save-brain` | Lưu kiến thức |
| `/customize` | Tùy chỉnh preferences |

## Agent Skills (Harness Extension)

| Skill | Chức năng |
|---|---|
| `$encode-invariant` | Mã hóa quy tắc kiến trúc & bảo mật thành native checks 2 chiều |
| `$onboard-repository` | Khảo sát và lập bản đồ repository (read-only first, evidence capsule v2) |
| `$audit-onboarding-proposal` | Kiểm tra tính toàn vẹn và bằng chứng của đề xuất onboarding |
| `$improve-harness` | Cải tiến Harness dựa trên ma sát thực tế + fresh rerun |
| `$engineering-wisdom` | Áp dụng các heuristic kỹ thuật thực tiễn (SOLID, clean architecture) |

## Harness CLI (`rig`)

```bash
rig init                                          # Khởi tạo database
rig doctor                                        # Kiểm tra tính toàn vẹn
rig update                                        # Cập nhật Rig lên phiên bản mới nhất
rig plan create/list/complete                     # Quản lý durable plans
rig intake --type ... --summary ... --lane ...   # Phân loại task
rig story add/update/verify                       # Quản lý stories
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
