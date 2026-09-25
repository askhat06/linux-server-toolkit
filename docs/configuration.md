# Configuration

## Git

Author identity is configured locally for this repository. Check with `git config --local --get user.name` and `git config --local --get user.email`. Keep credentials out of tracked files. GitHub authentication is separate from commit author identity.

`.gitattributes` keeps shell scripts and documentation in LF format. `.gitignore` excludes archives, logs and local environment files. Run scripts with `bash scripts/name.sh` so execution works on Windows-mounted directories as well as Linux filesystems.

## Runtime

Health check: first positional argument is the filesystem path (default `/`); second is an integer disk threshold from 0 to 100 (default 80). Usage strictly greater than the threshold returns a warning. Leading zeroes such as `08` are rejected.

Backup: first argument is an existing source directory; second is the backup destination. Use quotes around paths with spaces. Configuration is passed as arguments, not executed from an external config file. Archive permissions depend on the filesystem; Ubuntu's native filesystem supports mode 600.
