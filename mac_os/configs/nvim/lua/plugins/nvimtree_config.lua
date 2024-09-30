
-- nvimtree_config.lua

require'nvim-tree'.setup {
  view = {
    width = 30,
    side = 'left',
  },
  filters = {
    dotfiles = true,  -- Show dotfiles
    custom = { "^\\.git$", "node_modules", ".cache", vim.fn.expand("$HOME") .. "/Library/" }
  },
  actions = {
    open_file = {
      quit_on_open = true,  -- Close file explorer after opening a file
    },
  },
  filesystem_watchers = {
    enable = true,
    ignore_dirs = { vim.fn.expand("$HOME") .. "/Library/" },
  },
}