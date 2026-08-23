---
name: create-question
description: Tự động sinh ngân hàng câu hỏi trắc nghiệm & tự luận theo thang đo Bloom (Biết, Hiểu, Vận dụng) từ bài học ebook. Xuất dữ liệu ra Excel (.xlsx) và định dạng Moodle XML chuẩn để import LMS.
---

# Create Question / Quiz Generator

Tự động phân tích nội dung bài học Markdown và tạo ngân hàng câu hỏi trắc nghiệm đa cấp độ.

## Quy trình

### 1. Đọc nội dung & phân loại kiến thức
- Khái niệm / Định nghĩa
- Quy trình / Các bước
- So sánh / Phân biệt
- Cú pháp code / Bài tập tính toán

### 2. Sinh câu hỏi theo thang đo Bloom
- **Interactive Quiz** (5 câu tương tác nhanh MC/MR cho iSpring).
- **Review Quiz** (50 câu cho ngân hàng đề):
  - Mức 1 (Biết/Nhớ): 20 câu
  - Mức 2 (Hiểu/Áp dụng): 20 câu
  - Mức 3 (Vận dụng/Phân tích): 10 câu

### 3. Xuất file kết quả
- `question/bai_XX_*_interactive.xlsx`
- `question/bai_XX_*_review.xlsx`
- `question/bai_XX_*_moodle.xml` (chuẩn Moodle XML import LMS)
