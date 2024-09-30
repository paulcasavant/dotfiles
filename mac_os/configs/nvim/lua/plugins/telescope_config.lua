
-- telescope_config.lua

local telescope = require('telescope')
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close,  -- Close telescope with escape
      },
    },
  },
}
telescope.load_extension('fzf')  -- Load the FZF extension
