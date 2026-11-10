# Zsh configuration (managed by dotfiles; synced to ~/.zshrc by sync.sh)
# Ported from the former fish config.

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS

# Fish-like behavior: typing a directory changes into it
setopt AUTO_CD

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PAGER=less

# Editor
if (( $+commands[nvim] )); then
  export EDITOR=nvim
  export VISUAL=nvim
elif (( $+commands[vim] )); then
  export EDITOR=vim
  export VISUAL=vim
fi

# Path (deduplicated)
typeset -U path PATH
for dir in /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/sbin; do
  [[ -d "$dir" ]] && path=("$dir" $path)
done
path=("$HOME/.lmstudio/bin" "$HOME/.local/bin" $path)
[[ -d "$HOME/.docker/bin" ]] && path+=("$HOME/.docker/bin")
[[ -d "$HOME/.cargo/bin" ]] && path+=("$HOME/.cargo/bin")
[[ -d "$HOME/go/bin" ]] && path+=("$HOME/go/bin")

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Prompt: oh-my-zsh's robbyrussell theme, reimplemented natively
# (colored arrow, cyan pwd, blue git:(red branch) + yellow ✗ when dirty)
__rr_git_prompt() {
  local branch
  branch="$(git branch --show-current 2>/dev/null)" || return
  [[ -z "$branch" ]] && branch="$(git rev-parse --short HEAD 2>/dev/null)" || true
  local dirty=""
  git status --porcelain 2>/dev/null | grep -q . && dirty=" ✗"
  print -r -- " %F{blue}git:(%F{red}${branch}%F{blue})%F{yellow}${dirty}%f"
}
precmd() { GIT_PROMPT="$(__rr_git_prompt)" }
setopt PROMPT_SUBST
PROMPT=' %(?.%F{green}.%F{red})➜%f %F{cyan}%1~%f${GIT_PROMPT} '

# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# uv/deno environment files created by their installers
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
[[ -f "$HOME/.deno/env" ]] && . "$HOME/.deno/env"

# uv: always use uv for Python package management
alias pip='uv pip'
alias pip3='uv pip'
export UV_PYTHON_PREFERENCE=only-managed

# Yazi: open a directory and keep the selected location on exit
yy() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return 1
  yazi "$@" --cwd-file="$tmp"
  if [[ -f "$tmp" ]] && cwd="$(command cat -- "$tmp")"; then
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
  fi
  rm -f -- "$tmp"
}

# Application shortcuts
alias o=open
alias oo="open ."
(( $+commands[codium] )) && alias cc="codium ."
(( $+commands[neovide] )) && alias v="neovide --fork --reuse-instance ."

# Git shortcuts
alias g=git
alias ga="git add"
alias gaa="git add --all"
alias gcm="git commit -m"
alias gf="git fetch"
alias gfa="git fetch --all --tags --prune --jobs=10"
alias gl="git pull"
alias gp="git push"

# Navigation shortcuts
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# fzf key bindings and completion (no fzf-tab)
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# zsh-autosuggestions (fish-like suggestions)
[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Machine-local, untracked overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
