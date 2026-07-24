# settings

새 macOS 개발환경을 구축할 때 필요한 것들을 정리한 저장소.

## 빠른 시작

```bash
# 1. Homebrew 설치 (없다면)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 이 저장소 클론
git clone https://github.com/mike2ox/settings.git ~/settings && cd ~/settings

# 3. 패키지 일괄 설치
brew bundle --file=macos/Brewfile

# 4. 폰트 설치
./macos/install-fonts.sh

# 5. dotfiles 배치
mkdir -p ~/.config/ghostty
cp dotfiles/ghostty/config ~/.config/ghostty/config
```

## 구성

```
.
├── macos/
│   ├── Brewfile           # brew bundle 로 일괄 설치할 패키지 목록
│   └── install-fonts.sh   # cask 없는 폰트(Pravka) 설치
├── dotfiles/
│   └── ghostty/config     # 터미널 설정
└── docs/
    └── manual-install.md  # 자동화 불가 항목 (Xcode, 보안 프로그램 등)
```

## 체크리스트

새 PC 세팅 시 아래 순서로 진행한다.

- [ ] **1. OS 업데이트 & 시스템 설정** — 소프트웨어 업데이트, 트랙패드/키보드, Finder 확장자 표시
- [x] **2. 패키지 매니저** — Homebrew + [`macos/Brewfile`](macos/Brewfile)
- [x] **3. 터미널 & 셸** — Ghostty + Pravka Nerd Font ([설정](dotfiles/ghostty/config), [폰트 설치](macos/install-fonts.sh))
- [ ] **4. Git 설정** — user.name/email, alias, .gitignore_global
- [ ] **5. SSH / GPG 키** — 키 생성, GitHub 등록, 커밋 서명
- [ ] **6. 런타임 버전 매니저** — mise (node/python/java)
- [ ] **7. 에디터 / IDE** — VS Code, Zed, DataGrip 설정 동기화
- [ ] **8. AI 코딩 도구** — Claude Code, Codex 설정
- [ ] **9. 컨테이너 / 가상화** — Docker
- [ ] **10. dotfiles 관리** — 심볼릭 링크 또는 chezmoi
- [ ] **11. CLI 유틸리티** — fzf, ripgrep, bat, eza, jq 등
- [ ] **12. 생산성 앱** — Raycast, Rectangle, Obsidian
- [ ] **13. 보안 & 자격증명** — 비밀번호 매니저, Doppler, FileVault
- [ ] **14. 백업 & 동기화** — Time Machine, 클라우드 동기화

> 자동화할 수 없는 항목(Xcode, 관공서 보안 프로그램 등)은 [`docs/manual-install.md`](docs/manual-install.md) 참고.

## 참고

- 폰트 [Pravka](https://github.com/sudosubin/pravka) — Iosevka 기반 PragmataPro 스타일, Nerd Font 글리프 + 한글 지원
- Ghostty 설정은 `~/.config/ghostty/config` (XDG 경로)를 표준으로 사용한다.
  `~/Library/Application Support/com.mitchellh.ghostty/config` 에도 파일이 있으면
  **두 설정이 함께 적용되어 `font-family` 가 폴백으로 누적**되므로 한쪽만 유지할 것.
