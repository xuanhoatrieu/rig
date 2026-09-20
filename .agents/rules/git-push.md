# Quy tắc Git Push & Release cho GitHub (xuanhoatrieu)

Quy tắc này áp dụng khi người dùng yêu cầu: "push git", "push code", "đẩy git", "release", hoặc các yêu cầu liên quan đến việc đẩy mã nguồn lên GitHub.

## 1. Xác định Repository Target
- Mọi repository mặc định thuộc tổ chức/tài khoản: `github.com/xuanhoatrieu/<tên-repo>` (HTTPS hoặc SSH: `git@github.com:xuanhoatrieu/<tên-repo>.git`).
- Trước khi thực hiện bất kỳ lệnh push nào, Agent PHẢI kiểm tra `git remote -v`.
- Nếu remote chưa có hoặc trỏ sai tài khoản/repo, Agent phải thông báo rõ và hỗ trợ người dùng cấu hình đúng remote trỏ về `xuanhoatrieu/<tên-repo>`.

## 2. Kiểm tra trước khi Push (Pre-push Check)
- Chạy `git status` để kiểm tra các file thay đổi, đảm bảo:
  - Không có file rác, file sinh tự động trong quá trình build (`node_modules`, `target`, `.DS_Store`).
  - Không có file nhạy cảm (`.env`, secrets, token, private keys).
- Đảm bảo các bài kiểm tra cơ bản (linter, unit tests) đã vượt qua nếu dự án có bộ test sẵn.

## 3. Quy chuẩn Tagging & Release (SemVer)
- Khi phát hành phiên bản hoặc yêu cầu push có tag:
  - Kiểm tra tag mới nhất hiện tại: `git describe --tags --abbrev=0` hoặc `git tag -l`.
  - Tuân thủ Semantic Versioning: `vMAJOR.MINOR.PATCH` (tiền tố `v`).
    - **PATCH** (`vX.Y.Z+1`): Sửa lỗi, cải tiến nhỏ, không đổi API.
    - **MINOR** (`vX.Y+1.0`): Thêm tính năng mới tương thích ngược.
    - **MAJOR** (`vX+1.0.0`): Thay đổi lớn, phá vỡ tương thích cũ.
  - Tạo annotated tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z: <mô tả ngắn>"`

## 4. Chiến lược Push tránh Duplicate GitHub Actions
- **Quy tắc vàng:** TUYỆT ĐỐI KHÔNG dùng `git push --tags` hoặc `git push origin main --tags` (vì sẽ gửi đồng thời ref branch và ref tag, kích hoạt 2 Action runs song song).
- **Thực hiện tuần tự:**
  1. Nếu có commit mới trên nhánh `main`: `git push origin main` (chỉ lưu code, CI linter/test chạy nếu có cấu hình).
  2. Nếu có phiên bản mới cần release: `git push origin vX.Y.Z` (kích hoạt duy nhất 1 run cho release/deploy).

## 5. Xác nhận an toàn (Safety Confirmation)
- Luôn hiển thị tóm tắt và **HỎI XÁC NHẬN** người dùng trước khi chạy lệnh push:
  - Target: `github.com/xuanhoatrieu/<repo>`
  - Nhánh / Tag: `main` / `vX.Y.Z`
  - Tóm tắt các thay đổi / commits sắp push.
- Chỉ thực thi push khi có sự đồng ý của người dùng.
