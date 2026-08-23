---
description: ❓ Sinh câu hỏi trắc nghiệm từ bài ebook
---

# /question — Quiz Question Generator

## Cách gọi

```
/question bai_02              → Sinh 3 file câu hỏi cho Bài 02
/question bai_01 bai_03       → Sinh cho nhiều bài
/question all                 → Sinh cho tất cả bài đã hoàn thành
/question bai_02 review       → Chỉ sinh Review (50 câu)
/question bai_02 interactive  → Chỉ sinh Interactive (5 câu)
```

## Quy trình

### Bước 1: Xác định bài cần sinh

```
Nếu "bai_XX":
  → Tìm file: ebooks/chapter_*/bai_XX_*.md
  → Kiểm tra file tồn tại

Nếu "all":
  → Đọc _meta.json
  → Lọc sections có status="done"
  → Sinh lần lượt cho từng bài
```

### Bước 2: Đọc nội dung bài

- Đọc toàn bộ file Markdown
- Trích xuất kiến thức theo phân loại:
  - Khái niệm / Định nghĩa
  - Quy trình / Các bước
  - So sánh / Phân biệt
  - Code / Cú pháp
  - Ứng dụng thực tế

### Bước 3: Sinh câu hỏi (chia nhỏ do token limit)

```
Lần 1: 5 câu Interactive (MC/MR)
  → Viết Python script tạo .xlsx
  → Chạy script → verify

Lần 2: 20 câu Review Mức 1 (Biết/Nhớ)
  → Append vào script

Lần 3: 20 câu Review Mức 2 (Hiểu/Áp dụng)
  → Tiếp tục

Lần 4: 10 câu Review Mức 3 (Vận dụng/Phân tích)
  → Ghép tất cả → xuất review.xlsx + moodle.xml
```

### Bước 4: Verify

- Chạy Python verify: đếm số dòng Excel, parse XML
- Kiểm tra:
  - Đủ số câu theo phân bổ
  - Đáp án đúng phải chính xác
  - Không có placeholder
  - Moodle XML hợp lệ

## Output

```
📁 Files:
   + question/bai_XX_*_interactive.xlsx (5 câu MC/MR)
   + question/bai_XX_*_review.xlsx (50 câu, 3 mức)
   + question/bai_XX_*_moodle.xml (50 câu, Moodle import)

📊 Phân bổ Review:
   Mức 1 (Biết): 20 câu
   Mức 2 (Hiểu): 20 câu
   Mức 3 (Vận dụng): 10 câu
```

## Next Steps

```
1️⃣ Review nội dung? Mở file Excel
2️⃣ Sinh bài khác? /question bai_XX
3️⃣ Import Moodle? Upload file .xml
4️⃣ Import iSpring? Mở file interactive.xlsx
```
