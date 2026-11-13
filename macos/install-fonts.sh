#!/usr/bin/env bash
#
# install-fonts.sh — Homebrew cask 가 없는 폰트 설치
#
# Pravka: Iosevka 34.6 기반 PragmataPro 스타일 무료 폰트
#   - Nerd Font 글리프 패치본 제공
#   - CJK(한글) 지원 (Source Han Mono 폴백)
#   - https://github.com/sudosubin/pravka
#
# 사용법:  ./macos/install-fonts.sh
#
set -euo pipefail

REPO="sudosubin/pravka"
ASSET_PREFIX="PravkaNerdFontMono"   # Nerd Font 패치본. 순정은 "Pravka"
FONT_DIR="$HOME/Library/Fonts"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
err() { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

command -v curl >/dev/null || err "curl 이 필요합니다."
command -v unzip >/dev/null || err "unzip 이 필요합니다."

# 이미 설치되어 있으면 건너뛴다
if ls "$FONT_DIR"/Pravka*.ttf >/dev/null 2>&1; then
  log "Pravka 가 이미 설치되어 있습니다. 건너뜁니다."
  log "재설치하려면: rm $FONT_DIR/Pravka*"
  exit 0
fi

log "최신 릴리스 정보를 조회합니다..."
API_URL="https://api.github.com/repos/${REPO}/releases/latest"

# GITHUB_TOKEN 이 있으면 rate limit 회피에 사용
AUTH_ARGS=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  AUTH_ARGS=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

DOWNLOAD_URL=$(
  # bash 3.2 + set -u 에서 빈 배열 확장이 unbound 에러가 나지 않도록 ${arr[@]+...} 형태 사용
  curl -fsSL ${AUTH_ARGS[@]+"${AUTH_ARGS[@]}"} "$API_URL" \
    | grep -o "https://[^\"]*${ASSET_PREFIX}-[^\"]*\.zip" \
    | head -n1
) || err "릴리스 정보를 가져오지 못했습니다."

[ -n "$DOWNLOAD_URL" ] || err "${ASSET_PREFIX} 자산을 찾지 못했습니다. 릴리스 페이지를 확인하세요: https://github.com/${REPO}/releases"

log "다운로드: $(basename "$DOWNLOAD_URL")"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fSL --progress-bar -o "$TMP_DIR/font.zip" "$DOWNLOAD_URL" \
  || err "다운로드에 실패했습니다."

log "압축 해제 중..."
unzip -q "$TMP_DIR/font.zip" -d "$TMP_DIR/extracted"

mkdir -p "$FONT_DIR"

# zip 내부 구조가 바뀌어도 동작하도록 재귀 탐색
count=0
while IFS= read -r -d '' f; do
  cp "$f" "$FONT_DIR/"
  count=$((count + 1))
done < <(find "$TMP_DIR/extracted" -type f \( -name '*.ttf' -o -name '*.otf' \) -print0)

[ "$count" -gt 0 ] || err "압축 파일에서 폰트를 찾지 못했습니다."

log "완료: ${count}개 폰트 파일을 $FONT_DIR 에 설치했습니다."
log "터미널/에디터에서 'Pravka Nerd Font Mono' 를 선택하세요."
