#!/usr/bin/env bash
#
# macos-defaults.sh — 새 PC 기본 시스템 설정 적용 (Step 1)
#
# `defaults write` 로 자동화 가능한 항목만 적용한다. 실행하면 이 머신의
# 실제 시스템 설정이 바뀌므로, 값을 확인한 뒤 실행할 것.
#
# 적용 범위 (넣은 이유는 README '참고' 참조):
#   - 키보드: 빠른 키 반복
#   - Finder: 확장자 표시, 기본 리스트뷰, 검색은 현재 폴더 기준
#
# 소프트웨어 업데이트, 트랙패드 tap-to-click 등 GUI/재부팅/sudo 가 필요한
# 항목은 자동화하지 않는다 (아래 '수동 항목' 주석 참조).
#
# 사용법:  ./macos/macos-defaults.sh
#
set -euo pipefail

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

[ "$(uname)" = "Darwin" ] || { printf 'macOS 전용 스크립트입니다.\n' >&2; exit 1; }

log "키보드: 빠른 키 반복 설정"
# 키 반복 속도(작을수록 빠름). macOS 슬라이더 최소보다 더 빠른 값 허용
defaults write NSGlobalDomain KeyRepeat -int 2
# 반복 시작까지 지연(작을수록 짧음)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# 키를 누르고 있을 때 악센트 팝오버 대신 문자 반복이 동작하도록
defaults write NSGlobalDomain ApplePressAndHold -bool false

log "Finder: 모든 파일 확장자 표시"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

log "Finder: 새 창 기본 리스트 뷰"
# Nlsv=리스트, icnv=아이콘, clmv=컬럼, glyv=갤러리
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

log "Finder: 검색 범위를 현재 폴더로"
# SCcf=현재 폴더, SCsp=이전 검색 범위, SCev=이 Mac 전체
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

log "변경 사항 반영을 위해 Finder 를 재시작합니다"
killall Finder 2>/dev/null || true

log "완료. 일부 설정은 로그아웃/재로그인 후 완전히 반영됩니다."

# ── 수동 항목 (자동화하지 않음) ────────────────────────────
# - 소프트웨어 업데이트: 시스템 설정 > 일반 > 소프트웨어 업데이트에서 최신화
#   (CLI: sudo softwareupdate -ia  — sudo/재부팅 필요)
# - 트랙패드/키보드 세부(추적 속도, tap-to-click 등): 시스템 설정 GUI
# - Finder 확장자 표시 관련 개별 앱 경고는 그대로 둔다
