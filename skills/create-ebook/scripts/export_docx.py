import os
import sys
import subprocess
import docx
from docx.shared import Pt, RGBColor, Cm, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml, OxmlElement
from docx.oxml.ns import nsdecls, qn

def get_or_create_reference_doc(ref_path="custom_reference.docx"):
    """Tạo file reference.docx chuẩn A4, Left 3cm, Times New Roman 13pt nếu chưa tồn tại"""
    if not os.path.exists(ref_path):
        temp_init = "temp_default_ref.docx"
        subprocess.run(["pandoc", "--print-default-data-file", "reference.docx"], stdout=open(temp_init, "wb"))
        doc = docx.Document(temp_init)
        if os.path.exists(temp_init):
            os.remove(temp_init)
    else:
        doc = docx.Document(ref_path)

    for section in doc.sections:
        section.page_width = Cm(21.0)
        section.page_height = Cm(29.7)
        section.left_margin = Cm(3.0)
        section.right_margin = Cm(2.0)
        section.top_margin = Cm(2.0)
        section.bottom_margin = Cm(2.0)

    styles = doc.styles

    # Normal Style
    if 'Normal' in styles:
        s = styles['Normal']
        s.font.name = 'Times New Roman'
        s.font.size = Pt(13)
        s.font.color.rgb = RGBColor(0x22, 0x22, 0x22)
        s.paragraph_format.line_spacing = 1.25
        s.paragraph_format.space_after = Pt(6)

    # Body Text
    if 'Body Text' in styles:
        s = styles['Body Text']
        s.font.name = 'Times New Roman'
        s.font.size = Pt(13)
        s.font.color.rgb = RGBColor(0x22, 0x22, 0x22)
        s.paragraph_format.line_spacing = 1.25
        s.paragraph_format.space_after = Pt(6)

    # Headings
    h_configs = {
        'Heading 1': (Pt(16), RGBColor(0x00, 0x33, 0x66), True, Pt(14), Pt(6)),
        'Heading 2': (Pt(14), RGBColor(0x00, 0x33, 0x66), True, Pt(12), Pt(4)),
        'Heading 3': (Pt(13), RGBColor(0x1E, 0x3A, 0x8A), True, Pt(10), Pt(3)),
        'Heading 4': (Pt(13), RGBColor(0x37, 0x41, 0x51), True, Pt(8), Pt(2)),
    }
    for h_name, (h_size, h_color, h_bold, sp_before, sp_after) in h_configs.items():
        if h_name in styles:
            s = styles[h_name]
            s.font.name = 'Times New Roman'
            s.font.size = h_size
            s.font.bold = h_bold
            s.font.color.rgb = h_color
            s.paragraph_format.space_before = sp_before
            s.paragraph_format.space_after = sp_after

    # Source Code
    if 'Source Code' in styles:
        s = styles['Source Code']
        s.font.name = 'Consolas'
        s.font.size = Pt(10)
        s.font.color.rgb = RGBColor(0x1E, 0x29, 0x3B)
        s.paragraph_format.line_spacing = 1.15
        s.paragraph_format.space_after = Pt(2)

    doc.save(ref_path)
    return ref_path

def set_cell_background(cell, fill_hex):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=120, bottom=120, left=180, right=180):
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = parse_xml(f'<w:tcMar {nsdecls("w")}><w:top w:w="{top}" w:type="dxa"/><w:bottom w:w="{bottom}" w:type="dxa"/><w:left w:w="{left}" w:type="dxa"/><w:right w:w="{right}" w:type="dxa"/></w:tcMar>')
    tcPr.append(tcMar)

def set_table_borders(table, color="D1D5DB", sz="4", val="single"):
    tblPr = table._tbl.tblPr
    borders = parse_xml(f'''
        <w:tblBorders {nsdecls("w")}>
            <w:top w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
            <w:bottom w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
            <w:left w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
            <w:right w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
            <w:insideH w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
            <w:insideV w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
        </w:tblBorders>
    ''')
    tblPr.append(borders)

