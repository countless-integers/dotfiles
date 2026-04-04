#!/usr/bin/env bash
set -euo pipefail

# Defaults
PRUNE_EXIT=true
PRUNE_FREQ=true
EXIT_CODES=(1 2 126 127 128 130 137 139 143)
MIN_USES=2
DAYS=45
FORCE=false

usage() {
  cat <<EOF
Usage: atuin-prune.bash [OPTIONS]

Prune atuin history by exit code and/or usage frequency.
Runs in dry-run mode by default, showing what would be deleted and prompting
for confirmation before making any changes.

OPTIONS:
  --no-exit-code        Skip pruning by non-zero exit codes
  --no-frequency        Skip pruning by usage frequency
  --exit-codes CODES    Comma-separated exit codes to prune (default: ${EXIT_CODES[*]})
  --min-uses N          Minimum uses in the time window to keep (default: ${MIN_USES})
  --days N              Time window in days for frequency analysis (default: ${DAYS})
  -f, --force           Skip confirmation prompt, delete immediately
  -h, --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-exit-code)  PRUNE_EXIT=false; shift ;;
    --no-frequency)  PRUNE_FREQ=false; shift ;;
    --exit-codes)    IFS=',' read -ra EXIT_CODES <<< "$2"; shift 2 ;;
    --min-uses)      MIN_USES="$2"; shift 2 ;;
    --days)          DAYS="$2"; shift 2 ;;
    -f|--force)      FORCE=true; shift ;;
    -h|--help)       usage; exit 0 ;;
    *)               echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if ! command -v atuin &>/dev/null; then
  echo "Error: atuin not found" >&2
  exit 1
fi

if [[ "$PRUNE_EXIT" == false && "$PRUNE_FREQ" == false ]]; then
  echo "Nothing to do (both pruning modes disabled)."
  exit 0
fi

# --- Exit code pruning ---

exit_code_entries=()

collect_exit_code_entries() {
  echo "Scanning for commands with non-zero exit codes..."
  for code in "${EXIT_CODES[@]}"; do
    while IFS= read -r cmd; do
      [[ -n "$cmd" ]] && exit_code_entries+=("$code|$cmd")
    done < <(atuin search --cmd-only --exit "$code" 2>/dev/null)
  done
}

# --- Frequency pruning ---

declare -A freq_counts
rare_commands=()

collect_frequency_entries() {
  echo "Analyzing command frequency over the last ${DAYS} days..."
  local after_date
  if [[ "$(uname -s)" == "Darwin" ]]; then
    after_date=$(date -v-"${DAYS}"d +%Y-%m-%d)
  else
    after_date=$(date -d "${DAYS} days ago" +%Y-%m-%d)
  fi

  # Count occurrences of each unique command in the window
  while IFS= read -r cmd; do
    [[ -z "$cmd" ]] && continue
    freq_counts["$cmd"]=$(( ${freq_counts["$cmd"]:-0} + 1 ))
  done < <(atuin search --cmd-only --after "$after_date" --search-mode prefix --include-duplicates 2>/dev/null)

  for cmd in "${!freq_counts[@]}"; do
    if (( freq_counts["$cmd"] < MIN_USES )); then
      rare_commands+=("$cmd")
    fi
  done

  # Sort for stable output
  IFS=$'\n' rare_commands=($(sort <<< "${rare_commands[*]}")); unset IFS
}

# --- Collect ---

if [[ "$PRUNE_EXIT" == true ]]; then
  collect_exit_code_entries
fi

if [[ "$PRUNE_FREQ" == true ]]; then
  collect_frequency_entries
fi

# --- Report ---

exit_count=${#exit_code_entries[@]}
freq_count=${#rare_commands[@]}
total=$(( exit_count + freq_count ))

if (( total == 0 )); then
  echo "Nothing to prune."
  exit 0
fi

echo ""
echo "=== Dry Run Report ==="
echo ""

if [[ "$PRUNE_EXIT" == true && exit_count -gt 0 ]]; then
  echo "--- Non-zero exit code entries: ${exit_count} ---"
  declare -A exit_summary
  for entry in "${exit_code_entries[@]}"; do
    code="${entry%%|*}"
    exit_summary["$code"]=$(( ${exit_summary["$code"]:-0} + 1 ))
  done
  for code in $(printf '%s\n' "${!exit_summary[@]}" | sort -n); do
    echo "  exit ${code}: ${exit_summary[$code]} entries"
  done
  echo ""
fi

if [[ "$PRUNE_FREQ" == true && freq_count -gt 0 ]]; then
  echo "--- Rare commands (<${MIN_USES} uses in ${DAYS}d): ${freq_count} ---"
  for cmd in "${rare_commands[@]:0:10}"; do
    echo "  ${cmd}"
  done
  if (( freq_count > 10 )); then
    echo "  ... and $(( freq_count - 10 )) more"
  fi
  echo ""
fi

echo "Total entries to prune: ~${total}"
echo ""

# --- Confirm ---

if [[ "$FORCE" != true ]]; then
  while true; do
    read -rp "[y] delete  [n] abort  [e] show exit-code entries  [r] show rare commands: " answer
    case "$answer" in
      [Ee])
        if [[ "$PRUNE_EXIT" == true && exit_count -gt 0 ]]; then
          echo ""
          for entry in "${exit_code_entries[@]}"; do
            code="${entry%%|*}"
            cmd="${entry#*|}"
            printf "  [exit %s] %s\n" "$code" "$cmd"
          done | "${PAGER:-less}"
          echo ""
        else
          echo "  (no exit-code entries)"
        fi
        ;;
      [Rr])
        if [[ "$PRUNE_FREQ" == true && freq_count -gt 0 ]]; then
          echo ""
          printf '%s\n' "${rare_commands[@]}" | "${PAGER:-less}"
          echo ""
        else
          echo "  (no rare command entries)"
        fi
        ;;
      [Yy])
        break
        ;;
      [Nn]|"")
        echo "Aborted."
        exit 0
        ;;
      *)
        echo "  Invalid option."
        ;;
    esac
  done
fi

# --- Delete ---

deleted=0

if [[ "$PRUNE_EXIT" == true && exit_count -gt 0 ]]; then
  echo "Deleting entries with non-zero exit codes..."
  for code in "${EXIT_CODES[@]}"; do
    count=$( (atuin search --cmd-only --exit "$code" "" 2>/dev/null || true) | wc -l | tr -d ' ')
    if (( count > 0 )); then
      atuin search --exit "$code" --delete "" 2>/dev/null
      deleted=$(( deleted + count ))
      echo "  exit ${code}: ${count} deleted"
    fi
  done
fi

if [[ "$PRUNE_FREQ" == true && freq_count -gt 0 ]]; then
  echo "Deleting rare commands from the last ${DAYS} days..."
  local_after_date=""
  if [[ "$(uname -s)" == "Darwin" ]]; then
    local_after_date=$(date -v-"${DAYS}"d +%Y-%m-%d)
  else
    local_after_date=$(date -d "${DAYS} days ago" +%Y-%m-%d)
  fi

  for cmd in "${rare_commands[@]}"; do
    # Use prefix search with the full command to match exact entries
    count=$( (atuin search --cmd-only --after "$local_after_date" --search-mode prefix "$cmd" 2>/dev/null || true) | grep -cxF "$cmd" || true)
    if (( count > 0 )); then
      atuin search --after "$local_after_date" --search-mode prefix --delete "$cmd" 2>/dev/null
      deleted=$(( deleted + count ))
    fi
  done
  echo "  ${freq_count} rare commands deleted"
fi

echo ""
echo "Done. ${deleted} entries pruned."
