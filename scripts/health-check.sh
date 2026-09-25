#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo 'Usage: bash scripts/health-check.sh [PATH] [DISK_THRESHOLD_PERCENT]'
  echo 'Exit codes: 0 healthy, 1 disk warning, 2 invalid input or inspection failure.'
}

if [[ ${1:-} == --help ]]; then usage; exit 0; fi
if (( $# > 2 )); then usage >&2; exit 2; fi
target=${1:-/}
threshold=${2:-90}
if [[ ! $threshold =~ ^(0|[1-9][0-9]?|100)$ ]]; then
  echo 'Threshold must be an integer from 0 to 100.' >&2
  exit 2
fi
if [[ ! -e $target ]]; then echo 'Target does not exist.' >&2; exit 2; fi
if ! disk_report=$(LC_ALL=C df -P -- "$target"); then
  echo 'Cannot inspect filesystem.' >&2
  exit 2
fi
used=$(awk 'NR == 2 {gsub(/%/, "", $5); print $5}' <<< "$disk_report")
if [[ ! $used =~ ^[0-9]+$ ]]; then echo 'Invalid disk report.' >&2; exit 2; fi
printf 'Disk used: %s%% | threshold: %s%%\n' "$used" "$threshold"
printf 'Uptime: '
uptime -p
free -m
if (( 10#$used > threshold )); then
  echo 'WARNING: disk usage exceeds threshold.'
  exit 1
fi
echo 'OK: disk usage is within threshold.'
