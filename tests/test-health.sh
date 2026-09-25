#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir "$tmp/bin"
cat > "$tmp/bin/df" <<'MOCK'
#!/usr/bin/env bash
printf 'Filesystem 1024-blocks Used Available Capacity Mounted on\n'
printf 'testfs 100 85 15 85%% /\n'
MOCK
chmod +x "$tmp/bin/df"
expect_exit() {
  local expected=$1 actual=0
  shift
  "$@" > "$tmp/result" 2>&1 || actual=$?
  if [[ $actual != "$expected" ]]; then
    cat "$tmp/result"
    echo "Expected exit $expected, got $actual" >&2
    exit 1
  fi
}
export PATH="$tmp/bin:$PATH"
expect_exit 1 bash "$root/scripts/health-check.sh" / 80
grep -q WARNING "$tmp/result"
expect_exit 0 bash "$root/scripts/health-check.sh" / 85
expect_exit 0 bash "$root/scripts/health-check.sh" / 100
expect_exit 2 bash "$root/scripts/health-check.sh" / 101
expect_exit 2 bash "$root/scripts/health-check.sh" / 08
expect_exit 2 bash "$root/scripts/health-check.sh" "$tmp/missing" 80
expect_exit 2 bash "$root/scripts/health-check.sh" / 80 extra
expect_exit 0 bash "$root/scripts/health-check.sh" --help
printf '#!/usr/bin/env bash\nexit 9\n' > "$tmp/bin/uptime"
chmod +x "$tmp/bin/uptime"
expect_exit 2 bash "$root/scripts/health-check.sh" / 100
rm -- "$tmp/bin/uptime"
printf '#!/usr/bin/env bash\nexit 9\n' > "$tmp/bin/free"
chmod +x "$tmp/bin/free"
expect_exit 2 bash "$root/scripts/health-check.sh" / 100
rm -- "$tmp/bin/free"
printf '#!/usr/bin/env bash\nexit 9\n' > "$tmp/bin/df"
expect_exit 2 bash "$root/scripts/health-check.sh" / 100
printf '#!/usr/bin/env bash\necho malformed\n' > "$tmp/bin/df"
expect_exit 2 bash "$root/scripts/health-check.sh" / 100
echo 'PASS: 12 health-check cases, including inspection failures.'
