
-- treesitter_config.lua

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript", "html", "css" }, -- Add languages as needed
  highlight = {
    enable = true,              -- Enable syntax highlighting
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },    -- Enable smart indentation
}
