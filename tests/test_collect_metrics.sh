#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/collect_metrics.sh"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

bash -n "$SCRIPT"
out="$("$SCRIPT" -c 1)"
[[ "$out" == timestamp=* ]]
[[ "$out" == *load_1m=* ]]
[[ "$out" == *memory_used_pct=* ]]
[[ "$out" == *root_disk_used_pct=* ]]

log="$TMP_DIR/metrics.log"
"$SCRIPT" -c 2 -i 1 -o "$log" >/dev/null
[[ "$(wc -l < "$log")" -eq 2 ]]

if "$SCRIPT" -i 0 >/dev/null 2>&1; then
  echo "Expected invalid interval to fail" >&2
  exit 1
fi

if "$SCRIPT" -c 0 >/dev/null 2>&1; then
  echo "Expected invalid count to fail" >&2
  exit 1
fi

printf 'All system monitoring tests passed.\n'
