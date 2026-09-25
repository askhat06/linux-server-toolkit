# Testing

From the repository root after the feature branches are integrated:

```bash
bash -n scripts/health-check.sh scripts/backup.sh tests/test-health.sh tests/test-backup.sh
bash tests/test-health.sh
bash tests/test-backup.sh
git diff --check
```

Health tests use a deterministic 85-percent disk fixture to verify warning boundaries and invalid input. A real WSL run checks integration with `df`, `free`, and `uptime`.

Backup tests create disposable fixtures under `/tmp`, archive and restore them, compare contents, check hidden files and symlinks, verify private Linux permissions and distinct archive names, reject invalid destinations, and simulate archiver failure. No personal files are used.

A successful test command exits 0 and prints PASS. Do not merge a change if a relevant test fails. After review fixes and conflict resolution, run the tests again.
