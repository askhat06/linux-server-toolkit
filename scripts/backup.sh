#!/usr/bin/env bash
set -euo pipefail
umask 077
if [[ ${1:-} == --help ]]; then
  echo 'Usage: bash scripts/backup.sh SOURCE_DIRECTORY DESTINATION_DIRECTORY'
  exit 0
fi
if (( $# != 2 )); then echo 'Expected source and destination directories.' >&2; exit 2; fi
if [[ ! -d $1 ]]; then echo 'Source must be an existing directory.' >&2; exit 2; fi
source_dir=$(realpath -- "$1")
dest_dir=$(realpath -m -- "$2")
if [[ $source_dir == / || $dest_dir == "$source_dir" || $dest_dir == "$source_dir/"* ]]; then
  echo 'Destination must be outside the source directory.' >&2
  exit 2
fi
mkdir -p -- "$dest_dir"
archive=$(mktemp -- "$dest_dir/backup-$(date -u +%Y%m%dT%H%M%SZ)-XXXXXX.tar.gz")
complete=false
trap 'if [[ $complete == false ]]; then rm -f -- "$archive"; fi' EXIT
# Ignore inherited tar options; symlinks are stored without following them.
TAR_OPTIONS= tar -czf "$archive" -C "$source_dir" -- .
complete=true
printf '%s\n' "$archive"
