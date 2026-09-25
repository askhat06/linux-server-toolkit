# Health check

Run `bash scripts/health-check.sh / 80` to inspect the root filesystem, display memory in MiB and uptime, and warn if disk usage is greater than 80 percent.

The path and threshold are optional; defaults are `/` and `80`. A reading equal to the threshold is healthy. Exit codes: 0 healthy, 1 warning, 2 invalid input or disk inspection error. Unexpected failures of system utilities also terminate the script with a nonzero status.

The tool only reads system information. It does not remove files, change services, or require root. Linux utilities required: Bash, GNU coreutils, awk, and procps (`free` and `uptime`).

Run `bash tests/test-health.sh`. Tests replace only `df` with a controlled fixture in a temporary PATH and check boundaries and invalid arguments. The temporary directory is removed on exit.
