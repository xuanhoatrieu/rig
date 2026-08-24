<!-- RIG_CODEX:BEGIN -->
## Rig Harness

- For repository engineering tasks, use `$rig-harness` when it is installed.
- Repository truth, accepted product policy, code, tests, CI, runtime evidence,
  and Git history outrank generic Harness guidance.
- Keep read-only requests read-only. Discovery does not authorize fixes or
  Harness-state writes.
- Use durable plans only for multi-session, coordinated, risky, or recoverable
  work. Keep bounded changes bounded.
- Validate behavior with executable or observable evidence appropriate to the
  change.
- Do not commit or push unless the user explicitly authorizes it.
<!-- RIG_CODEX:END -->
