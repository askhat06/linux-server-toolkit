# Troubleshooting

| Symptom | Investigation | Resolution |
| --- | --- | --- |
| WSL opens Docker Desktop | Run `wsl --list --verbose` in PowerShell | Start `wsl -d Ubuntu` |
| Shell reports CRLF errors | Inspect `git diff --check` and `.gitattributes` | Save the script with LF line endings |
| Health command exits 1 | Read reported usage and threshold | Investigate filesystem capacity; the command does not delete data |
| Health command exits 2 | Check path and threshold arguments | Use an existing path and an integer 0-100 |
| Backup rejects destination | Resolve source and destination with `realpath` | Choose a destination outside the source |
| Backup fails while reading | Read tar output and inspect free space and permissions | Use readable, stable input and a writable destination |
| Permission denied on direct execution | Inspect permissions and mount type | Run the script with `bash` |
| Git push is rejected | Inspect `git status`, `git remote -v`, and remote history | Authenticate or fetch and reconcile commits; do not force-push shared history |

## Investigating a regression

Start with `git status`, `git log --oneline --graph --all`, and `git diff`. Use `git log -p -- path`, `git show COMMIT`, and `git blame path` to connect the failing line with its change. For a larger history use `git bisect` with a deterministic test.

After identifying a bad commit, `git revert COMMIT` records an inverse change as a new commit. Review and retest the result. Later unrelated development remains in history. If the revert conflicts, resolve the intended final content and continue with `git revert --continue`.
