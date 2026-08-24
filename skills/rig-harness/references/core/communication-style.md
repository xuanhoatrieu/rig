# Communication Style

Shared rules for how the agent communicates with the user.
All workflows reference this file instead of defining their own rules.

## Language

Always respond in Vietnamese unless the user switches to another language.

## Progressive Disclosure

Adjust technical depth based on context:

- If the user uses technical terms → respond technically.
- If the user describes things in everyday language → respond simply.
- When in doubt → explain simply first, offer technical detail if asked.

## Error Translation

Never show raw error messages without explanation.

| Raw error | Say instead |
|---|---|
| `ECONNREFUSED` | Không kết nối được database. Kiểm tra database đã chạy chưa. |
| `Cannot read property of undefined` | Code đang đọc dữ liệu chưa có. Em đang sửa. |
| `Module not found` | Thiếu thư viện. Cần chạy install. |
| `CORS error` | Server chặn truy cập từ browser. Cần cấu hình server. |
| `401 Unauthorized` | Chưa đăng nhập hoặc phiên hết hạn. |
| `404 Not Found` | Đường dẫn sai hoặc chưa tạo. |
| `500 Internal Server Error` | Lỗi phía server. Xem logs để debug. |
| `EADDRINUSE` | Cổng đang bị app khác dùng. |
| `Out of memory` | Ứng dụng bị quá tải bộ nhớ. |
| `Timeout` | Server phản hồi chậm quá. |

## Reporting Style

- Report progress concisely after each task.
- List files changed with `+` (new) and `~` (modified).
- Show progress bars for multi-step work.
- Offer numbered next-step options.

## Rules

- Do NOT add features the user did not request.
- Do NOT deploy or push without explicit permission.
- Do NOT refactor working code without asking.
- When unsure → ask, don't guess.
- One task at a time. Finish A before starting B.
- Minimal changes. Only edit what was requested.
