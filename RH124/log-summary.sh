#!/usr/bin/env bash
set -euo pipefail

#usage: ./log-summary.sh [path-to-log | -]
#default: var/log/syslog
file=${1:-/var/log}

#Read from stdin (-), a gzip file (.gz), or a regular file.

if [[ "$file" == "-" ]]; then 
awk_source="/dev/stdin"
exec awk '
BEGIN { ERR=0; WARN=0; INFO=0; }
{
line = tolower($0);
if (index(line,"error")) {ERR++; next}
if (index(line,"warning")) {WARN++; next}
if (index(line,"info")) {INFO++; next}
}
END { printf("{\"ERROR\": %d, \"WARNING\": %d, \"INFO\": %d}\n", ERR, WARN, INFO)}
' -
exit
0
fi
if [[ "${file: -3}" == ".gz" ]]; then
  if ! command -v zcat >/dev/null 2>&1; then
    echo "zcat required to read .gz files. Install 'gzip' package." >&2
    exit 2
  fi
  zcat "$file" | awk '
  BEGIN { ERR=0; WARN=0; INFO=0; }
  {
    line = tolower($0);
    if (index(line,"error")) { ERR++; next }
    if (index(line,"warning")) { WARN++; next }
    if (index(line,"info")) { INFO++; next }
  }
  END { printf("{\"ERROR\": %d, \"WARNING\": %d, \"INFO\": %d}\n", ERR, WARN, INFO) }
  '
  exit 0
fi

if [[ ! -r "$file" ]]; then
  echo "Error: cannot read file: $file" >&2
  exit 2
fi

awk '
BEGIN { ERR=0; WARN=0; INFO=0; }
{
  line = tolower($0);
  if (index(line,"error")) { ERR++; next }
  if (index(line,"warning")) { WARN++; next }
  if (index(line,"info")) { INFO++; next }
}
END { printf("{\"ERROR\": %d, \"WARNING\": %d, \"INFO\": %d}\n", ERR, WARN, INFO) }
' "$file"
