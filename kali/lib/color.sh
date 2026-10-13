# Source me. Sets C_* color vars when stdout is a terminal (or COPYCAT_FORCE_COLOR=1),
# and leaves them empty when NO_COLOR is set or output is piped.
if [ -z "$NO_COLOR" ] && { [ -t 1 ] || [ -n "$COPYCAT_FORCE_COLOR" ]; }; then
  C_PINK=$'\e[38;5;213m'; C_CYAN=$'\e[38;5;51m';  C_BLUE=$'\e[38;5;33m'
  C_GRN=$'\e[38;5;82m';   C_YEL=$'\e[38;5;220m';  C_RED=$'\e[38;5;203m'
  C_BOLD=$'\e[1m';        C_DIM=$'\e[2m';         C_RST=$'\e[0m'
else
  C_PINK=; C_CYAN=; C_BLUE=; C_GRN=; C_YEL=; C_RED=; C_BOLD=; C_DIM=; C_RST=
fi
