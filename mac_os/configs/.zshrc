eval "$(mise activate zsh)"

# ALIASES
alias ll="ls -al"
alias python="python3"
alias pip="pip3"
alias vim="nvim"

if [ ! -L $HOME/.hammerspoon ]; then
    ln -s $SCRIPTS_PATH/hammerspoon $HOME/.hammerspoon
fi

if [ ! -L $HOME/.yabairc ]; then
    ln -s $CONFIG_PATH/.yabairc $HOME/.yabairc
fi

if [ ! -L $HOME/.skhdrc ]; then
    ln -s $CONFIG_PATH/.skhdrc $HOME/.skhdrc
fi
