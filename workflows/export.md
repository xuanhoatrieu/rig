---
description: 📄 Xuất bài học ra DOCX
---

# /export — Document Export to DOCX

## Cách gọi

```
/export bai_01               → Xuất Bài 01 ra DOCX
/export bai_03               → Xuất Bài 03 ra DOCX
/export chapter_01           → Xuất toàn bộ Chapter 01
/export all                  → Xuất toàn bộ giáo trình
/export de_cuong             → Xuất đề cương học phần
```

## Loại export

| Loại | Script | Template | Đặc điểm |
|---|---|---|---|
| **Bài giảng (Textbook)** | `ebooks/export.py` | `_reference.docx` | Code block có viền, nền xám |
| **Đề cương học phần** | `ebooks/export_decuong.py` | `_reference_decuong.docx` | Font Times New Roman, Mục 7-8 xoay ngang |

## Yêu cầu hệ thống

- **Pandoc** cài đặt sẵn (`pandoc --version`)
- **python-docx** (`pip install python-docx`)

## Quy trình

### Bước 1: Xác định loại export

```
Nếu target chứa "de_cuong", "đề cương", "syllabus"
  → Dùng export_decuong.py

Nếu target chứa "bai_", số, "chapter_", "all"
  → Dùng export.py
```

### Bước 2: Chạy export

```bash
# Bài giảng
python ebooks/export.py <target>

# Đề cương
python ebooks/export_decuong.py
```

### Bước 3: Xử lý kết quả

- **Thành công**: Báo dung lượng file và vị trí DOCX
- **Lỗi khóa file** (file đang mở trong Word/Drive):
  - Script tạo file `.tmp` trước, rồi rename
  - Nếu rename fail → copy sang `<tên>_v2.docx`
  - Hướng dẫn user đóng file đang mở

## Next Steps

```
1️⃣ Xuất bài khác? /export bai_XX
2️⃣ Tạo slide? /pptx
3️⃣ Sinh câu hỏi? /question
```
