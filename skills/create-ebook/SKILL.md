---
name: create-ebook
description: Viết giáo trình, sách, ebook bài bản theo phương pháp Backward Design. Thu thập chủ đề, tạo khung sườn (scaffold), viết nội dung chi tiết theo từng bài/chapter kèm ví dụ, bài tập và theo dõi tiến độ.
---

# Create Ebook / Textbook

Sử dụng phương pháp Backward Design (xác định chuẩn đầu ra và đánh giá trước khi viết nội dung).

## Quy trình

### 1. Thu thập thông tin
- **Chủ đề** sách/giáo trình
- **Đối tượng** độc giả (người mới bắt đầu, chuyên gia, sinh viên)
- **Outline** / Đề cương chi tiết
- **Ngôn ngữ** (Tiếng Việt / English)
- **Ngôn ngữ lập trình/Công nghệ** (nếu có)
- **Thư mục lưu**: Mặc định `./ebooks/`

### 2. Tạo khung sườn (Scaffold)
Tạo cấu trúc thư mục:
```
ebooks/
├── _meta.json          # Metadata tổng thể toàn sách
├── README.md           # Mục lục sách
├── progress.md         # Bảng theo dõi tiến độ từng bài
├── chapter_01/
│   ├── _chapter_meta.json
│   ├── bai_01_intro.md
│   └── bai_02_setup.md
└── chapter_02/
    └── ...
```

### 3. Viết nội dung từng bài (Backward Design)
1. Đọc `_meta.json` và `_chapter_meta.json` để lấy chuẩn đầu ra (*Learning Outcomes*).
2. Cấu trúc bài học:
   - Mục tiêu bài học
   - Nội dung lý thuyết trọng tâm
   - Code mẫu / Ví dụ minh họa thực tế
   - Tổng kết bài học
   - Bài tập thực hành / Câu hỏi ôn tập
3. Tiêu chuẩn Anti-AI Checklist:
   - Ví dụ cụ thể, giải thích sâu sắc, code phải chạy được.
4. Cập nhật `_chapter_meta.json` và `progress.md`.

### 4. Lệnh liên quan
- Xuất file DOCX/PDF: `$export-ebook` hoặc `/export`
- Sinh câu hỏi trắc nghiệm: `$create-question` hoặc `/question`
- Tạo slide bài giảng: `$create-pptx` hoặc `/pptx`
