# Quy Tắc Xây Dựng & Phát Hành Mobile App Chuẩn Doanh Nghiệp (Expo / React Native)

Quy tắc này áp dụng khi người dùng yêu cầu: "apk", "build apk", "test local", "build store", "ch play", "google play", "app store", "apple store", "phát hành app".

---

## 1. NGUYÊN TẮC BẮT BUỘC KHI BUILD APK (LOCAL-ONLY & ZERO-QUESTION)

> ⚠️ **ĐẶC BIỆT LƯU Ý VỀ TÀI KHOẢN EAS FREE:**
> - Người dùng sử dụng tài khoản Expo/EAS **Gói Miễn Phí (Free Tier)**: Giới hạn nghiêm ngặt **15 lượt build Cloud / tháng**.
> - **TUYỆT ĐỐI CẤM**: Không bao giờ được gọi build APK trên EAS Cloud. Toàn bộ hạn ngạch Cloud phải để dành cho việc nộp bài lên Store (.aab / .ipa).
> - **KHI NGƯỜI DÙNG BẢO "APK" / "BUILD APK":**
>   1. **CẤM HỎI THÊM BẤT KỲ CÂU HỎI NÀO** (Không hỏi "Build local hay cloud?", không hỏi "Cần cấu hình gì không?").
>   2. **CẤM CHẠY LỆNH KIỂM TRA MÔI TRƯỜNG** (Mặc định máy đã có đủ Android SDK, Java, Node.js).
>   3. **CHẠY NGAY LẬP TỨC LỆNH BUILD LOCAL 100%:**
>      ```bash
>      eas build --platform android --profile preview --local
>      ```
>      *(Hoặc nếu là Bare React Native: `cd android && ./gradlew assembleRelease`)*.
>   4. Nếu thiếu file `eas.json`: Tự động tạo âm thầm và chạy build ngay, không hỏi người dùng.

---

## 2. Phân Tầng Xây Dựng (Enterprise 3-Tier Build Strategy)

Hệ thống tuân thủ 3 tầng build thông qua `eas.json`:

| Tầng (Profile) | Loại File Đầu Ra | Nền Tảng | Môi Trường Build | Mục Đích | Kích Hoạt |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`preview` (APK)** | `.apk` (Sideload) | Android | **100% LOCAL** (Không tốn quota EAS) | Cài trực tiếp điện thoại để test nội bộ | "apk", "build apk", "test local" |
| **`production` (AAB)** | `.aab` (App Bundle) | Android | EAS Cloud / CI | Nộp lên Google Play Console | "build ch play", "google play" |
| **`production` (IPA)** | `.ipa` (Signed) | iOS | EAS Cloud (macOS runner) | Nộp lên TestFlight / Apple Store | "build app store", "apple store" |
| **`production` (All)** | `.aab` + `.ipa` | Cả 2 | EAS Cloud | Đóng gói bản phát hành đồng bộ 2 Store | "build store", "phát hành mobile" |

---

## 3. Quy Trình Xử Lý Cho Từng Lệnh Cụ Thể

### Trường hợp 1: Người dùng nói "apk", "build apk", "test local"
- **Hành vi duy nhất**:
  1. Đảm bảo file `eas.json` có profile `preview` với `"buildType": "apk"`.
  2. Bắn lệnh build local ngay lập tức:
     ```bash
     eas build --platform android --profile preview --local
     ```
  3. Báo cáo đường dẫn file `.apk` xuất ra sau khi build xong để người dùng copy vào điện thoại.

---

### Trường hợp 2: Người dùng nói "build ch play", "google play"
1. Tự động kiểm tra và tăng `versionCode` (số nguyên) trong `app.json`.
2. Thực thi build gói `.aab`:
   ```bash
   eas build --platform android --profile production
   ```
3. Nếu người dùng yêu cầu đưa lên CH Play: `eas submit --platform android`.

---

### Trường hợp 3: Người dùng nói "build app store", "apple store", "ios"
1. Tự động kiểm tra và tăng `buildNumber` (chuỗi số) trong `app.json`.
2. Thực thi build gói `.ipa`:
   ```bash
   eas build --platform ios --profile production
   ```
3. Nếu người dùng yêu cầu đưa lên TestFlight / App Store: `eas submit --platform ios`.

---

### Trường hợp 4: Người dùng nói "build store", "phát hành mobile"
1. Tăng đồng bộ cả `versionCode` và `buildNumber`.
2. Thực thi build cả 2 nền tảng:
   ```bash
   eas build --platform all --profile production
   ```

---

## 4. Quản Lý Phiên Bản (Versioning Rules)
Trong file `app.json`:
* `expo.version`: Chuỗi SemVer hiển thị cho người dùng (ví dụ: `"1.0.0"`).
* `expo.android.versionCode`: Số nguyên tăng dần từng đơn vị mỗi lần build store (ví dụ: `1`, `2`, `3`...).
* `expo.ios.buildNumber`: Chuỗi số tăng dần khớp với `versionCode` (ví dụ: `"1"`, `"2"`, `"3"`...).

---

## 5. Bảo Mật Keystore & Khóa Ký
- Tuyệt đối KHÔNG commit các file chữ ký nhạy cảm vào Git:
  - File Android Keystore: `*.jks`, `*.keystore`
  - File khóa dịch vụ Google: `google-services.json`, `api-*-service-account.json`
  - File khóa Apple: `*.p8`, `*.p12`, `*.mobileprovision`
- Đảm bảo các file trên đã nằm trong `.gitignore`.
