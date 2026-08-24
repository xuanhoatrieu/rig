---
description: 🎨 Thiết kế UI/UX mockup
extends: core/HARNESS.md
tools: generate_image
---

# /visualize — UI/UX Design

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. Read `docs/DESIGN.md` if exists → list of screens needed
2. Read `docs/product/README.md` → understand product

## Work

### 1. Quick Interview (3 questions)

- **Thiết kế gì?** Toàn bộ app / 1 màn hình / chỉnh sửa UI có sẵn
- **Tham khảo?** Có website/app nào thích? Hoặc bắt đầu từ đầu
- **Cảm xúc?** Chuyên nghiệp / thân thiện / hiện đại / vui vẻ

### 2. Vibe Styling

Hỏi về:
- Phong cách: Clean / Dark luxury / Colorful / Corporate / Tech
- Màu sắc: Logo color? Light/Dark mode?
- Hình dáng: Bo tròn / vuông vức?

### 3. Mockup Generation

Dùng `generate_image` tạo mockup với prompt chi tiết (colors, layout, typography).

### 4. Iteration

Lặp lại cho đến khi user hài lòng.

### 5. Design Specs

Sau khi mockup được duyệt, tạo `docs/design-specs.md`:
- Color palette (hex codes)
- Typography (font, sizes, weights)
- Spacing system
- Border radius, shadows
- Breakpoints
- Animations

## Post-work

```bash
rig trace --summary "Designed UI: <screen>" --outcome success
```

## Next Steps

```
1️⃣ UI OK? → /code để implement
2️⃣ Design màn hình khác? Tiếp tục /visualize
3️⃣ Chỉnh sửa? Nói chi tiết
```
