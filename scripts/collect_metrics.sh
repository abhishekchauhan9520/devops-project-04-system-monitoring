#!/usr/bin/env bash
set -euo pipefail

INTERVAL=1
COUNT=1
OUTPUT_FILE=""

usage() {
  cat <<'USAGE'
Usage: collect_metrics.sh [-i interval_seconds] [-c samples] [-o output_file]

Collects basic CPU, memory, load and disk metrics from Linux.
USAGE
}

while getopts ":i:c:o:h" opt; do
  case "$opt" in
    i) INTERVAL="$OPTARG" ;;
    c) COUNT="$OPTARG" ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    h) usage; exit 0 ;;
    :) echo "Missing argument for -$OPTARG" >&2; exit 2 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage >&2; exit 2 ;;
  esac
done

[[ "$INTERVAL" =~ ^[1-9][0-9]*$ ]] || { echo "Interval must be a positive integer" >&2; exit 2; }
[[ "$COUNT" =~ ^[1-9][0-9]*$ ]] || { echo "Count must be a positive integer" >&2; exit 2; }

collect() {
  local timestamp load1 mem_available_kb mem_total_kb mem_used_pct root_used_pct
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  read -r load1 _ < /proc/loadavg
  mem_total_kb="$(awk '/MemTotal:/ {print $2}' /proc/meminfo)"
  mem_available_kb="$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)"
  mem_used_pct="$(awk -v t="$mem_total_kb" -v a="$mem_available_kb" 'BEGIN {printf "%.2f", ((t-a)/t)*100}')"
  root_used_pct="$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')"
  printf 'timestamp=%s load_1m=%s memory_used_pct=%s root_disk_used_pct=%s\n' \
    "$timestamp" "$load1" "$mem_used_pct" "$root_used_pct"
}

if [[ -n "$OUTPUT_FILE" ]]; then
  mkdir -p "$(dirname "$OUTPUT_FILE")"
  : > "$OUTPUT_FILE"
fi

for ((n=1; n<=COUNT; n++)); do
  line="$(collect)"
  echo "$line"
  if [[ -n "$OUTPUT_FILE" ]]; then
    echo "$line" >> "$OUTPUT_FILE"
  fi
  if (( n < COUNT )); then
    sleep "$INTERVAL"
  fi
done
