#!/usr/bin/env bash
# Raptus AG — Claude Code Statusline

input=$(cat)

RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
WHITE='\033[97m'
GRAY='\033[90m'

model=$(echo "$input"      | jq -r '.model.display_name // "?"')
effort=$(echo "$input"     | jq -r '.effort.level // ""')
cwd=$(echo "$input"        | jq -r '.workspace.current_dir // .cwd // ""')
folder=$(basename "$cwd")
cost=$(echo "$input"       | jq -r '.cost.total_cost_usd // 0')
dur_ms=$(echo "$input"     | jq -r '.cost.total_duration_ms // 0')
used_pct=$(echo "$input"   | jq -r '.context_window.used_percentage // 0')

# Rate limits (resets_at are Unix timestamps in seconds)
fh_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
fh_pct=$(echo "$input"    | jq -r '.rate_limits.five_hour.used_percentage // 0')
wk_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0')
wk_pct=$(echo "$input"    | jq -r '.rate_limits.seven_day.used_percentage // 0')

# Signed-in Claude account. Deliberately no OS-user fallback: the point of this
# segment is to show WHICH Claude account is active, and an OS name would look
# exactly like one. Unreadable account -> a yellow "?" that cannot be mistaken.
user=$(jq -r '.oauthAccount.emailAddress // .oauthAccount.displayName // empty' \
  "$HOME/.claude.json" 2>/dev/null)
user=${user%%@*}   # local part only
if [ -n "$user" ]; then
  user_color="$GRAY"
else
  user="?"
  user_color="$YELLOW"
fi

branch=""
if [ -n "$cwd" ]; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

dur_s=$((dur_ms / 1000))
if   [ "$dur_s" -ge 3600 ]; then dur_fmt="$(( dur_s / 3600 ))h $(( (dur_s % 3600) / 60 ))m"
elif [ "$dur_s" -ge 60 ];   then dur_fmt="$(( dur_s / 60 ))m $(( dur_s % 60 ))s"
else dur_fmt="${dur_s}s"
fi

cost_fmt=$(awk -v c="$cost" 'BEGIN { printf "$%.2f", c }')

# Percentages: at most one decimal, trailing ".0" dropped
fmt_pct() {
  awk -v p="$1" 'BEGIN { s = sprintf("%.1f", p); sub(/\.0$/, "", s); print s }'
}

filled=$(awk -v p="$used_pct" 'BEGIN { printf "%d", (p/100)*10 + 0.5 }')
empty=$(( 10 - filled ))
bar=""
for i in $(seq 1 "$filled"); do bar="${bar}█"; done
for i in $(seq 1 "$empty");  do bar="${bar}░"; done
# Kontextnutzung als Ganzzahl; fmt_pct bleibt fuer die Rate-Limits
pct_fmt=$(awk -v p="$used_pct" 'BEGIN { printf "%d", p + 0.5 }')

bar_color=$(awk -v p="$used_pct" -v g="$GREEN" -v y="$YELLOW" -v r="$RED" \
  'BEGIN { if (p < 60) print g; else if (p < 80) print y; else print r }')

# Format seconds-until-target as a compact countdown (e.g. 2h13m, 5d4h, 47m, now)
now=$(date +%s)
fmt_until() {
  local target=$1 rem d h m
  { [ -z "$target" ] || [ "$target" -le 0 ] 2>/dev/null; } && { echo "—"; return; }
  rem=$(( target - now ))
  if [ "$rem" -le 0 ]; then echo "now"; return; fi
  d=$(( rem / 86400 )); h=$(( (rem % 86400) / 3600 )); m=$(( (rem % 3600) / 60 ))
  if   [ "$d" -gt 0 ]; then echo "${d}d${h}h"
  elif [ "$h" -gt 0 ]; then echo "${h}h${m}m"
  else echo "${m}m"
  fi
}

# Color a rate-limit segment by its used_percentage
limit_color() {
  awk -v p="$1" -v g="$GREEN" -v y="$YELLOW" -v r="$RED" \
    'BEGIN { if (p < 60) print g; else if (p < 80) print y; else print r }'
}

fh_fmt=$(fmt_until "$fh_resets")
wk_fmt=$(fmt_until "$wk_resets")
fh_color=$(limit_color "$fh_pct")
wk_color=$(limit_color "$wk_pct")
fh_pct=$(fmt_pct "$fh_pct")
wk_pct=$(fmt_pct "$wk_pct")

# Spaces needed to push $2 to the right edge behind $1. Ignores ANSI escapes and
# counts wide glyphs (emoji) as two columns. Falls back to a plain gap.
# RIGHT_MARGIN: the status line is rendered in an area narrower than $COLUMNS;
# without this reserve the tail gets truncated with an ellipsis.
RIGHT_MARGIN=4
right_gap() {
  python3 - "$1" "$2" "${3:-80}" "$RIGHT_MARGIN" 2>/dev/null <<'PY'
import re, sys, unicodedata
def width(s):
    s = re.sub(r'\\033\[[0-9;]*m', '', s)
    w = 0
    for ch in s:
        if unicodedata.combining(ch):
            continue
        w += 2 if unicodedata.east_asian_width(ch) in ('W', 'F') else 1
    return w
left, right, cols, margin = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
gap = cols - width(left) - width(right) - margin
print(' ' * gap if gap >= 2 else '  ')
PY
}

SEP="${GRAY}  │  ${RESET}"

line1="${CYAN}${BOLD}[${model}]${RESET}"
if [ -n "$effort" ]; then
  line1+="${GRAY} ${RESET}${WHITE}${BOLD}⚡ ${effort}${RESET}"
fi
line1+="${GRAY}  ${RESET}${WHITE}📁 ${folder}${RESET}"
if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
  line1+="${SEP}${GREEN}🌿 ${branch}${RESET}"
fi

if [ -n "$user" ]; then
  cols=${COLUMNS:-0}
  if ! [ "$cols" -gt 0 ] 2>/dev/null; then cols=$(tput cols 2>/dev/null || echo 80); fi
  right="${user_color}👤 ${user}${RESET}"
  gap=$(right_gap "$line1" "$right" "$cols")
  [ -z "$gap" ] && gap="  "
  line1+="${gap}${right}"
fi

line2="${bar_color}${bar}${RESET} ${WHITE}${pct_fmt}%${RESET}"
line2+="${SEP}${YELLOW}${cost_fmt}${RESET}"
line2+="${SEP}${GRAY}⏱ ${dur_fmt}${RESET}"
line2+="${SEP}${fh_color}🔄 5h ${fh_pct}% → ${fh_fmt}${RESET}"
line2+="${SEP}${wk_color}📅 7d ${wk_pct}% → ${wk_fmt}${RESET}"

printf "%b\n%b\n" "$line1" "$line2"
