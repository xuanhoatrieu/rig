---
description: 🎬 Tạo video animation ML bằng Manim
---

# /video — ML Animation Video

## Cách gọi

```
/video gradient descent      → Tạo video gradient descent
/video neural network        → Tạo video neural network
/video <chủ đề bất kỳ>      → Sinh code Manim mới
```

## Quy trình

### Bước 1: Phân tích chủ đề

Xác định chủ đề từ input user và map vào template có sẵn:

| Keyword | Template |
|---|---|
| gradient descent | `gradient_descent.py` |
| linear regression | `linear_regression.py` |
| neural network | `neural_network.py` |
| loss, landscape | `loss_landscape.py` |

Nếu không có template phù hợp → sinh code Manim mới dựa trên `common_styles.py`.

### Bước 2: Customize (nếu cần)

- Điều chỉnh parameters (learning rate, data points...)
- Thêm/bớt animation scenes
- Chỉnh text labels và colors

### Bước 3: Render video

```bash
# Medium quality (mặc định, nhanh, preview)
manim -qm <template_file>.py <SceneName>

# High quality (khi user yêu cầu)
manim -qh <template_file>.py <SceneName>
```

### Bước 4: Trả kết quả

- Thông báo đường dẫn video
- Video nằm tại: `media/videos/<file>/720p30/` hoặc `1080p60/`

## Lưu ý

- Luôn `cd` vào thư mục chứa file template trước khi render
- Dùng `-qm` để preview, `-qh` cho sản phẩm cuối
- Nếu LaTeX lỗi → dùng `Text()` thay `MathTex()`
- Kiểm tra `manim` đã cài: `pip install manim`

## Next Steps

```
1️⃣ Render chất lượng cao? /video <chủ đề> --hq
2️⃣ Tạo video khác? /video <chủ đề>
3️⃣ Tạo slide? /pptx
```
