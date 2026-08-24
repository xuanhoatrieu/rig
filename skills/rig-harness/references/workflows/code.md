---
description: 💻 Viết code theo spec
extends: core/HARNESS.md
tools: rig, graphify, git
---

# /code — Code Implementation

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. `rig query session` → current task context
2. `rig query matrix` → check existing proof status
3. If `graphify-out/` exists → query relevant symbols
4. Run `core/FEATURE_INTAKE.md` classification if not done:
   ```bash
   rig intake --type "<type>" --summary "<summary>" --lane <lane>
   ```
5. If lane ≥ normal → create/locate story:
   ```bash
   rig story add --id "US-XXX" --title "<title>" --lane <lane>
   rig story update --id "US-XXX" --status in-progress
   ```

## Work

### Quality Levels

| Level | Khi nào | Yêu cầu |
|-------|---------|---------|
| MVP | Prototype, test ý tưởng | Code chạy được, no tests |
| Production | Default cho mọi task | Code clean + unit tests |
| Enterprise | Team lớn, long-term | Full tests + docs + types |

### Code Rules

- Follow existing code patterns in the project.
- Minimal changes — only edit what was requested.
- Do NOT refactor unrelated code.
- Do NOT add features not requested.

### Auto-Test Loop

Sau khi code xong:
1. Chạy test/lint nếu project có.
2. Nếu fail → sửa (tối đa 3 lần).
3. Nếu vẫn fail → báo user, không loop vô hạn.

### Phase Checkpoint (cho task lớn)

Sau mỗi phase/milestone:
```bash
rig trace --summary "Phase N done: <what>" --outcome success --story "US-XXX"
```

Chỉ stage hoặc commit khi user đã cho phép rõ ràng. Không tự động chạy
`git add -A`, vì lệnh này có thể gom cả thay đổi không thuộc task.

## Post-work

1. Update story proof:
   ```bash
   rig story update --id "US-XXX" --status done --unit 1 --integration 0
   ```
2. Re-index nếu có Graphify:
   ```bash
   graphify update .
   ```
3. Record trace:
   ```bash
   rig trace --summary "<what was done>" --outcome success --story "US-XXX" --files-changed "<files>"
   ```

## Next Steps

```
1️⃣ Chạy thử? → /verify
2️⃣ Có lỗi? → /debug
3️⃣ Tiếp tục code? Nói cho em biết task tiếp
4️⃣ Xong rồi? → /save-brain
```
