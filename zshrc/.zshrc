# ~/.zshrc
export PATH=/opt/homebrew/bin:$PATH
export PATH=usr/local/bin:$PATH

eval "$(starship init zsh)"

# aliases for commands 
alias cl=clear
alias htop=btop
alias l=ls
alias ll=ls
alias anvil="ssh -i .ssh/anvil x-psah@anvil.rcac.purdue.edu"

#if [[ -z "$TMUX" ]]; then
#    tmux attach -t default || tmux new -s default
#    touchegg
#fi
# Check if tmux is installed
#if command -v tmux &> /dev/null; then
#    # Check if not already in a tmux session
#    if [ -z "$TMUX" ]; then
#        # Start the first tmux session and run the touch command
#        tmux new-session -d -s "🙂"
#     
#        
#        # Attach to the second session
#        exec tmux attach-session -t "🙂"
#    fi
#fi
fortune | cowsay -f dragon 
# Enable ls colors
alias ls="ls --color=auto"



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

