
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
autoload -Uz compinit && compinit

# git loga/lg/sw/st/wt 는 ~/.gitconfig [alias] 로 이관 (git 자체 alias라 셸 무관하게 동작)
alias gitwtb='git worktree add -b $1 ../$2'
alias brewu="brew upgrade; brew cleanup"

cherrypick() {
  if [ -z "$1" ]; then
    echo "Please provide branch names(origin, target)"
    return 1
  fi
  local target_branch=$1
  local previous_branch=$(git branch --show-current)
  git stash
  git switch "$1"
  git cherry-pick $(git rev-list --max-count=1 "$previous_branch")
  git switch -
  git stash apply
  git stash drop
}

export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

export NPM_TOKEN=$(gh auth token)
export GITHUB_TOKEN=$(gh auth token)
export PS1="%1~ %# "
export DISABLE_NON_ESSENTIAL_MODEL_CALLS=1

# Claude Code 토큰 효율화 설정
export CLAUDE_CODE_EFFORT_LEVEL=high
export BASH_MAX_OUTPUT_LENGTH=10000
eval "$(mise activate zsh)"

# fzf 셸 통합 (Ctrl-R 히스토리 검색, Ctrl-T 파일 검색)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
