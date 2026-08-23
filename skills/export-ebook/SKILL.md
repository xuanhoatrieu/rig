---
name: export-ebook
description: Xuất giáo trình, bài học, đề cương học phần từ Markdown sang định dạng Word (.docx) hoặc PDF chuẩn format, hỗ trợ định dạng code block có viền, font chữ chuẩn và bảng biểu xoay ngang.
---

# Export Ebook / Document to DOCX

Xuất tài liệu từ định dạng Markdown sang Word/PDF phục vụ in ấn, giảng dạy.

## Các chế độ Export

1. **Xuất từng bài**: `python ebooks/export.py bai_01`
2. **Xuất theo chapter**: `python ebooks/export.py chapter_01`
3. **Xuất toàn bộ sách**: `python ebooks/export.py all`
4. **Xuất đề cương học phần**: `python ebooks/export_decuong.py`

## Công cụ yêu cầu
- `pandoc` (`pandoc --version`)
- Thư viện Python: `pip install python-docx`

## Quy trình
1. Nhận diện mục tiêu export (bài học, chương, hoặc đề cương học phần).
2. Áp dụng template chuẩn (`_reference.docx` cho giáo trình hoặc `_reference_decuong.docx` cho đề cương).
3. Biên dịch và xuất file. Xử lý an toàn nếu file đang bị khóa mở trong Word (tạo file `_v2.docx`).
