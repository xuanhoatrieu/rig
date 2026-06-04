# 🔧 Rig — Harness-Core Workflow Framework v5.0

Rig biến AI coding agent thành đồng nghiệp có quy trình — biết phân loại rủi ro, theo dõi tiến độ, ghi nhận quyết định, và tự cải thiện.

> **Triết lý:** Harness là core (quản lý QUY TRÌNH), Workflows là overlays (hướng dẫn CÁCH LÀM).
> **Tham khảo:** Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/) by OpenAI.

## ✨ Highlights

| Feature | Chi tiết |
|---|---|
| **Harness-Core** | Task loop trung tâm: Intake → Classify → Work → Validate → Trace |
| **Rust CLI `rig`** | SQLite durable layer — query trạng thái thay vì parse files |
| **15 Workflow Overlays** | Mỗi file ≤5KB, chỉ chứa logic đặc thù (không copy-paste) |
| **Risk Lanes** | 10 risk flags, 3 lanes (tiny/normal/high-risk), 5 hard gates |
| **Auto Trace & Score** | Mỗi task được ghi nhận và chấm điểm tự động |
| **Growth Rule** | "Harness grows from friction" — tự cải thiện qua backlog |
| **Graphify Integration** | Knowledge graph cho codebase (optional) |

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

### Sau khi cài

```
~/.gemini/                           # Global (mọi dự án)
├── GEMINI.md                        # Entry point (~20 dòng)
├── rig_version                      # 5.0.0
└── antigravity/
    ├── core/                        # Harness source of truth
    │   ├── HARNESS.md               # Task loop & rules
    │   ├── FEATURE_INTAKE.md        # Risk classification
    │   ├── communication-style.md   # Shared comms rules
    │   └── templates/               # Story, decision templates
    └── workflows/                   # 15 lightweight overlays

your-project/                        # Per-project
├── harness.db                       # SQLite (managed by `rig` CLI)
├── .brain/brain.json                # Infra + GitHub config only
└── docs/
    ├── product/                     # Product contract
    ├── stories/                     # Story packets
    └── decisions/                   # Architecture decisions
```

---

## 🎮 Commands

### Planning & Design
| Command | Chức năng |
|---|---|
| `/init` | Khởi tạo dự án + harness.db |
| `/plan` | Lên kế hoạch + risk classification |
| `/design` | Thiết kế kỹ thuật |
| `/visualize` | UI/UX mockup |
| `/brainstorm` | Research & brainstorm |

### Development
| Command | Chức năng |
|---|---|
| `/code` | Viết code + auto-test loop |
| `/debug` | Sửa lỗi + rollback |
| `/refactor` | Tái cấu trúc + blast radius |
| `/verify` | Chạy app + kiểm thử |

### Operations
| Command | Chức năng |
|---|---|
| `/health` | Review + audit toàn diện |
| `/deploy` | Deploy production |
| `/status` | Tình trạng + bước tiếp theo |
| `/save-brain` | Lưu kiến thức |
| `/help` | Hướng dẫn |
| `/customize` | Tùy chỉnh preferences |

---

## 🔧 CLI `rig`

```bash
rig init                                    # Khởi tạo harness.db
rig intake --type spec-slice --summary "..." --lane normal
rig story add --id US-001 --title "..." --lane normal
rig story update --id US-001 --status done --unit 1
rig story verify US-001                     # Chạy verify command
rig decision add --id DR-001 --title "..."
rig trace --summary "..." --outcome success
rig query stats                             # Project overview
rig query matrix                            # Test coverage
rig query session                           # Current state
rig query backlog --open                    # Pending items
rig query friction                          # Friction records
rig backlog add --title "..." --pain "..."
```

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────┐
│  Layer 1: HARNESS CORE (Source of Truth)    │
│  HARNESS.md → Task Loop (state machine)    │
│  FEATURE_INTAKE.md → Risk Classification   │
│  harness.db → Durable Layer (SQLite)       │
├────────────────────────────────────────────┤
│  Layer 2: WORKFLOW OVERLAYS (≤5KB each)    │
│  15 lightweight guides for specific tasks  │
├────────────────────────────────────────────┤
│  Layer 3: TOOLS                            │
│  rig CLI | Graphify | Git                  │
└────────────────────────────────────────────┘
```

### Risk Lanes

| Lane | Khi nào | Yêu cầu |
|---|---|---|
| **Tiny** | Sửa nhỏ, ít rủi ro | Patch trực tiếp |
| **Normal** | Story-sized, bounded | Story file + validation |
| **High-risk** | Auth, data, security | Story folder (4 files) + human confirm |

---

## 🔍 Graphify (Optional)

```bash
pip install graphifyy
cd your-project && graphify update .
```

Auto-triggers in `/code`, `/debug`, `/refactor`, `/health`.

---

## 📊 So sánh v4.3 → v5.0

| Metric | v4.3 | v5.0 | Cải thiện |
|---|---|---|---|
| Instruction text | ~350KB | ~80KB | **-77%** |
| Workflows | 27 files | 15 files | **-44%** |
| State files | 9+ JSON | 2 JSON + SQLite | **-78%** |
| Source of truth conflicts | 6+ | 0 | **-100%** |
| Persona descriptions | 7 × 50 lines | 0 | **-100%** |
| Non-tech mode copies | 7 × 40 lines | 1 × 50 lines | **-82%** |

---

## 📝 License

MIT — Fork freely, customize as needed.
