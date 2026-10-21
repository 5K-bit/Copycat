# shellcheck shell=bash disable=SC2034
# Source me from a grading script (grading/NN-name/check.sh). Usage:
#   . /usr/local/lib/copycat/grade.sh
#   grade_start 06 "FILE PERMISSIONS"
#   grade_section "File ownership"      # optional; groups the items below it
#   item "report.txt belongs to copycat" test "$(stat -c %U f)" = copycat
#   grade_finish                        # prints the report, saves the score, exits 0 only at 100
# Every item runs as the student and must be a plain command that exits 0 on success.
. /usr/local/lib/copycat/color.sh

GRADE_DB="${COPYCAT_DB:-$HOME/.copycat/progress.db}"
GRADE_LAB=""; GRADE_TITLE=""; GRADE_TOTAL=0; GRADE_PASS=0
GRADE_SECTION=""; GRADE_SECTION_OK=1; GRADE_SECTION_N=0
GRADE_RULE='━━━━━━━━━━━━━━━━━━━━━━━━'

grade_start() {
  GRADE_LAB=$1; GRADE_TITLE=$2
  printf '%sCOPYCAT TRAINING SYSTEM%s\n%s\n\n' "$C_BOLD" "$C_RST" "$GRADE_RULE"
  printf '%sLAB %s: %s%s\n\n' "$C_BOLD" "$GRADE_LAB" "$GRADE_TITLE" "$C_RST"
}

# Print the line for the section that just ended (dots up to a fixed column, then PASS/FAIL).
__grade_close_section() {
  [ -n "$GRADE_SECTION" ] || return 0
  local dots result col
  dots=$(printf '%*s' $((24 - ${#GRADE_SECTION})) '' | tr ' ' '.')
  if [ "$GRADE_SECTION_OK" = 1 ]; then result="${C_GRN}PASS${C_RST}"; else result="${C_RED}FAIL${C_RST}"; fi
  col=$GRADE_SECTION
  printf '%s %s %s\n' "$col" "$dots" "$result"
  GRADE_SECTION=""
}

grade_section() {
  __grade_close_section
  GRADE_SECTION=$1; GRADE_SECTION_OK=1; GRADE_SECTION_N=0
}

# item "what is being checked" command [args...]
item() {
  local label=$1; shift
  GRADE_TOTAL=$((GRADE_TOTAL + 1))
  if "$@" >/dev/null 2>&1; then
    GRADE_PASS=$((GRADE_PASS + 1))
  else
    GRADE_SECTION_OK=0
    GRADE_FAILED+=("$label")
  fi
  GRADE_SECTION_N=$((GRADE_SECTION_N + 1))
}
GRADE_FAILED=()

grade_save() {
  command -v sqlite3 >/dev/null 2>&1 || return 0
  mkdir -p "$(dirname "$GRADE_DB")" 2>/dev/null || return 0
  sqlite3 "$GRADE_DB" "
    CREATE TABLE IF NOT EXISTS results(
      id INTEGER PRIMARY KEY, lab TEXT NOT NULL, ts TEXT NOT NULL,
      score INTEGER NOT NULL, passed INTEGER NOT NULL, total INTEGER NOT NULL);
    INSERT INTO results(lab, ts, score, passed, total)
      VALUES('$GRADE_LAB', datetime('now'), $1, $GRADE_PASS, $GRADE_TOTAL);" 2>/dev/null || true
}

grade_finish() {
  __grade_close_section
  local score=0
  [ "$GRADE_TOTAL" -gt 0 ] && score=$(( (GRADE_PASS * 100 + GRADE_TOTAL / 2) / GRADE_TOTAL ))
  grade_save "$score"
  echo
  if [ "$score" -eq 100 ]; then
    printf 'RESULT: %sCOMPLETE%s\n' "$C_GRN" "$C_RST"
  else
    printf 'RESULT: %sNOT YET%s\n' "$C_YEL" "$C_RST"
    local f; for f in "${GRADE_FAILED[@]}"; do printf '  - %s\n' "$f"; done
  fi
  printf '\nScore: %s/100\n%s\n' "$score" "$GRADE_RULE"
  [ "$score" -eq 100 ]
}
