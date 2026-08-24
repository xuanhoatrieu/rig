---
name: create-ebook
description: Viết giáo trình, sách, ebook bài bản theo Chu trình Sư phạm 5 bước và phong cách văn phong học thuật chuẩn mực, kèm công cụ kiểm thử Linter tự động.
---

# Create Ebook / Textbook

Biên soạn giáo trình, tài liệu bài giảng đại học chuẩn mực khoa học và sư phạm.

## Nguyên tắc Văn phong & Đề mục
Đọc `references/academic_textbook_style_guide.md` trong thư mục skill này.
- **Khách quan, trung tính:** Thể trần thuật, không dùng ngôi thứ nhất.
- **Loại bỏ từ ngữ cảm tính:** Cấm các từ `kinh điển`, `ví dụ thực tế`, `sâu sắc`, `cốt tử`, `hoàn hảo`, `câu châm ngôn` → Chỉ dùng `Ví dụ: ...`.
- **Cấu trúc đề mục:** Phân cấp `## 1.`, `### 1.1.`, `#### a)`, tuyệt đối không dùng chữ "CHƯƠNG" trong bài học.

## Chu trình Sư phạm 5 bước cho Mỗi Tiểu mục
1. Định nghĩa hình thức (Formal Definition)
2. Trực giác hình học & Bản chất (Geometric Intuition & Mechanism)
3. Ví dụ tính toán thủ công từng bước (Step-by-step Trace)
4. Mã nguồn chuẩn mực (PEP 8, Type Hints, Docstring, Edge Cases)
5. Lưu ý kỹ thuật & Độ phức tạp tính toán O(·)

## Quy trình Thực thi
1. Soạn thảo file bài học `.md`
2. Chạy Anti-Check Linter bắt buộc:
   ```bash
   python <skill-dir>/scripts/lint_textbook.py <file.md>
   ```
3. Xuất file DOCX chuẩn in ấn A4 (Lề trái 3cm, Times New Roman 13pt):
   ```bash
   python <skill-dir>/scripts/export_docx.py <file.md> <file.docx>
   ```
4. Tạo ngân hàng câu hỏi CodeRunner XML (`/question`).
