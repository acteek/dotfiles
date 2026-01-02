
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
  alias nvim="$HOME/nvim-macos-arm64/bin/nvim"
  export EDITOR="$HOME/nvim-macos-arm64/bin/nvim"
fi

[ -r ~/.job-stuff.zsh ] && source ~/.job-stuff.zsh

eval "$(starship init zsh)"
source <(fzf --zsh)

export TESTCONTAINERS_RYUK_DISABLED=true
export DOCKER_HOST=unix:///var/run/docker.sock
export KUBECONFIG=~/.kube/config-aws.yaml
export K9S_CONFIG_DIR=~/.config/k9s

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

