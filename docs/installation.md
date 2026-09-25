# Installation

## Environment

Use Ubuntu in WSL 2 or a Linux machine with Bash, Git, GNU coreutils, tar, gzip, awk, and procps. On Windows start the intended distribution explicitly: `wsl -d Ubuntu`.

Check prerequisites:

```bash
git --version
bash --version
tar --version
command -v df free uptime awk realpath mktemp gzip
```

Clone the GitHub URL shown on this project's repository page once it has been published, then enter the resulting directory. The project requires no package installation or root permissions when the listed commands are already available.

```bash
bash tests/test-health.sh
bash tests/test-backup.sh
bash scripts/health-check.sh / 80
```

For a safe backup demo, create a test source directory and a separate backup destination. Never use live production data for the assignment.
