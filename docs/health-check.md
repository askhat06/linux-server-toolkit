# Health check

Run `bash scripts/health-check.sh / 80` to inspect the root filesystem, display memory in MiB and uptime, and warn if disk usage is greater than 80 percent.

The path and threshold are optional; defaults are `/` and `80`. A reading equal to the threshold is healthy. Exit codes: 0 healthy, 1 warning, 2 invalid input or inspection error. Failures of `df`, `uptime`, and `free` return 2 with a clear diagnostic instead of exposing an arbitrary utility exit code.

The tool only reads system information. It does not remove files, change services, or require root. Linux utilities required: Bash, GNU coreutils, awk, and procps (`free` and `uptime`).

Run `bash tests/test-health.sh`. Twelve cases use a temporary PATH to check disk boundaries, invalid arguments, failures of `df`, `uptime`, and `free`, and malformed disk output. The temporary directory is removed on exit.
