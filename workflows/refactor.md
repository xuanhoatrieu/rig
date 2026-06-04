---
description: 🔧 Tái cấu trúc code
extends: core/HARNESS.md
tools: rig, graphify
---

# /refactor — Code Cleanup

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. If `graphify-out/` exists:
   - `graphify query "<target symbol>"` → blast radius analysis
   - `graphify explain "<target>"` → understand dependencies
2. `rig query matrix` → check what has tests

## Work

### Refactor Rules

- **Never change behavior** — only structure.
- **Tests must pass** before AND after.
- **Small PRs** — one refactor concern at a time.
- Show BEFORE/AFTER for each change.

### Common Refactors

| Type | Action |
|---|---|
| Extract function | Long function → smaller functions |
| Remove duplication | Copy-paste → shared utility |
| Rename | Unclear names → descriptive names |
| Simplify | Nested if/else → early returns |
| Dead code | Remove unused functions/imports |
| Type safety | Any → specific types |

### Blast Radius Check

Before each refactor:
- List all files that import/call the target.
- Confirm changes won't break dependents.

## Post-work

```bash
graphify update .    # re-index if exists
rig trace --summary "Refactored: <what>" --outcome success --files-changed "<files>"
```

## Next Steps

```
1️⃣ Chạy test? → /verify
2️⃣ Code tiếp? → /code
3️⃣ Kiểm tra chất lượng? → /health
```
