# 🔧 Rig — Harness-Core Workflow Framework v5.1.0

Rig biến AI coding agent thành đồng nghiệp có quy trình — biết phân loại rủi ro, duy trì repository là single source of truth, mã hóa invariant kiểm thử 2 chiều, theo dõi tiến độ, ghi nhận quyết định, và tự cải thiện qua bằng chứng thực nghiệm.

> **Triết lý:** Harness là core (quản lý QUY TRÌNH & INVARIANTS), Workflows là overlays (hướng dẫn CÁCH LÀM), Skills là công cụ chuyên sâu.
> **Tham khảo:** Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/) & [repository-harness](https://github.com/hoangnb24/repository-harness).

## ✨ Highlights v5.1.0

| Feature | Chi tiết |
|---|---|
| **Harness-Core Protocol v2** | 4 Work Shapes: Read-only, Bounded change, Durable planned change (`docs/plans/`), Invariant encoding |
| **Invariant Encoding** | Mã hóa quy tắc kiến trúc/bảo mật thành native validation có kiểm chứng 2 chiều (Positive & Negative proof) |
| **Rust CLI `rig`** | SQLite durable layer + `rig doctor` chẩn đoán toàn vẹn + `rig plan` quản lý kế hoạch |
| **5 Agent Skills** | `$encode-invariant`, `$onboard-repository`, `$audit-onboarding-proposal`, `$improve-harness`, `$engineering-wisdom` |
| **15 Workflow Overlays** | Mỗi file ≤5KB, chỉ chứa logic đặc thù (không copy-paste) |
| **Risk Lanes & Hard Gates** | 10 risk flags, 3 lanes (tiny/normal/high-risk), 5 hard gates bắt buộc |
| **Auto Trace & Score** | Mỗi task được ghi nhận và chấm điểm tự động |
| **Evidence-backed Growth** | Cải tiến Harness dựa trên ma sát thực tế và kiểm chứng bằng fresh agent rerun |

---

## 📦 Cài đặt

### Mac / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
iex "& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }"
```

### Cấu trúc sau khi cài

```
~/.gemini/                           # Global (mọi dự án)
├── GEMINI.md                        # Entry point (~25 dòng)
├── rig_version                      # 5.1.0
└── antigravity/
    ├── core/                        # Harness source of truth & rules
    │   ├── HARNESS.md               # Task loop & rules
    │   ├── WORKFLOW.md              # 4 Work shapes & flows
    │   ├── FEATURE_INTAKE.md        # Risk classification
    │   ├── patterns/                # Invariant encoding pattern
    │   ├── communication-style.md   # Shared comms rules
    │   └── templates/               # Exec-plan, runbook, decision, story templates
    ├── skills/                      # 5 Specialized Agent Skills
    └── workflows/                   # 15 lightweight overlays

your-project/                        # Per-project
├── harness.db                       # SQLite (managed by `rig` CLI)
├── .brain/brain.json                # Infra + GitHub config only
└── docs/
    ├── product/                     # Product contract
    ├── plans/                       # Durable plans (active/ & completed/)
    ├── patterns/                    # Architecture & invariant patterns
    ├── stories/                     # Story packets
    └── decisions/                   # Architecture decisions (ADR)
```

---

## 🎮 Commands & Skills

### Planning & Design
| Command | Chức năng |
|---|---|
| `/init` | Khởi tạo dự án + harness.db + plans structure |
| `/plan` | Lên kế hoạch tính năng & Durable Plans |
| `/design` | Thiết kế kỹ thuật (DB, API, Flow, ADR) |
| `/visualize` | UI/UX mockup |
| `/brainstorm` | Research & brainstorm |

### Development & Invariants
| Command / Skill | Chức năng |
|---|---|
| `/code` | Viết code + auto-test loop |
| `/debug` | Sửa lỗi + rollback |
| `/refactor` | Tái cấu trúc + blast radius |
| `/verify` | Chạy app + kiểm thử |
| `$encode-invariant` | Mã hóa quy tắc kiến trúc & bảo mật thành native checks |

### Operations & Maintenance
| Command / Skill | Chức năng |
|---|---|
| `/health` | Review + audit toàn diện + `rig doctor` |
| `/deploy` | Deploy production |
| `/status` | Tình trạng + bước tiếp theo |
| `/save-brain` | Lưu kiến thức |
| `$onboard-repository` | Khảo sát và lập bản đồ repository lạ (read-only first) |
| `$improve-harness` | Cải tiến Harness dựa trên ma sát thực tế + fresh rerun |
| `$engineering-wisdom` | Heuristic kỹ thuật thực tiễn (SOLID, Clean Architecture) |
| `/help` | Hướng dẫn |
| `/customize` | Tùy chỉnh preferences |

---

## 🔧 CLI `rig`

```bash
rig init                                    # Khởi tạo harness.db
rig doctor                                  # Kiểm tra tính toàn vẹn hệ thống
rig plan create --title "..." --lane normal # Tạo durable plan mới
rig plan list                               # Xem danh sách active plans
rig plan complete --id "..."                # Hoàn thành plan
rig intake --type spec-slice --summary "..." --lane normal
rig story add --id US-001 --title "..." --lane normal
rig story update --id US-001 --status done --unit 1
rig story verify US-001                     # Chạy verify command
rig decision add --id DR-001 --title "..."
rig trace --summary "..." --outcome success
rig query stats                             # Project overview
rig query matrix                            # Test coverage
rig query backlog --open                    # Pending friction items
```

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────────────────┐
│  Layer 1: HARNESS CORE (Source of Truth & Controls)    │
│  - HARNESS.md & WORKFLOW.md → Task loop & work shapes │
│  - FEATURE_INTAKE.md → Risk classification             │
│  - patterns/encoding-invariants.md → Guard framework   │
│  - harness.db → SQLite Durable Layer                   │
├────────────────────────────────────────────────────────┤
│  Layer 2: WORKFLOW OVERLAYS & AGENT SKILLS             │
│  - 15 lightweight overlays mapped to slash commands    │
│  - 5 specialized agent skills ($skill)                 │
├────────────────────────────────────────────────────────┤
│  Layer 3: TOOLS                                        │
│  - rig CLI | Graphify | Git                            │
└────────────────────────────────────────────────────────┘
```

---

## 📝 License

MIT — Fork freely, customize as needed.
