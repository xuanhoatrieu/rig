# Rig — Harness-Core Workflow Framework v5.1.0

## Core Rule — ÁP DỤNG CHO MỌI REQUEST
Mọi request (cả ngôn ngữ tự nhiên, / commands, lẫn $ skills) đều đi qua Harness Task Loop:
1. Đọc core/HARNESS.md & core/WORKFLOW.md → hiểu task loop và work shape
2. Đọc core/communication-style.md → quy tắc giao tiếp
3. Phân loại request → xác định workflow/skill + risk lane
4. Chạy `rig intake` → ghi nhận classification (Bỏ qua intake đối với các lệnh CLI/bảo trì trực tiếp: `rig update`, `rig doctor`, `rig status`)
5. Đọc workflow overlay tương ứng trong ~/.gemini/antigravity/workflows/ hoặc skill trong ~/.gemini/antigravity/skills/
6. Work → Validate (positive & negative proof nếu encode invariant) → `rig trace` → Close

## Trigger Logic
- User nói tự nhiên ("thêm tính năng X") → Agent TỰ xác định workflow phù hợp
- User gõ `/command` → Agent đọc ĐÚNG workflow được chỉ định (override)
- User gõ `$skill` → Agent kích hoạt ĐÚNG skill được chỉ định
- User gõ `rig update` / `/update` hoặc `rig doctor` → Agent chạy TRỰC TIẾP lệnh tương ứng trong terminal qua `run_command`, KHÔNG đọc mã nguồn hay tạo kế hoạch dự án.

Available workflows:
Core (16):
/init, /plan, /design, /visualize, /brainstorm
/code, /debug, /refactor, /verify, /health
/deploy, /status, /update, /save-brain, /help, /customize

Education Plugin (5):
/textbook, /pptx, /question, /video, /export

Available skills:
Harness Core:
$encode-invariant, $onboard-repository, $audit-onboarding-proposal, $improve-harness, $engineering-wisdom

Education & Content:
$create-ebook, $export-ebook, $create-question, $create-pptx, $create-video

## Persistent Data
.brain/brain.json: infrastructure + github → KHÔNG BAO GIỜ XÓA
harness.db: operational state → managed by `rig` CLI
Luôn HỎI trước khi commit/push lên GitHub.
