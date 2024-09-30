
-- nvimtree.lua

require'nvim-tree'.setup {
  view = {
    width = 30,
    side = 'left',
  },
  filters = {
    dotfiles = true,  -- Show dotfiles
  },
  actions = {
    open_file = {
      quit_on_open = true,  -- Close file explorer after opening a file
    },
  },
}
