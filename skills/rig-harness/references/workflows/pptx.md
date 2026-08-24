---
description: 🎞️ Tạo slide PPTX + TTS audio
---

# /pptx — PPTX Slide Generation

## Cách gọi

```
/pptx bai_02                          → Tạo slide cho Bài 02
/pptx bai_02 --no-tts                 → Không tạo audio
/pptx bai_02 --voice-female           → Giọng nữ (mặc định)
/pptx bai_02 --voice-male             → Giọng nam
/pptx bai_02 --eng-vi                 → Song ngữ Anh-Việt
```

## Bước 1: Xác định bài học

- Hỏi user chọn bài (hoặc đọc từ context)
- Tìm file: `ebooks/chapter_XX/bai_YY_*.md`
- Flags: `--bg1`/`--bg2`, `--vi`/`--eng`/`--eng-vi`, `--voice-*`, `--no-tts`

## Bước 2: Đọc textbook Markdown

Đọc file textbook tương ứng, trích xuất cấu trúc.

## Bước 3: Tạo kịch bản slide

Map cấu trúc Markdown sang 8 slide types:

| Markdown element | Slide type |
|---|---|
| `#` Tiêu đề | Title slide |
| `## Mục tiêu bài học` | Objectives slide |
| `## N. Section` | Agenda + Divider + Content slides |
| `## Tổng kết` | Summary slide |
| `## Bài tập` | Exercise slide |
| Cuối bài | Closing slide |

Mỗi content slide: 3-4 ý chính, speaker note 200-300 từ.

## Bước 4: Tạo ảnh minh họa

Dùng `generate_image` tạo ảnh cho các content slides cần hình.

## Bước 5: TTS Audio (nếu không `--no-tts`)

```bash
python scripts/tts_client.py speak \
  --text "..." --mode system \
  --voice female --output "audio/slide_01.wav"
```

## Bước 6: Build PPTX

Gọi `scripts/pptx_generator.py` để build PPTX với audio nhúng sẵn.

## Bước 7: Verify

```bash
pip install "markitdown[pptx]"
python -m markitdown output.pptx
```

Kiểm tra nội dung đầy đủ, không placeholder.

## Next Steps

```
1️⃣ Tạo slide bài khác? /pptx bai_XX
2️⃣ Sinh câu hỏi? /question
3️⃣ Tạo video? /video
```
