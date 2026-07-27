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

mkdir -p ~/.config/mise
cp dotfiles/mise/config.toml ~/.config/mise/config.toml

# 6. mise 활성화 (셸 rc 파일에 추가, 이미 있다면 생략)
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
exec zsh

# 7. VS Code 설정 배치 + 확장 설치
cp dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
cp dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
./macos/install-vscode-extensions.sh

# 8. Claude Code / Codex 설정 배치
cp dotfiles/claude/settings.json ~/.claude/settings.json
cp dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
cp dotfiles/claude/RTK.md ~/.claude/RTK.md
cp dotfiles/claude/statusline-command.sh ~/.claude/statusline-command.sh

cp dotfiles/codex/AGENTS.md ~/.codex/AGENTS.md
cp dotfiles/codex/RTK.md ~/.codex/RTK.md
cp dotfiles/codex/hooks.json ~/.codex/hooks.json
cp dotfiles/codex/config.toml ~/.codex/config.toml
```

## 구성

```
.
├── macos/
│   ├── Brewfile                     # brew bundle 로 일괄 설치할 패키지 목록
│   ├── install-fonts.sh             # cask 없는 폰트(Pravka) 설치
│   └── install-vscode-extensions.sh # dotfiles/vscode/extensions.txt 일괄 설치
├── dotfiles/
│   ├── ghostty/config       # 터미널 설정
│   ├── mise/config.toml     # 전역 런타임 버전 (node/python/pnpm)
│   ├── vscode/
│   │   ├── settings.json    # 에디터 설정
│   │   ├── keybindings.json # 커스텀 키 바인딩
│   │   └── extensions.txt   # 설치 확장 목록
│   ├── claude/
│   │   ├── settings.json           # 모델/훅/상태줄 설정
│   │   ├── CLAUDE.md               # 전역 지침 (RTK.md 로드)
│   │   ├── RTK.md                  # rtk CLI 프록시 사용법
│   │   └── statusline-command.sh   # rate limit/컨텍스트 사용량 상태줄
│   └── codex/
│       ├── AGENTS.md    # 전역 지침 (RTK.md 로드)
│       ├── RTK.md        # rtk CLI 프록시 사용법 (Codex 용)
│       ├── hooks.json    # Bash PreToolUse 훅 (rtk 프록시)
│       └── config.toml   # 모델/추론강도/TUI 상태줄 설정 (발췌)
└── docs/
    ├── manual-install.md  # 자동화 불가 항목 (Xcode, 보안 프로그램 등)
    └── ssh-gpg-setup.md   # SSH 키 생성, GitHub 등록, 커밋 서명 절차
```

## 체크리스트

새 PC 세팅 시 아래 순서로 진행한다.

- [ ] **1. OS 업데이트 & 시스템 설정** — 소프트웨어 업데이트, 트랙패드/키보드, Finder 확장자 표시
- [x] **2. 패키지 매니저** — Homebrew + [`macos/Brewfile`](macos/Brewfile)
- [x] **3. 터미널 & 셸** — Ghostty + Pravka Nerd Font ([설정](dotfiles/ghostty/config), [폰트 설치](macos/install-fonts.sh))
- [x] **4. Git 설정** — user.name/email, alias, [.gitignore_global](dotfiles/git/.gitignore_global)
- [x] **5. SSH / GPG 키** — 키 생성, GitHub 등록, 커밋 서명 ([설정 절차](docs/ssh-gpg-setup.md))
- [x] **6. 런타임 버전 매니저** — mise ([전역 설정](dotfiles/mise/config.toml)), node/python/java 고정 버전은 brew 로 유지
- [x] **7. 에디터 / IDE** — VS Code 설정/키바인딩/확장 동기화 ([dotfiles/vscode](dotfiles/vscode))
- [x] **8. AI 코딩 도구** — Claude Code, Codex 설정 ([claude](dotfiles/claude), [codex](dotfiles/codex))
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
- `git st`/`git lg`/`git sw`/`git wt` 등은 `~/.gitconfig` alias로 이관했다(`dotfiles/git/.gitconfig`).
  `.zshrc`의 옛 `gitst` 류 shell alias는 제거했으며, `gitwtb`(함수형 로직 포함)와 `cherrypick`은
  Step 10에서 `.zshrc`를 dotfiles로 편입할 때 함께 옮긴다.
- 런타임 버전은 원칙적으로 `mise`(`dotfiles/mise/config.toml`)로 관리한다. `node@18`/`node@20`,
  `python@3.11`, `openjdk`/`openjdk@17` 처럼 프로젝트 전환 없이 전역 고정이 필요한 버전만
  `macos/Brewfile`에 별도로 유지한다.
- `dotfiles/vscode/settings.json`은 머신별 절대경로(`dart.flutterSdkPath` 등)를 제외하고 옮겼다.
  이런 항목이 필요해지면 새 머신의 실제 경로로 다시 설정할 것. `keybindings.json`은 VS Code가
  자동 생성하는 unbind 규칙을 빼고 실제로 의도한 커스텀 바인딩 3개만 남겼다.
- `rtk`(Rust Token Killer)는 모든 셸 명령을 가로채 토큰을 절약하는 CLI 프록시로, Claude Code
  와 Codex 양쪽에 훅으로 연결되어 있다(`macos/Brewfile`로 설치, `dotfiles/claude/RTK.md`·
  `dotfiles/codex/RTK.md`로 각 도구에 사용법을 안내). `CLAUDE.md`/`AGENTS.md`는 이 RTK.md 를
  `@RTK.md` 형태로 로드하는 진입점이다.
- `dotfiles/codex/config.toml`은 `~/.codex/config.toml` 전체가 아니라 발췌본이다.
  `[projects."경로"]` 신뢰 목록과 marketplace 캐시 경로처럼 머신·세션마다 자동 생성되는
  항목은 제외했다.