def set_run_xml_font(rPr, font_name="Times New Roman", sz_pt=13, is_bold=None, color_hex="222222"):
    """Thiết lập phông chữ ở cấp độ OpenXML để loại bỏ hoàn toàn thuộc tính Theme (Aptos/Calibri)"""
    # 1. Xóa rFonts cũ và đặt lại thuộc tính tường minh không dùng Theme
    for el in rPr.findall(qn('w:rFonts')):
        rPr.remove(el)
    new_rFonts = parse_xml(f'<w:rFonts {nsdecls("w")} w:ascii="{font_name}" w:hAnsi="{font_name}" w:cs="{font_name}" w:eastAsia="{font_name}"/>')
    rPr.append(new_rFonts)

    # 2. Đặt cỡ chữ (Half-points: 13pt = 26)
    if sz_pt is not None:
        sz_val = int(sz_pt * 2)
        for el in rPr.findall(qn('w:sz')) + rPr.findall(qn('w:szCs')):
            rPr.remove(el)
        rPr.append(parse_xml(f'<w:sz {nsdecls("w")} w:val="{sz_val}"/>'))
        rPr.append(parse_xml(f'<w:szCs {nsdecls("w")} w:val="{sz_val}"/>'))

    # 3. Đặt in đậm
    if is_bold is not None:
        for el in rPr.findall(qn('w:b')) + rPr.findall(qn('w:bCs')):
            rPr.remove(el)
        if is_bold:
            rPr.append(parse_xml(f'<w:b {nsdecls("w")}/>'))
            rPr.append(parse_xml(f'<w:bCs {nsdecls("w")}/>'))

    # 4. Đặt màu chữ
    if color_hex is not None:
        for el in rPr.findall(qn('w:color')):
            rPr.remove(el)
        rPr.append(parse_xml(f'<w:color {nsdecls("w")} w:val="{color_hex}"/>'))

def format_docx(input_docx, output_docx=None):
    """Hậu xử lý tài liệu DOCX để chuẩn hóa lề, phông chữ 13pt Times New Roman, căn đều 2 bên, bảng biểu và khối code"""
    if output_docx is None:
        output_docx = input_docx

    doc = docx.Document(input_docx)

    # 1. Chuẩn hóa Section & Căn lề A4 (Trái 3cm, Phải 2cm, Trên 2cm, Dưới 2cm)
    for section in doc.sections:
        section.page_width = Cm(21.0)
        section.page_height = Cm(29.7)
        section.left_margin = Cm(3.0)
        section.right_margin = Cm(2.0)
        section.top_margin = Cm(2.0)
        section.bottom_margin = Cm(2.0)

    # 2. Xử lý đoạn văn bản (Paragraphs) — dùng OpenXML override
    for p in doc.paragraphs:
        style_name = p.style.name if p.style else ""

        # Nếu là tiêu đề (Heading 1..4, Title)
        if style_name.startswith('Heading') or style_name == 'Title':
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            for run in p.runs:
                rPr = run._r.get_or_add_rPr()
                set_run_xml_font(rPr, "Times New Roman", 13, is_bold=True, color_hex="003366")

        # Nếu là đoạn văn bản thông thường
        elif style_name in ['Normal', 'Body Text', 'List Paragraph', 'Compact', 'First Paragraph']:
            p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
            p.paragraph_format.line_spacing = 1.25
            for run in p.runs:
                rPr = run._r.get_or_add_rPr()
                set_run_xml_font(rPr, "Times New Roman", 13, color_hex="222222")

        # Nếu là khối mã nguồn (Source Code)
        elif style_name == 'Source Code':
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.left_indent = Cm(0.3)
            # Thêm viền / nền nhẹ cho từng dòng code
            pPr = p._p.get_or_add_pPr()
            shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="F3F4F6"/>')
            pPr.append(shd)
            pBdr = parse_xml(f'<w:pBdr {nsdecls("w")}><w:left w:val="single" w:sz="18" w:space="8" w:color="3B82F6"/></w:pBdr>')
            pPr.append(pBdr)
            for run in p.runs:
                rPr = run._r.get_or_add_rPr()
                set_run_xml_font(rPr, "Consolas", 10, color_hex="1E293B")

    # 3. Xử lý bảng biểu (Tables)
    for table in doc.tables:
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        set_table_borders(table, color="D1D5DB", sz="4")

        for i, row in enumerate(table.rows):
            # Header row
            if i == 0:
                for cell in row.cells:
                    set_cell_background(cell, "003366")
                    set_cell_margins(cell, top=140, bottom=140, left=180, right=180)
                    for p in cell.paragraphs:
                        for run in p.runs:
                            run.font.name = 'Times New Roman'
                            run.font.size = Pt(12)
                            run.font.bold = True
                            run.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
            else:
                bg_color = "F9FAFB" if i % 2 == 1 else "FFFFFF"
                for cell in row.cells:
                    set_cell_background(cell, bg_color)
                    set_cell_margins(cell, top=100, bottom=100, left=180, right=180)
                    for p in cell.paragraphs:
                        for run in p.runs:
                            run.font.name = 'Times New Roman'
                            run.font.size = Pt(12)
                            run.font.color.rgb = RGBColor(0x22, 0x22, 0x22)

