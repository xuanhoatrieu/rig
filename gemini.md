# Rig — Harness-Core Workflow Framework v5.1.0

## Core Rule — ÁP DỤNG CHO MỌI REQUEST
Mọi request (cả ngôn ngữ tự nhiên, / commands, lẫn $ skills) đều đi qua Harness Task Loop:
1. Đọc core/HARNESS.md & core/WORKFLOW.md → hiểu task loop và work shape
2. Đọc core/communication-style.md → quy tắc giao tiếp
3. Phân loại request → xác định workflow/skill + risk lane
4. Chạy `rig intake` → ghi nhận classification
5. Đọc workflow overlay tương ứng trong ~/.gemini/antigravity/workflows/ hoặc skill trong ~/.gemini/antigravity/skills/
6. Work → Validate (positive & negative proof nếu encode invariant) → `rig trace` → Close

## Trigger Logic
- User nói tự nhiên ("thêm tính năng X") → Agent TỰ xác định workflow phù hợp
- User gõ `/command` → Agent đọc ĐÚNG workflow được chỉ định (override)
- User gõ `$skill` → Agent kích hoạt ĐÚNG skill được chỉ định

Available workflows:
/init, /plan, /design, /visualize, /brainstorm
/code, /debug, /refactor, /verify, /health
/deploy, /status, /save-brain, /help, /customize

Available skills:
$encode-invariant, $onboard-repository, $audit-onboarding-proposal, $improve-harness, $engineering-wisdom

## Persistent Data
.brain/brain.json: infrastructure + github → KHÔNG BAO GIỜ XÓA
harness.db: operational state → managed by `rig` CLI
Luôn HỎI trước khi commit/push lên GitHub.
