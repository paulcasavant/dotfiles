
-- lualine_config.lua

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',  -- Theme for status line
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {},
  }
}