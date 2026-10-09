
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
fi

[ -r ~/.job-stuff.zsh ] && source ~/.job-stuff.zsh

# Vim-style editing: Esc enters normal mode; v starts visual selection.
# Enable before fzf so its bindings are installed in the vi keymaps.
bindkey -v
KEYTIMEOUT=10 # Wait up to 100 ms for a key sequence after Esc.

# Word text objects are built in. Add quotes and matching brackets for
# change/delete/yank operators and visual selections (ci", viw, di(, va{).
autoload -Uz select-quoted select-bracketed
zle -N select-quoted
zle -N select-bracketed
() {
  local keymap key
  for keymap in viopp visual; do
    for key in {a,i}{\',\",\`}; do
      bindkey -M "$keymap" "$key" select-quoted
    done
    for key in {a,i}${(s..)^:-'()[]{}<>bB'}; do
      bindkey -M "$keymap" "$key" select-bracketed
    done
  done
}

# Initialize once per shell: repeated init wraps Starship's own keymap hook
# until it calls itself recursively. Keep the original prompt across reloads.
if (( ! ${+_dotfiles_starship_prompt} )); then
  eval "$(starship init zsh)"
  typeset -g _dotfiles_starship_prompt=$PROMPT
fi

# Repair the self-reference in terminals affected before the init guard existed.
if [[ ${__starship_preserved_zle_keymap_select:-} == starship_zle-keymap-select-wrapped ]]; then
  __starship_preserved_zle_keymap_select=starship_zle-keymap-select
fi

# Zsh's visual mode keeps the vicmd keymap. Watch the selection separately
# and use a Starship profile while it is active, preserving Starship's args.
typeset -g _dotfiles_starship_visual_prompt=${_dotfiles_starship_prompt/ prompt / prompt --profile visual }
typeset -gi _dotfiles_visual_active=0

_dotfiles_visual_prompt() {
  local -i visual_active=0
  [[ $KEYMAP == vicmd ]] && (( REGION_ACTIVE )) && visual_active=1
  if (( visual_active != _dotfiles_visual_active )); then
    _dotfiles_visual_active=$visual_active
    if (( visual_active )); then
      PROMPT=$_dotfiles_starship_visual_prompt
    else
      PROMPT=$_dotfiles_starship_prompt
    fi
    zle reset-prompt
  fi
  return 0
}

_dotfiles_reset_visual_prompt() {
  _dotfiles_visual_active=0
  PROMPT=$_dotfiles_starship_prompt
}

# Add hooks without replacing syntax-highlighting or other existing widgets.
autoload -Uz add-zle-hook-widget add-zsh-hook
add-zle-hook-widget line-pre-redraw _dotfiles_visual_prompt
add-zsh-hook precmd _dotfiles_reset_visual_prompt

export HISTFILE
export FZF_CTRL_R_OPTS="--tmux=center,50%,50% --layout=reverse --cycle --border=rounded"
export FZF_CTRL_T_OPTS="--tmux=center,80%,80% --layout=reverse --cycle --border=rounded --preview='bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null' --preview-window='right:60%:wrap' --prompt='Files> '"
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
export PATH="$HOME/.local/bin:$PATH" 

alias ps='ps-fzf'
alias wm='workmux'
eval "$(~/.local/bin/mise activate zsh)"
