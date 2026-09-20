# Quy Tắc Xây Dựng & Phát Hành Mobile App Chuẩn Doanh Nghiệp (Expo / React Native)

Quy tắc này áp dụng khi người dùng yêu cầu: "apk", "build apk", "test local", "build store", "ch play", "google play", "app store", "apple store", "phát hành app".

---

## 1. Nguyên Tắc Tối Thượng: Không Kiểm Tra Môi Trường Thừa (Zero-Check Policy)
- **Mặc định**: Máy chủ / máy local của người dùng ĐÃ ĐẦY ĐỦ CÁC CÔNG CỤ (Node.js, Java JDK, Android SDK, Gradle, EAS CLI, Expo CLI).
- **Cấm tuyệt đối**: Không chạy các lệnh thăm dò/kiểm tra trước khi build (như `which java`, `node -v`, `adb version`, `sdkmanager --list`...).
- **Hành vi**: CHẠY THẲNG lệnh build ngay lập tức. Chỉ can thiệp sửa lỗi nếu quá trình build gặp lỗi thiếu package/thư viện cụ thể.

---

## 2. Phân Tầng Xây Dựng (Enterprise 3-Tier Build Strategy)

Hệ thống tuân thủ 3 tầng build chuẩn doanh nghiệp thông qua `eas.json`:

| Tầng (Profile) | Loại File Đầu Ra | Nền Tảng | Mục Đích | Cách Kích Hoạt |
| :--- | :--- | :--- | :--- | :--- |
| **`preview` (APK)** | `.apk` (Sideload) | Android | Cài trực tiếp máy thật để Tester/QC/Khách hàng test nội bộ | "apk", "build apk", "test local" |
| **`production` (AAB)** | `.aab` (App Bundle) | Android | Nộp lên Google Play Console (Internal Testing / Production) | "build ch play", "google play" |
| **`production` (IPA)** | `.ipa` (Signed) | iOS | Nộp lên TestFlight / Apple App Store | "build app store", "apple store" |
| **`production` (All)** | `.aab` + `.ipa` | Cả 2 | Đóng gói bản phát hành đồng bộ cho cả 2 chợ ứng dụng | "build store", "phát hành mobile" |

---

## 3. Quy Trình Xử Lý Cho Từng Yêu Cầu Cụ Thể

### Trường hợp 1: Người dùng nói "apk", "build apk", "test local"
1. Kiểm tra file `eas.json` ở thư mục gốc:
   - Nếu chưa có: Tạo `eas.json` chuẩn (cấu hình profile `preview` có `buildType: "apk"`).
2. Chạy trực tiếp lệnh build APK local:
   ```bash
   eas build --platform android --profile preview --local
   ```
   *(Hoặc nếu là dự án Bare React Native: `cd android && ./gradlew assembleRelease`)*.
3. Báo cáo đường dẫn file `.apk` xuất ra sau khi build xong để người dùng cài vào máy.

---

### Trường hợp 2: Người dùng nói "build ch play", "google play"
1. Tự động kiểm tra và tăng `versionCode` (số nguyên) trong `app.json` (bắt buộc cho Google Play).
2. Thực thi lệnh build gói `.aab`:
   ```bash
   eas build --platform android --profile production
   ```
3. Nếu người dùng yêu cầu đưa lên CH Play:
   ```bash
   eas submit --platform android
   ```

---

### Trường hợp 3: Người dùng nói "build app store", "apple store", "ios"
1. Tự động kiểm tra và tăng `buildNumber` (chuỗi số) trong `app.json`.
2. Thực thi lệnh build gói `.ipa`:
   ```bash
   eas build --platform ios --profile production
   ```
3. Nếu người dùng yêu cầu đưa lên TestFlight / App Store:
   ```bash
   eas submit --platform ios
   ```

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

## 5. Bảo Mật Chữ Ký & Keystore (Security Guardrails)
- Tuyệt đối KHÔNG commit các file chữ ký nhạy cảm vào Git:
  - File Android Keystore: `*.jks`, `*.keystore`
  - File khóa dịch vụ Google: `google-services.json`, `api-*-service-account.json`
  - File khóa Apple: `*.p8`, `*.p12`, `*.mobileprovision`
- Đảm bảo các file trên đã nằm trong `.gitignore`.
