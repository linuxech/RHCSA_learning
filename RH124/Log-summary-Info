2) What the script does (brief technical explanation)

set -euo pipefail — fail fast and avoid subtle bugs.

Accepts a filename argument; defaults to /var/log/syslog. Accepts - to read from stdin.

Supports gzipped logs (*.gz) via zcat. If zcat is missing it exits with a clear message.

Uses a single awk pass to count error, warning, info (case-insensitive via tolower).

The script checks for error first, then warning, then info. This prevents double counting a single line with multiple tokens and matches severity priority.

Prints one compact JSON object: {"ERROR": X, "WARNING": Y, "INFO": Z} — easy to parse by tooling or tests.

Opinion: single awk is the correct approach for this task — it is efficient and shows SRE thinking (single pass, deterministic behavior). Avoid running grep -c three times on the same large file during assessments.

3) Test it locally (quick reproducible test)

Create a small test log and run the script:

cat > test.log <<'EOF'
Sep 25 10:00:01 host app[1234]: INFO Starting service
Sep 25 10:01:02 host app[1234]: WARNING Disk usage at 85%
Sep 25 10:02:03 host app[1234]: ERROR Failed to connect to DB
Sep 25 10:03:04 host app[1234]: info Heartbeat OK
EOF

# run
./log_summary.sh test.log
# output should be:
# {"ERROR": 1, "WARNING": 1, "INFO": 2}


Optional unit check (add to tests/test_log_summary.sh):

#!/usr/bin/env bash
set -euo pipefail
out=$(../log_summary.sh test.log)
expected='{"ERROR": 1, "WARNING": 1, "INFO": 2}'
if [[ "$out" == "$expected" ]]; then
  echo "PASS"
  exit 0
else
  echo "FAIL: got=$out expected=$expected" >&2
  exit 1
fi

4) How to present this work (showing research & learning)

Commit history: commit often with messages that reveal the thought process:

git add log_summary.sh

git commit -m "feat: add single-pass awk log counter with gzip/stdin support"

git commit -m "test: add test.log and CI test script"

README.md: add a short section:

Problem statement

Approach (why awk, tradeoffs vs grep)

Commands to reproduce and test

Known limitations and next steps

Research notes (RESEARCH.md): list the resources you consulted (e.g., awk man, zcat docs, JSON formatting considerations) and the reason you picked the final approach — this demonstrates structured research.

Metrics: on a large sample, run time for both grep-based and awk-based approaches and include the results in RESEARCH.md to show data-driven decisions.

5) Suggested improvements (if you want to expand)

Output pretty JSON and validation via jq for CI. (Note: mention jq in README so reviewers can install it.)

Add CLI flags: --since, --level to filter by time range or single severity.

Add resource limits and a simple benchmark script to show performance on a ~1GB sample.

Convert to a tiny Python script if you need richer parsing (timestamps, structured logs). For the challenge, Bash/awk is usually preferred.
