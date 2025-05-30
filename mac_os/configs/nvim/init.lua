
-- init.lua

-- Automatically install packer if not installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- Auto-compile when there are changes in plugins.lua
vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

-- Plugins installation and management
require('core.plugins')

-- General settings
vim.o.number = true                -- Enable line numbers
vim.o.relativenumber = false       -- Relative line numbers
vim.o.mouse = 'a'                  -- Enable mouse
vim.o.clipboard = 'unnamedplus'    -- System clipboard integration
vim.o.expandtab = true             -- Convert tabs to spaces
vim.o.shiftwidth = 4               -- Number of spaces to use for each step of (auto)indent
vim.o.tabstop = 4                  -- Number of spaces a tab counts for
vim.o.smartindent = true           -- Smart indentation
vim.o.wrap = false                 -- Disable line wrap
vim.o.termguicolors = true         -- Enable 24-bit RGB color in the terminal
vim.o.splitright = true            -- Split windows to the right
vim.o.splitbelow = true            -- Split windows below
vim.o.ignorecase = true            -- Ignore case when searching
vim.o.smartcase = true             -- Smart case
vim.o.updatetime = 300             -- Faster completion (4000ms default)
vim.o.signcolumn = "yes"           -- Always show signcolumn to avoid text shifting

-- Leader key
vim.g.mapleader = ' '  -- Space as the leader key

-- Keybindings
vim.api.nvim_set_keymap('n', '<Leader>pv', ':Ex<CR>', { noremap = true })  -- File Explorer
vim.api.nvim_set_keymap(
  'n',
  '<leader>dw',
  '<cmd>lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)

-- Plugin configurations
require('plugins.lsp_config')         -- LSP settings
require('plugins.treesitter_config')  -- Treesitter settings
require('plugins.telescope_config')   -- Telescope settings
require('plugins.gitsigns_config')    -- Gitsigns settings
require('plugins.lualine_config')     -- Statusline settings
require('plugins.nvimtree_config')    -- File explorer settings

require("packer").startup(function()  -- Lazy commenting
  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }
end)

-- Autocompletion settings
require('plugins.cmp_config')

-- Auto pairs (for automatically closing brackets, etc.)
-- require('lua.nvim-autopairs').setup{}

-- Set colorscheme
vim.cmd [[colorscheme tokyonight]]
-- vim.cmd [[colorscheme gruvbox]]

-- Enable mouse
vim.o.mouse = 'a'

-- Automatically show diagnostics when hovering with the mouse
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})
]]
