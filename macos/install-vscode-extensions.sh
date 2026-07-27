#!/usr/bin/env bash
#
# install-vscode-extensions.sh — dotfiles/vscode/extensions.txt 목록을 일괄 설치
#
# 사용법:  ./macos/install-vscode-extensions.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/../dotfiles/vscode/extensions.txt"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
err() { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

command -v code >/dev/null || err "'code' CLI 를 찾을 수 없습니다. VS Code 에서 Cmd+Shift+P > Shell Command: Install 'code' command in PATH 를 먼저 실행하세요."
[ -f "$EXTENSIONS_FILE" ] || err "$EXTENSIONS_FILE 을 찾을 수 없습니다."

installed="$(code --list-extensions)"
count=0

while IFS= read -r ext; do
  [ -n "$ext" ] || continue
  if grep -qxi "$ext" <<< "$installed"; then
    continue
  fi
  log "설치: $ext"
  code --install-extension "$ext" --force
  count=$((count + 1))
done < "$EXTENSIONS_FILE"

log "완료: ${count}개 확장을 새로 설치했습니다."
