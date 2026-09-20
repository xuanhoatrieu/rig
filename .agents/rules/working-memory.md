# Quy Tắc Duy Trì Bộ Nhớ Phiên (In-Session Working Memory & Anti-Amnesia)

Quy tắc này giải quyết triệt để hiện tượng Agent bị "mất trí nhớ" ngay trong cùng một phiên làm việc (in-session) sau khi thực hiện các lệnh trung gian (như `rig update`, build, commit, git push).

---

## 1. Nguyên Tắc Tự Động Ghim Trạng Thái (Auto-Pinning State)

Mỗi khi Agent hoàn thành việc tạo mới, sửa đổi hoặc kiểm thử một tính năng trong phiên làm việc:
- Agent **BẮT BUỘC** cập nhật trạng thái làm việc gần nhất vào file `.brain/scratchpad.json` (hoặc chạy `rig session set --key "active_feature" --value "..."`).
- Cấu trúc thông tin ghim:
  ```json
  {
    "active_feature": "<Tên tính năng, ví dụ: Xem lịch thi>",
    "target_app": "<Tên ứng dụng/module, ví dụ: Lịch học app>",
    "key_files": [
      "src/screens/ExamScheduleScreen.tsx",
      "src/api/examService.ts"
    ],
    "database": {
      "tables": ["exams", "exam_slots"],
      "schema_file": "prisma/schema.prisma"
    },
    "endpoints": ["GET /api/v1/exams/my-schedule"],
    "last_status": "Đã code và test thành công",
    "updated_at": "2026-09-20T10:30:00+07:00"
  }
  ```

---

## 2. Quy Tắc "Đọc Trí Nhớ Trước Khi Thăm Dò" (Memory-First, Zero-Blind-Exploration)

Khi người dùng yêu cầu: *"kiểm tra lại chức năng X vừa làm"*, *"xem lại..."*, *"sửa tiếp..."*:

1. **BƯỚC 1: ĐỌC BỘ NHỚ ĐẦU TIÊN (BẮT BUỘC):**
   - Đọc file `.brain/scratchpad.json` hoặc chạy `rig session get --key "active_feature"` để lấy ngay danh sách file và database liên quan.
2. **CẤM TUYỆT ĐỐI:**
   - CẤM chạy `grep_search` hoặc `list_dir` quét toàn bộ dự án từ con số 0.
   - CẤM chạy các lệnh dò hỏi lại schema database nếu bảng đã được ghi nhận trong `scratchpad`.
3. **BƯỚC 2: ĐI THẲNG VÀO CÁC FILE ĐÃ BIẾT:**
   - Mở trực tiếp các file trong `key_files` để kiểm tra.
   - Báo cáo ngay cho người dùng kết quả mà không làm mất thời gian mò mẫm lại từ đầu.

---

## 3. Cách Ly Nhiễu Log Terminal (Log Insulation)

- Khi thực thi các lệnh CLI in ra nhiều log (như `rig update`, `cargo build`, `npm install`, `git push`):
  - Agent chỉ ghi nhận kết quả tóm tắt (Success / Error, phiên bản mới).
  - TUYỆT ĐỐI KHÔNG để các dòng log biên dịch làm phân tán hoặc xóa nhòa ngữ cảnh công việc chính mà người dùng đang làm việc trong phiên.
