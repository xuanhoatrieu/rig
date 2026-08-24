# QUY CHUẨN BIÊN SOẠN GIÁO TRÌNH & BÀI GIẢNG ĐẠI HỌC (ACADEMIC PEDAGOGICAL STYLE GUIDE)

Tài liệu này quy định chuẩn mực về tư duy sư phạm, cấu trúc nội dung và phong cách ngôn ngữ học thuật áp dụng cho toàn bộ quá trình biên soạn sách, giáo trình và tài liệu bài giảng môn **Nền tảng Trí tuệ Nhân tạo & Khoa học Dữ liệu**.

---

## 1. NGUYÊN TẮC NGÔN NGỮ HỌC THUẬT (ACADEMIC LINGUISTIC REGISTER)

### 1.1. Tính Khách quan & Trần thuật (Objectivity & Neutral Tone)
- **Ngôi xưng và chủ thể:** Sử dụng thể trần thuật khách quan hoặc câu chủ động hướng vào đối tượng nghiên cứu. Tránh dùng ngôi thứ nhất thân mật ("tôi", "chúng ta", "mình") hoặc câu mệnh lệnh cảm tính ("hãy nhớ rằng", "hãy tưởng tượng", "bạn sẽ thấy thật thú vị").
  - *Không viết:* "Chúng ta hãy cùng nhau tìm hiểu một công thức vô cùng kỳ diệu..."
  - *Chuẩn mực:* "Xét hàm mất mát sai số bình phương trung bình (MSE)..."
- **Loại bỏ hoàn toàn tính từ/phó từ cực cấp và từ ngữ cảm thán:**
  - *Cấm tuyệt đối các từ:* `kinh điển`, `sâu sắc`, `cốt tử`, `hoàn hảo`, `kỳ diệu`, `thần thánh`, `đỉnh cao`, `vô cùng`, `cực kỳ`, `tuyệt đối`, `siêu việt`, `câu châm ngôn`, `then chốt`, `rất hay`.
  - *Cách sửa:* Thay thế bằng thuật ngữ định lượng hoặc miêu tả chức năng trực diện:
    - *"thuật toán cực kỳ quan trọng"* $\rightarrow$ *"thuật toán tối ưu hóa trọng số"*.
    - *"một ví dụ thực tế kinh điển"* $\rightarrow$ *"Ví dụ:"*.
    - *"đối xứng hoàn hảo"* $\rightarrow$ *"đối xứng qua trục"*.

### 1.2. Tính Chính xác Kỹ thuật & Nhất quán Thuật ngữ (Technical Precision)
- Mọi thuật ngữ chuyên ngành phải được định nghĩa chính xác.
- Khi xuất hiện lần đầu, ghi rõ thuật ngữ tiếng Việt kèm tiếng Anh trong ngoặc đơn:
  - *Ví dụ:* *Hạ Gradient (Gradient Descent)*, *Ma trận hiệp phương sai (Covariance Matrix)*, *Độ tương đồng Cosine (Cosine Similarity)*, *Phân tích Thành phần Chính (Principal Component Analysis - PCA)*.
- Ký hiệu toán học phải nhất quán xuyên suốt bài học: Vector in đậm chữ thường ($\mathbf{x}, \mathbf{w}$), Ma trận in hoa ($X, W$), Vô hướng in nghiêng ($x_i, b, \alpha$).

---

## 2. CẤU TRÚC MÔ-ĐUN SƯ PHẠM 5 BƯỚC (5-STAGE PEDAGOGICAL FLOW)

Mỗi khái niệm / đơn vị kiến thức trong giáo trình phải được triển khai đầy đủ theo chu trình 5 bước:

```
┌────────────────────────┐
│ 1. ĐỊNH NGHĨA TOÁN HỌC │ ──► Phát biểu chính xác, công thức và không gian vector (R^n)
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ 2. TRỰC GIÁC HÌNH HỌC  │ ──► Giải thích bản chất, ý nghĩa hình học & sơ đồ ASCII
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ 3. VÍ DỤ TÍNH TAY MẪU  │ ──► Cho dữ liệu số nhỏ, lần vết từng bước tính toán (Trace)
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ 4. MÃ NGUỒN CHUẨN MỰC  │ ──► Code Python/NumPy chuẩn mực, Type Hints, Docstring, Edge Cases
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ 5. LƯU Ý KỸ THUẬT      │ ──► Độ phức tạp O(·), bộ nhớ View vs Copy, bẫy lỗi thường gặp
└────────────────────────┘
```

