# shellcheck shell=bash
# Sourced by the launchers. Coloured banner and step/result lines; plain when NO_COLOR is set or
# output is piped. Docker's own output is left visible so long first builds show progress.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  U_PINK=$'\e[38;5;213m'; U_GRN=$'\e[38;5;82m'; U_RED=$'\e[38;5;203m'
  U_DIM=$'\e[2m'; U_BOLD=$'\e[1m'; U_RST=$'\e[0m'
else
  U_PINK=; U_GRN=; U_RED=; U_DIM=; U_BOLD=; U_RST=
fi

# ui_banner: mascot (pink) and wordmark (cyan -> blue) from kali/motd.
ui_banner() {
  awk '
    NR>=2 && NR<=4  { printf "\033[38;5;213m%s\033[0m\n", $0; next }
    NR>=6 && NR<=11 { split("51 45 39 33 27 21", c, " "); printf "\033[38;5;%sm%s\033[0m\n", c[NR-5], $0 }
  ' kali/motd | if [ -n "$U_RST" ]; then cat; else sed 's/\x1b\[[0-9;]*m//g'; fi
}
ui_step() { printf '\n%s==>%s %s%s%s\n' "$U_PINK" "$U_RST" "$U_BOLD" "$1" "$U_RST"; }
ui_ok()   { printf '%s ok%s  %s\n' "$U_GRN" "$U_RST" "$1"; }
ui_fail() { printf '%sFAIL%s  %s\n' "$U_RED" "$U_RST" "$1" >&2; }
ui_info() { printf '%s%s%s\n' "$U_DIM" "$1" "$U_RST"; }

# ui_run LABEL CMD...: runs CMD, prints ok/FAIL, and returns CMD's exit status.
ui_run() {
  local label=$1 rc=0
  shift
  ui_step "$label"
  "$@" || rc=$?
  if [ "$rc" -eq 0 ]; then ui_ok "$label"; else ui_fail "$label (exit $rc)"; fi
  return "$rc"
}
