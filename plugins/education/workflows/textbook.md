---
description: 📚 Viết ebook/textbook (Backward Design)
---

# /textbook — Ebook/Textbook Writing

## Cách gọi

```
/textbook viết bài 4         → Viết bài cụ thể
/textbook viết bài tiếp      → Viết bài tiếp theo (status="not_started")
/textbook tiến độ            → Xem progress table
```

## Bước 1: Thu thập thông tin

Hỏi user (nếu chưa có):
1. **Chủ đề** sách?
2. **Đối tượng** đọc giả?
3. **Outline** / kế hoạch có sẵn? (file path hoặc mô tả)
4. **Ngôn ngữ** viết? (vi/en)
5. **Ngôn ngữ lập trình** nếu có? (Python, JS...)
6. **Thư mục lưu?** (mặc định: `./ebooks/`)

## Bước 2: Tạo khung sườn (Scaffold)

1. Tạo thư mục `ebooks/` với cấu trúc chapter/bài theo outline
2. Tạo `_meta.json` tổng (metadata toàn sách)
3. Tạo `_chapter_meta.json` cho mỗi chapter
4. Tạo `README.md` mục lục
5. Tạo `progress.md` bảng tiến độ

```
ebooks/
├── _meta.json
├── README.md
├── progress.md
├── chapter_01/
│   ├── _chapter_meta.json
│   ├── bai_01_intro.md
│   └── bai_02_setup.md
└── chapter_02/
    ├── _chapter_meta.json
    └── ...
```

## Bước 3: Viết nội dung (Backward Design)

Với mỗi bài:
1. Đọc `_meta.json` → xác định bài cần viết
2. Đọc `_chapter_meta.json` → lấy learning outcomes
3. Đọc outline + context bài trước (nếu có)
4. **Xác định Learning Outcomes + Assessments TRƯỚC** (Backward Design)
5. Viết nội dung theo template:
   - Mục tiêu bài học
   - Nội dung chính (sections)
   - Ví dụ / code samples
   - Tổng kết
   - Bài tập
6. Tự review theo Anti-AI Checklist:
   - Không generic, phải có ví dụ cụ thể
   - Code phải chạy được
   - Giải thích phải sâu, không surface-level
7. Lưu file + update `_chapter_meta.json` (status, word_count)
8. Update `progress.md`

## Bước 4: Review & Chỉnh sửa

1. User đọc và feedback
2. Chỉnh sửa theo feedback
3. Update status → "completed" khi user approve

## Bước 5: Export (khi cần)

Dùng `/export` để xuất sang PDF / DOCX.

## Next Steps

```
1️⃣ Viết bài tiếp? /textbook viết bài tiếp
2️⃣ Xem tiến độ? /textbook tiến độ
3️⃣ Tạo slide? /pptx
4️⃣ Sinh câu hỏi? /question
5️⃣ Xuất file? /export
```
