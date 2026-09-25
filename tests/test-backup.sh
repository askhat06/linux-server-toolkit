#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/source folder/sub" "$tmp/restored"
printf 'important data\n' > "$tmp/source folder/sub/file with spaces.txt"
printf 'hidden\n' > "$tmp/source folder/.hidden"
ln -s .hidden "$tmp/source folder/link"
archive=$(bash "$root/scripts/backup.sh" "$tmp/source folder" "$tmp/backup folder")
test -s "$archive"
tar -xzf "$archive" -C "$tmp/restored"
diff -r -- "$tmp/source folder" "$tmp/restored"
test -L "$tmp/restored/link"
test "$(stat -c %a "$archive")" = 600
second=$(bash "$root/scripts/backup.sh" "$tmp/source folder" "$tmp/backup folder")
test "$archive" != "$second"
expect_invalid() {
  local actual=0
  bash "$root/scripts/backup.sh" "$@" > "$tmp/result" 2>&1 || actual=$?
  [[ $actual == 2 ]] || { cat "$tmp/result"; echo "Expected 2, got $actual"; exit 1; }
}
expect_invalid "$tmp/missing" "$tmp/out"
expect_invalid "$tmp/source folder" "$tmp/source folder/nested"
expect_invalid "$tmp/source folder" "$tmp/source folder"
expect_invalid
ln -s "$tmp/source folder" "$tmp/alias"
expect_invalid "$tmp/source folder" "$tmp/alias/nested"
# Simulate archiver failure and verify that no partial archive remains.
mkdir "$tmp/bin" "$tmp/failed"
printf '#!/usr/bin/env bash\nexit 9\n' > "$tmp/bin/tar"
chmod +x "$tmp/bin/tar"
actual=0
PATH="$tmp/bin:$PATH" bash "$root/scripts/backup.sh" "$tmp/source folder" "$tmp/failed" || actual=$?
test "$actual" = 9
test -z "$(find "$tmp/failed" -type f -print -quit)"
echo 'PASS: restore, spaces, hidden files, symlinks, permissions, unique names, 5 invalid-input cases and failure cleanup.'
