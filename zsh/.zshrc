
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
fi

[ -r ~/.job-stuff.zsh ] && source ~/.job-stuff.zsh

eval "$(starship init zsh)"
source <(fzf --zsh)

export CLICOLOR=1
export EDITOR=nvim
export TESTCONTAINERS_RYUK_DISABLED=true
export DOCKER_HOST=unix:///var/run/docker.sock
export KUBECONFIG="$HOME/.kube/config-aws.yaml:$HOME/.kube/config"
export K9S_CONFIG_DIR=~/.config/k9s

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH="$HOME/nvim-macos-arm64/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH" # cursor-agent

alias ps='ps -exo "pid,%cpu,%mem,command" | fzf --reverse --header-lines=1 --tmux 80% --multi --bind "enter:become(kill -9  {+1})"'
