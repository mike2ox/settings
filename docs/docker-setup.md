# Docker 설정

Docker Desktop 은 `macos/Brewfile` (`cask "docker"`) 로 설치된다. 설치 후 최초 실행 시 아래 설정만 확인/조정하면 나머지는 기본값으로 충분하다.

## 확인 절차

Docker Desktop 실행 → Settings 에서:

1. **General**
   - Start Docker Desktop when you log in: 끔 (`autoStart: false`) — 필요할 때만 수동 실행
2. **Resources → Advanced**
   - CPUs / Memory: 머신 사양에 맞춰 조정 (전체의 절반 정도가 기본 권장치)
3. **Resources → File Sharing**
   - 기본 공유 목록에 `/Users`, `/Volumes`, `/private`, `/tmp`, `/var/folders` 포함되어 있는지 확인
4. **General → Choose file sharing implementation**
   - VirtioFS 대신 기본 gRPC FUSE 사용 중이면 그대로 유지 (프로젝트에서 별도 이슈 없었음)

## 확인 명령

```bash
docker --version
docker compose version
docker context ls   # desktop-linux 가 currentContext 인지 확인
```

## credential helper

Docker Desktop 설치 시 `~/.docker/config.json`에 `"credsStore": "desktop"`이 자동 설정된다. 별도 조치 불필요.
