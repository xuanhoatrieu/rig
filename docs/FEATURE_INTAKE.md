# Feature Intake

Every implementation prompt enters the intake gate before code changes. A new
project spec also enters through this gate before it becomes product docs,
stories, or implementation work.

The human does not need to classify risk. The harness does.

## Intake Flow

```text
User prompt
    |
    v
Classify input type
    |
    v
Restate as work item
    |
    v
Find affected product docs and stories
    |
    v
Run risk checklist
    |
    v
Choose lane: tiny, normal, or high-risk
```

## Input Types

| Type | Use when | Typical artifact |
| --- | --- | --- |
| New spec | Turning a user-provided project spec into harness-ready docs | Product docs, candidate epics, decisions |
| Spec slice | Implementing selected behavior from an accepted spec | Story packet |
| Change request | Changing, fixing, or refining accepted behavior | Story packet or direct patch |
| New initiative | Adding a larger product area that needs multiple stories | Initiative notes plus story packets |
| Maintenance request | Changing technical, operational, or dependency behavior | Story packet, validation report, or decision |
| Harness improvement | Improving how humans and agents collaborate | Direct docs update or `rig backlog add` |

## Lanes

- **Tiny**: Sửa nhỏ, ít rủi ro. Patch trực tiếp, chạy quick checks.
- **Normal**: Story-sized. Tạo story packet từ `core/templates/story.md`, cập nhật ma trận với `rig story add/update`.
- **High-Risk**: Chạm bảo mật, dữ liệu, auth, public contract. Tạo story folder 4 files từ `core/templates/high-risk-story/`, ghi ADR với `rig decision add`.