FORBIDDEN_PATTERNS = [
    (r'\bkinh\s+điển\b', 'Từ thừa cảm thán: "kinh điển"'),
    (r'\bví\s+dụ\s+thực\s+tế\b', 'Cụm từ thừa: "ví dụ thực tế" (hãy dùng "Ví dụ:")'),
    (r'\bsâu\s+sắc\b', 'Từ thừa cảm thán: "sâu sắc"'),
    (r'\bcốt\s+tử\b', 'Từ ngữ phóng đại: "cốt tử"'),
    (r'\bhoàn\s+hảo\b', 'Từ ngữ phóng đại: "hoàn hảo"'),
    (r'#+\s+CHƯƠNG\b', 'Tiêu đề bài không được dùng chữ "CHƯƠNG" (hãy dùng số phân cấp: 1., 1.1, ...)'),
    (r'\bcâu\s+châm\s+ngôn\b', 'Văn phong cảm tính: "câu châm ngôn"'),
]

def lint_markdown(md_path):
    """Kiểm tra văn phong học thuật, phát hiện và chặn các từ thừa / cảm thán / sai tiêu đề"""
    if not os.path.exists(md_path):
        return
    with open(md_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    errors = []
    import re
    for line_num, line in enumerate(lines, 1):
        for pattern, msg in FORBIDDEN_PATTERNS:
            if re.search(pattern, line, re.IGNORECASE):
                errors.append(f"  [Dòng {line_num}]: {msg} -> '{line.strip()[:60]}...'")

    if errors:
        error_report = "\n".join(errors)
        raise ValueError(f"PHÁT HIỆN LỖI VĂN PHONG TRONG {md_path}:\n{error_report}\n-> Vui lòng sửa lại Markdown trước khi xuất DOCX!")

def convert_md_to_docx(md_path, docx_path):
    """Chuyển đổi Markdown sang DOCX chuẩn học thuật bằng Pandoc và hậu xử lý python-docx"""
    # 1. Chạy linter tự động kiểm tra văn phong & tiêu đề
    lint_markdown(md_path)

    # 2. Xuất DOCX qua Pandoc (sử dụng temp file để tránh conflict)
    ref_doc = get_or_create_reference_doc("tools/custom_reference.docx")
    temp_docx = docx_path + ".tmp.docx"
    cmd = [
        "pandoc",
        md_path,
        "-o", temp_docx,
        f"--reference-doc={ref_doc}"
    ]
    subprocess.run(cmd, check=True)

    # 3. Hậu xử lý định dạng chuẩn
    format_docx(temp_docx, temp_docx)

    # 4. Ghi đè file đích (xử lý trường hợp người dùng đang mở file trong Microsoft Word)
    try:
        if os.path.exists(docx_path):
            os.remove(docx_path)
        os.rename(temp_docx, docx_path)
        print(f"Export thanh cong: {docx_path}")
    except PermissionError:
        alt_path = docx_path.replace(".docx", "_new.docx")
        if os.path.exists(alt_path):
            os.remove(alt_path)
        os.rename(temp_docx, alt_path)
        print(f"[Luu y]: File '{docx_path}' dang duoc mo trong Word. Da luu ban moi tai '{alt_path}'.")

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        convert_md_to_docx(sys.argv[1], sys.argv[2])
    elif len(sys.argv) == 2:
        format_docx(sys.argv[1])
    else:
        print("Usage: python tools/export_docx.py <input.md> <output.docx>")
