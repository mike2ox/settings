# SSH / GPG 키 설정

새 PC에서 GitHub 접속용 SSH 키와 커밋 서명을 설정하는 절차. 키 자체는 머신마다 새로 생성해야 하므로 파일을 복사하지 않고 아래 명령을 그대로 실행한다.

## 1. SSH 키 생성

```bash
ssh-keygen -t ed25519 -C "firefinger07@gmail.com"
# 저장 경로는 기본값(~/.ssh/id_ed25519) 그대로 Enter
```

`ssh-agent`에 등록하고 재부팅 후에도 유지되도록 `~/.ssh/config`에 추가한다.

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

`~/.ssh/config`:

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

## 2. GitHub에 공개키 등록

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

GitHub → Settings → **SSH and GPG keys** → New SSH key → Key type: `Authentication Key` → 복사한 값 붙여넣기.

확인:

```bash
ssh -T git@github.com
# Hi mike2ox! You've successfully authenticated...
```

## 3. 커밋 서명 (SSH 키 방식)

별도 GPG 키 없이, 1번에서 만든 SSH 키를 그대로 커밋 서명에 사용한다 (git 2.34+).

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

로컬에서 서명을 검증하려면(선택) `allowed_signers` 파일을 만든다.

```bash
echo "firefinger07@gmail.com $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

## 4. GitHub에 서명 검증용 공개키 등록

1번과 같은 공개키를 GitHub에 **한 번 더** 등록한다. 이번엔 Key type을 `Signing Key`로 선택한다.

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

GitHub → Settings → SSH and GPG keys → New SSH key → Key type: `Signing Key` → 붙여넣기.

## 5. 확인

```bash
git commit --allow-empty -m "test: signed commit"
git log --show-signature -1
```

GitHub에 push한 뒤 커밋에 **Verified** 배지가 표시되면 완료.

> GPG 키(`gpg --full-generate-key`)를 별도로 쓰고 싶다면 `commit.gpgsign`/`user.signingkey` 값만 GPG 키 ID로 바꾸면 된다. 이 저장소는 GPG 키를 따로 관리하지 않고 SSH 키 하나로 인증과 서명을 겸하는 방식을 기본으로 한다.
