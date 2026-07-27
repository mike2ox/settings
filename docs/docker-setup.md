# Docker 설정

Docker Desktop 은 `macos/Brewfile` (`cask "docker-desktop"`) 로 설치된다. 설치 후 최초 실행 시 아래 설정만 확인/조정하면 나머지는 기본값으로 충분하다.

> 구 `cask "docker"` 는 upstream 에서 `docker-desktop` 으로 리네임되었다. 예전 이름으로 두면 `brew bundle` 이 경고를 내므로 Brewfile 에서 새 이름을 쓴다.

## Apple Silicon: Rosetta 선행 설치

Apple Silicon(M 시리즈)에서는 Docker Desktop 이 x86/amd64 이미지 에뮬레이션을 위해 최초 실행 시 Rosetta 2 를 자동 설치하려 한다. 이때 가상화 프레임워크 경로로 실패하면 다음 에러가 뜬다.

```
installing Rosetta: Error Domain=VZErrorDomain Code=1 ... "Failed to install Rosetta."
```

Docker 를 실행하기 전에 Rosetta 를 수동으로 먼저 설치해 두면 이 에러를 피할 수 있다.

```bash
softwareupdate --install-rosetta --agree-to-license   # sudo 불필요, 약 300MB
# 확인
/usr/bin/arch -x86_64 /usr/bin/true && echo "Rosetta OK"
```

(설치 중 `Package Authoring Error: ... installKBytes` 경고가 보여도 무해하며, `finished successfully` 가 나오면 정상이다.)

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
