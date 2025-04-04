# ~/.zshrc

eval "$(starship init zsh)"

# aliases for commands 
alias cl=clear
alias htop=btop
alias l=ls
alias ll=ls

#if [[ -z "$TMUX" ]]; then
#    tmux attach -t default || tmux new -s default
#    touchegg
#fi
# Check if tmux is installed
if command -v tmux &> /dev/null; then
    # Check if not already in a tmux session
    if [ -z "$TMUX" ]; then
        # Start the first tmux session and run the touch command
        tmux new-session -d -s "🙂"
     
        
        # Attach to the second session
        exec tmux attach-session -t "🙂"
    fi
fi
fortune | cowsay -f dragon 
# Enable ls colors
alias ls="ls --color=auto"


export PATH=$HOME/.local/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
