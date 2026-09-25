# Linux Server Toolkit

Small Bash utilities for Linux server inspection and backup, developed for Assignment 2.

## Development

`main` contains stable, tested changes. Develop features on `feature/*` branches and documentation on `docs/*` branches. Open a pull request explaining what changed, why, and how it was tested. Resolve review comments before merging.

## Purpose and structure

The completed toolkit reports disk usage, memory and uptime, and creates recoverable backups of selected directories without changing system services or deleting source data.

```text
scripts/health-check.sh      System report and disk threshold warning
scripts/backup.sh            Archive one directory outside its source
tests/test-health.sh        Disk boundaries and invalid-input checks
tests/test-backup.sh        Restore round trip and failure checks
docs/                       Installation, configuration and operating guides
.github/                    Pull request template
```

## Quick start

After integrating the feature branches, use Ubuntu or another compatible Linux environment:

```bash
bash scripts/health-check.sh / 80
bash scripts/backup.sh /path/to/test-source /path/to/backups
bash tests/test-health.sh
bash tests/test-backup.sh
```

Health exits 0 for normal usage, 1 for a disk warning, and 2 for invalid input or an inspection failure. Backup prints the created archive path on success.

## Guides

- [Installation](docs/installation.md)
- [Configuration](docs/configuration.md)
- [Health check](docs/health-check.md)
- [Backup and restoration](docs/backup.md)
- [Testing](docs/testing.md)
- [Troubleshooting and repository investigation](docs/troubleshooting.md)
- [Contribution and review process](CONTRIBUTING.md)
- [Individual submission and self-review](docs/self-review.md)

## Branching strategy

Use `feature/*` for new functionality, `docs/*` for documentation, `fix/*` for repairs, and `lab/*` for intentional exercises. Develop separately, test, request review, resolve comments, then merge into `main`. Keep meaningful commits instead of collapsing the assignment's development history.

Demonstrate a conflict by editing the same setting in two branches. Explain which final value you choose and why. Demonstrate recovery by identifying a deliberately wrong commit after later development and using `git revert` to preserve history.
