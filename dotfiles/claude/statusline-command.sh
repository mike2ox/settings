#!/usr/bin/env bash
# Claude Code statusLine command
# Shows: 47%(260508 15:20) | 12% | kiwi-back

input=$(cat)

parts=()

# 1. Rate limit remaining with refresh time
five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five_used" ]; then
  five_remaining=$(printf '%.0f' "$(echo "100 - $five_used" | bc)")

  resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
  refresh_str=""
  if [ -n "$resets_at" ]; then
    kst_time=$(TZ='Asia/Seoul' date -r "$resets_at" '+%y%m%d %H:%M' 2>/dev/null)
    [ -n "$kst_time" ] && refresh_str="(${kst_time})"
  fi

  if [ "$five_remaining" -le 20 ]; then
    parts+=("$(printf '\033[31m%s%%%s\033[0m' "$five_remaining" "$refresh_str")")
  elif [ "$five_remaining" -le 50 ]; then
    parts+=("$(printf '\033[33m%s%%%s\033[0m' "$five_remaining" "$refresh_str")")
  else
    parts+=("$(printf '\033[32m%s%%%s\033[0m' "$five_remaining" "$refresh_str")")
  fi
fi

# 2. Context usage percentage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  if [ "$used_int" -ge 80 ]; then
    parts+=("$(printf '\033[31m%s%%\033[0m' "$used_int")")
  elif [ "$used_int" -ge 50 ]; then
    parts+=("$(printf '\033[33m%s%%\033[0m' "$used_int")")
  else
    parts+=("$(printf '\033[32m%s%%\033[0m' "$used_int")")
  fi
fi

# 3. Current directory name only (basename)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
dir_name=$(basename "$cwd")
parts+=("$(printf '\033[34m%s\033[0m' "$dir_name")")

# Join parts with separator
printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf ' | %s' "$part"
done
printf '\n'
