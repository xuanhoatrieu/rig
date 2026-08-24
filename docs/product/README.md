# Product Contract — Rig v5.2.0

## Overview
Rig là framework quy trình Harness-Core dành cho AI coding agent và lập trình viên, hỗ trợ OpenAI Codex và Gemini Antigravity từ cùng một Core.
Rig biến AI agent thành cộng sự có quy trình, tuân thủ quản lý rủi ro (Risk Lanes), theo dõi tiến độ công việc (Story & Test Matrix), ghi chép quyết định kiến trúc (Decision Records), và tự học hỏi / tiến hóa từ khó khăn (Harness Friction & Backlog).

## Core Capabilities
- **Harness-Core Task Loop**: Mọi tác vụ đi qua chu trình Intake → Classify → Work → Validate → Trace.
- **Durable Layer (`rig` CLI + SQLite `harness.db`)**: Lưu trữ và truy vấn trạng thái dự án (intake, stories, traces, decisions, backlog, session, knowledge).
- **Cross-agent Adapters**: Antigravity dùng slash-command overlays; Codex dùng `$rig-harness`, `AGENTS.md` và plugin skills.
- **Workflow Overlays**: Hướng dẫn chi tiết cho planning, implementation, verification, operations và education.
- **Risk Lanes & Hard Gates**: 3 lane phân loại rủi ro (`tiny`, `normal`, `high-risk`) với 5 hard gates bắt buộc.
- **Trace & Auto Scoring**: Tự động chấm điểm độ hoàn thiện của trace tác vụ.
