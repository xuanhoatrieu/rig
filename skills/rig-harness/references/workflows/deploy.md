---
description: 🚀 Deploy production
extends: core/HARNESS.md
tools: rig, git
---

# /deploy — Production Deployment

> Đọc `core/HARNESS.md` trước. File này chỉ bổ sung logic đặc thù.
> Đọc `core/communication-style.md` cho quy tắc giao tiếp.

## Pre-work

1. `rig query matrix` → verify all critical stories have proof
2. `rig query stats` → check open blockers
3. Read `.brain/brain.json` → get infrastructure config

## Work

### 1. Pre-Deploy Checklist

- [ ] All tests pass (`/verify`)
- [ ] No critical security issues (`/health`)
- [ ] Environment variables set
- [ ] Database migrations ready (if any)
- [ ] Human confirmation received

### 2. Deploy Method Detection

Auto-detect from project:
- `docker-compose.yml` → Docker deploy
- `.github/workflows/` → GitHub Actions
- `Dockerfile` → Container build + push
- `vercel.json` → Vercel deploy
- Manual → Guide user through steps

### 3. Deploy Execution

Follow detected method. Always:
- Build production bundle first
- Run smoke test after deploy
- Verify health endpoint

### 4. Post-Deploy Verification

- Check app is accessible
- Run basic smoke tests
- Verify critical flows work

## Post-work

```bash
rig trace --summary "Deployed: <version/description>" --outcome success
rig session set --key "last_deploy" --value "<timestamp>"
```

## Next Steps

```
1️⃣ Có lỗi production? → /debug
2️⃣ Cần rollback? → git revert + redeploy
3️⃣ Xong? → /save-brain
```
