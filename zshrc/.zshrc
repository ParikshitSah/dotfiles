# ~/.zshrc

eval "$(starship init zsh)"

# aliases for commands 
alias cl=clear
alias htop=btop
alias l=ls
alias ll=ls

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/sah/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/sah/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/sah/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/sah/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#if [[ -z "$TMUX" ]]; then
#    tmux attach -t default || tmux new -s default
#    touchegg
#fi
# Check if tmux is installed
if command -v tmux &> /dev/null; then
    # Check if not already in a tmux session
    if [ -z "$TMUX" ]; then
        # Start the first tmux session and run the touch command
        tmux new-session -d -s "session1"
        tmux send-keys -t "session1" "touchegg" C-m
        
        # Start the second tmux session
        tmux new-session -d -s "session2"
        
        # Attach to the second session
        exec tmux attach-session -t "session2"
    fi
fi
fortune | cowsay -f dragon 
# Enable ls colors
alias ls="ls --color=auto"

PATH=$PATH:/usr/local/MATLAB/R2024b/bin

export PATH=$PATH:/home/sah/.spicetify
export PATH=$HOME/.local/bin:$PATH
