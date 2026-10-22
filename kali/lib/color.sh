# shellcheck shell=bash disable=SC2034
# Source me. Sets C_* color vars when stdout is a terminal (or COPYCAT_FORCE_COLOR=1),
# and leaves them empty when NO_COLOR is set or output is piped.
if [ -z "$NO_COLOR" ] && { [ -t 1 ] || [ -n "$COPYCAT_FORCE_COLOR" ]; }; then
  C_PINK=$'\e[38;5;213m'; C_CYAN=$'\e[38;5;51m';  C_BLUE=$'\e[38;5;33m'
  C_GRN=$'\e[38;5;82m';   C_YEL=$'\e[38;5;220m';  C_RED=$'\e[38;5;203m'
  C_BOLD=$'\e[1m';        C_DIM=$'\e[2m';         C_RST=$'\e[0m'
else
  C_PINK=; C_CYAN=; C_BLUE=; C_GRN=; C_YEL=; C_RED=; C_BOLD=; C_DIM=; C_RST=
fi

# lab_counts DONE_FILE: sets LAB_DONE / LAB_TOTAL from the dirs in ~/labs. A lab counts as done when
# it is in the progress file or its best graded score is 100 (same rule as copycat-labs).
lab_counts() {
  local d n db="$HOME/.copycat/progress.db" best
  LAB_TOTAL=0; LAB_DONE=0
  for d in "$HOME"/labs/*/; do
    [ -d "$d" ] || continue
    d=$(basename "$d"); n=${d%%-*}; best=''
    LAB_TOTAL=$((LAB_TOTAL + 1))
    case $n in *[!0-9]*|'') ;; *)
      if [ -f "$db" ] && command -v sqlite3 >/dev/null 2>&1; then
        best=$(sqlite3 "$db" "SELECT MAX(score) FROM results WHERE lab='$n'" 2>/dev/null)
      fi ;;
    esac
    if [ "$best" = 100 ] || grep -qx "$d" "$1" 2>/dev/null; then LAB_DONE=$((LAB_DONE + 1)); fi
  done
}

# draw_bar DONE TOTAL [WIDTH]: prints a block progress bar, no newline.
draw_bar() {
  local n=$1 total=$2 w=${3:-20} filled i s=''
  [ "$total" -gt 0 ] || total=1
  filled=$((n * w / total))
  for ((i = 0; i < w; i++)); do
    if [ "$i" -lt "$filled" ]; then s+='█'; else s+='░'; fi
  done
  printf '%s' "$s"
}
