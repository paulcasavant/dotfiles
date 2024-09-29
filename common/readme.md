# Configure Terminal

## Configure tmux

1. Clone: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

2. Add to `~/.tmux.conf`:

    ```bash
    # Enable mouse mode
    set -g mouse on

    # Enable vim mode
    set-window-option -g mode-keys vi

    # List of plugins
    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @plugin 'tmux-plugins/tmux-yank'

    # Other examples:
    # set -g @plugin 'github_username/plugin_name'
    # set -g @plugin 'github_username/plugin_name#branch'
    # set -g @plugin 'git@github.com:user/plugin'
    # set -g @plugin 'git@bitbucket.com:user/plugin'

    # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
    run '~/.tmux/plugins/tpm/tpm'
    ```

3. Run: `tmux source ~/.tmux.conf`

## Configure Bash

1. Add to `~/.bashrc`:

```bash
set -o vi
```

## Configure Vim

1. Add to `~/.vimrc`:
   
    ```vim
    "Enable highlight search
    set hlsearch

    "Enable incremental search
    set is hls

    " ESC -> Clear highlight search
    nnoremap <esc> :noh<return><esc>
    nnoremap <esc>^[ <esc>^[

    "Send clipboard to system clipboard
    set clipboard=unnamedplus
    
    "Enable mouse control
    set mouse=a
    
    "Enable numbers
    set number
    
    "Enable TODO/FIXME highlights
    augroup HiglightTODO
        autocmd!
        autocmd WinEnter,VimEnter * :silent! call matchadd('FIXME', 'TODO', -1)
    augroup END
    
    "Enable wildmenu for better console autocompletion
    set wildmenu
    set wildmode=list:longest,full

    " Enable syntax highlighting
    filetype plugin on
    syntax on
    ```
