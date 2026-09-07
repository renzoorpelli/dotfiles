if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting
end

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx PAGER less

if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
else if type -q vim
    set -gx EDITOR vim
    set -gx VISUAL vim
end

if test -d /opt/homebrew/bin
    fish_add_path --prepend /opt/homebrew/bin /opt/homebrew/sbin
end
if test -d /usr/local/bin
    fish_add_path --prepend /usr/local/bin /usr/local/sbin
end
fish_add_path "$HOME/.lmstudio/bin"
fish_add_path "$HOME/.local/bin"
if test -d "$HOME/.docker/bin"
    fish_add_path "$HOME/.docker/bin"
end
if test -d "$HOME/.cargo/bin"
    fish_add_path "$HOME/.cargo/bin"
end
if test -d "$HOME/go/bin"
    fish_add_path "$HOME/go/bin"
end

if type -q starship
    starship init fish | source
end

if type -q direnv
    direnv hook fish | source
end

# uv: always use uv for Python package management
alias pip='uv pip'
alias pip3='uv pip'
set -gx UV_PYTHON_PREFERENCE only-managed

# Yazi: open a directory and keep the selected location on exit
function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Application shortcuts
alias o open
alias oo "open ."
if type -q codium
    alias cc "codium ."
end

# Git shortcuts
alias g git
alias ga "git add"
alias gaa "git add --all"
alias gcm "git commit -m"
alias gf "git fetch"
alias gfa "git fetch --all --tags --prune --jobs=10"
alias gl "git pull"
alias gp "git push"

# Navigation shortcuts
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias ...... "cd ../../../../.."
