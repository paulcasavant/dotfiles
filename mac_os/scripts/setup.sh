#!/bin/zsh

# Function to create a symlink if it doesn't exist
create_symlink() {
    local target=$1
    local link=$2

    if [ ! -L "$link" ]; then
        echo "Creating symlink: $link -> $target"
        ln -s "$target" "$link"
    else
        echo "Symlink already exists: $link"
    fi
}

# Symlink and source .zshrc config file
create_symlink "$HOME/repos/dotfiles/mac_os/configs/.zshrc" "$HOME/.zshrc"
source $HOME/.zshrc

# Symlink and source .zshenv config file
create_symlink "$HOME/repos/dotfiles/mac_os/configs/.zshenv" "$HOME/.zshenv"
source $HOME/.zshenv

# Symlink .yabairc config file
create_symlink "$CONFIG_PATH/.yabairc" "$HOME/.yabairc"

# Symlink .skhdrc config file
create_symlink "$CONFIG_PATH/.skhdrc" "$HOME/.skhdrc"

# Symlink karabiner.json config file
create_symlink "$CONFIG_PATH/karabiner-elements/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# Symlink .hammerspoon directory
create_symlink "$SCRIPT_PATH/hammerspoon" "$HOME/.hammerspoon"
