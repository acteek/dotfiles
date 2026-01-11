
#!/usr/bin/env bash

DIR="$HOME/develop/IVA"

# for tests
tmux kill-server 2>/dev/null

# Create home session if not exist 
if tmux has-session -t "home" 2>/dev/null; then
  echo "Session home already exists. Skipping..."
else
  tmux new-session -d -s "home" -x- -y- -n "zsh" -c "$HOME"
  tmux new-window -t "home" -n "dotfiles" -c "$HOME/dotfiles"
  tmux split-window -t "home:zsh" -h -c "$HOME"
  tmux split-window -t "home:zsh" -v -c "$HOME"  
  tmux resize-pane -t "home:zsh.1" -R 50
  tmux resize-pane -t "home:zsh.2" -U 10

  tmux send-keys -t "home:dotfiles.1" nvim Enter 0
  tmux clock-mode -t "home:zsh.2"
  
  tmux select-window -t "home:zsh"
  tmux select-pane -t "home:zsh.1"
fi

# Create sessions for projects
for PROJECT in $(ls $DIR); do
  if tmux has-session -t "$PROJECT" 2>/dev/null; then
    echo "Session $PROJECT already exists. Skipping..."
    continue
  fi
  echo "Creating session for project: $PROJECT"
  tmux new-session -d -s "$PROJECT" -x- -y- -n "nvim" -c "$DIR/$PROJECT" 
  tmux new-window -t "$PROJECT" -n "zsh" -c "$DIR/$PROJECT"

  tmux split-window -t "$PROJECT:nvim" -h -c "$DIR/$PROJECT"
  tmux split-window -t "$PROJECT:nvim" -v -c "$DIR/$PROJECT"
  tmux resize-pane -t "$PROJECT:nvim.1" -R 50
  tmux resize-pane -t "$PROJECT:nvim.2" -U 10

  tmux send-keys -t "$PROJECT:nvim.1" "nvim" Enter 0
  tmux clock-mode -t "$PROJECT:nvim.2"

  tmux select-window -t "$PROJECT:nvim"
  tmux select-pane -t "$PROJECT:nvim.1"

done

tmux attach -t "home"

