---
description: 📚 Viết ebook/textbook học thuật (Chu trình Sư phạm 5 bước & Anti-Check Linter)
---

# /textbook — Ebook/Textbook Writing

## Cách gọi

```
/textbook viết bài 4         → Viết bài cụ thể theo đề cương
/textbook viết bài tiếp      → Viết bài tiếp theo (status="not_started")
/textbook tiến độ            → Xem progress table
```

## Quy chuẩn Biên soạn Sư phạm & Văn phong Học thuật
Bắt buộc tuân thủ tài liệu: `~/.gemini/antigravity/plugins/education/guides/academic_textbook_style_guide.md`
1. **Thể trần thuật khách quan:** Không dùng ngôi thứ nhất ("chúng ta", "tôi", "bạn").
2. **Cấm từ ngữ cảm tính / phóng đại:** `kinh điển`, `ví dụ thực tế`, `sâu sắc`, `cốt tử`, `hoàn hảo`, `câu châm ngôn`, `then chốt`, `vô cùng`, `kỳ diệu` → Chỉ ghi trực diện: `Ví dụ: ...`.
3. **Phân cấp đề mục chuẩn đại học:** Không dùng chữ "CHƯƠNG" trong bài học. Sử dụng:
   - `## 1. TÊN MỤC LỚN`
   - `### 1.1. Tên mục con`
   - `#### a) Tiểu mục chi tiết` hoặc `#### 1.1.1.`
   - `## 2. BẢNG TỔNG KẾT & CÂU HỎI TỰ ĐÁNH GIÁ` (5 câu hỏi tự luận bản chất).

## Chu trình Thực thi 3 Bước

### Bước 1: Soạn thảo Markdown (`.md`) theo Chu trình Sư phạm 5 bước
Mỗi tiểu mục kiến thức phải triển khai đầy đủ:
1. **Định nghĩa hình thức:** Phát biểu toán học/kỹ thuật chính xác, miền giá trị, thứ nguyên.
2. **Trực giác hình học & Cơ chế:** Giải thích bản chất, sơ đồ ASCII minh họa.
3. **Ví dụ tính toán thủ công:** Dữ liệu số cụ thể (2x2, 3x3), lần vết từng phép tính (Trace).
4. **Mã nguồn chuẩn mực:** Code Python/NumPy chuẩn PEP 8 có Type Hints, Docstring, xử lý lỗi biên.
5. **Lưu ý kỹ thuật:** Đánh giá độ phức tạp O(·), quản lý bộ nhớ (View vs Copy).

**GATE CHECK BẮT BUỘC (Bước 1.1 - Anti-Check Linter):**
Chạy lệnh kiểm thử văn phong tự động:
```bash
python ~/.gemini/antigravity/plugins/education/tools/lint_textbook.py <path_to_file.md>
```
Phải đạt `✅ [ANTI-CHECK THÀNH CÔNG]` 100% trước khi chuyển sang bước tiếp theo.

### Bước 2: Export DOCX (`.docx`)
Chạy lệnh chuyển đổi định dạng:
```bash
python ~/.gemini/antigravity/plugins/education/tools/export_docx.py <input.md> <output.docx>
```
Đạt chuẩn in ấn đại học: Khổ A4, Lề trái 3.0cm, Lề phải/trên/dưới 2.0cm, Font Times New Roman 13pt, khối code Consolas 10pt có khung viền xám, bảng biểu tiêu đề xanh `#003366`.

### Bước 3: Tạo Ngân hàng Câu hỏi CodeRunner (`.md` & `.xml`)
Tạo bộ bài tập lập trình Python 3 CodeRunner tương ứng để chấm điểm tự động.

## Next Steps

```
1️⃣ Viết bài tiếp? /textbook viết bài tiếp
2️⃣ Xem tiến độ? /textbook tiến độ
3️⃣ Tạo slide? /pptx
4️⃣ Sinh câu hỏi? /question
5️⃣ Xuất file? /export
```
