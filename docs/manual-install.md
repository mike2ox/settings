# 수동 설치 항목

Homebrew cask 로 자동화할 수 없어 직접 설치해야 하는 것들. `brew bundle` 이후에 처리한다.

## 개발 필수

| 항목 | 설치 경로 | 비고 |
|---|---|---|
| Xcode | App Store | 용량이 크므로 가장 먼저 시작해두기. 설치 후 `xcode-select --install` 로 Command Line Tools 확인 |

## 일반 앱

| 항목 | 설치 경로 | 비고 |
|---|---|---|
| KakaoTalk | App Store | cask 미제공 |

> App Store 앱을 자동화하려면 `mas` 를 설치하고 `mas list` 로 ID를 확인해 Brewfile 에 `mas "KakaoTalk", id: 869223134` 형태로 추가할 수 있다. 단 `mas` 는 App Store 로그인이 선행되어야 하므로 완전 무인 설치는 되지 않는다.

## 보안 & 자격증명

| 항목 | 설치 경로 | 비고 |
|---|---|---|
| 비밀번호 매니저 | App Store 또는 [1password.com](https://1password.com) | 로그인/동기화가 필요해 무인 설치 불가. 필요해진 시점에 직접 설치 |
| FileVault | 시스템 설정 → 개인정보 보호 및 보안 | `fdesetup status` 로 확인, 꺼져 있으면 `sudo fdesetup enable` (복구키 보관 필수) |
| Doppler | `macos/Brewfile` 로 CLI 는 자동 설치됨 | `doppler login` 으로 브라우저 인증 필요 (자동화 불가). 프로젝트 디렉터리에서 `doppler setup` 으로 project/config 연결 |

## 백업 & 동기화

| 항목 | 설치 경로 | 비고 |
|---|---|---|
| Time Machine | 시스템 설정 → 일반 → Time Machine | 백업용 외장 디스크를 연결한 뒤 수동으로 지정. `tmutil destinationinfo` 로 대상 확인 |
| iCloud Drive | 시스템 설정 → Apple 계정 | Apple 계정으로 로그인만 하면 기존 파일이 자동 동기화됨. `defaults read MobileMeAccounts` 로 로그인 여부 확인 |
| 기타 클라우드 동기화(Dropbox 등) | 필요 시 `brew install --cask dropbox` 등 | 이 컴퓨터에는 미사용. 필요해진 시점에 개별 설치 |

⚠️ 디스크 연결·Apple 계정 로그인이 선행되어야 하는 항목이라 완전 자동화는 불가능하다. 새 PC 세팅의 마지막 단계로 남겨두고 수동으로 진행한다.

## 업무용 보안 / 관공서 액세서리

회사 PC 한정 항목. 개발환경과 무관하며 **자동화 불가**하다. 해당 기관·서비스 사이트에 접속하면 설치 안내가 뜨는 방식이므로, 새 PC 세팅 시에는 **필요해진 시점에 설치**하는 것으로 충분하다.

| 항목 | 용도 |
|---|---|
| TouchEn nxKey | 키보드 보안 (금융/공공 사이트) |
| Veraport | 보안 프로그램 통합 설치 관리자 |
| UniSignCRSV3 | 공동인증서 서명 모듈 |
| CrossEX | 브라우저 보안 확장 |
| MaSafeViewer | 문서 뷰어 (보안 열람) |
| MDMBroker | 회사 기기 관리(MDM) 에이전트 |
| Chrome Remote Desktop Host | 원격 지원 |
| OpenVPN Connect | 사내망 VPN (필요 시 `brew install --cask openvpn-connect` 로 대체 가능) |

⚠️ 이 항목들은 시스템 확장·키보드 후킹을 사용하므로, 새 PC에서 개발 도구 세팅이 모두 끝난 뒤 마지막에 설치하는 것을 권장한다.
