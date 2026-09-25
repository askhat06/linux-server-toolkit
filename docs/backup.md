# Backup and restore

Run `bash scripts/backup.sh /path/to/source /path/to/backups`. The output is the absolute path to a new gzip-compressed tar archive. Both arguments are required. The source must exist; the destination is created if necessary and must be outside the source, including after resolving symlinks.

The script never deletes source files or existing backups. Archive names include a UTC timestamp and a random suffix. On Linux filesystems archives are created with mode 600. Windows-mounted filesystems may apply Windows permissions instead. Symlinks are archived without following targets. A failed archive is removed; the original data remains untouched.

To inspect: `tar -tzf /path/to/archive.tar.gz`.
To restore a trusted archive: create a separate empty directory with `mkdir restored`, then run `tar -xzf /path/to/archive.tar.gz -C restored`. Compare the restored files before using them.

Exit 2 indicates invalid arguments. Other nonzero exits indicate a filesystem or archiver error. Run `bash tests/test-backup.sh` to check a restore round trip, special filenames, permissions, repeat backups, invalid destinations, and cleanup after an archiver failure.

Limitations: files changing during backup can cause tar to fail; this is not an atomic snapshot. Archives are not encrypted. Use a stable source directory and a destination with sufficient space. There is no automated retention, scheduling, or off-site replication.
