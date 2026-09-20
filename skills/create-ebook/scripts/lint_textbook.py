import os
import sys
import re

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

# Danh sách các mẫu vi phạm văn phong học thuật và cấu trúc đề mục
FORBIDDEN_PATTERNS = [
    (r'\bkinh\s+điển\b', 'Từ thừa cảm tính: "kinh điển"'),
    (r'\bví\s+dụ\s+thực\s+tế\b', 'Cụm từ thừa: "ví dụ thực tế" (hãy dùng "Ví dụ:")'),
    (r'\bsâu\s+sắc\b', 'Từ thừa cảm tính: "sâu sắc"'),
    (r'\bcốt\s+tử\b', 'Từ ngữ phóng đại: "cốt tử"'),
    (r'\bhoàn\s+hảo\b', 'Từ ngữ phóng đại: "hoàn hảo"'),
    (r'#+\s+CHƯƠNG\b', 'Tiêu đề bài học không được dùng chữ "CHƯƠNG" (hãy dùng số phân cấp: 1., 1.1, ...)'),
    (r'\bcâu\s+châm\s+ngôn\b', 'Văn phong cảm tính: "câu châm ngôn"'),
    (r'\btuyệt\s+đối\s+không\b', 'Từ ngữ cảm thán: "tuyệt đối không"'),
]

def lint_textbook(md_path):
    """
    Hàm Anti-check độc lập cho quy trình Tạo Textbook.
    Quét qua từng dòng của file Markdown để đảm bảo chuẩn văn phong khoa học và đề mục phân cấp.
    """
    if not os.path.exists(md_path):
        print(f"[LỖI]: Không tìm thấy file {md_path}")
        return False

    with open(md_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    errors = []
    for line_num, line in enumerate(lines, 1):
        for pattern, msg in FORBIDDEN_PATTERNS:
            if re.search(pattern, line, re.IGNORECASE):
                snippet = line.strip()
                if len(snippet) > 70:
                    snippet = snippet[:67] + "..."
                errors.append((line_num, msg, snippet))

    if errors:
        print(f"================================================================================")
        print(f"❌ [ANTI-CHECK THẤT BẠI] Phát hiện {len(errors)} lỗi trong file: {md_path}")
        print(f"================================================================================")
        for line_num, msg, snippet in errors:
            print(f"  • Dòng {line_num:<4} | {msg}")
            print(f"               Đoạn văn: '{snippet}'")
        print(f"--------------------------------------------------------------------------------")
        print(f"👉 Vui lòng sửa lại nội dung file Markdown trước khi hoàn tất Bước Tạo Textbook!")
        print(f"================================================================================")
        return False
    else:
        print(f"✅ [ANTI-CHECK THÀNH CÔNG]: File '{md_path}' đạt 100% chuẩn văn phong và đề mục!")
        return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python tools/lint_textbook.py <path_to_textbook.md>")
        sys.exit(1)

    file_path = sys.argv[1]
    success = lint_textbook(file_path)
    sys.exit(0 if success else 1)