### Chi tiết từng bước:

#### Bước 1: Định nghĩa Hình thức (Formal Definition)
- Phát biểu rõ ràng khái niệm, điều kiện áp dụng, miền xác định và thứ nguyên (Dimensions) của các đại lượng.

#### Bước 2: Trực giác Hình học & Bản chất Cơ chế (Geometric Intuition)
- Giải thích vì sao công thức lại có dạng như vậy. Sử dụng sơ đồ hộp hoặc biểu đồ ASCII để sinh viên hình dung trực quan trong không gian nhiều chiều.

#### Bước 3: Ví dụ Tính toán Thủ công (Worked Numerical Example)
- Đưa ra bài toán cụ thể với kích thước ma trận nhỏ ($2 \times 2$ hoặc $3 \times 3$).
- Trình bày tuần tự từng phép nhân, cộng, trừ để sinh viên thấy rõ dòng dữ liệu biến đổi.

#### Bước 4: Cài đặt Mã nguồn Tham chiếu (Reference Code Implementation)
- Viết code Python/NumPy theo chuẩn PEP 8.
- Có Type Hints đầy đủ (`X: np.ndarray, y: np.ndarray -> float`).
- Chú thích (comments) giải thích thuật toán, bắt các ngoại lệ biên (như chia cho 0, ma trận suy biến).

#### Bước 5: Phân tích Kỹ thuật & Bẫy Lập trình (Technical Analysis & Caveats)
- Phân tích độ phức tạp thời gian ($O(N \cdot D)$) và bộ nhớ.
- Phân biệt giữa cơ chế tạo bản sao (Copy) và giao diện nhìn (View).

---

## 3. CẤU TRÚC PHÂN CẤP ĐỀ MỤC BÀI GIẢNG (HEADING HIERARCHY)

Một bài học (`Bài XX`) là một chỉnh thể độc lập, tuyệt đối **không dùng chữ "Chương"**. Phân cấp chuẩn mực gồm:

```text
# BÀI XX: TÊN BÀI HỌC
*(Tài liệu Giáo trình thuộc Course 2: Nền tảng Toán và Khoa học Dữ liệu cho AI)*

## 🎯 MỤC TIÊU BÀI HỌC (3-5 mục tiêu cụ thể, đo lường được theo thang Bloom)

## 1. TÊN MỤC LỚN THỨ NHẤT
### 1.1. Tên mục con
#### a) Ý chi tiết / Tiểu mục nhỏ
#### b) Ý chi tiết tiếp theo
### 1.2. Tên mục con thứ hai

## 2. TÊN MỤC LỚN THỨ HAI
...

## 3. BẢNG TỔNG KẾT & CÂU HỎI TỰ ĐÁNH GIÁ
### 3.1. Bảng Tra cứu Cú pháp / Công thức
### 3.2. Câu hỏi Tự Đánh giá Kiến thức (5 câu hỏi tư duy bản chất)
```

---

## 4. QUY TRÌNH KIỂM THỬ VĂN PHONG TỰ ĐỘNG (ANTI-CHECK GATE)

Trước khi hoàn tất soạn thảo bài giảng Markdown:
1. Chạy công cụ kiểm thử:
   ```bash
   python tools/lint_textbook.py baigiang/baiXX/textbook/baiXX_textbook.md
   ```
2. Tự rà soát theo bảng kiểm (Checklist):
   - [ ] Đã loại bỏ 100% từ ngữ cảm thán, phóng đại, cảm tính chưa?
   - [ ] Đã có ví dụ số học tính tay từng bước chưa?
   - [ ] Mã nguồn đã có Type Hints, Docstring và xử lý lỗi biên chưa?
   - [ ] Đề mục đã phân cấp chuẩn `1.`, `1.1.`, `a)`, không chứa chữ `CHƯƠNG` chưa?
   - [ ] Linter có trả về `✅ [ANTI-CHECK THÀNH CÔNG]` không?
